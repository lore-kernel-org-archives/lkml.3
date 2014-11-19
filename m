Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbaKSVEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:04:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525AbaKSVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.14 065/122] x86, microcode, AMD: Fix ucode patch stashing on 32-bit
Date: Wed, 19 Nov 2014 12:51:55 -0800
Message-Id: <20141119205210.960902340@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/microcode/amd_early.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -108,12 +108,13 @@ static size_t compute_container_size(u8
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
@@ -123,10 +124,12 @@ static void apply_ucode_in_initrd(void *
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
@@ -213,9 +216,9 @@ static void apply_ucode_in_initrd(void *
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
@@ -387,7 +391,7 @@ int __init save_microcode_in_initrd_amd(
 
 	ret = load_microcode_amd(eax, container, container_size);
 	if (ret != UCODE_OK)
-		return -EINVAL;
+		retval = -EINVAL;
 
 	/*
 	 * This will be freed any msec now, stash patches for the current
@@ -396,5 +400,5 @@ int __init save_microcode_in_initrd_amd(
 	container = NULL;
 	container_size = 0;
 
-	return 0;
+	return retval;
 }


