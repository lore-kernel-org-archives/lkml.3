Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935701Ab3DHLC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:02:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:52615 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935118Ab3DHLCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:02:53 -0400
Message-ID: <5162A3DA.9010205@hitachi.com>
Date: Mon, 08 Apr 2013 20:02:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, radovan.lekanovic@sonymobile.com,
        bjorn.davidsson@sonymobile.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v3 2/4] kprobes: split blacklist into common and arch
References: <1365168400-17954-1-git-send-email-oskar.andero@sonymobile.com> <1365168400-17954-3-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1365168400-17954-3-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/05 22:26), Oskar Andero wrote:
> Some blackpoints are only valid for specific architectures. To let each
> architecture specify its own blackpoints the list has been split in two
> lists: common and arch. The common list is kept in kernel/kprobes.c and
> the arch list is kept in the arch/ directory.

Looks good for me:)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  kernel/kprobes.c | 88 +++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index c8c2281..2458ae1 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -68,7 +68,6 @@
>  #endif
>  
>  static int kprobes_initialized;
> -static bool kprobe_blacklist_initialized;
>  static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
>  static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>  
> @@ -94,31 +93,64 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
>   *
>   * For such cases, we now have a blacklist
>   */
> -static struct kprobe_blackpoint kprobe_blacklist[] = {
> -	{"preempt_schedule",},
> -	{"native_get_debugreg",},
> -	{"irq_entries_start",},
> -	{"common_interrupt",},
> -	{"mcount",},	/* mcount can be called from everywhere */
> -	{NULL}    /* Terminator */
> +static const char * const common_kprobes_blacksyms[] = {
> +	"preempt_schedule",
> +	"native_get_debugreg",
> +	"irq_entries_start",
> +	"common_interrupt",
> +	"mcount",       /* mcount can be called from everywhere */
>  };
> +static const size_t common_kprobes_blacksyms_size =
> +			ARRAY_SIZE(common_kprobes_blacksyms);
> +
> +/*
> + * These weak symbols can be overridden from the arch/ directory for
> + * architecure specific blackpoints.
> + */
> +const char * const __weak arch_kprobes_blacksyms[] = {};
> +const size_t __weak arch_kprobes_blacksyms_size;
> +
> +static struct kprobe_blackpoint *kprobe_blacklist;
> +static size_t kprobe_blacklist_size;
> +
> +static void init_kprobe_blacklist_entry(struct kprobe_blackpoint *kb,
> +					const char * const name)
> +{
> +	const char *symbol_name;
> +	char *modname, namebuf[128];
> +	void *addr;
> +	unsigned long offset = 0, size = 0;
> +
> +	kb->name = name;
> +	kprobe_lookup_name(kb->name, addr);
> +	if (!addr)
> +		return;
> +
> +	kb->start_addr = (unsigned long)addr;
> +	symbol_name = kallsyms_lookup(kb->start_addr,
> +			&size, &offset, &modname, namebuf);
> +	if (!symbol_name)
> +		kb->range = 0;
> +	else
> +		kb->range = size;
> +}
>  
>  /* it can take some time ( > 100ms ) to initialise the
>   * blacklist so we delay this until we actually need it
>   */
>  static void init_kprobe_blacklist(void)
>  {
> -	int i;
> -	unsigned long offset = 0, size = 0;
> -	char *modname, namebuf[128];
> -	const char *symbol_name;
> -	void *addr;
> +	int i, j = 0;
>  	struct kprobe_blackpoint *kb;
>  
>  	mutex_lock(&kprobe_mutex);
> -	if (kprobe_blacklist_initialized)
> +	if (kprobe_blacklist)
>  		goto out;
>  
> +	kprobe_blacklist_size = common_kprobes_blacksyms_size +
> +				arch_kprobes_blacksyms_size;
> +	kb = kzalloc(sizeof(*kb) * kprobe_blacklist_size, GFP_KERNEL);
> +
>  	/*
>  	 * Lookup and populate the kprobe_blacklist.
>  	 *
> @@ -127,18 +159,14 @@ static void init_kprobe_blacklist(void)
>  	 * since a kprobe need not necessarily be at the beginning
>  	 * of a function.
>  	 */
> -	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
> -		kprobe_lookup_name(kb->name, addr);
> -		if (!addr)
> -			continue;
> +	for (i = 0; i < common_kprobes_blacksyms_size; i++, j++) {
> +		init_kprobe_blacklist_entry(&kb[j],
> +					    common_kprobes_blacksyms[i]);
> +	}
>  
> -		kb->start_addr = (unsigned long)addr;
> -		symbol_name = kallsyms_lookup(kb->start_addr,
> -				&size, &offset, &modname, namebuf);
> -		if (!symbol_name)
> -			kb->range = 0;
> -		else
> -			kb->range = size;
> +	for (i = 0; i < arch_kprobes_blacksyms_size; i++, j++) {
> +		init_kprobe_blacklist_entry(&kb[j],
> +					    arch_kprobes_blacksyms[i]);
>  	}
>  
>  	if (kretprobe_blacklist_size) {
> @@ -153,7 +181,7 @@ static void init_kprobe_blacklist(void)
>  	}
>  
>  	smp_wmb();
> -	kprobe_blacklist_initialized = true;
> +	kprobe_blacklist = kb;
>  
>  out:
>  	mutex_unlock(&kprobe_mutex);
> @@ -1384,18 +1412,20 @@ out:
>  static int __kprobes in_kprobes_functions(unsigned long addr)
>  {
>  	struct kprobe_blackpoint *kb;
> +	int i;
>  
>  	if (addr >= (unsigned long)__kprobes_text_start &&
>  	    addr < (unsigned long)__kprobes_text_end)
>  		return -EINVAL;
>  
> -	if (unlikely(!kprobe_blacklist_initialized))
> +	if (unlikely(!kprobe_blacklist))
>  		init_kprobe_blacklist();
>  	/*
>  	 * If there exists a kprobe_blacklist, verify and
>  	 * fail any probe registration in the prohibited area
>  	 */
> -	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
> +	for (i = 0; i < kprobe_blacklist_size; i++) {
> +		kb = &kprobe_blacklist[i];
>  		if (kb->start_addr) {
>  			if (addr >= kb->start_addr &&
>  			    addr < (kb->start_addr + kb->range))
> @@ -1876,7 +1906,7 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
>  	void *addr;
>  
>  	if (kretprobe_blacklist_size) {
> -		if (unlikely(!kprobe_blacklist_initialized))
> +		if (unlikely(!kprobe_blacklist))
>  			init_kprobe_blacklist();
>  		addr = kprobe_addr(&rp->kp);
>  		if (IS_ERR(addr))
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


