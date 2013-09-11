Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3IKCxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:53:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45058 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab3IKCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:53:37 -0400
Subject: [PATCH V3 0/6] cpuidle/ppc: Enable broadcast support for deep idle
 states
To: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 08:20:49 +0530
Message-ID: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091102-9332-0000-0000-0000016033FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, when CPUs enter deep idle states, their local timers get
switched off. An external clock device needs to programmed to wake them
up at their next timer event.
	On PowerPC, we do not have an external device equivalent to HPET,
which is currently used on architectures like x86 under the same scenario.
Instead we assign the local timer of one of the CPUs to do this job.

This patchset is an attempt to hook onto the existing timer broadcast
framework in the kernel by using the local timer of one of the CPUs to do the
job of the external clock device.

On expiry of this device, the broadcast framework today has the infrastructure
to send ipis to all such CPUs whose local timers have expired. Hence the term
"broadcast" and the ipi sent is called the broadcast ipi.

This patch series is ported ontop of 3.11-rc7 + the cpuidle driver backend
for power posted by Deepthi Dharwar recently.
http://comments.gmane.org/gmane.linux.ports.ppc.embedded/63556

Changes in V3:

1. Fix the way in which a broadcast ipi is handled on the idling cpus. Timer
handling on a broadcast ipi is being done now without missing out any timer
stats generation.

2. Fix a bug in the programming of the hrtimer meant to do broadcast. Program
it to trigger at the earlier of a "broadcast period", and the next wakeup
event. By introducing the "broadcast period" as the maximum period after
which the broadcast hrtimer can fire, we ensure that we do not miss
wakeups in corner cases.

3. On hotplug of a broadcast cpu, trigger the hrtimer meant to do broadcast
to fire immediately on the new broadcast cpu. This will ensure we do not miss
doing a broadcast pending in the nearest future.

4. Change the type of allocation from GFP_KERNEL to GFP_NOWAIT while
initializing bc_hrtimer since we are in an atomic context and cannot sleep.

5. Use the broadcast ipi to wakeup the newly nominated broadcast cpu on
hotplug of the old instead of smp_call_function_single(). This is because we
are interrupt disabled at this point and should not be using
smp_call_function_single or its children in this context to send an ipi.

6. Move GENERIC_CLOCKEVENTS_BROADCAST to arch/powerpc/Kconfig.

7. Fix coding style issues.

Changes in V2: https://lkml.org/lkml/2013/8/14/239

1. Dynamically pick a broadcast CPU, instead of having a dedicated one.
2. Remove the constraint of having to disable tickless idle on the broadcast
CPU by queueing a hrtimer dedicated to do broadcast.

V1 posting: https://lkml.org/lkml/2013/7/25/740.

The patchset has been tested for stability in idle and during multi threaded
ebizzy runs.

Many thanks to Ben H, Frederic Weisbecker, Li Yang, Srivatsa S. Bhat and
Vaidyanathan Srinivasan for all their comments and suggestions so far.

---

Preeti U Murthy (4):
      cpuidle/ppc: Split timer_interrupt() into timer handling and interrupt handling routines
      cpuidle/ppc: Add basic infrastructure to support the broadcast framework on ppc
      cpuidle/ppc: Introduce the deep idle state in which the local timers stop
      cpuidle/ppc: Nominate new broadcast cpu on hotplug of the old

Srivatsa S. Bhat (2):
      powerpc: Free up the IPI message slot of ipi call function (PPC_MSG_CALL_FUNC)
      powerpc: Implement broadcast timer interrupt as an IPI message


 arch/powerpc/Kconfig                    |    1 
 arch/powerpc/include/asm/smp.h          |    3 -
 arch/powerpc/include/asm/time.h         |    4 +
 arch/powerpc/kernel/smp.c               |   23 +++-
 arch/powerpc/kernel/time.c              |  143 ++++++++++++++++++++------
 arch/powerpc/platforms/cell/interrupt.c |    2 
 arch/powerpc/platforms/ps3/smp.c        |    2 
 drivers/cpuidle/cpuidle-ibm-power.c     |  172 +++++++++++++++++++++++++++++++
 scripts/kconfig/streamline_config.pl    |    0 
 9 files changed, 307 insertions(+), 43 deletions(-)
 mode change 100644 => 100755 scripts/kconfig/streamline_config.pl

