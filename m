Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3HPCZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:25:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56426 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3HPCZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:25:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, spear-devel@list.st.com,
        Stephen Warren <swarren@nvidia.com>, Steven Miao <realmz6@gmail.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/34] CPUFreq: Move freq change notifications out of drivers
Date: Fri, 16 Aug 2013 07:54:57 +0530
Message-Id: <cover.1376619363.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another 452 lines gone :)

Total stats upto now for all the 5 patchsets:
Viresh Kumar (186):
...
69 files changed, 700 insertions(+), 2451 deletions(-)

Net: 1751 lines gone..

-----x-------------x----------------

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

There are few special cases though, like exynos5440, which doesn't do everything
on the call to ->target_index() routine and call some kind of bottom halves for
doing this work, work/tasklet/etc..

They may continue doing notification from their own code and so this patch
introduces another flag: CPUFREQ_NO_NOTIFICATION, which will be set by such
drivers.

This is Fifth part of my cleanup work for CPUFreq, first three are (And
obviously its rebased over them):

1: cpufreq: Introduce cpufreq_table_validate_and_show()
https://lkml.org/lkml/2013/8/8/263

2: cpufreq: define generic routines for cpufreq drivers
https://lkml.org/lkml/2013/8/10/48

3. CPUFreq: Implement light weight ->target(): for 3.13
https://lkml.org/lkml/2013/8/13/349

4. CPUFreq: set policy->cur in cpufreq core instead of drivers
https://lkml.org/lkml/2013/8/14/288

All these are pushed here:
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

--
viresh

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: spear-devel@list.st.com
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>

Viresh Kumar (34):
  cpufreq: move freq change notifications to cpufreq core
  cpufreq: acpi: remove calls to cpufreq_notify_transition()
  cpufreq: arm_big_little: remove calls to cpufreq_notify_transition()
  cpufreq: at32ap: remove calls to cpufreq_notify_transition()
  cpufreq: blackfin: remove calls to cpufreq_notify_transition()
  cpufreq: cpu0: remove calls to cpufreq_notify_transition()
  cpufreq: cris: remove calls to cpufreq_notify_transition()
  cpufreq: davinci: remove calls to cpufreq_notify_transition()
  cpufreq: dbx500: remove calls to cpufreq_notify_transition()
  cpufreq: e_powersaver: remove calls to cpufreq_notify_transition()
  cpufreq: elanfreq: remove calls to cpufreq_notify_transition()
  cpufreq: exynos: remove calls to cpufreq_notify_transition()
  cpufreq: exynos5440: set CPUFREQ_NO_NOTIFICATION flag
  cpufreq: ia64-acpi: remove calls to cpufreq_notify_transition()
  cpufreq: imx6q: remove calls to cpufreq_notify_transition()
  cpufreq: kirkwood: remove calls to cpufreq_notify_transition()
  cpufreq: longhaul: set CPUFREQ_NO_NOTIFICATION flag
  cpufreq: loongson2: remove calls to cpufreq_notify_transition()
  cpufreq: maple: remove calls to cpufreq_notify_transition()
  cpufreq: omap: remove calls to cpufreq_notify_transition()
  cpufreq: p4-clockmod: remove calls to cpufreq_notify_transition()
  cpufreq: pasemi: remove calls to cpufreq_notify_transition()
  cpufreq: pmac: remove calls to cpufreq_notify_transition()
  cpufreq: powernow: remove calls to cpufreq_notify_transition()
  cpufreq: ppc: remove calls to cpufreq_notify_transition()
  cpufreq: pxa: remove calls to cpufreq_notify_transition()
  cpufreq: s3c: remove calls to cpufreq_notify_transition()
  cpufreq: s5pv210: remove calls to cpufreq_notify_transition()
  cpufreq: sa11x0: remove calls to cpufreq_notify_transition()
  cpufreq: sc520: remove calls to cpufreq_notify_transition()
  cpufreq: sparc: remove calls to cpufreq_notify_transition()
  cpufreq: SPEAr: remove calls to cpufreq_notify_transition()
  cpufreq: speedstep: remove calls to cpufreq_notify_transition()
  cpufreq: tegra: remove calls to cpufreq_notify_transition()

 drivers/cpufreq/acpi-cpufreq.c         | 14 ++-------
 drivers/cpufreq/arm_big_little.c       | 25 ++--------------
 drivers/cpufreq/at32ap-cpufreq.c       | 22 ++++++--------
 drivers/cpufreq/blackfin-cpufreq.c     | 22 +++++---------
 drivers/cpufreq/cpufreq-cpu0.c         | 33 ++++++++-------------
 drivers/cpufreq/cpufreq.c              | 34 +++++++++++++++++++++
 drivers/cpufreq/cris-artpec3-cpufreq.c |  8 -----
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  8 -----
 drivers/cpufreq/davinci-cpufreq.c      | 30 +++++++------------
 drivers/cpufreq/dbx500-cpufreq.c       | 22 +-------------
 drivers/cpufreq/e_powersaver.c         | 23 ++-------------
 drivers/cpufreq/elanfreq.c             | 13 --------
 drivers/cpufreq/exynos-cpufreq.c       | 28 +++++-------------
 drivers/cpufreq/exynos5440-cpufreq.c   |  2 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c    | 19 ------------
 drivers/cpufreq/imx6q-cpufreq.c        | 39 ++++++++++--------------
 drivers/cpufreq/kirkwood-cpufreq.c     | 54 +++++++++++++---------------------
 drivers/cpufreq/longhaul.c             |  1 +
 drivers/cpufreq/loongson2_cpufreq.c    | 16 ----------
 drivers/cpufreq/maple-cpufreq.c        | 18 +-----------
 drivers/cpufreq/omap-cpufreq.c         | 39 +++++++++---------------
 drivers/cpufreq/p4-clockmod.c          | 10 -------
 drivers/cpufreq/pasemi-cpufreq.c       | 14 +--------
 drivers/cpufreq/pmac32-cpufreq.c       | 20 +++----------
 drivers/cpufreq/pmac64-cpufreq.c       | 18 +-----------
 drivers/cpufreq/powernow-k6.c          |  8 -----
 drivers/cpufreq/powernow-k7.c          | 11 +------
 drivers/cpufreq/powernow-k8.c          | 15 +---------
 drivers/cpufreq/ppc-corenet-cpufreq.c  | 19 +-----------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 19 +-----------
 drivers/cpufreq/pxa2xx-cpufreq.c       | 27 ++++-------------
 drivers/cpufreq/pxa3xx-cpufreq.c       | 12 --------
 drivers/cpufreq/s3c2416-cpufreq.c      | 21 +++----------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 48 ++++++++++--------------------
 drivers/cpufreq/s5pv210-cpufreq.c      | 16 ++++------
 drivers/cpufreq/sa1100-cpufreq.c       | 17 ++++-------
 drivers/cpufreq/sa1110-cpufreq.c       | 12 ++------
 drivers/cpufreq/sc520_freq.c           | 11 -------
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  7 -----
 drivers/cpufreq/sparc-us3-cpufreq.c    |  7 -----
 drivers/cpufreq/spear-cpufreq.c        | 13 +-------
 drivers/cpufreq/speedstep-centrino.c   | 20 +------------
 drivers/cpufreq/speedstep-ich.c        |  9 ------
 drivers/cpufreq/speedstep-smi.c        |  7 -----
 drivers/cpufreq/tegra-cpufreq.c        | 25 ++++------------
 include/linux/cpufreq.h                |  6 ++++
 46 files changed, 205 insertions(+), 657 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

