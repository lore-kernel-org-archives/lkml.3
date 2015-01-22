Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbbAVVyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:54:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47430 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbbAVVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:54:14 -0500
Message-ID: <54C17139.1040706@oracle.com>
Date: Thu, 22 Jan 2015 16:52:57 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVj?= =?UTF-8?B?a2Vy?= 
	<fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST
 context
References: <cover.1416604491.git.luto@amacapital.net> <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
In-Reply-To: <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 04:26 PM, Andy Lutomirski wrote:
> We currently pretend that IST context is like standard exception
> context, but this is incorrect.  IST entries from userspace are like
> standard exceptions except that they use per-cpu stacks, so they are
> atomic.  IST entries from kernel space are like NMIs from RCU's
> perspective -- they are not quiescent states even if they
> interrupted the kernel during a quiescent state.
> 
> Add and use ist_enter and ist_exit to track IST context.  Even
> though x86_32 has no IST stacks, we track these interrupts the same
> way.
> 
> This fixes two issues:
> 
>  - Scheduling from an IST interrupt handler will now warn.  It would
>    previously appear to work as long as we got lucky and nothing
>    overwrote the stack frame.  (I don't know of any bugs in this
>    that would trigger the warning, but it's good to be on the safe
>    side.)
> 
>  - RCU handling in IST context was dangerous.  As far as I know,
>    only machine checks were likely to trigger this, but it's good to
>    be on the safe side.
> 
> Note that the machine check handlers appears to have been missing
> any context tracking at all before this patch.

Hi Andy, Paul,

I *suspect* that the following is a result of this commit:

[  543.999079] ===============================
[  543.999079] [ INFO: suspicious RCU usage. ]
[  543.999079] 3.19.0-rc5-next-20150121-sasha-00064-g3c37e35-dirty #1809 Not tainted
[  543.999079] -------------------------------
[  543.999079] include/linux/rcupdate.h:892 rcu_read_lock() used illegally while idle!
[  543.999079]
[  543.999079] other info that might help us debug this:
[  543.999079]
[  543.999079]
[  543.999079] RCU used illegally from idle CPU!
[  543.999079] rcu_scheduler_active = 1, debug_locks = 1
[  543.999079] RCU used illegally from extended quiescent state!
[  543.999079] 1 lock held by trinity-main/15058:
[  543.999079] #0: (rcu_read_lock){......}, at: atomic_notifier_call_chain (kernel/notifier.c:192)
[  543.999079]
[  543.999079] stack backtrace:
[  543.999079] CPU: 16 PID: 15058 Comm: trinity-main Not tainted 3.19.0-rc5-next-20150121-sasha-00064-g3c37e35-dirty #1809
[  543.999079]  0000000000000000 0000000000000000 0000000000000001 ffff8801af907d88
[  543.999079]  ffffffff92e9e917 0000000000000011 ffff8801afcf8000 ffff8801af907db8
[  543.999079]  ffffffff815f5613 ffffffff9654d4a0 0000000000000003 ffff8801af907e28
[  543.999079] Call Trace:
[  543.999079] dump_stack (lib/dump_stack.c:52)
[  543.999079] lockdep_rcu_suspicious (kernel/locking/lockdep.c:4259)
[  543.999079] atomic_notifier_call_chain (include/linux/rcupdate.h:892 kernel/notifier.c:182 kernel/notifier.c:193)
[  543.999079] ? atomic_notifier_call_chain (kernel/notifier.c:192)
[  543.999079] notify_die (kernel/notifier.c:538)
[  543.999079] ? atomic_notifier_call_chain (kernel/notifier.c:538)
[  543.999079] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[  543.999079] do_debug (arch/x86/kernel/traps.c:652)
[  543.999079] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[  543.999079] ? do_int3 (arch/x86/kernel/traps.c:610)
[  543.999079] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2554 kernel/locking/lockdep.c:2601)
[  543.999079] debug (arch/x86/kernel/entry_64.S:1310)


Thanks,
Sasha
