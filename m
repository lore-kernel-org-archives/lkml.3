Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3FZWNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:13:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3FZWNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:13:11 -0400
Date: Wed, 26 Jun 2013 15:12:44 -0700
From: tip-bot for Jacob Shin <tipbot@zytor.com>
Message-ID: <tip-9608d33b8210c993af4430d661a6474946480c9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130620152414.GA6676@jshin-Toonie>
References: <20130620152414.GA6676@jshin-Toonie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, amd:
  Another early loading fixup
Git-Commit-ID: 9608d33b8210c993af4430d661a6474946480c9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 15:12:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9608d33b8210c993af4430d661a6474946480c9b
Gitweb:     http://git.kernel.org/tip/9608d33b8210c993af4430d661a6474946480c9b
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Thu, 20 Jun 2013 09:52:50 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 26 Jun 2013 14:55:37 -0700

x86, microcode, amd: Another early loading fixup

commit cd1c32ca969ebfd65e61312c988223bb14f09c2e is an early premature
rendition of the patch. Augment it with this delta patch to:
  * correctly mark offset and size of the matching bin file
  * use __pa instead of __pa_nodebug during AP load
  * check for !initrd_start before using it

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Link: http://lkml.kernel.org/r/20130620152414.GA6676@jshin-Toonie
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_amd_early.c | 40 +++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 4c593c2..1ac6e9a 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -143,13 +143,17 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 			left  -= offset;
 		}
 
-		offset = data - (u8 *)ucode;
+		/* mark where the next microcode container file starts */
+		offset    = data - (u8 *)ucode;
 		*uoffset += offset;
 		*usize   -= offset;
+		ucode     = data;
 	}
 
-	if (!eq_id)
+	if (!eq_id) {
+		*usize = 0;
 		return;
+	}
 
 	/* find ucode and update if needed */
 
@@ -166,15 +170,21 @@ static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
 		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
 			if (__apply_microcode_amd(mc) == 0) {
-				if (!(*new_rev))
-					*new_rev = mc->hdr.patch_id;
-				break;
+				rev = mc->hdr.patch_id;
+				*new_rev = rev;
 			}
 
 		offset  = header[1] + SECTION_HDR_SIZE;
 		data   += offset;
 		left   -= offset;
 	}
+
+	/* mark where this microcode container file ends */
+	offset  = *usize - (data - (u8 *)ucode);
+	*usize -= offset;
+
+	if (!(*new_rev))
+		*usize = 0;
 }
 
 void __init load_ucode_amd_bsp(void)
@@ -204,19 +214,20 @@ void __cpuinit load_ucode_amd_ap(void)
 	size_t *usize;
 	void *ucode;
 
-	mc = (struct microcode_amd *)__pa_nodebug(amd_bsp_mpb);
+	mc = (struct microcode_amd *)__pa(amd_bsp_mpb);
 	if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
 		__apply_microcode_amd(mc);
 		return;
 	}
 
-	initrd  = (unsigned long *)__pa_nodebug(&initrd_start);
-	uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
-	usize   = (size_t *)__pa_nodebug(&ucode_size);
-	if (!*usize)
+	initrd  = (unsigned long *)__pa(&initrd_start);
+	uoffset = (unsigned long *)__pa(&ucode_offset);
+	usize   = (size_t *)__pa(&ucode_size);
+
+	if (!*usize || !*initrd)
 		return;
 
-	ucode = (void *)((unsigned long)__pa_nodebug(*initrd) + *uoffset);
+	ucode = (void *)((unsigned long)__pa(*initrd) + *uoffset);
 	apply_ucode_in_initrd(ucode, *usize);
 }
 
@@ -250,7 +261,7 @@ void __cpuinit load_ucode_amd_ap(void)
 	if (cpu && !ucode_loaded) {
 		void *ucode;
 
-		if (!ucode_size)
+		if (!ucode_size || !initrd_start)
 			return;
 
 		ucode = (void *)(initrd_start + ucode_offset);
@@ -278,10 +289,7 @@ int __init save_microcode_in_initrd_amd(void)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (ucode_loaded)
-		return 0;
-
-	if (!ucode_size)
+	if (ucode_loaded || !ucode_size || !initrd_start)
 		return 0;
 
 	ucode = (void *)(initrd_start + ucode_offset);
