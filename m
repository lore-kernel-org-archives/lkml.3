Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaJVCan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:30:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34651 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJVCam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:30:42 -0400
Message-ID: <544716CA.2020605@hitachi.com>
Date: Wed, 22 Oct 2014 11:30:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/22 0:48), Jiri Kosina wrote:
> Add a function that allows external users (such as live patching 
> mechanisms) to check whether a given function (identified by symbol name) 
> has a kprobe installed in it.

Actually, we've already exported the list of kprobes with probe points
(symbols) via debugfs. Please check /sys/kernel/debug/kprobes/list :)

Thank you,

> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  include/linux/kprobes.h |  5 +++++
>  kernel/kprobes.c        | 28 ++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index f7296e5..f760555 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -384,6 +384,7 @@ int disable_kprobe(struct kprobe *kp);
>  int enable_kprobe(struct kprobe *kp);
>  
>  void dump_kprobe(struct kprobe *kp);
> +bool kprobe_is_function_probed(const char *name);
>  
>  #else /* !CONFIG_KPROBES: */
>  
> @@ -459,6 +460,10 @@ static inline int enable_kprobe(struct kprobe *kp)
>  {
>  	return -ENOSYS;
>  }
> +static inline bool kprobe_is_function_probed(const char *name)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_KPROBES */
>  static inline int disable_kretprobe(struct kretprobe *rp)
>  {
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f54..27e8ddb 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -2036,6 +2036,34 @@ void dump_kprobe(struct kprobe *kp)
>  NOKPROBE_SYMBOL(dump_kprobe);
>  
>  /*
> + * Check whether a given symbol is a probed function
> + */
> +bool kprobe_is_function_probed(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct kprobe *p, *kp;
> +	const char *sym = NULL;
> +	unsigned long offset = 0;
> +	unsigned int i;
> +	char *modname, namebuf[KSYM_NAME_LEN];
> +
> +	preempt_disable();
> +	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
> +		head = &kprobe_table[i];
> +		hlist_for_each_entry_rcu(p, head, hlist) {
> +			sym = kallsyms_lookup((unsigned long)p->addr,
> +					NULL, &offset, &modname,
> +					namebuf);
> +			if (!strcmp(sym, name))
> +				return true;
> +		}
> +	}
> +	preempt_enable();
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(kprobe_is_function_probed);
> +
> +/*
>   * Lookup and populate the kprobe_blacklist.
>   *
>   * Unlike the kretprobe blacklist, we'll need to determine
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


