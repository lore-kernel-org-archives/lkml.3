Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaBJQ5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:57:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBJQ5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:57:32 -0500
Date: Mon, 10 Feb 2014 17:57:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no
	rules
Message-ID: <20140210165723.GA10856@redhat.com>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Andy Lutomirski wrote:
>
> +void audit_inc_n_rules()
> +{
> +	struct task_struct *p, *t;
> +
> +	read_lock(&tasklist_lock);
> +	audit_n_rules++;
> +	smp_wmb();
> +	if (audit_n_rules == 1) {
> +		/*
> +		 * We now have a rule; we need to hook syscall entry.
> +		 */
> +		for_each_process_thread(p, t) {
> +			if (t->audit_context)
> +				set_tsk_thread_flag(t, TIF_SYSCALL_AUDIT);
> +		}
> +	}
> +	read_unlock(&tasklist_lock);
> +}
> +
> +void audit_dec_n_rules()
> +{
> +	read_lock(&tasklist_lock);
> +	--audit_n_rules;
> +	BUG_ON(audit_n_rules < 0);
> +
> +	/*
> +	 * If audit_n_rules == 0, then __audit_syscall_exit will clear
> +	 * TIF_SYSCALL_AUDIT.
> +	 */
> +
> +	read_unlock(&tasklist_lock);
> +}

To be honest, I do not understand why _dec_ takes tasklist_lock...
And why _inc_ increments audit_n_rules under tasklist.

> @@ -1528,6 +1562,25 @@ void __audit_syscall_exit(int success, long return_code)
>  		context->filterkey = NULL;
>  	}
>  	tsk->audit_context = context;
> +
> +	if (ACCESS_ONCE(audit_n_rules) == 0) {
> +		/*
> +		 * Either this is the very first syscall by this process or
> +		 * audit_dec_n_rules recently set audit_n_rules to zero.
> +		 */
> +		smp_rmb();

rmb() looks wrong, we need mb() to serialize ACCESS_ONCE() and
clear_tsk_thread_flag().

But, otoh, I think we do not need any barrier at all, we can rely on
control dependency. See the recent 18c03c61444a21 "Documentation/
memory-barriers.txt: Prohibit speculative writes".

> +		/* audit_inc_n_rules could increment audit_n_rules here... */
> +
> +		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> +
> +		smp_rmb();

Again, I guess this should be mb() or smp_mb__after_clear_bit().


And I still think this needs more changes. Once again, I do not think
that, say, __audit_log_bprm_fcaps() should populate context->aux if
!TIF_SYSCALL_AUDIT, this list can grow indefinitely. Or __audit_signal_info()...

Perhaps __audit_syscall_exit() should also set context->dummy?

Oleg.

