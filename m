Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbaJUQpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:45:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39202 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbaJUQpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:45:47 -0400
Date: Tue, 21 Oct 2014 22:18:35 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
Message-ID: <20141021164835.GB10290@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102116-0029-0000-0000-000000D323F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:48:30PM +0200, Jiri Kosina wrote:

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

Better name? function_is_kprobed() or such?

...

> +bool kprobe_is_function_probed(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct kprobe *p, *kp;

kp not used

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

Don't you want a strncmp instead?

Ananth

