Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaBDSLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:11:48 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54590 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaBDSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:11:46 -0500
MIME-Version: 1.0
In-Reply-To: <20140204165015.GA3011@redhat.com>
References: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
 <20140204165015.GA3011@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 10:11:25 -0800
Message-ID: <CALCETrXuBL3__bYWJ-wSQdbTx=n1jGiD71D4wN-Sm5bDU2=JSw@mail.gmail.com>
Subject: Re: [PATCH v2.1] audit: Only use the syscall slowpath when syscall
 audit rules exist
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 8:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/03, Andy Lutomirski wrote:
>>
>> +void audit_inc_n_rules()
>> +{
>> +     struct task_struct *p, *g;
>> +     unsigned long flags;
>> +
>> +     read_lock_irqsave(&tasklist_lock, flags);
>
> Confused... read_lock(tasklist) doesn't need to disable irqs.
>
> (ftrace does this for no reason too, perhaps I should resend the patch)

Is this because there are no interrupt handlers that write_lock(tasklist)?

>
>> +     if (audit_n_rules++ == 0) {
>
> probably this can be done outside of read_lock?

I don't think so.  I'm cheating and using the tasklist_lock to prevent
audit_sync_flags from racing against this increment, so this needs to
be inside the lock.  I'll add a comment.

>
>> +             do_each_thread(g, p) {
>
> for_each_process_thread ;) do_each_thread will die, I hope.
>

Sorry, forgot to mention: where is this mythical
for_each_process_thread?  Either it only exists in a kernel version
I'm not looking at, my grepping skills aren't up to the task, or you
just hate do_each_thread so much that you imagined up an alternative
:)

>> +void audit_dec_n_rules()
>> +{
>> +     struct task_struct *p, *g;
>> +     unsigned long flags;
>> +
>> +     read_lock_irqsave(&tasklist_lock, flags);
>> +
>> +     --audit_n_rules;
>> +     BUG_ON(audit_n_rules < 0);
>> +
>> +     if (audit_n_rules == 0) {
>> +             do_each_thread(g, p) {
>> +                     clear_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
>> +             } while_each_thread(g, p);
>> +     }
>
> The same, and...
>
> On a second thought it seems that audit_dec_n_rules() has a problem.
> Note the BUG_ON(context->in_syscall) in __audit_syscall_entry().
>
> Suppose that audit_dec_n_rules() clears TIF_SYSCALL_AUDIT when a task
> runs a syscall. In this case (afaics) __audit_syscall_exit() won't be
> called. The next audit_inc_n_rules() can set TIF_SYSCALL_AUDIT and
> trigger another __audit_syscall_entry() which will hit this BUG_ON().
>

Egads!

> And in general it doesn't look safe although I know almost nothing
> about audit. I mean, currently __audit_syscall_entry() or
> __audit_log_bprm_fcaps() assume that __audit_syscall_exit() or
> __audit_free() will "cleanup" ->audit_context, perhaps we should not
> break the rules?
>
> Once again, I do not pretend I understand this code, this is the
> question, not the comment.
>
> But if I am right, then TIF_SYSCALL_AUDIT should be cleared in
> __audit_syscall_exit() as you suggested before.

I think I'll wait for Eric to chime in.  I suspect that the real
solution is to simplify all this stuff by relying on the fact that the
syscall nr and args are saved by the (fast path and slow path) entry
code, so the audit entry hook may be entirely unnecessary.  Or maybe a
new TIF flag would be needed to make it work.

Anyway, *grumble*.  My only real interest in this stuff is to get rid
of the overhead.  I don't actually want syscall auditing on any of my
boxes (in contrast to avc auditing, which is useful but (mostly)
independent).

--Andy
