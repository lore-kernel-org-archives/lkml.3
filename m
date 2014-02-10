Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaBJNbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:31:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33186 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaBJNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:30:51 -0500
Date: Mon, 10 Feb 2014 05:30:39 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgVmlsbGUgU3lyasOkbMOk?=" <tipbot@zytor.com>
Message-ID: <tip-52ca70454ea5ff29bc39f7871d28f8e6f4713867@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bhelgaas@google.com, ville.syrjala@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, ville.syrjala@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1391628540-23072-2-git-send-email-ville.syrjala@linux.intel.com>
References: <1391628540-23072-2-git-send-email-ville.syrjala@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/gpu:
  Add vfunc for Intel graphics stolen memory base address
Git-Commit-ID: 52ca70454ea5ff29bc39f7871d28f8e6f4713867
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:30:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52ca70454ea5ff29bc39f7871d28f8e6f4713867
Gitweb:     http://git.kernel.org/tip/52ca70454ea5ff29bc39f7871d28f8e6f4713867
Author:     Ville Syrjälä <ville.syrjala@linux.intel.com>
AuthorDate: Wed, 5 Feb 2014 21:28:58 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:11:30 +0100

x86/gpu: Add vfunc for Intel graphics stolen memory base address

For gen2 devices we're going to need another way to determine
the stolen memory base address. Make that into a vfunc as well.

Also drop the bogus inline keyword from gen8_stolen_size().

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/1391628540-23072-2-git-send-email-ville.syrjala@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
