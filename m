Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaBDTct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:32:49 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:65044 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaBDTcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:32:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140204191129.GB8996@redhat.com>
References: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net>
 <20140204165015.GA3011@redhat.com> <CALCETrXuBL3__bYWJ-wSQdbTx=n1jGiD71D4wN-Sm5bDU2=JSw@mail.gmail.com>
 <20140204191129.GB8996@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 11:32:24 -0800
Message-ID: <CALCETrVgx+BE78Pu9pLgikK00SZRHv=iN4BKtzBB_=CgZwhY=Q@mail.gmail.com>
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

On Tue, Feb 4, 2014 at 11:11 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/04, Andy Lutomirski wrote:
>> On Tue, Feb 4, 2014 at 8:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 02/03, Andy Lutomirski wrote:
>> Sorry, forgot to mention: where is this mythical
>> for_each_process_thread?
>
> In Linus's tree, please see 0c740d0afc3bff.
>
>> or you
>> just hate do_each_thread so much that you imagined up an alternative
>> :)
>
> sort of ;)

Aha -- it probably got merged just after I pulled Linus' tree and
looked for it.  Or something.

>
>> I think I'll wait for Eric to chime in.  I suspect that the real
>> solution is to simplify all this stuff by relying on the fact that the
>> syscall nr and args are saved by the (fast path and slow path) entry
>> code, so the audit entry hook may be entirely unnecessary.
>
> Perhaps... but even in this case we need to do something with, say,
> __audit_log_bprm_fcaps().
>
> At least this list should not grow indefinitely if the task skips
> __audit_syscall_exit(). Although at first glance this can be probably
> cleanuped too.

OK, here's a thought: let's change the semantics of TIF_SYSCALL_AUDIT.
 New semantics:

TIF_SYSCALL_AUDIT is set if (the task is eligible for syscall auditing
and n_rules != 0 *or* something has started writing an audit record).
TIF_SYSCALL_AUDIT is *never* cleared by anything other than
copy_process or __audit_syscall_exit.

This means that, if there's a pending audit record, then
TIF_SYSCALL_AUDIT will be set.  That, in turn, means that
__audit_syscall_exit will be called, which avoids the BUGs you pointed
out.

Now we get rid of __audit_syscall_entry.  (This speeds up even the
auditing-is-on case.)  Instead we have __audit_start_record, which
does more or less the same thing, except that (a) it doesn't BUG if
in_syscall and (b) it *sets* TIF_SYSCALL_AUDIT.  This relies on the
fact that syscall_get_nr and syscall_get_arguments are reliable on
x86_64.  I suspect that they're reliable everywhere else, too.  The
idea is that there's nothing wrong with calling __audit_start_record
more than once.  (Maybe it should be called
__audit_record_this_syscall.)

To finish the job, we change __audit_syscall_exit to clear
TIF_SYSCALL_AUDIT if n_rules==0.  inc_n_rules can set
TIF_SYSCALL_AUDIT (without even needing to worry about races, I
think).  dec_n_rules doesn't need to do anything special.

Benefits:
 - Removing the syscall entry hook speeds everyone up.  Even silly
people who use exit rules :)
 - There's no need to think about mismatched entry/exit hook calls,
since there is no entry hook.
 - The same mechanism could be reused for non-audit purposes.  Any
code could say, at any point "hey, this syscall is interesting.  let's
record it."

Disadvantages:
 - Need to check other architectures to make sure that syscall_get_xyz
works reliably for fast path syscalls.
 - For the full performance boost, all architectures need to avoid
checking TIF_SYSCALL_AUDIT in the entry path.  I prefer not to mess
with non-x86 assembly, so I won't do that part, since it's not
required for correctness.

Eric, any thoughts?

--Andy
