Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763756Ab3DDGoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:44:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33056 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab3DDGoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:44:19 -0400
Message-ID: <515D213A.2080707@hitachi.com>
Date: Thu, 04 Apr 2013 15:44:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: oskar.andero@sonymobile.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        radovan.lekanovic@sonymobile.com, bjorn.davidsson@sonymobile.com,
        Toby Collett <toby.collett@sonymobile.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 1/4] kprobes: delay blacklist symbol lookup until we actually
 need it
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com> <1364977734-32267-2-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1364977734-32267-2-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/03 17:28), oskar.andero@sonymobile.com wrote:
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
> +	kprobe_blacklist_initialized = 1;
> +}
> +
>  #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
>  /*
>   * kprobe->ainsn.insn points to the copy of the instruction to be
> @@ -1331,6 +1379,9 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
>  	if (addr >= (unsigned long)__kprobes_text_start &&
>  	    addr < (unsigned long)__kprobes_text_end)
>  		return -EINVAL;
> +
> +	if (!kprobe_blacklist_initialized)
> +		init_kprobe_blacklist();
>  	/*
>  	 * If there exists a kprobe_blacklist, verify and
>  	 * fail any probe registration in the prohibited area
> @@ -1816,6 +1867,8 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
>  	void *addr;
>  
>  	if (kretprobe_blacklist_size) {
> +		if (!kprobe_blacklist_initialized)
> +			init_kprobe_blacklist();

Joonsoo reminds me that these calling points are not protected by kprobe_mutex,
thus we have to do something for avoiding concurrent initialization.

Perhaps, the easiest way is to protect init_kprobe_blacklist() by kprobe_mutex
and check kprobe_blacklist_initialized again in the top of that.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


