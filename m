Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3CDRhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:37:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab3CDRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:37:18 -0500
Date: Mon, 4 Mar 2013 17:37:14 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 114/153] idr: fix top layer handling
Message-ID: <20130304173714.GE9031@hercules>
References: <20130304033707.648729212@decadent.org.uk>
 <20130304033718.789608442@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304033718.789608442@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 03:39:01AM +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 326cf0f0f308933c10236280a322031f0097205d upstream.
> 
> Most functions in idr fail to deal with the high bits when the idr
> tree grows to the maximum height.
> 
> * idr_get_empty_slot() stops growing idr tree once the depth reaches
>   MAX_IDR_LEVEL - 1, which is one depth shallower than necessary to
>   cover the whole range.  The function doesn't even notice that it
>   didn't grow the tree enough and ends up allocating the wrong ID
>   given sufficiently high @starting_id.
> 
>   For example, on 64 bit, if the starting id is 0x7fffff01,
>   idr_get_empty_slot() will grow the tree 5 layer deep, which only
>   covers the 30 bits and then proceed to allocate as if the bit 30
>   wasn't specified.  It ends up allocating 0x3fffff01 without the bit
>   30 but still returns 0x7fffff01.
> 
> * __idr_remove_all() will not remove anything if the tree is fully
>   grown.
> 
> * idr_find() can't find anything if the tree is fully grown.
> 
> * idr_for_each() and idr_get_next() can't iterate anything if the tree
>   is fully grown.
> 
> Fix it by introducing idr_max() which returns the maximum possible ID
> given the depth of tree and replacing the id limit checks in all
> affected places.
> 
> As the idr_layer pointer array pa[] needs to be 1 larger than the
> maximum depth, enlarge pa[] arrays by one.
> 
> While this plugs the discovered issues, the whole code base is
> horrible and in desparate need of rewrite.  It's fragile like hell,
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - s/MAX_IDR_LEVEL/MAX_LEVEL/; s/MAX_IDR_SHIFT/MAX_ID_SHIFT/
>  - Drop change to idr_alloc()]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  lib/idr.c |   38 +++++++++++++++++++++++---------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -39,6 +39,14 @@
>  static struct kmem_cache *idr_layer_cache;
>  static DEFINE_SPINLOCK(simple_ida_lock);
>  
> +/* the maximum ID which can be allocated given idr->layers */
> +static int idr_max(int layers)
> +{
> +	int bits = min_t(int, layers * IDR_BITS, MAX_ID_SHIFT);
> +
> +	return (1 << bits) - 1;
> +}
> +
>  static struct idr_layer *get_from_free_list(struct idr *idp)
>  {
>  	struct idr_layer *p;
> @@ -223,7 +231,7 @@ build_up:
>  	 * Add a new layer to the top of the tree if the requested
>  	 * id is larger than the currently allocated space.
>  	 */
> -	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
> +	while (id > idr_max(layers)) {
>  		layers++;
>  		if (!p->count) {
>  			/* special case: if the tree is currently empty,
> @@ -265,7 +273,7 @@ build_up:
>  
>  static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
>  {
> -	struct idr_layer *pa[MAX_LEVEL];
> +	struct idr_layer *pa[MAX_LEVEL + 1];
>  	int id;
>  
>  	id = idr_get_empty_slot(idp, starting_id, pa);
> @@ -357,7 +365,7 @@ static void idr_remove_warning(int id)
>  static void sub_remove(struct idr *idp, int shift, int id)
>  {
>  	struct idr_layer *p = idp->top;
> -	struct idr_layer **pa[MAX_LEVEL];
> +	struct idr_layer **pa[MAX_LEVEL + 1];
>  	struct idr_layer ***paa = &pa[0];
>  	struct idr_layer *to_free;
>  	int n;
> @@ -451,16 +459,16 @@ void idr_remove_all(struct idr *idp)
>  	int n, id, max;
>  	int bt_mask;
>  	struct idr_layer *p;
> -	struct idr_layer *pa[MAX_LEVEL];
> +	struct idr_layer *pa[MAX_LEVEL + 1];
>  	struct idr_layer **paa = &pa[0];
>  
>  	n = idp->layers * IDR_BITS;
>  	p = idp->top;
>  	rcu_assign_pointer(idp->top, NULL);
> -	max = 1 << n;
> +	max = idr_max(idp->layers);
>  
>  	id = 0;
> -	while (id < max) {
> +	while (id >= 0 && id <= max) {
>  		while (n > IDR_BITS && p) {
>  			n -= IDR_BITS;
>  			*paa++ = p;
> @@ -519,7 +527,7 @@ void *idr_find(struct idr *idp, int id)
>  	/* Mask off upper bits we don't use for the search. */
>  	id &= MAX_ID_MASK;
>  
> -	if (id >= (1 << n))
> +	if (id > idr_max(p->layer + 1))
>  		return NULL;
>  	BUG_ON(n == 0);
>  
> @@ -555,15 +563,15 @@ int idr_for_each(struct idr *idp,
>  {
>  	int n, id, max, error = 0;
>  	struct idr_layer *p;
> -	struct idr_layer *pa[MAX_LEVEL];
> +	struct idr_layer *pa[MAX_LEVEL + 1];
>  	struct idr_layer **paa = &pa[0];
>  
>  	n = idp->layers * IDR_BITS;
>  	p = rcu_dereference_raw(idp->top);
> -	max = 1 << n;
> +	max = idr_max(idp->layers);
>  
>  	id = 0;
> -	while (id < max) {
> +	while (id >= 0 && id <= max) {
>  		while (n > 0 && p) {
>  			n -= IDR_BITS;
>  			*paa++ = p;
> @@ -601,7 +609,7 @@ EXPORT_SYMBOL(idr_for_each);
>   */
>  void *idr_get_next(struct idr *idp, int *nextidp)
>  {
> -	struct idr_layer *p, *pa[MAX_LEVEL];
> +	struct idr_layer *p, *pa[MAX_LEVEL + 1];
>  	struct idr_layer **paa = &pa[0];
>  	int id = *nextidp;
>  	int n, max;
> @@ -611,9 +619,9 @@ void *idr_get_next(struct idr *idp, int
>  	if (!p)
>  		return NULL;
>  	n = (p->layer + 1) * IDR_BITS;
> -	max = 1 << n;
> +	max = idr_max(p->layer + 1);
>  
> -	while (id < max) {
> +	while (id >= 0 && id <= max) {
>  		while (n > 0 && p) {
>  			n -= IDR_BITS;
>  			*paa++ = p;
> @@ -787,7 +795,7 @@ EXPORT_SYMBOL(ida_pre_get);
>   */
>  int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
>  {
> -	struct idr_layer *pa[MAX_LEVEL];
> +	struct idr_layer *pa[MAX_LEVEL + 1];
>  	struct ida_bitmap *bitmap;
>  	unsigned long flags;
>  	int idr_id = starting_id / IDA_BITMAP_BITS;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I've reviewed this backport and it looks correct to me.  I've queued it
in the 3.5 tree as well.

Cheers,
--
Luis
