Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaBDQur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:50:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaBDQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:50:44 -0500
Date: Tue, 4 Feb 2014 17:50:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2.1] audit: Only use the syscall slowpath when syscall
	audit rules exist
Message-ID: <20140204165015.GA3011@redhat.com>
References: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Andy Lutomirski wrote:
>
> +void audit_inc_n_rules()
> +{
> +	struct task_struct *p, *g;
> +	unsigned long flags;
> +
> +	read_lock_irqsave(&tasklist_lock, flags);

Confused... read_lock(tasklist) doesn't need to disable irqs.

(ftrace does this for no reason too, perhaps I should resend the patch)

> +	if (audit_n_rules++ == 0) {

probably this can be done outside of read_lock?

> +		do_each_thread(g, p) {

for_each_process_thread ;) do_each_thread will die, I hope.

> +void audit_dec_n_rules()
> +{
> +	struct task_struct *p, *g;
> +	unsigned long flags;
> +
> +	read_lock_irqsave(&tasklist_lock, flags);
> +
> +	--audit_n_rules;
> +	BUG_ON(audit_n_rules < 0);
> +
> +	if (audit_n_rules == 0) {
> +		do_each_thread(g, p) {
> +			clear_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
> +		} while_each_thread(g, p);
> +	}

The same, and...

On a second thought it seems that audit_dec_n_rules() has a problem.
Note the BUG_ON(context->in_syscall) in __audit_syscall_entry().

Suppose that audit_dec_n_rules() clears TIF_SYSCALL_AUDIT when a task
runs a syscall. In this case (afaics) __audit_syscall_exit() won't be
called. The next audit_inc_n_rules() can set TIF_SYSCALL_AUDIT and
trigger another __audit_syscall_entry() which will hit this BUG_ON().

And in general it doesn't look safe although I know almost nothing
about audit. I mean, currently __audit_syscall_entry() or
__audit_log_bprm_fcaps() assume that __audit_syscall_exit() or
__audit_free() will "cleanup" ->audit_context, perhaps we should not
break the rules?

Once again, I do not pretend I understand this code, this is the
question, not the comment.

But if I am right, then TIF_SYSCALL_AUDIT should be cleared in
__audit_syscall_exit() as you suggested before.

Oleg.

