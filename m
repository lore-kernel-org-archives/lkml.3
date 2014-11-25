Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaKYLGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:06:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58923 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaKYKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Borislav Petkov <bp@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 184/254] x86, microcode, AMD: Fix ucode patch stashing on 32-bit
Date: Tue, 25 Nov 2014 10:38:54 +0000
Message-Id: <1416912004-5928-185-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit c0a717f23dccdb6e3b03471bc846fdc636f2b353 upstream.

Save the patch while we're running on the BSP instead of later, before
the initrd has been jettisoned. More importantly, on 32-bit we need to
access the physical address instead of the virtual.

This way we actually do find it on the APs instead of having to go
through the initrd each time.

Tested-by: Richard Hendershot <rshendershot@mchsi.com>
Fixes: 5335ba5cf475 ("x86, microcode, AMD: Fix early ucode loading")
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/microcode/amd_early.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 65bdfb598880..b63773ba1646 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -108,12 +108,13 @@ static size_t compute_container_size(u8 *data, u32 total_size)
  * load_microcode_amd() to save equivalent cpu table and microcode patches in
  * kernel heap memory.
  */
-static void apply_ucode_in_initrd(void *ucode, size_t size)
+static void apply_ucode_in_initrd(void *ucode, size_t size, bool save_patch)
 {
 	struct equiv_cpu_entry *eq;
 	size_t *cont_sz;
 	u32 *header;
 	u8  *data, **cont;
+	u8 (*patch)[PATCH_MAX_SIZE];
 	u16 eq_id = 0;
 	int offset, left;
 	u32 rev, eax, ebx, ecx, edx;
@@ -123,10 +124,12 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
 	cont_sz = (size_t *)__pa_nodebug(&container_size);
 	cont	= (u8 **)__pa_nodebug(&container);
+	patch	= (u8 (*)[PATCH_MAX_SIZE])__pa_nodebug(&amd_ucode_patch);
 #else
 	new_rev = &ucode_new_rev;
 	cont_sz = &container_size;
 	cont	= &container;
+	patch	= &amd_ucode_patch;
 #endif
 
 	data   = ucode;
@@ -213,9 +216,9 @@ static void apply_ucode_in_initrd(void *ucode, size_t size)
 				rev = mc->hdr.patch_id;
 				*new_rev = rev;
 
-				/* save ucode patch */
-				memcpy(amd_ucode_patch, mc,
-				       min_t(u32, header[1], PATCH_MAX_SIZE));
+				if (save_patch)
+					memcpy(patch, mc,
+					       min_t(u32, header[1], PATCH_MAX_SIZE));
 			}
 		}
 
@@ -246,7 +249,7 @@ void __init load_ucode_amd_bsp(void)
 	*data = cp.data;
 	*size = cp.size;
 
-	apply_ucode_in_initrd(cp.data, cp.size);
+	apply_ucode_in_initrd(cp.data, cp.size, true);
 }
 
 #ifdef CONFIG_X86_32
@@ -263,7 +266,7 @@ void load_ucode_amd_ap(void)
 	size_t *usize;
 	void **ucode;
 
-	mc = (struct microcode_amd *)__pa(amd_ucode_patch);
+	mc = (struct microcode_amd *)__pa_nodebug(amd_ucode_patch);
 	if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
 		__apply_microcode_amd(mc);
 		return;
@@ -275,7 +278,7 @@ void load_ucode_amd_ap(void)
 	if (!*ucode || !*usize)
 		return;
 
-	apply_ucode_in_initrd(*ucode, *usize);
+	apply_ucode_in_initrd(*ucode, *usize, false);
 }
 
 static void __init collect_cpu_sig_on_bsp(void *arg)
@@ -339,7 +342,7 @@ void load_ucode_amd_ap(void)
 		 * AP has a different equivalence ID than BSP, looks like
 		 * mixed-steppings silicon so go through the ucode blob anew.
 		 */
-		apply_ucode_in_initrd(ucode_cpio.data, ucode_cpio.size);
+		apply_ucode_in_initrd(ucode_cpio.data, ucode_cpio.size, false);
 	}
 }
 #endif
@@ -347,6 +350,7 @@ void load_ucode_amd_ap(void)
 int __init save_microcode_in_initrd_amd(void)
 {
 	unsigned long cont;
+	int retval = 0;
 	enum ucode_state ret;
 	u8 *cont_va;
 	u32 eax;
@@ -387,7 +391,7 @@ int __init save_microcode_in_initrd_amd(void)
 
 	ret = load_microcode_amd(eax, container, container_size);
 	if (ret != UCODE_OK)
-		return -EINVAL;
+		retval = -EINVAL;
 
 	/*
 	 * This will be freed any msec now, stash patches for the current
@@ -396,5 +400,5 @@ int __init save_microcode_in_initrd_amd(void)
 	container = NULL;
 	container_size = 0;
 
-	return 0;
+	return retval;
 }
-- 
2.1.0

