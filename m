Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3LCPuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:50:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:15163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab3LCPuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:50:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,818,1378882800"; 
   d="scan'208";a="437797183"
From: ville.syrjala@linux.intel.com
To: intel-gfx@lists.freedesktop.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86: Add vfunc for Intel graphics stolen memory base address
Date: Tue,  3 Dec 2013 17:49:48 +0200
Message-Id: <1386085793-317-2-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
References: <1386085793-317-1-git-send-email-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

For gen2 devices we're going to need another way to determine the
stolen memory base address. Make that into a vfunc as well.

Also drop the bogus inline keyword from gen8_stolen_size().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 arch/x86/kernel/early-quirks.c | 77 ++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..fddd4d0 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -228,7 +228,7 @@ static void __init intel_remapping_check(int num, int slot, int func)
  *
  * And yes, so far on current devices the base addr is always under 4G.
  */
-static u32 __init intel_stolen_base(int num, int slot, int func)
+static u32 __init intel_stolen_base(int num, int slot, int func, size_t stolen_size)
 {
 	u32 base;
 
@@ -313,7 +313,7 @@ static size_t __init gen6_stolen_size(int num, int slot, int func)
 	return gmch_ctrl << 25; /* 32 MB units */
 }
 
-static inline size_t gen8_stolen_size(int num, int slot, int func)
+static size_t gen8_stolen_size(int num, int slot, int func)
 {
 	u16 gmch_ctrl;
 
@@ -323,31 +323,50 @@ static inline size_t gen8_stolen_size(int num, int slot, int func)
 	return gmch_ctrl << 25; /* 32 MB units */
 }
 
-typedef size_t (*stolen_size_fn)(int num, int slot, int func);
+
+struct intel_stolen_funcs {
+	size_t (*size)(int num, int slot, int func);
+	u32 (*base)(int num, int slot, int func, size_t size);
+};
+
+static const struct intel_stolen_funcs gen3_stolen_funcs = {
+	.base = intel_stolen_base,
+	.size = gen3_stolen_size,
+};
+
+static const struct intel_stolen_funcs gen6_stolen_funcs = {
+	.base = intel_stolen_base,
+	.size = gen6_stolen_size,
+};
+
+static const struct intel_stolen_funcs gen8_stolen_funcs = {
+	.base = intel_stolen_base,
+	.size = gen8_stolen_size,
+};
 
 static struct pci_device_id intel_stolen_ids[] __initdata = {
-	INTEL_I915G_IDS(gen3_stolen_size),
-	INTEL_I915GM_IDS(gen3_stolen_size),
-	INTEL_I945G_IDS(gen3_stolen_size),
-	INTEL_I945GM_IDS(gen3_stolen_size),
-	INTEL_VLV_M_IDS(gen6_stolen_size),
-	INTEL_VLV_D_IDS(gen6_stolen_size),
-	INTEL_PINEVIEW_IDS(gen3_stolen_size),
-	INTEL_I965G_IDS(gen3_stolen_size),
-	INTEL_G33_IDS(gen3_stolen_size),
-	INTEL_I965GM_IDS(gen3_stolen_size),
-	INTEL_GM45_IDS(gen3_stolen_size),
-	INTEL_G45_IDS(gen3_stolen_size),
-	INTEL_IRONLAKE_D_IDS(gen3_stolen_size),
-	INTEL_IRONLAKE_M_IDS(gen3_stolen_size),
-	INTEL_SNB_D_IDS(gen6_stolen_size),
-	INTEL_SNB_M_IDS(gen6_stolen_size),
-	INTEL_IVB_M_IDS(gen6_stolen_size),
-	INTEL_IVB_D_IDS(gen6_stolen_size),
-	INTEL_HSW_D_IDS(gen6_stolen_size),
-	INTEL_HSW_M_IDS(gen6_stolen_size),
-	INTEL_BDW_M_IDS(gen8_stolen_size),
-	INTEL_BDW_D_IDS(gen8_stolen_size)
+	INTEL_I915G_IDS(&gen3_stolen_funcs),
+	INTEL_I915GM_IDS(&gen3_stolen_funcs),
+	INTEL_I945G_IDS(&gen3_stolen_funcs),
+	INTEL_I945GM_IDS(&gen3_stolen_funcs),
+	INTEL_VLV_M_IDS(&gen6_stolen_funcs),
+	INTEL_VLV_D_IDS(&gen6_stolen_funcs),
+	INTEL_PINEVIEW_IDS(&gen3_stolen_funcs),
+	INTEL_I965G_IDS(&gen3_stolen_funcs),
+	INTEL_G33_IDS(&gen3_stolen_funcs),
+	INTEL_I965GM_IDS(&gen3_stolen_funcs),
+	INTEL_GM45_IDS(&gen3_stolen_funcs),
+	INTEL_G45_IDS(&gen3_stolen_funcs),
+	INTEL_IRONLAKE_D_IDS(&gen3_stolen_funcs),
+	INTEL_IRONLAKE_M_IDS(&gen3_stolen_funcs),
+	INTEL_SNB_D_IDS(&gen6_stolen_funcs),
+	INTEL_SNB_M_IDS(&gen6_stolen_funcs),
+	INTEL_IVB_M_IDS(&gen6_stolen_funcs),
+	INTEL_IVB_D_IDS(&gen6_stolen_funcs),
+	INTEL_HSW_D_IDS(&gen6_stolen_funcs),
+	INTEL_HSW_M_IDS(&gen6_stolen_funcs),
+	INTEL_BDW_M_IDS(&gen8_stolen_funcs),
+	INTEL_BDW_D_IDS(&gen8_stolen_funcs)
 };
 
 static void __init intel_graphics_stolen(int num, int slot, int func)
@@ -364,10 +383,10 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
 
 	for (i = 0; i < ARRAY_SIZE(intel_stolen_ids); i++) {
 		if (intel_stolen_ids[i].device == device) {
-			stolen_size_fn stolen_size =
-				(stolen_size_fn)intel_stolen_ids[i].driver_data;
-			size = stolen_size(num, slot, func);
-			start = intel_stolen_base(num, slot, func);
+			const struct intel_stolen_funcs *stolen_funcs =
+				(const struct intel_stolen_funcs *)intel_stolen_ids[i].driver_data;
+			size = stolen_funcs->size(num, slot, func);
+			start = stolen_funcs->base(num, slot, func, size);
 			if (size && start) {
 				/* Mark this space as reserved */
 				e820_add_region(start, size, E820_RESERVED);
-- 
1.8.3.2

