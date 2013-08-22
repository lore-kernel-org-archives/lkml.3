Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3HVJyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:54:16 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53279 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3HVJyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:54:14 -0400
Subject: [PATCH V5 0/5] POWER/cpuidle: Generic IBM-POWER cpuidle driver
 enabled for PSERIES and POWERNV platforms
To: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, scottwood@freescale.com,
        linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: michael@ellerman.id.au, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, dongsheng.wang@freescale.com
Date: Thu, 22 Aug 2013 15:23:34 +0530
Message-ID: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082209-5564-0000-0000-0000096020BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series consolidates the backend cpuidle driver for pSeries
and powernv platforms with minimal code duplication.

Current existing backend driver for pseries has been moved to drivers/cpuidle 
and has been extended to accommodate powernv idle power mgmt states. 
As seen in V1 of this patch series, having a separate powernv backend driver 
results in too much code duplication, which is less elegant and can pose 
maintenance problems going further.

Using the cpuidle framework to exploit platform low power idle states
management can take advantage of advanced heuristics, tunables and features 
provided by framework. The statistics and tracing infrastructure provided 
by the cpuidle framework also helps in enabling power management 
related tools and help tune the system and applications.

Earlier in 3.3 kernel, pSeries idle state management was modified to 
exploit the cpuidle framework and the end goal of this patch is to have powernv
platform also to hook its idle states into cpuidle framework with minimal 
code duplication between both platforms.  

This series aims to maintain compatibility and functionality to existing pseries 
and powernv idle cpu management code. There are no new functions or idle 
states added as part of this series. This can be extended by adding more 
states to this existing framework.

This patch series has been tested on both PSERIES and POWERNV
platform and is based on v3.11-rc6 kernel version.

With this patch series, the powernv cpuidle functionalities are on-par with 
pSeries idle management.  

V1 -> http://lkml.org/lkml/2013/7/23/143
V2 -> https://lkml.org/lkml/2013/7/30/872
V3 -> http://comments.gmane.org/gmane.linux.ports.ppc.embedded/63093 
V4 -> https://lkml.org/lkml/2013/8/22/25

Changes in V5:
=============

* As per the discussions in the community, this patch series
  enables cpuidle backend driver only for IBM-POWER 
  platforms. File is re-named from drivers/cpuidle/cpuidle-powerpc.c
  to drivers/cpuidle/cpuildle-ibm-power.c
  New back-end cpuidle driver is called IBM-POWER-Idle.

* General cleanups on the accessors front that was introduced in 
  previous version.

Changes in V4:
=============

* This patch series includes generic backend driver cpuidle cleanups 
  including, replacing the driver and device initialisation
  routines with cpuidle_register function.

* Enable CPUIDLE framework only for POWER and POWERNV platforms.

Changes in V3:
=============

* This patch series does not include smt-snooze-delay fixes. 
  This will be taken up later on.

* Integrated POWERPC driver in drivers/cpuidle.  Enabled for all of 
  POWERPC platform.  Currently has PSERIES and POWERNV support.
  No compile time flags in .c file. This  will be one consolidated 
  binary that does a run time detection based on platform and take 
  decisions accordingly.

* Enabled CPUIDLE framwork for all of PPC64.

Changes in V2:
=============

* Merged the backend driver posted out for powernv in V1 with
  pSeries to create a single powerpc driver but this had compile
  time flags.

 Deepthi Dharwar (5):
      pseries/cpuidle: Remove dependency of pseries.h file
      pseries: Move plpar_wrapper.h to powerpc common include/asm location.
      POWER/cpuidle: Generic IBM-POWER backend cpuidle driver.
      POWER/cpuidle: Enable powernv cpuidle support.
      powernv/cpuidle: Enable idle powernv cpu to call into the cpuidle framework.


 arch/powerpc/include/asm/plpar_wrappers.h       |  325 +++++++++++++++++++++
 arch/powerpc/include/asm/processor.h            |    2 
 arch/powerpc/platforms/powernv/setup.c          |   14 +
 arch/powerpc/platforms/pseries/Kconfig          |    9 -
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/cmm.c            |    3 
 arch/powerpc/platforms/pseries/dtl.c            |    3 
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |    3 
 arch/powerpc/platforms/pseries/hvconsole.c      |    2 
 arch/powerpc/platforms/pseries/iommu.c          |    3 
 arch/powerpc/platforms/pseries/kexec.c          |    2 
 arch/powerpc/platforms/pseries/lpar.c           |    2 
 arch/powerpc/platforms/pseries/plpar_wrappers.h |  324 ---------------------
 arch/powerpc/platforms/pseries/processor_idle.c |  362 -----------------------
 arch/powerpc/platforms/pseries/pseries.h        |    3 
 arch/powerpc/platforms/pseries/setup.c          |    2 
 arch/powerpc/platforms/pseries/smp.c            |    2 
 drivers/cpuidle/Kconfig                         |    7 
 drivers/cpuidle/Makefile                        |    2 
 drivers/cpuidle/cpuidle-ibm-power.c             |  335 +++++++++++++++++++++
 20 files changed, 693 insertions(+), 713 deletions(-)
 create mode 100644 arch/powerpc/include/asm/plpar_wrappers.h
 delete mode 100644 arch/powerpc/platforms/pseries/plpar_wrappers.h
 delete mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 drivers/cpuidle/cpuidle-ibm-power.c


-- Deepthi

