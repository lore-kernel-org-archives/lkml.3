Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbaGQP45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:56:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63136 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaGQP4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:56:55 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5f-53c7f245a423
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
Date: Thu, 17 Jul 2014 17:56:09 +0200
Message-id: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4FV3XT8eDDXZv5rD4/vAUq8XfScfY
	LR7Nf8xs0bvgKpvFpsfXWC0u75rDZjHj/D4mi9uXeS3WHrnLbnHq+mc2ixvTW1gt1s94zWKx
	atcfRgdej5bmHjaP378mMXos+p7lsXPWXXaPzUvqPa6caGL16G1+x+bRt2UVo8fnTXIBnFFc
	NimpOZllqUX6dglcGee2rWIueC1cserWDMYGxtkCXYycHBICJhJbJ35ghbDFJC7cW8/WxcjF
	ISSwlFHi7Lf3rBBOH5PErcM7GUGq2ATUJD43PGIDsUUEVCU+ty1gByliFpjFLPFtzgawhLCA
	u8SjdZvBbBagoin7F7KD2LwCThKTenexQKyTk+jd9oZ5AiP3AkaGVYyiqaXJBcVJ6bmGesWJ
	ucWleel6yfm5mxghYfhlB+PiY1aHGAU4GJV4eDs/HwsWYk0sK67MPcQowcGsJMKbff94sBBv
	SmJlVWpRfnxRaU5q8SFGJg5OqQbGyTNl2Bx7+6b67BZMcIsu7X0rxRIns+p9eewntXmWEivm
	d9hZmH/sm29+UehqG5PBXYubJ7Y81svnd3y5P1cl04Y1kuPZzBveN4rqtQQnCc05lS5/1pTB
	c+Jad3mHI7HMH6RKP7n8N+mZVr2+3EHI08vy5bTkTcV7de999HI5Xm0pvarxopsSS3FGoqEW
	c1FxIgC/fV/aIQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos-based boards running secure firmware the sequence of low level
operations to enter and leave system-wide sleep mode is different than
on those without the firmware. Namely:
 - CP15 power control and diagnostic registers cannot be written directly,
 - the way of setting boot address and boot flag is different,
 - different resume handler needs to be used,
 - dedicated SMC call needs to be performed instead of letting the CPU enter
   WFI.

This series introduces .suspend() and .resume() firmware operations to
perform low level firmware-specific suspend and resume and then leverages
them to provide suspend-resume path meeting the above requirements.

The series is based on Kgene's for-next branch and tested on:
 - Exynos4412-based Trats2 board running in non-secure mode (under secure
   firmware) with few board-specific fixes that will be sent separately soon,
 - Exynos4210-based Trats board running in secure mode,
 - Exynos4412-based ODROID-U3 board running in non-secure mode with one minor
   board-specific fix which will be send shortly.

Depends on:
 - [PATCH v3] ARM: save/restore Cortex-A9 CP15 registers on suspend/resume
   (http://www.spinics.net/lists/arm-kernel/msg346212.html)
 - [PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences
   (https://lkml.org/lkml/2014/7/15/319)
 - [PATCH] ARM: make it easier to check the CPU part number correctly
   (http://thread.gmane.org/gmane.linux.ports.arm.kernel/335126
    already in linux-next)

Changes since v1:
 - dropped outer_resume() - will be handled in assembly in further patches,
   as support for L2C in non-secure mode gets added,
 - moved CP15 resume to assembly as it needs to be done before MMU is enabled,
 - surrounded CP15 save with a check for cpuid part, because it is valid only
   on Cortex A9,
 - rebased on next-20140717 tag of linux-next tree.

Tomasz Figa (2):
  ARM: firmware: Introduce suspend and resume operations
  ARM: EXYNOS: Add support for firmware-assisted suspend/resume

 Documentation/arm/firmware.txt  | 28 +++++--------------------
 arch/arm/include/asm/firmware.h |  8 ++++++++
 arch/arm/mach-exynos/Makefile   |  1 +
 arch/arm/mach-exynos/common.h   |  4 ++++
 arch/arm/mach-exynos/firmware.c | 45 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c       | 16 ++++++++++-----
 arch/arm/mach-exynos/sleep.S    | 28 +++++++++++++++++++++++++
 arch/arm/mach-exynos/smc.h      |  4 ++++
 8 files changed, 106 insertions(+), 28 deletions(-)

-- 
1.9.3

