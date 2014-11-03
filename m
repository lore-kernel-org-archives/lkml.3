Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaKCQIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:08:50 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41382 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaKCQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:08:48 -0500
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH 0/4] powernv: cpuidle: Redesign idle states management
Date: Mon,  3 Nov 2014 21:38:26 +0530
Message-Id: <1415030910-5799-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110316-0013-0000-0000-000005FA52A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deep idle states like sleep and winkle are per core idle states. A core
enters these states only when all the threads enter either the particular
idle state or a deeper one. There are tasks like fastsleep hardware bug
workaround and hypervisor core state save which have to be done only by
the last thread of the core entering deep idle state and similarly tasks
like timebase resync, hypervisor core register restore that have to be
done only by the first thread waking up from these states. 

The current idle state management does not have a way to distinguish the
first/last thread of the core waking/entering idle states. Tasks like
timebase resync are done for all the threads. This is not only is suboptimal,
but can cause functionality issues when subcores are involved.

Winkle is deeper idle state compared to fastsleep. In this state the power
supply to the chiplet, i.e core, private L2 and private L3 is turned off.
This results in a total hypervisor state loss. This patch set adds support
for winkle and provides a way to track the idle states of the threads of the
core and use it for idle state management of idle states sleep and winkle.

TODO:
-----
Handle the case where a thread enters nap and wakes up with supervisor/
hypervisor state loss. This can only happen due to a bug in the
hardware or the kernel. One way to handle this can be restore the state,
switch to the kernel process context and trigger a panic or a warning.


Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Paul Mackerras (1):
  powerpc: powernv: Switch off MMU before entering nap/sleep/rvwinkle
    mode

Preeti U. Murthy (1):
  powerpc/powernv: Enable Offline CPUs to enter deep idle states

Shreyas B. Prabhu (2):
  powernv: cpuidle: Redesign idle states management
  powernv: powerpc: Add winkle support for offline cpus

 arch/powerpc/include/asm/cpuidle.h             |  14 ++
 arch/powerpc/include/asm/opal.h                |  13 +
 arch/powerpc/include/asm/paca.h                |   6 +
 arch/powerpc/include/asm/ppc-opcode.h          |   2 +
 arch/powerpc/include/asm/processor.h           |   1 +
 arch/powerpc/include/asm/reg.h                 |   2 +
 arch/powerpc/kernel/asm-offsets.c              |   6 +
 arch/powerpc/kernel/cpu_setup_power.S          |   4 +
 arch/powerpc/kernel/exceptions-64s.S           |  30 ++-
 arch/powerpc/kernel/idle_power7.S              | 326 +++++++++++++++++++++----
 arch/powerpc/platforms/powernv/opal-wrappers.S |  39 +++
 arch/powerpc/platforms/powernv/powernv.h       |   2 +
 arch/powerpc/platforms/powernv/setup.c         | 170 +++++++++++++
 arch/powerpc/platforms/powernv/smp.c           |  10 +-
 arch/powerpc/platforms/powernv/subcore.c       |  35 +++
 arch/powerpc/platforms/powernv/subcore.h       |   1 +
 drivers/cpuidle/cpuidle-powernv.c              |  10 +-
 17 files changed, 611 insertions(+), 60 deletions(-)
 create mode 100644 arch/powerpc/include/asm/cpuidle.h

-- 
1.9.3

