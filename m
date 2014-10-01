Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJAHrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:47:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40413 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaJAHrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:47:20 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Srivatsa S. Bhat" <srivatsa@MIT.EDU>,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 0/5] Winkle support for offline cpus
Date: Wed,  1 Oct 2014 13:16:52 +0530
Message-Id: <1412149617-3178-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-8236-0000-0000-000005D308AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powernv already has support for nap and sleep and these states are used
by cpuidle framework. This patchset adds support for 'deep winkle' a 
deeper idle state. 

In deep winkle, entire chiplet (core/L2/L3) is power off, leading to 
higher power savings. But this results in hypervisor state loss. This
patchset add the necessary infrastructure to recover from hypervisor
state loss and enables offline cpus to use winkle. 

I've successfully tested subcore functionality with these patches. 
Particularly these two scenarios:

Scenario 1:
-> Set subcore-per-core to 4.
-> Offline and online a complete core
Check if core wakes up with 4 subcores

Scenario 2. 
-> Set subcore-per-core to 1.
-> Offline a core. 
-> set subcore-per-core to 4.
-> Online a core 
Check if core wakes up with 4 subcores.

In both these scenarios, the core wakes up with 4 subcores and can run 
guests on individual subcores.

Note, these patches apply on top 'powernv/cpuidle: Fastsleep workaround and
fixes' series.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Srivatsa S. Bhat <srivatsa@MIT.EDU>
Cc: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org

v2:
Rebased on 3.17-rc7
Split from 'powerpc/powernv: Support for fastsleep and winkle'

v1:
https://lkml.org/lkml/2014/8/25/446

Shreyas B. Prabhu (5):
  powerpc/powernv: Add OPAL call to save and restore
  powerpc: Adding macro for accessing Thread Switch Control Register
  powerpc/powernv: Add winkle infrastructure
  powerpc/powernv: Discover and enable winkle
  powerpc/powernv: Enter deepest supported idle state in offline

 arch/powerpc/include/asm/machdep.h             |  1 +
 arch/powerpc/include/asm/opal.h                |  3 +
 arch/powerpc/include/asm/paca.h                |  3 +
 arch/powerpc/include/asm/ppc-opcode.h          |  2 +
 arch/powerpc/include/asm/processor.h           |  2 +
 arch/powerpc/include/asm/reg.h                 |  1 +
 arch/powerpc/kernel/asm-offsets.c              |  1 +
 arch/powerpc/kernel/exceptions-64s.S           |  4 +-
 arch/powerpc/kernel/idle.c                     | 11 +++
 arch/powerpc/kernel/idle_power7.S              | 81 ++++++++++++++++++++-
 arch/powerpc/platforms/powernv/opal-wrappers.S |  1 +
 arch/powerpc/platforms/powernv/powernv.h       |  1 +
 arch/powerpc/platforms/powernv/setup.c         | 99 ++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/smp.c           |  6 +-
 arch/powerpc/platforms/powernv/subcore.c       | 15 ++++
 15 files changed, 226 insertions(+), 5 deletions(-)

-- 
1.9.3

