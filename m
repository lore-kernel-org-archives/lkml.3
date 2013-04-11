Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705Ab3DKVQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:16:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935533Ab3DKUs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:59 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pf493yhn-g0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qmpaVRES1zUA:10 a=pGLkceISAAAA:8 a=NPcXljDpAAAA:8 a=VwQbUJbxAAAA:8 a=9eV9fzTZAAAA:20 a=fWqJKd327IZUMN6Qc2IA:9 a=MSl-tDqOz04A:10 a=FW2zQvlL1bsA:10 a=jeBq3FmKZ4MA:10 a=PWw0xKXniMs1HnNn:21 a=Tt2v4DyvKXVBn0-X:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202608.619447567@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mac Lin <mkl0301@gmail.com>, Anton Vorontsov <anton@enomsg.org>
Subject: [ 136/171 ] ARM: cns3xxx: fix mapping of private memory region
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0136-ARM-cns3xxx-fix-mapping-of-private-memory-region.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mac Lin <mkl0301@gmail.com>

[ Upstream commit a3d9052c6296ad3398d3ad649c3c682c3e7ecfa6 ]

Since commit 0536bdf33faf (ARM: move iotable mappings within the vmalloc
region), the Cavium CNS3xxx cannot boot anymore.

This is caused by the pre-defined iotable mappings is not in the vmalloc
region. This patch move the iotable mappings into the vmalloc region, and
merge the MPCore private memory region (containing the SCU, the GIC and
the TWD) as a single region.

Signed-off-by: Mac Lin <mkl0301@gmail.com>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
Cc: stable@vger.kernel.org [v3.3+]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-cns3xxx/core.c                 |   16 +++-------------
 arch/arm/mach-cns3xxx/include/mach/cns3xxx.h |   16 ++++++++--------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-cns3xxx/core.c b/arch/arm/mach-cns3xxx/core.c
index 031805b..7f26faf 100644
--- a/arch/arm/mach-cns3xxx/core.c
+++ b/arch/arm/mach-cns3xxx/core.c
@@ -22,19 +22,9 @@
 
 static struct map_desc cns3xxx_io_desc[] __initdata = {
 	{
-		.virtual	= CNS3XXX_TC11MP_TWD_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_TWD_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
-	}, {
-		.virtual	= CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_GIC_CPU_BASE),
-		.length		= SZ_4K,
-		.type		= MT_DEVICE,
-	}, {
-		.virtual	= CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT,
-		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_GIC_DIST_BASE),
-		.length		= SZ_4K,
+		.virtual	= CNS3XXX_TC11MP_SCU_BASE_VIRT,
+		.pfn		= __phys_to_pfn(CNS3XXX_TC11MP_SCU_BASE),
+		.length		= SZ_8K,
 		.type		= MT_DEVICE,
 	}, {
 		.virtual	= CNS3XXX_TIMER1_2_3_BASE_VIRT,
diff --git a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
index 191c8e5..b1021aa 100644
--- a/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
+++ b/arch/arm/mach-cns3xxx/include/mach/cns3xxx.h
@@ -94,10 +94,10 @@
 #define RTC_INTR_STS_OFFSET			0x34
 
 #define CNS3XXX_MISC_BASE			0x76000000	/* Misc Control */
-#define CNS3XXX_MISC_BASE_VIRT			0xFFF07000	/* Misc Control */
+#define CNS3XXX_MISC_BASE_VIRT			0xFB000000	/* Misc Control */
 
 #define CNS3XXX_PM_BASE				0x77000000	/* Power Management Control */
-#define CNS3XXX_PM_BASE_VIRT			0xFFF08000
+#define CNS3XXX_PM_BASE_VIRT			0xFB001000
 
 #define PM_CLK_GATE_OFFSET			0x00
 #define PM_SOFT_RST_OFFSET			0x04
@@ -109,7 +109,7 @@
 #define PM_PLL_HM_PD_OFFSET			0x1C
 
 #define CNS3XXX_UART0_BASE			0x78000000	/* UART 0 */
-#define CNS3XXX_UART0_BASE_VIRT			0xFFF09000
+#define CNS3XXX_UART0_BASE_VIRT			0xFB002000
 
 #define CNS3XXX_UART1_BASE			0x78400000	/* UART 1 */
 #define CNS3XXX_UART1_BASE_VIRT			0xFFF0A000
@@ -130,7 +130,7 @@
 #define CNS3XXX_I2S_BASE_VIRT			0xFFF10000
 
 #define CNS3XXX_TIMER1_2_3_BASE			0x7C800000	/* Timer */
-#define CNS3XXX_TIMER1_2_3_BASE_VIRT		0xFFF10800
+#define CNS3XXX_TIMER1_2_3_BASE_VIRT		0xFB003000
 
 #define TIMER1_COUNTER_OFFSET			0x00
 #define TIMER1_AUTO_RELOAD_OFFSET		0x04
@@ -227,16 +227,16 @@
  * Testchip peripheral and fpga gic regions
  */
 #define CNS3XXX_TC11MP_SCU_BASE			0x90000000	/* IRQ, Test chip */
-#define CNS3XXX_TC11MP_SCU_BASE_VIRT		0xFF000000
+#define CNS3XXX_TC11MP_SCU_BASE_VIRT		0xFB004000
 
 #define CNS3XXX_TC11MP_GIC_CPU_BASE		0x90000100	/* Test chip interrupt controller CPU interface */
-#define CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT	0xFF000100
+#define CNS3XXX_TC11MP_GIC_CPU_BASE_VIRT	(CNS3XXX_TC11MP_SCU_BASE_VIRT + 0x100)
 
 #define CNS3XXX_TC11MP_TWD_BASE			0x90000600
-#define CNS3XXX_TC11MP_TWD_BASE_VIRT		0xFF000600
+#define CNS3XXX_TC11MP_TWD_BASE_VIRT		(CNS3XXX_TC11MP_SCU_BASE_VIRT + 0x600)
 
 #define CNS3XXX_TC11MP_GIC_DIST_BASE		0x90001000	/* Test chip interrupt controller distributor */
-#define CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT	0xFF001000
+#define CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT	(CNS3XXX_TC11MP_SCU_BASE_VIRT + 0x1000)
 
 #define CNS3XXX_TC11MP_L220_BASE		0x92002000	/* L220 registers */
 #define CNS3XXX_TC11MP_L220_BASE_VIRT		0xFF002000
-- 
1.7.10.4


