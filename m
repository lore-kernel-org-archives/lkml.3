Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936847Ab3DHK65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:58:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52889 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935303Ab3DHK6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:58:54 -0400
Message-ID: <5162A2EB.7030105@hitachi.com>
Date: Mon, 08 Apr 2013 19:58:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        davem@davemloft.net, anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, radovan.lekanovic@sonymobile.com,
        bjorn.davidsson@sonymobile.com,
        Toby Collett <toby.collett@sonymobile.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v3 1/4] kprobes: delay blacklist symbol lookup until
 we actually need it
References: <1365168400-17954-1-git-send-email-oskar.andero@sonymobile.com> <1365168400-17954-2-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1365168400-17954-2-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/05 22:26), Oskar Andero wrote:
> From: Toby Collett <toby.collett@sonymobile.com>
> 
> The symbol lookup can take a long time and kprobes is
> initialised very early in boot, so delay symbol lookup
> until the blacklist is first used.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: David S. Miller <davem@davemloft.net>
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Toby Collett <toby.collett@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  kernel/kprobes.c | 100 ++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 62 insertions(+), 38 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index e35be53..c8c2281 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -68,6 +68,7 @@
>  #endif
>  
>  static int kprobes_initialized;
> +static bool kprobe_blacklist_initialized;
>  static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
>  static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>  
> @@ -102,6 +103,62 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
>  	{NULL}    /* Terminator */
>  };
>  
> +/* it can take some time ( > 100ms ) to initialise the
> + * blacklist so we delay this until we actually need it
> + */
> +static void init_kprobe_blacklist(void)
> +{
> +	int i;
> +	unsigned long offset = 0, size = 0;
> +	char *modname, namebuf[128];
> +	const char *symbol_name;
> +	void *addr;
> +	struct kprobe_blackpoint *kb;
> +
> +	mutex_lock(&kprobe_mutex);
> +	if (kprobe_blacklist_initialized)
> +		goto out;
> +
> +	/*
> +	 * Lookup and populate the kprobe_blacklist.
> +	 *
> +	 * Unlike the kretprobe blacklist, we'll need to determine
> +	 * the range of addresses that belong to the said functions,
> +	 * since a kprobe need not necessarily be at the beginning
> +	 * of a function.
> +	 */
> +	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
> +		kprobe_lookup_name(kb->name, addr);
> +		if (!addr)
> +			continue;
> +
> +		kb->start_addr = (unsigned long)addr;
> +		symbol_name = kallsyms_lookup(kb->start_addr,
> +				&size, &offset, &modname, namebuf);
> +		if (!symbol_name)
> +			kb->range = 0;
> +		else
> +			kb->range = size;
> +	}
> +
> +	if (kretprobe_blacklist_size) {
> +		/* lookup the function address from its name */
> +		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
> +			kprobe_lookup_name(kretprobe_blacklist[i].name,
> +					   kretprobe_blacklist[i].addr);
> +			if (!kretprobe_blacklist[i].addr)
> +				printk("kretprobe: lookup failed: %s\n",
> +				       kretprobe_blacklist[i].name);
> +		}
> +	}
> +
> +	smp_wmb();
> +	kprobe_blacklist_initialized = true;
> +
> +out:
> +	mutex_unlock(&kprobe_mutex);
> +}
> +
>  #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
>  /*
>   * kprobe->ainsn.insn points to the copy of the instruction to be
> @@ -1331,6 +1388,9 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
>  	if (addr >= (unsigned long)__kprobes_text_start &&
>  	    addr < (unsigned long)__kprobes_text_end)
>  		return -EINVAL;
> +
> +	if (unlikely(!kprobe_blacklist_initialized))
> +		init_kprobe_blacklist();
>  	/*
>  	 * If there exists a kprobe_blacklist, verify and
>  	 * fail any probe registration in the prohibited area
> @@ -1816,6 +1876,8 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
>  	void *addr;
>  
>  	if (kretprobe_blacklist_size) {
> +		if (unlikely(!kprobe_blacklist_initialized))
> +			init_kprobe_blacklist();
>  		addr = kprobe_addr(&rp->kp);
>  		if (IS_ERR(addr))
>  			return PTR_ERR(addr);
> @@ -2065,11 +2127,6 @@ static struct notifier_block kprobe_module_nb = {
>  static int __init init_kprobes(void)
>  {
>  	int i, err = 0;
> -	unsigned long offset = 0, size = 0;
> -	char *modname, namebuf[128];
> -	const char *symbol_name;
> -	void *addr;
> -	struct kprobe_blackpoint *kb;
>  
>  	/* FIXME allocate the probe table, currently defined statically */
>  	/* initialize all list heads */
> @@ -2079,39 +2136,6 @@ static int __init init_kprobes(void)
>  		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
>  	}
>  
> -	/*
> -	 * Lookup and populate the kprobe_blacklist.
> -	 *
> -	 * Unlike the kretprobe blacklist, we'll need to determine
> -	 * the range of addresses that belong to the said functions,
> -	 * since a kprobe need not necessarily be at the beginning
> -	 * of a function.
> -	 */
> -	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
> -		kprobe_lookup_name(kb->name, addr);
> -		if (!addr)
> -			continue;
> -
> -		kb->start_addr = (unsigned long)addr;
> -		symbol_name = kallsyms_lookup(kb->start_addr,
> -				&size, &offset, &modname, namebuf);
> -		if (!symbol_name)
> -			kb->range = 0;
> -		else
> -			kb->range = size;
> -	}
> -
> -	if (kretprobe_blacklist_size) {
> -		/* lookup the function address from its name */
> -		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
> -			kprobe_lookup_name(kretprobe_blacklist[i].name,
> -					   kretprobe_blacklist[i].addr);
> -			if (!kretprobe_blacklist[i].addr)
> -				printk("kretprobe: lookup failed: %s\n",
> -				       kretprobe_blacklist[i].name);
> -		}
> -	}
> -
>  #if defined(CONFIG_OPTPROBES)
>  #if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
>  	/* Init kprobe_optinsn_slots */
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


