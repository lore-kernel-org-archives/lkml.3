Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3HRU3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:29:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3HRU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:28:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jan Rinze <janrinze@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Adrian Bunk <adrian.bunk@movial.com>,
        Rob Herring <robherring2@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robert Marklund <robert.marklund@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 11/12] ARM: 7080/1: l2x0: make sure I&D are not locked down on init
Date: Sun, 18 Aug 2013 13:30:20 -0700
Message-Id: <20130818202952.011027699@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818202949.875887601@linuxfoundation.org>
References: <20130818202949.875887601@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit bac7e6ecf60933b68af910eb4c83a775a8b20b19 upstream.

Fighting unfixed U-Boots and other beasts that may the cache in
a locked-down state when starting the kernel, we make sure to
disable all cache lock-down when initializing the l2x0 so we
are in a known state.

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reported-by: Jan Rinze <janrinze@gmail.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Adrian Bunk <adrian.bunk@movial.com>
Cc: Rob Herring <robherring2@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Tested-by: Robert Marklund <robert.marklund@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/hardware/cache-l2x0.h |    9 +++++++--
 arch/arm/mm/cache-l2x0.c                   |   21 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/hardware/cache-l2x0.h
+++ b/arch/arm/include/asm/hardware/cache-l2x0.h
@@ -45,8 +45,13 @@
 #define L2X0_CLEAN_INV_LINE_PA		0x7F0
 #define L2X0_CLEAN_INV_LINE_IDX		0x7F8
 #define L2X0_CLEAN_INV_WAY		0x7FC
-#define L2X0_LOCKDOWN_WAY_D		0x900
-#define L2X0_LOCKDOWN_WAY_I		0x904
+/*
+ * The lockdown registers repeat 8 times for L310, the L210 has only one
+ * D and one I lockdown register at 0x0900 and 0x0904.
+ */
+#define L2X0_LOCKDOWN_WAY_D_BASE	0x900
+#define L2X0_LOCKDOWN_WAY_I_BASE	0x904
+#define L2X0_LOCKDOWN_STRIDE		0x08
 #define L2X0_TEST_OPERATION		0xF00
 #define L2X0_LINE_DATA			0xF10
 #define L2X0_LINE_TAG			0xF30
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -277,6 +277,25 @@ static void l2x0_disable(void)
 	spin_unlock_irqrestore(&l2x0_lock, flags);
 }
 
+static void __init l2x0_unlock(__u32 cache_id)
+{
+	int lockregs;
+	int i;
+
+	if (cache_id == L2X0_CACHE_ID_PART_L310)
+		lockregs = 8;
+	else
+		/* L210 and unknown types */
+		lockregs = 1;
+
+	for (i = 0; i < lockregs; i++) {
+		writel_relaxed(0x0, l2x0_base + L2X0_LOCKDOWN_WAY_D_BASE +
+			       i * L2X0_LOCKDOWN_STRIDE);
+		writel_relaxed(0x0, l2x0_base + L2X0_LOCKDOWN_WAY_I_BASE +
+			       i * L2X0_LOCKDOWN_STRIDE);
+	}
+}
+
 void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
 {
 	__u32 aux;
@@ -328,6 +347,8 @@ void __init l2x0_init(void __iomem *base
 	 * accessing the below registers will fault.
 	 */
 	if (!(readl_relaxed(l2x0_base + L2X0_CTRL) & 1)) {
+		/* Make sure that I&D is not locked down when starting */
+		l2x0_unlock(cache_id);
 
 		/* l2x0 controller is disabled */
 		writel_relaxed(aux, l2x0_base + L2X0_AUX_CTRL);


