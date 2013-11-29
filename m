Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3K2Koi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:44:38 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52690 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab3K2Koe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:44:34 -0500
Subject: [PATCH V4 0/9] cpuidle/ppc: Enable deep idle states on PowerNV
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 29 Nov 2013 16:11:06 +0530
Message-ID: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112910-0320-0000-0000-000001DA61CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, when CPUs enter certain deep idle states, the local timers stop and the
time base could go out of sync with the rest of the cores in the system.

This patchset adds support to wake up CPUs in such idle states by broadcasting
IPIs to them at their next timer events. We refer to these IPIs as the tick
broadcast IPIs in this patchset to refer to this context.

The patchset also includes resyncing of time base with the rest of the cores
in the system as soon as the CPUs wake up from deep idle states.

"Fast-Sleep" is a deep idle state on Power8 in which the above mentioned challenges
exist. With the required support for deep idle states thus in place, the patchset
adds Fast-Sleep into cpuidle. Fast-Sleep can yield us significantly more power
savings than the idle states that we have in cpuidle so far.

This patchset is based on mainline-3.13-rc1 and the cpuidle driver for power
posted by Deepthi Dharwar: https://lkml.org/lkml/2013/11/11/29

Changes in V4:

1. Add Fast Sleep CPU idle state on PowerNV.

2. Add the required context management for Fast Sleep and the call to OPAL
to synchronize time base after wakeup from fast sleep.

4. Add parsing of CPU idle states from the device tree to populate the cpuidle
state table.

5. Rename ambiguous functions in the code around waking up of CPUs from fast
sleep.

6. Fixed a bug in re-programming of the hrtimer that is queued to wakeup the
CPUs in fast sleep and modified Changelogs.

7. Added the ARCH_HAS_TICK_BROADCAST option. This signifies that we have a
arch specific function to perform broadcast.

Changes in V3:
http://thread.gmane.org/gmane.linux.power-management.general/38113

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

1. Added the infrastructure to wakeup CPUs in deep idle states in which the
local timers stop.

---

Preeti U Murthy (5):
      cpuidle/ppc: Split timer_interrupt() into timer handling and interrupt handling routines
      cpuidle/ppc: Add basic infrastructure to enable the broadcast framework on ppc
      cpuidle/powernv: Add "Fast-Sleep" CPU idle state
      cpuidle/ppc: Nominate new broadcast cpu on hotplug of the old
      cpuidle/powernv: Parse device tree to setup idle states

Srivatsa S. Bhat (2):
      powerpc: Free up the slot of PPC_MSG_CALL_FUNC_SINGLE IPI message
      powerpc: Implement tick broadcast IPI as a fixed IPI message

Vaidyanathan Srinivasan (2):
      powernv/cpuidle: Add context management for Fast Sleep
      powermgt: Add OPAL call to resync timebase on wakeup


 arch/powerpc/Kconfig                           |    2 
 arch/powerpc/include/asm/opal.h                |    2 
 arch/powerpc/include/asm/processor.h           |    1 
 arch/powerpc/include/asm/smp.h                 |    2 
 arch/powerpc/include/asm/time.h                |    4 
 arch/powerpc/kernel/exceptions-64s.S           |   10 +
 arch/powerpc/kernel/idle_power7.S              |   90 +++++++--
 arch/powerpc/kernel/smp.c                      |   23 ++
 arch/powerpc/kernel/time.c                     |  137 ++++++++++----
 arch/powerpc/platforms/cell/interrupt.c        |    2 
 arch/powerpc/platforms/powernv/opal-wrappers.S |    1 
 arch/powerpc/platforms/ps3/smp.c               |    2 
 drivers/cpuidle/cpuidle-powerpc-book3s.c       |  241 +++++++++++++++++++++++-
 13 files changed, 443 insertions(+), 74 deletions(-)

-- 

