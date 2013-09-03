Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3ICO56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:57:58 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:51235 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab3ICO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:57:57 -0400
Message-ID: <5225F8EF.3040701@keymile.com>
Date: Tue, 03 Sep 2013 16:57:51 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org>
In-Reply-To: <5221264F.4070402@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried again from scratch, so let me recap the whole situation, so we 
can all view it from the same standpoint. This should make the problem 
easier to see and reproduce.

I can confirm that running a stock 3.10 kernel with HRTICK enabled:

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..294e3ca 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -41,7 +41,7 @@ SCHED_FEAT(WAKEUP_PREEMPTION, true)
   */
  SCHED_FEAT(ARCH_POWER, true)

-SCHED_FEAT(HRTICK, false)
+SCHED_FEAT(HRTICK, true)
  SCHED_FEAT(DOUBLE_TICK, false)
  SCHED_FEAT(LB_BIAS, true)

makes the following program (and the whole board, as a matter of fact) 
hang with no further notice:

#include <stdio.h>
#include <sys/timex.h>

int main(void)
{
     int i;

     for (i = 0 ; ; i++) {
         struct timex adj = {};
         printf("%d\r", i);
         fflush(stdout);
         adjtimex(&adj);
     }
     return 0;
}

If I then revert everything up to (and including) the offending commit
(mind the '~'):

$ git log --oneline ...06c017f~ -- kernel/time/timekeeping.c 
kernel/time/ntp.c | cut -f1 -d' ' | xargs git revert

The problem disappears.

If I then cherry-pick again the offending commit:

$ git cherry-pick 06c017f; git log -1

commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
Author: John Stultz <john.stultz@linaro.org>
Date:   Fri Mar 22 11:37:28 2013 -0700

      timekeeping: Hold timekeepering locks in do_adjtimex and hardpps

      In moving the NTP state to be protected by the timekeeping locks,
      be sure to acquire the timekeeping locks prior to calling
      ntp functions.

      Cc: Thomas Gleixner <tglx@linutronix.de>
      Cc: Richard Cochran <richardcochran@gmail.com>
      Cc: Prarit Bhargava <prarit@redhat.com>
      Signed-off-by: John Stultz <john.stultz@linaro.org>

I get the following deadlock report:

================================ cut ===============================

=================================
[ INFO: inconsistent lock state ]
3.10.0-00018-gd915798 #3 Not tainted
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
a.out/574 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (timekeeper_lock){?.-...}, at: [<c0049d00>] do_adjtimex+0x94/0xf4
{IN-HARDIRQ-W} state was registered at:
   [<c00548fc>] __lock_acquire+0xabc/0x1bb8
   [<c0055ffc>] lock_acquire+0xa8/0x15c
   [<c0432c1c>] _raw_spin_lock_irqsave+0x50/0x64
   [<c0049090>] do_timer+0x2c/0xa54
   [<c004dfa8>] tick_periodic+0x74/0x9c
   [<c004dfe8>] tick_handle_periodic+0x18/0x7c
   [<c0012da8>] orion_timer_interrupt+0x24/0x34
   [<c00693b8>] handle_irq_event_percpu+0x5c/0x300
   [<c0069698>] handle_irq_event+0x3c/0x5c
   [<c006b920>] handle_level_irq+0x8c/0xe8
   [<c0068d30>] generic_handle_irq+0x28/0x44
   [<c000951c>] handle_IRQ+0x30/0x84
   [<c04338b8>] __irq_svc+0x38/0xa0
   [<c0617824>] calibrate_delay+0x350/0x4e4
   [<c05e26e0>] start_kernel+0x23c/0x2c4
   [<0000803c>] 0x803c
irq event stamp: 2840
hardirqs last  enabled at (2839): [<c0008ccc>] no_work_pending+0x8/0x28
hardirqs last disabled at (2840): [<c0432bec>] 
_raw_spin_lock_irqsave+0x20/0x64
softirqs last  enabled at (2098): [<c039e908>] rpc_wake_up_first+0x6c/0x15c
softirqs last disabled at (2096): [<c0432e58>] _raw_spin_lock_bh+0x14/0x54

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(timekeeper_lock);
   <Interrupt>
     lock(timekeeper_lock);

  *** DEADLOCK ***

1 lock held by a.out/574:
  #0:  (timekeeper_lock){?.-...}, at: [<c0049d00>] do_adjtimex+0x94/0xf4

stack backtrace:
CPU: 0 PID: 574 Comm: a.out Not tainted 3.10.0-00018-gd915798 #3
[<c000d67c>] (unwind_backtrace+0x0/0xf0) from [<c000b530>] 
(show_stack+0x10/0x14)
[<c000b530>] (show_stack+0x10/0x14) from [<c042c274>] 
(print_usage_bug.part.27+0x218/0x280)
[<c042c274>] (print_usage_bug.part.27+0x218/0x280) from [<c005281c>] 
(mark_lock+0x538/0x6bc)
[<c005281c>] (mark_lock+0x538/0x6bc) from [<c0052a30>] 
(mark_held_locks+0x90/0x124)
[<c0052a30>] (mark_held_locks+0x90/0x124) from [<c0052b6c>] 
(trace_hardirqs_on_caller+0xa8/0x23c)
[<c0052b6c>] (trace_hardirqs_on_caller+0xa8/0x23c) from [<c0433390>] 
(_raw_spin_unlock_irq+0x24/0x5c)
[<c0433390>] (_raw_spin_unlock_irq+0x24/0x5c) from [<c004a490>] 
(__do_adjtimex+0xf0/0x580)
[<c004a490>] (__do_adjtimex+0xf0/0x580) from [<c0049d20>] 
(do_adjtimex+0xb4/0xf4)
[<c0049d20>] (do_adjtimex+0xb4/0xf4) from [<c001cf38>] 
(SyS_adjtimex+0x50/0xa8)
[<c001cf38>] (SyS_adjtimex+0x50/0xa8) from [<c0008c40>] 
(ret_fast_syscall+0x0/0x44)

================================ cut ===============================

And as soon as I also cherry-pick (notice there is another commit in 
between, which seems not to be relevant on this matter):

$ git cherry-pick a076b2146fabb0894cae5e0189a8ba3f1502d737; git show

commit a076b2146fabb0894cae5e0189a8ba3f1502d737
Author: John Stultz <john.stultz@linaro.org>
Date:   Fri Mar 22 11:52:03 2013 -0700

     ntp: Remove ntp_lock, using the timekeeping locks to protect ntp state

     In order to properly handle the NTP state in future changes to the
     timekeeping lock management, this patch moves the management of
     all of the ntp state under the timekeeping locks.

     This allows us to remove the ntp_lock.

     Cc: Thomas Gleixner <tglx@linutronix.de>
     Cc: Richard Cochran <richardcochran@gmail.com>
     Cc: Prarit Bhargava <prarit@redhat.com>
     Signed-off-by: John Stultz <john.stultz@linaro.org>


I end up in the situation where the system hangs completely and NO 
deadlock report whatsoever is output.

So it looks like 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40 introduces the 
deadlock, while a076b2146fabb0894cae5e0189a8ba3f1502d737 cares to hide 
the report.

Notice how I tested the above on an ARM board; on PowerPC I get similar 
results, although I am not able to see the deadlock report under any 
circumstances (enabling CONFIG_PROVE_LOCKING, which is the flag that 
triggers the deadlock report, causes the kernel to hang at startup even 
on a vanilla 3.10 kernel).

John, could you please confirm whether you're at least able to reproduce 
it somehow?

Thank you,
Gerlando
