Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaLCUHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:07:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51649 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLCUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:07:00 -0500
Message-ID: <547F6D60.5050007@amacapital.net>
Date: Wed, 03 Dec 2014 12:06:56 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, rgb@redhat.com,
        eparis@redhat.com
CC: fweisbec@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: audit: rcu_read_lock() used illegally while idle
References: <20141203181922.GA26916@redhat.com> <20141203192919.GP25340@linux.vnet.ibm.com>
In-Reply-To: <20141203192919.GP25340@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 11:29 AM, Paul E. McKenney wrote:
> On Wed, Dec 03, 2014 at 01:19:22PM -0500, Dave Jones wrote:
>> I'm not sure why this only just started complaining, because this code
>> hasn't changed in years, but I don't recall seeing this before.
>> This gets spewed during bootup since I put 3.18-rc7 on my firewall.
>> Previously it was running rc4 where I didn't see this.
> 
> That is quite strange.  I wonder if NO_HZ_FULL has told RCU that the
> CPU is idle before the sysret_audit hook is called.
> 
> Adding Frederic for his thoughts on this.
> 
>> Did something in RCU change recently ?
> 
> Not since -rc1, as far as I know, anyway.

There was a cute little bug that probably prevented sysret_audit from
being called if TIF_NOHZ was set:

b5e212a3051b x86, syscall: Fix _TIF_NOHZ handling in
syscall_trace_enter_phase1

IOW, between 3.18-rc1 and 3.18-rc6 (approximately), sysret_audit would
never happen in NO_HZ_FULL mode due to that bug.

Looking at the current code, I'm not sure I understand why we don't just
infinite-loop.  Hmm, maybe we do -- could this be the lockup that no one
understands yet?  (I doubt it, but maybe.)

The loop would be:

sysret_check:

Load ti.flags into edx (assume that _TIF_SYSCALL_AUDIT and some other
_TIF_ALLWORK_MASK but is set).

Jump to sysret_careful.  Eventually get to sysret_signal.  Notice that
TIF_SYSCALL_AUDIT is set in edx.  Jump to sysret_audit.

sysret_audit then clears the _TIF_SYSCALL_AUDIT bit from edi.  edi is
not edx.  Hmm.

Jump to sysret_check, where edx is the same as before.  Repeat.

This doesn't explain how we end up screwing up context tracking.  But I
don't understand why we don't execute the audit exit hook *twice* if
TIF_NOHZ is set.

I have patches to delete this whole fscking sysret fast but not really
fast path.  I'll resend them for 3.19.  In the mean time, can you test
this patch by itself:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=1072a16a8d4ad1b11b8062f76e3236b9771b0fb6

Applying just that patch will result in a fairly large performance hit
if auditing is on, but given the shear number of bugs that the syscall
audit hooks seem to cause, I'm think it may be a reasonable tradeoff.  I
don't really like it as a last-minute fix, though.  (To get the
performance back, you need the two patches before it, but those are
*definitely* not last-minute material.)


On another note, all those TIF_FOO_BAR_BAZ masks are incomprehensible
and probably wrong in various interesting ways.

--Andy

> 
> 							Thanx, Paul
> 
>> ===============================
>> [ INFO: suspicious RCU usage. ]
>> 3.18.0-rc7+ #93 Not tainted
>> -------------------------------
>> include/linux/rcupdate.h:883 rcu_read_lock() used illegally while idle!
>>
>> other info that might help us debug this:
>>
>>
>> RCU used illegally from idle CPU!
>> rcu_scheduler_active = 1, debug_locks = 0
>> RCU used illegally from extended quiescent state!
>> 1 lock held by systemd-sysctl/557:
>>  #0:  (rcu_read_lock){......}, at: [<ffffffff890f1320>] audit_filter_type+0x0/0x240
>>
>> stack backtrace:
>> CPU: 0 PID: 557 Comm: systemd-sysctl Not tainted 3.18.0-rc7+ #93
>>  0000000000000000 0000000063c50efc ffff88021f51fd28 ffffffff895abec3
>>  0000000000000000 ffff880234758000 ffff88021f51fd58 ffffffff890a5280
>>  ffff880221d9c548 00007fd651f320d0 0000000000000514 00000000ffff9012
>> Call Trace:
>>  [<ffffffff895abec3>] dump_stack+0x4e/0x68
>>  [<ffffffff890a5280>] lockdep_rcu_suspicious+0xf0/0x110
>>  [<ffffffff890f150e>] audit_filter_type+0x1ee/0x240
>>  [<ffffffff890f1320>] ? audit_filter_user+0x340/0x340
>>  [<ffffffff890ecd39>] audit_log_start+0x49/0x4a0
>>  [<ffffffff8908f4f5>] ? local_clock+0x25/0x30
>>  [<ffffffff890a397f>] ? lock_release_holdtime.part.30+0xf/0x190
>>  [<ffffffff890f1973>] audit_log_exit+0x53/0xcf0
>>  [<ffffffff8908f4f5>] ? local_clock+0x25/0x30
>>  [<ffffffff890a397f>] ? lock_release_holdtime.part.30+0xf/0x190
>>  [<ffffffff895b4f0c>] ? sysret_signal+0x5/0x43
>>  [<ffffffff890f4a65>] __audit_syscall_exit+0x245/0x2a0
>>  [<ffffffff895b4f61>] sysret_audit+0x17/0x21
>>
> 

