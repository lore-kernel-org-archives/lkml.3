Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3CFSAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:00:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab3CFSAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:00:41 -0500
From: Peter Jones <pjones@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Be explicit about what the x86 0x020c boot parameter version requires.
Date: Wed,  6 Mar 2013 13:00:23 -0500
Message-Id: <1362592823-28967-1-git-send-email-pjones@redhat.com>
In-Reply-To: <51377C3A.3030301@zytor.com>
References: <51377C3A.3030301@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should help avoid making the incorrect change in non-compliant
bootloaders.

Signed-off-by: Peter Jones <pjones@redhat.com>
---
 Documentation/x86/boot.txt             | 5 +++--
 arch/x86/include/asm/bootparam_utils.h | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 3840b6f..72702db 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -1110,7 +1110,8 @@ firmware, 'table' is the EFI system table - these are the first two
 arguments of the "handoff state" as described in section 2.3 of the
 UEFI specification. 'bp' is the boot loader-allocated boot params.
 
-The boot loader *must* fill out the following fields in bp,
+The boot loader *must* zero the entirity of bp, and then fill out the
+following fields:
 
     o hdr.code32_start
     o hdr.cmd_line_ptr
@@ -1118,4 +1119,4 @@ The boot loader *must* fill out the following fields in bp,
     o hdr.ramdisk_image (if applicable)
     o hdr.ramdisk_size  (if applicable)
 
-All other fields should be zero.
+All other fields should remain zero.
diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 5b5e9cb..b4e8aa8 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -17,6 +17,13 @@
  */
 static void sanitize_boot_params(struct boot_params *boot_params)
 {
+	/* Note: do not simply clear this field.  The purpose of this field is
+	 * to guarantee compliance with the x86 boot spec located in
+	 * Documentation/x86/boot.txt .  That spec says that the *whole*
+	 * structure should be cleared.  If you're having an issue because
+	 * the sentinel is set, you need to change the whole structure to be
+	 * cleared, not this (or any other) indidivual field.
+	 */
 	if (boot_params->sentinel) {
 		/*fields in boot_params are not valid, clear them */
 		memset(&boot_params->olpc_ofw_header, 0,
-- 
1.8.1.4

