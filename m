Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaAOIL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:11:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51610 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaAOILY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:11:24 -0500
Subject: [PATCH V5 0/8] cpuidle/ppc: Enable deep idle states on PowerNV
To: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        agraf@suse.de, paul.gortmaker@windriver.com, paulus@samba.org,
        mingo@kernel.org, mikey@neuling.org, shangw@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 13:37:45 +0530
Message-ID: <20140115080555.20446.27238.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011508-0928-0000-0000-000005A6160C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, when CPUs enter certain deep idle states, the local timers stop
and the time base could go out of sync with the rest of the cores in the system.

This patchset adds support to wake up CPUs in such idle states by
broadcasting IPIs to them at their next timer events using the tick broadcast
framework in the Linux kernel. We refer to these IPIs as the tick
broadcast IPIs in this patchset.

However the tick broadcast framework as it exists today makes use of an external
clock device to wakeup CPUs in such idle states. But not all implementations of
PowerPC provides such an external clock device.

Hence Patch[6/8]:
[time/cpuidle: Support in tick broadcast framework for archs without external
clock device] adds support in the tick broadcast framework for such
use cases by queuing a hrtimer on one of the CPUs which is meant to handle the wakeup
of CPUs in deep idle states.
This patch was posted separately at: https://lkml.org/lkml/2013/12/12/687.

Patches 1-3 adds support in powerpc to hook onto the tick broadcast framework.

The patchset also includes support for resyncing of time base with the rest of the
cores in the system and context management for fast sleep. PATCH[4/8] and
PATCH[5/8] address these issues.

With the required support for deep idle states thus in place, the
patchset adds "Fast-Sleep" idle state into cpuidle (Patches 7 and 8). "Fast-Sleep"
is a deep idle state on Power8 in which the above mentioned challenges
exist. Fast-Sleep can yield us significantly more power
savings than the idle states that we have in cpuidle so far.

This patchset is based on mainline commit-id:8ae516aa8b8161254d3,  and the
cpuidle driver for powernv posted by Deepthi Dharwar:
https://lkml.org/lkml/2014/1/14/172


Changes in V5:
-------------
The primary change in this version is in Patch[6/8].
As per the discussions in V4 posting of this patchset, it was decided to
refine handling the wakeup of CPUs in fast-sleep by doing the following:

1. In V4, a polling mechanism was used by the CPU handling broadcast to
find out the time of next wakeup of the CPUs in deep idle states. V5 avoids
polling by a way described under PATCH[6/8] in this patchset.

2. The mechanism of broadcast handling of CPUs in deep idle in the absence of an
external wakeup device should be generic and not arch specific code. Hence in this
version this functionality has been integrated into the tick broadcast framework in
the kernel unlike before where it was handled in powerpc specific code.

3. It was suggested that the "broadcast cpu" can be the time keeping cpu
itself. However this has challenges of its own:

 a. The time keeping cpu need not exist when all cpus are idle. Hence there
are phases in time when time keeping cpu is absent. But for the use case that
this patchset is trying to address we rely on the presence of a broadcast cpu
all the time.

 b. The nomination and un-assignment of the time keeping cpu is not protected
by a lock today and need not be as well since such is its use case in the
kernel. However we would need locks if we double up the time keeping cpu as the
broadcast cpu.

Hence the broadcast cpu is independent of the time-keeping cpu. However PATCH[6/8]
proposes a simpler solution to pick a broadcast cpu in this version.



Changes in V4:
-------------
https://lkml.org/lkml/2013/11/29/97

1. Add Fast Sleep CPU idle state on PowerNV.

2. Add the required context management for Fast Sleep and the call to OPAL
to synchronize time base after wakeup from fast sleep.

4. Add parsing of CPU idle states from the device tree to populate the
cpuidle
state table.

5. Rename ambiguous functions in the code around waking up of CPUs from fast
sleep.

6. Fixed a bug in re-programming of the hrtimer that is queued to wakeup the
CPUs in fast sleep and modified Changelogs.

7. Added the ARCH_HAS_TICK_BROADCAST option. This signifies that we have a
arch specific function to perform broadcast.


Changes in V3:
-------------
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


Changes in V2:
-------------
https://lkml.org/lkml/2013/8/14/239

1. Dynamically pick a broadcast CPU, instead of having a dedicated one.
2. Remove the constraint of having to disable tickless idle on the broadcast
CPU by queueing a hrtimer dedicated to do broadcast.



V1 posting: https://lkml.org/lkml/2013/7/25/740.

1. Added the infrastructure to wakeup CPUs in deep idle states in which the
local timers stop.
---

Preeti U Murthy (4):
      cpuidle/ppc: Split timer_interrupt() into timer handling and interrupt handling routines
      time/cpuidle: Support in tick broadcast framework in the absence of external clock device
      cpuidle/powernv: Add "Fast-Sleep" CPU idle state
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
 arch/powerpc/include/asm/time.h                |    1 
 arch/powerpc/kernel/exceptions-64s.S           |   10 +
 arch/powerpc/kernel/idle_power7.S              |   90 +++++++++--
 arch/powerpc/kernel/smp.c                      |   23 ++-
 arch/powerpc/kernel/time.c                     |   80 ++++++----
 arch/powerpc/platforms/cell/interrupt.c        |    2 
 arch/powerpc/platforms/powernv/opal-wrappers.S |    1 
 arch/powerpc/platforms/ps3/smp.c               |    2 
 drivers/cpuidle/cpuidle-powernv.c              |  106 ++++++++++++-
 include/linux/clockchips.h                     |    4 -
 kernel/time/clockevents.c                      |    9 +
 kernel/time/tick-broadcast.c                   |  192 ++++++++++++++++++++++--
 kernel/time/tick-internal.h                    |    8 +
 17 files changed, 434 insertions(+), 101 deletions(-)

-- 

