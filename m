Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaE1EnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:43:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40266 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaE1EnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:43:12 -0400
Subject: [PATCH 0/6] ppc, kvm,
 cpuidle: Allow offline and kvm standby threads to enter fastsleep
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 10:08:34 +0530
Message-ID: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052804-0928-0000-0000-00000244A218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fast sleep is a deep idle state on Power8. The support for the state was
added in commit 0d94873011. Today the idle threads in the host can
potentially be put to fast sleep. But when we launch guests using kvm,
the secondary threads are required to be offline and the offline threads
are put to nap. Besides this case, when secondary threads are woken up
to run guests and eventually go idle or when the guest is killed, they
enter nap. So when the entire core goes idle in both the above scenarios,
the maximum power savings that we can obtain is as much as we can get from
napping the cpus. This patchset adds support in the above two cases
for the threads to enter fast sleep.
---

Srivatsa S. Bhat (6):
      powernv, cpuidle: Move the flags used for idle state discovery to powernv core
      powerpc, powernv, CPU hotplug: Put offline CPUs in Fast-Sleep instead of Nap
      KVM: PPC: Book3S HV: Enable CPUs to run guest after waking up from fast-sleep
      KVM: PPC: Book3S HV: Consolidate the idle-state enter sequence in KVM
      KVM: PPC: Book3S HV: Put KVM standby hwthreads to fast-sleep instead of nap
      ppc,book3s: Go back to same idle state after handling machine check interrupt


 arch/powerpc/include/asm/processor.h    |   12 ++++
 arch/powerpc/kernel/exceptions-64s.S    |   51 +++++++++------
 arch/powerpc/kernel/idle.c              |   52 ++++++++++++++++
 arch/powerpc/kernel/idle_power7.S       |    2 -
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  103 ++++++++++++++++++++++++-------
 arch/powerpc/platforms/powernv/smp.c    |   12 +++-
 drivers/cpuidle/cpuidle-powernv.c       |    7 +-
 7 files changed, 190 insertions(+), 49 deletions(-)

