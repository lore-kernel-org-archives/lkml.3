Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbaJURIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913AbaJURIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:08:38 -0400
Date: Tue, 21 Oct 2014 11:43:28 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
Message-ID: <20141021164328.GG3978@treble.redhat.com>
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:48:30PM +0200, Jiri Kosina wrote:
> Add a function that allows external users (such as live patching 
> mechanisms) to check whether a given function (identified by symbol name) 
> has a kprobe installed in it.

Functions aren't uniquely identifiable by name.  Perhaps it should be
something like kprobe_is_addr_range_probed()?

Should we refuse to patch a function which has a kprobe installed inside
it?  Is there a race-free way to do that?

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
> -- 
> 1.9.2
