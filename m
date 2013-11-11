Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3KKFff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:35:35 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54650 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3KKFf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:35:26 -0500
Subject: [PATCH v8 0/7] POWER/cpuidle: Generic POWERPC-BOOK3S cpuidle driver
 enabled for PSERIES and POWERNV platforms
To: benh@kernel.crashing.org, linux-pm@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: b.zolnierkie@samsung.com, daniel.lezcano@linaro.org,
        dongsheng.wang@freescale.com, michael@ellerman.id.au,
        scottwood@freescale.com, srivatsa.bhat@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Date: Mon, 11 Nov 2013 11:05:03 +0530
Message-ID: <20131111053450.14797.75544.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111105-4790-0000-0000-00000B46942C
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

With this patch series, the powernv cpuidle functionalities are on-par with 
pSeries idle management.  

V1 -> http://lkml.org/lkml/2013/7/23/143
V2 -> https://lkml.org/lkml/2013/7/30/872
V3 -> http://comments.gmane.org/gmane.linux.ports.ppc.embedded/63093 
V4 -> https://lkml.org/lkml/2013/8/22/25
V5 -> http://lkml.org/lkml/2013/8/22/184
V6 -> https://lkml.org/lkml/2013/8/27/432 
v7 -> https://lkml.org/lkml/2013/10/29/216

Changes in V8:
============
* Renaming driver and related files from
  ibm-power-idle to powerpc-book3s-idle
  for clarity and to avoid confusing between ibm-power
  systems and power mgmt.

Changes in V7:
============
* Rebased to the latest kernel 3.12-rc7

* Default idle routine to be called on POWERNV
  is power7_idle() instead of HMT_low() routines.

Changes in V6:
=============
* Made changes in Patch3: Generic POWER cpuidle driver in V5 by
  breaking down to multiple patches, as there were multiple changes
  including moving the file location.

* Remove MAX_IDLE_STATE macro and kernel command line for
  IBM-POWER systems.

* Make backend driver a built-in, instead of a module.
  As building this as a module is currently not possible. 

* Generic backend driver minor cleanups.

* First two patches in V5 are not a part of the series, as
  they are generic cleanups, already pushed into the tree.

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

 Deepthi Dharwar (7):
      pseries/cpuidle: Move processor_idle.c to drivers/cpuidle.
      pseries/cpuidle: Use cpuidle_register() for initialisation.
      pseries/cpuidle: Make pseries_idle backend driver a  non-module.
      pseries/cpuidle: Remove MAX_IDLE_STATE macro.
      POWER/cpuidle: Generic POWERPC-BOOK3S CPUIDLE driver supporting PSERIES.
      POWER/cpuidle: Enable powernv cpuidle support.
      powernv/cpuidle: Enable idle powernv cpu to call into the cpuidle framework.


 arch/powerpc/include/asm/processor.h            |    2 
 arch/powerpc/platforms/powernv/setup.c          |   13 +
 arch/powerpc/platforms/pseries/Kconfig          |    9 -
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  364 -----------------------
 drivers/cpuidle/Kconfig                         |    5 
 drivers/cpuidle/Kconfig.powerpc                 |   10 +
 drivers/cpuidle/Makefile                        |    4 
 drivers/cpuidle/cpuidle-powerpc-book3s.c        |  320 ++++++++++++++++++++
 9 files changed, 352 insertions(+), 376 deletions(-)
 delete mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 drivers/cpuidle/Kconfig.powerpc
 create mode 100644 drivers/cpuidle/cpuidle-powerpc-book3s.c


-- Deepthi

