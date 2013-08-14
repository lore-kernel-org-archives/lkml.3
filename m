Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3HNL6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:58:24 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45960 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab3HNL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:58:23 -0400
Subject: [RFC V2 PATCH 0/6] cpuidle/ppc: Timer offload framework to support
 deep idle states
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, rjw@sisk.pl, john.stultz@linaro.org,
        tglx@linutronix.de, chenhui.zhao@freescale.com, michael@ellerman.id.au,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 17:25:47 +0530
Message-ID: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081411-8256-0000-0000-000008CA1A6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC, when CPUs enter deep idle states, their local timers are
switched off. The responsibility of waking them up at their next timer event,
needs to be handed over to an external device. On PowerPC, we do not have an
external device equivalent to HPET, which is currently done on architectures
like x86. Instead we assign the local timer of one of the CPUs to do this job.

This patchset is an attempt to make use of the existing timer broadcast
framework in the kernel to meet the above requirement, except that the tick
broadcast device is the local timer of the boot CPU.

This patch series is ported ontop of 3.11-rc1 + the cpuidle driver backend
for powernv posted by Deepthi Dharwar recently. NOHZ_FULL is disabled for all
testing purposes.
  The current design and implementation supports the ONESHOT tick mode.
It does not yet support the PERIODIC tick mode.

The discussion around V1 of this patchset can be found here:
https://lkml.org/lkml/2013/7/25/740.

Changes since V1:
1. Dynamically pick a broadcast CPU, instead of having a dedicated one.
2. Remove the constraint of having to disable tickless idle on the broadcast CPU.

Thanks to Ben H, Frederic Weisbecker, Li Yang and Vaidyanathan Srinivasan for
all their comments and suggestions on the V1 of this patchset.

Patch[1/6], Patch[2/6]: optimize the broadcast mechanism on ppc.
Patch[3/6]: Introduces the core of the timer offload framework on powerpc.
Patch[4/6]: Add a deep idle state to the cpuidle state table on powernv
Patch[5/6]: Dynamically pick a broadcast CPU
Patch[6/6]: Remove the constraint of having to disable tickless idle on the
broadcast cpu, by queueing a hrtimer exclusively to do broadcast handling.

---

Preeti U Murthy (4):
      cpuidle/ppc: Add timer offload framework to support deep idle states
      cpuidle/ppc: Add longnap state to the idle states on powernv
      cpuidle/ppc: Enable dynamic movement of the broadcast functionality across CPUs
      cpuidle/ppc : Queue a hrtimer on bc_cpu, explicitly to do broadcast handling

Srivatsa S. Bhat (2):
      powerpc: Free up the IPI message slot of ipi call function (PPC_MSG_CALL_FUNC)
      powerpc: Implement broadcast timer interrupt as an IPI message


 arch/powerpc/include/asm/smp.h                  |    3 -
 arch/powerpc/include/asm/time.h                 |    9 ++
 arch/powerpc/kernel/smp.c                       |   23 +++--
 arch/powerpc/kernel/time.c                      |  114 +++++++++++++++++++++++
 arch/powerpc/platforms/cell/interrupt.c         |    2 
 arch/powerpc/platforms/powernv/Kconfig          |    1 
 arch/powerpc/platforms/powernv/processor_idle.c |  104 +++++++++++++++++++++
 arch/powerpc/platforms/ps3/smp.c                |    2 
 8 files changed, 246 insertions(+), 12 deletions(-)

