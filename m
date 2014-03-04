Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaCDK1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:27:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34005 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbaCDK1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:27:46 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-85-5315aaa1f6ec
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        thomas.ab@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC v3 0/5] cpufreq:LAB: Support for LAB governor.
Date: Tue, 04 Mar 2014 11:27:27 +0100
Message-id: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd2Fq0SDDQ7t4bTYOGM9q8XTph/s
	Fp1nnzBbvHnEbfHm4WZGi02Pr7FaXN41h83ic+8RRosZ5/cxWdxuXMFmceb0JVaL9TNes1hs
	nrCRzaJjGaPFxq8eDvweO2fdZfe4c20Pm8fmJfUe66a9ZfbYcrWdxaNvyypGj8+b5ALYo7hs
	UlJzMstSi/TtErgy/r6+yV7QIlbx+MkelgbGdYJdjJwcEgImEuvPPmGDsMUkLtxbD2RzcQgJ
	LGKU2LzvCSOE08UksXziO2aQKjYBPYnPd58ygdgiAqESR6d+ZQcpYhY4wyLx9sVuVpCEsICN
	RNevmWA2i4CqxKt3m8CaeQXcJP5O2sgIsU5RovvZBLDVnAKeElv3rGIBsYUEPCS6GlYyTmDk
	XcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOGifSe1gXNlgcYhRgINRiYd3xjSRYCHW
	xLLiytxDjBIczEoivIoLRYOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0t
	SC2CyTJxcEo1MDaHB5iyTf372VJ6XrxWff3kU3cDn3/K3/Q8K3+R7I2ma5xL5osWscfI/9di
	OKO/9s10oehPCp5/Wcr2PxXO38N3geuqw5uqefcdIzm8brLKtb16caPk8HS5B4uk7q9qMZx2
	RyOLZ6a4fOyfcsaYbrkopw922ackFL6Vcend8Os9s7l48+lfXkosxRmJhlrMRcWJAFgB2XxW	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite this patch set is working and applicable on top of 3.14-rc5, 
please regard it solely as a pure RFC.

This patch provides support for LAB governor build on top of ondemand.
Previous version of LAB can be found here:
http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq

LAB short reminder:

LAB uses information about how many cores are in "idle" state (the core 
idleness is represented as the value between 0 and 100) and the overall 
load of the system (from 0 to 100) to decide about frequency to be set.
It is extremely useful with SoCs like Exynos4412, which can set only one
frequency for all cores.

Important design decisions:

- Reuse well established ondemand governor's internal code. To do this
  I had to expose some previously static internal ondemand code. 
  This allowed smaller LAB code when compared to previous version.
	
- LAB works on top of ondemand, which means that one via device tree
  attributes can specify if and when e.g. BOOST shall be enabled or if 
  any particular frequency shall be imposed. For situation NOT important 
  from the power consumption reduction viewpoint the ondemand is used to 
  set proper frequency.

- It is only possible to either compile in or not the LAB into the kernel. 
  There is no "M" option for Kconfig. It is done on purpose, since ondemand 
  itself can be also compiled as a module and then it would be possible to
  remove ondemand when LAB is working on top of it.

- The LAB operation is specified (and thereof extendable) via device tree
  lab-ctrl-freq attribute defined at /cpus/cpu0.


Problems:
- How the governor will work for big.LITTLE systems (especially Global Task
  Scheduling).
- Will there be agreement to expose internal ondemand code to be reused for
  more specialized governors.

Test HW:
	Exynos4412 - Trats2 board.
Above patches were posted on top of Linux 3.14-rc5
(SHA1: 3f9590c281c66162bf8ae9b7b2d987f0a89043c6)

Lukasz Majewski (5):
  cpufreq:LAB:ondemand Adjust ondemand to be able to reuse its methods
  cpufreq:LAB:cpufreq_governor Adjust cpufreq_governor.[h|c] to support
    LAB
  cpufreq:LAB:lab Add LAB governor code
  cpufreq:LAB:Kconfig Add LAB definitions to Kconfig
  cpufreq:LAB:dts:trats2: Add DTS nodes for LAB governor

 arch/arm/boot/dts/exynos4412-trats2.dts |   29 ++
 drivers/cpufreq/Kconfig                 |   28 ++
 drivers/cpufreq/Makefile                |    1 +
 drivers/cpufreq/cpufreq_governor.c      |    7 +
 drivers/cpufreq/cpufreq_governor.h      |   12 +
 drivers/cpufreq/cpufreq_lab.c           |  457 +++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq_ondemand.c      |   24 +-
 7 files changed, 550 insertions(+), 8 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_lab.c

-- 
1.7.10.4

