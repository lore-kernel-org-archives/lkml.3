Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaJAHq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:46:29 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43180 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJAHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:46:27 -0400
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, "Srivatsa S. Bhat" <srivatsa@mit.edu>,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v2 0/3] powernv/cpuidle: Fastsleep workaround and fixes
Date: Wed,  1 Oct 2014 13:15:57 +0530
Message-Id: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100107-9332-0000-0000-00000230EDAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fast sleep is an idle state, where the core and the L1 and L2
caches are brought down to a threshold voltage. This also means that
the communication between L2 and L3 caches have to be fenced. However
the current P8 chips have a bug wherein this fencing between L2 and
L3 caches get delayed by a cpu cycle. This can delay L3 response to
the other cpus if they request for data during this time. Thus they
would fetch the same data from the memory which could lead to data
corruption if L3 cache is not flushed. 

This series overcomes above problem in kernel.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Srivatsa S. Bhat <srivatsa@mit.edu>
Cc: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

v2:
Rebased on 3.17-rc7
Split from 'powerpc/powernv: Support for fastsleep and winkle'

v1:
https://lkml.org/lkml/2014/8/25/446

Preeti U Murthy (1):
  powerpc/powernv/cpuidle: Add workaround to enable fastsleep

Shreyas B. Prabhu (1):
  powerpc/kvm/book3s_hv: Enable CPUs to run guest after waking up from
    fast-sleep

Srivatsa S. Bhat (1):
  powerpc/powernv: Enable Offline CPUs to enter deep idle states

 arch/powerpc/include/asm/machdep.h             |   3 +
 arch/powerpc/include/asm/opal.h                |   7 ++
 arch/powerpc/include/asm/processor.h           |   4 +-
 arch/powerpc/kernel/exceptions-64s.S           |  35 ++++----
 arch/powerpc/kernel/idle.c                     |  19 ++++
 arch/powerpc/kernel/idle_power7.S              |   2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S |   1 +
 arch/powerpc/platforms/powernv/powernv.h       |   7 ++
 arch/powerpc/platforms/powernv/setup.c         | 118 +++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/smp.c           |  11 ++-
 drivers/cpuidle/cpuidle-powernv.c              |  13 ++-
 11 files changed, 194 insertions(+), 26 deletions(-)

-- 
1.9.3

