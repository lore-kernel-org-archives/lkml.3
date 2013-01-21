Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3AUKy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:54:56 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:39065 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3AUKyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:54:50 -0500
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
Subject: [PATCH v6 4/4] ARM: mach-shmobile: r8a7740: Add IPMMU device
Date: Mon, 21 Jan 2013 19:54:29 +0900
Message-Id: <1358765669-14567-5-git-send-email-hdk@igel.co.jp>
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
 arch/arm/mach-shmobile/setup-r8a7740.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 0952224..b85bea5 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -28,6 +28,7 @@
 #include <linux/sh_dma.h>
 #include <linux/sh_timer.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_data/sh_ipmmu.h>
 #include <mach/dma-register.h>
 #include <mach/r8a7740.h>
 #include <mach/pm-rmobile.h>
@@ -262,6 +263,37 @@ static struct platform_device cmt10_device = {
 	.num_resources	= ARRAY_SIZE(cmt10_resources),
 };
 
+/* IPMMUI (an IPMMU module for ICB/LMB) */
+static struct resource ipmmu_resources[] = {
+	[0] = {
+		.name	= "IPMMUI",
+		.start	= 0xfe951000,
+		.end	= 0xfe9510ff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static const char * const ipmmu_dev_names[] = {
+	"sh_mobile_lcdc_fb.0",
+	"sh_mobile_lcdc_fb.1",
+	"sh_mobile_ceu.0",
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
 static struct platform_device *r8a7740_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
@@ -273,6 +305,7 @@ static struct platform_device *r8a7740_early_devices[] __initdata = {
 	&scif7_device,
 	&scifb_device,
 	&cmt10_device,
+	&ipmmu_device,
 };
 
 /* DMA */
-- 
1.8.0

