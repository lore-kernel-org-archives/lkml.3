Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3H1IkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3H1IkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:40:16 -0400
Date: Wed, 28 Aug 2013 11:40:09 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 08/12] KVM: MMU: introduce nulls desc
Message-ID: <20130828084009.GO22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375189330-24066-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:02:06PM +0800, Xiao Guangrong wrote:
> It likes nulls list and we use the pte-list as the nulls which can help us to
> detect whether the "desc" is moved to anther rmap then we can re-walk the rmap
> if that happened
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 3013bb1..36caf6a 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -918,6 +918,24 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
>  	return level - 1;
>  }
>  
> +static void desc_mark_nulls(unsigned long *pte_list, struct pte_list_desc *desc)
> +{
> +	unsigned long marker;
> +
> +	marker = (unsigned long)pte_list | 1UL;
> +	desc->more = (struct pte_list_desc *)marker;
> +}
> +
> +static bool desc_is_a_nulls(struct pte_list_desc *desc)
> +{
> +	return (unsigned long)desc & 1;
> +}
> +
> +static unsigned long *desc_get_nulls_value(struct pte_list_desc *desc)
> +{
> +	return (unsigned long *)((unsigned long)desc & ~1);
> +}
> +
>  static int __find_first_free(struct pte_list_desc *desc)
>  {
>  	int i;
> @@ -956,7 +974,7 @@ static int count_spte_number(struct pte_list_desc *desc)
>  
>  	first_free = __find_first_free(desc);
>  
> -	for (desc_num = 0; desc->more; desc = desc->more)
> +	for (desc_num = 0; !desc_is_a_nulls(desc->more); desc = desc->more)
>  		desc_num++;
>  
>  	return first_free + desc_num * PTE_LIST_EXT;
> @@ -991,6 +1009,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
>  		desc = mmu_alloc_pte_list_desc(vcpu);
>  		desc->sptes[0] = (u64 *)*pte_list;
>  		desc->sptes[1] = spte;
> +		desc_mark_nulls(pte_list, desc);
>  		*pte_list = (unsigned long)desc | 1;
>  		return 1;
>  	}
> @@ -1036,7 +1055,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
>  		/*
>  		 * Only one entry existing but still use a desc to store it?
>  		 */
> -		WARN_ON(!next_desc);
> +		WARN_ON(desc_is_a_nulls(next_desc));
>  
>  		mmu_free_pte_list_desc(first_desc);
>  		first_desc = next_desc;
> @@ -1050,7 +1069,7 @@ pte_list_desc_remove_entry(unsigned long *pte_list,
>  	 * Only one entry in this desc, move the entry to the head
>  	 * then the desc can be freed.
>  	 */
> -	if (!first_desc->sptes[1] && !first_desc->more) {
> +	if (!first_desc->sptes[1] && desc_is_a_nulls(first_desc->more)) {
>  		*pte_list = (unsigned long)first_desc->sptes[0];
>  		mmu_free_pte_list_desc(first_desc);
>  	}
> @@ -1077,7 +1096,7 @@ static void pte_list_remove(u64 *spte, unsigned long *pte_list)
>  
>  	rmap_printk("pte_list_remove:  %p many->many\n", spte);
>  	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
> -	while (desc) {
> +	while (!desc_is_a_nulls(desc)) {
>  		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
>  			if (desc->sptes[i] == spte) {
>  				pte_list_desc_remove_entry(pte_list,
> @@ -1103,11 +1122,13 @@ static void pte_list_walk(unsigned long *pte_list, pte_list_walk_fn fn)
>  		return fn((u64 *)*pte_list);
>  
>  	desc = (struct pte_list_desc *)(*pte_list & ~1ul);
> -	while (desc) {
> +	while (!desc_is_a_nulls(desc)) {
>  		for (i = 0; i < PTE_LIST_EXT && desc->sptes[i]; ++i)
>  			fn(desc->sptes[i]);
>  		desc = desc->more;
>  	}
> +
> +	WARN_ON(desc_get_nulls_value(desc) != pte_list);
>  }
>  
>  static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
> @@ -1200,7 +1221,7 @@ static u64 *rmap_get_first(unsigned long rmap, struct rmap_iterator *iter)
>   */
>  static u64 *rmap_get_next(struct rmap_iterator *iter)
>  {
> -	if (iter->desc) {
> +	if (iter->desc && !desc_is_a_nulls(iter->desc)) {
>  		if (iter->pos < PTE_LIST_EXT - 1) {
>  			u64 *sptep;
>  
> @@ -1212,7 +1233,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
>  
>  		iter->desc = iter->desc->more;
>  
I'd rather do:
		iter->desc = desc_is_a_nulls(iter->desc) ? NULL : iter->desc;
here and drop two desc_is_a_nulls() checks in this function.

> -		if (iter->desc) {
> +		if (!desc_is_a_nulls(iter->desc)) {
>  			iter->pos = 0;
>  			/* desc->sptes[0] cannot be NULL */
>  			return iter->desc->sptes[iter->pos];
> -- 
> 1.8.1.4

--
			Gleb.
