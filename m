Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3AUKyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:54:50 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36862 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3AUKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:54:48 -0500
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v6 3/4] ARM: mach-shmobile: sh73a0: Add IPMMU device
Date: Mon, 21 Jan 2013 19:54:28 +0900
Message-Id: <1358765669-14567-4-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an IPMMU device and notifies the IPMMU driver which
devices are connected via the IPMMU module.  All devices connected to the main
memory bus via the IPMMU module MUST be registered when SHMOBILE_IPMMU and
SHMOBILE_IOMMU are enabled because physical address cannot be used
while the IPMMU module's MMU function is enabled.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 arch/arm/mach-shmobile/setup-sh73a0.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index db99a4a..36c2b2e 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -30,6 +30,7 @@
 #include <linux/sh_dma.h>
 #include <linux/sh_intc.h>
 #include <linux/sh_timer.h>
+#include <linux/platform_data/sh_ipmmu.h>
 #include <mach/dma-register.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
@@ -754,6 +755,35 @@ static struct platform_device pmu_device = {
 	.resource	= pmu_resources,
 };
 
+/* an IPMMU module for ICB */
+static struct resource ipmmu_resources[] = {
+	[0] = {
+		.name	= "IPMMU",
+		.start	= 0xfe951000,
+		.end	= 0xfe9510ff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static const char * const ipmmu_dev_names[] = {
+	"sh_mobile_lcdc_fb.0",
+};
+
+static struct shmobile_ipmmu_platform_data ipmmu_platform_data = {
+	.dev_names = ipmmu_dev_names,
+	.num_dev_names = ARRAY_SIZE(ipmmu_dev_names),
+};
+
+static struct platform_device ipmmu_device = {
+	.name           = "ipmmu",
+	.id             = -1,
+	.dev = {
+		.platform_data = &ipmmu_platform_data,
+	},
+	.resource       = ipmmu_resources,
+	.num_resources  = ARRAY_SIZE(ipmmu_resources),
+};
+
 static struct platform_device *sh73a0_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
@@ -767,6 +797,7 @@ static struct platform_device *sh73a0_early_devices[] __initdata = {
 	&cmt10_device,
 	&tmu00_device,
 	&tmu01_device,
+	&ipmmu_device,
 };
 
 static struct platform_device *sh73a0_late_devices[] __initdata = {
-- 
1.8.0

