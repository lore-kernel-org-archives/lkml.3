Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3GMQYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 12:24:46 -0400
Received: from lists.laptop.org ([18.85.2.166]:45128 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab3GMQYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 12:24:45 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, pgf@laptop.org, dilinger@queued.net
Subject: [PATCH] x86: don't clear olpc_ofw_header when sentinel is detected
Message-Id: <20130713162604.627C2FAAE9@dev.laptop.org>
Date: Sat, 13 Jul 2013 12:26:04 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OpenFirmware doesn't quite follow the protocol described in boot.txt
and the kernel has detected this through use of the sentinel value
in boot_params. OFW does zero out almost all of the stuff that it should
do, but not the sentinel.

This causes the kernel to clear olpc_ofw_header, which breaks x86 OLPC
support.

We will fix OpenFirmware. However, it would be nice if we could maintain
Linux compatibility with old firmware versions. To do that, we just have
to avoid zeroing out olpc_ofw_header. 

OFW does not write to any other parts of the header that are being zapped
by the sentinel-detection code, and all users of olpc_ofw_header are
somewhat protected through checking for the OLPC_OFW_SIG magic value
before using it. So this should not cause any problems for anyone.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/include/asm/bootparam_utils.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 653668d..4a8cb8d 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -35,9 +35,9 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 	 */
 	if (boot_params->sentinel) {
 		/* fields in boot_params are left uninitialized, clear them */
-		memset(&boot_params->olpc_ofw_header, 0,
+		memset(&boot_params->ext_ramdisk_image, 0,
 		       (char *)&boot_params->efi_info -
-			(char *)&boot_params->olpc_ofw_header);
+			(char *)&boot_params->ext_ramdisk_image);
 		memset(&boot_params->kbd_status, 0,
 		       (char *)&boot_params->hdr -
 		       (char *)&boot_params->kbd_status);
-- 
1.8.1.4

