Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbaIZVNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:13:53 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:56301 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbaIZVNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:13:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 RESEND 1/3] ARM: EXYNOS: Move code from hotplug.c to platsmp.c
Date: Fri, 26 Sep 2014 23:13:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201409262313.26272.arnd@arndb.de>
X-Provags-ID: V02:K0:aJZa48mhF97M9Za5wrlf0/PR2Hl0ToimrNwOFQNwWNw
 VAf1bLBlj/7POJ7JFG+mIGIqNTgoXR0JbfdjSJA+WyhIht9+Xx
 VFrFyDUa5mDcADaqMjm79Ama4dGMdSYVHevTEUbMSwSC9WRWdA
 lU86hVBpEh7+0mPVJr494+sBuD72nFAXX12DYmiJ5s7VlhbdeZ
 hPvNYl047Js644cHi3Z8FFcGLS4dkOXvGwa/5boheoqqDzCuXS
 arJEoIgp05VpMLIc0+d34FKcjiVuH8j26YoeeefKbwOgoj02/D
 BYDPyKyXRa81Xg/bx2lVDvBiShFbekTbUHHDWSDIpeIcAxzrij
 Y2b49zwHAP6f+ab/cVUE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014, Krzysztof Kozlowski wrote:
> The commit only moves code around with one additional observable change:
> the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
> CFLAGS are not necessary any more.

This turns out to be wrong, and your change broke 'allmodconfig' builds
in linux-next. Please apply this patch on top.

	Arnd

8<----------
>From 4ba6bf8806caec386e35930314dbad071284c837 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 26 Sep 2014 23:09:38 +0200
Subject: [PATCH] ARM: EXYNOS: fix build error in platsmp.c

/tmp/ccYeWL3V.s: Assembler messages:
/tmp/ccYeWL3V.s:659: Error: selected processor does not support ARM mode `isb '
/tmp/ccYeWL3V.s:664: Error: selected processor does not support ARM mode `isb '
/tmp/ccYeWL3V.s:665: Error: selected processor does not support ARM mode `dsb '
make[3]: *** [arch/arm/mach-exynos/platsmp.o] Error 1

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 17342534e1d932 ("ARM: EXYNOS: Move code from hotplug.c to platsmp.c")

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 4e49d4efb264..64324bf5edb4 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_PM_SLEEP)		+= suspend.o
 obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
+CFLAGS_platsmp.o		:= -march=armv7-a
 
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
