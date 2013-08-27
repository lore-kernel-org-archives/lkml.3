Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3H0SbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:31:19 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39458 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3H0SbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:31:17 -0400
Subject: [PATCH V6 0/7] POWER/cpuidle: Generic IBM-POWER cpuidle driver
 enabled for PSERIES and POWERNV platforms
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: b.zolnierkie@samsung.com, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Date: Wed, 28 Aug 2013 00:00:29 +0530
Message-ID: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082718-3864-0000-0000-000009CA47C8
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
V5 -> http://lkml.org/lkml/2013/8/22/184

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
      POWER/cpuidle: Generic POWER CPUIDLE driver supporting PSERIES.
      POWER/cpuidle: Enable powernv cpuidle support.
      powernv/cpuidle: Enable idle powernv cpu to call into the cpuidle framework.


 arch/powerpc/include/asm/processor.h            |    2 
 arch/powerpc/platforms/powernv/setup.c          |   14 +
 arch/powerpc/platforms/pseries/Kconfig          |    9 -
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/processor_idle.c |  360 -----------------------
 drivers/cpuidle/Kconfig                         |    5 
 drivers/cpuidle/Kconfig.powerpc                 |   10 +
 drivers/cpuidle/Makefile                        |    2 
 drivers/cpuidle/cpuidle-ibm-power.c             |  316 ++++++++++++++++++++
 9 files changed, 347 insertions(+), 372 deletions(-)
 delete mode 100644 arch/powerpc/platforms/pseries/processor_idle.c
 create mode 100644 drivers/cpuidle/Kconfig.powerpc
 create mode 100644 drivers/cpuidle/cpuidle-ibm-power.c


-- Deepthi

