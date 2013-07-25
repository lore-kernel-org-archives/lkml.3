Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3GYJFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:05:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52463 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3GYJFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:05:34 -0400
Subject: [RFC PATCH 0/5] cpuidle/ppc: Timer offload framework to support
 deep idle states
To: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, michael@ellerman.id.au,
        arnd@arndb.de, linux-pm@vger.kernel.org, rostedt@goodmis.org,
        rjw@sisk.pl, john.stultz@linaro.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        geoff@infradead.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Thu, 25 Jul 2013 14:32:38 +0530
Message-ID: <20130725090016.12500.28888.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072509-2674-0000-0000-000009F42D58
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
for powernv posted by Deepthi Dharwar recently. The current design and
implementation supports the ONESHOT tick mode. It does not yet support
the PERIODIC tick mode. This patch is tested with NOHZ_FULL off.

Patch[1/5], Patch[2/5]: optimize the broadcast mechanism on ppc.
Patch[3/5]: Introduces the core of the timer offload framework on powerpc.
Patch[4/5]: The cpu doing the broadcast should not go into tickless idle.
Patch[5/5]: Add a deep idle state to the cpuidle state table on powernv.

Patch[5/5] is the patch that ultimately makes use of the timer offload
framework that the patches Patch[1/5] to Patch[4/5] build.

---

Preeti U Murthy (3):
      cpuidle/ppc: Add timer offload framework to support deep idle states
      cpuidle/ppc: CPU goes tickless if there are no arch-specific constraints
      cpuidle/ppc: Add longnap state to the idle states on powernv

Srivatsa S. Bhat (2):
      powerpc: Free up the IPI message slot of ipi call function (PPC_MSG_CALL_FUNC)
      powerpc: Implement broadcast timer interrupt as an IPI message


 arch/powerpc/include/asm/smp.h                  |    3 +
 arch/powerpc/include/asm/time.h                 |    3 +
 arch/powerpc/kernel/smp.c                       |   23 ++++--
 arch/powerpc/kernel/time.c                      |   84 +++++++++++++++++++++++
 arch/powerpc/platforms/cell/interrupt.c         |    2 -
 arch/powerpc/platforms/powernv/Kconfig          |    1 
 arch/powerpc/platforms/powernv/processor_idle.c |   48 +++++++++++++
 arch/powerpc/platforms/ps3/smp.c                |    2 -
 kernel/time/tick-sched.c                        |    7 ++
 9 files changed, 161 insertions(+), 12 deletions(-)

-- 
Signature

