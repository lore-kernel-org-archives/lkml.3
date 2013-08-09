Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031431Ab3HIWwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:52:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53897 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031398Ab3HIWwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:52:19 -0400
Date: Fri, 9 Aug 2013 15:51:58 -0700
From: tip-bot for Daniel Drake <tipbot@zytor.com>
Message-ID: <tip-d55e37bb0f51316e552376ddc0a3fff34ca7108b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, dsd@laptop.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, dsd@laptop.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130809221420.618E6FAB03@dev.laptop.org>
References: <20130809221420.618E6FAB03@dev.laptop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don'
 t clear olpc_ofw_header when sentinel is detected
Git-Commit-ID: d55e37bb0f51316e552376ddc0a3fff34ca7108b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 09 Aug 2013 15:52:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d55e37bb0f51316e552376ddc0a3fff34ca7108b
Gitweb:     http://git.kernel.org/tip/d55e37bb0f51316e552376ddc0a3fff34ca7108b
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Fri, 9 Aug 2013 18:14:20 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 15:29:48 -0700

x86: Don't clear olpc_ofw_header when sentinel is detected

OpenFirmware wasn't quite following the protocol described in boot.txt
and the kernel has detected this through use of the sentinel value
in boot_params. OFW does zero out almost all of the stuff that it should
do, but not the sentinel.

This causes the kernel to clear olpc_ofw_header, which breaks x86 OLPC
support.

OpenFirmware has now been fixed. However, it would be nice if we could
maintain Linux compatibility with old firmware versions. To do that, we just
have to avoid zeroing out olpc_ofw_header.

OFW does not write to any other parts of the header that are being zapped
by the sentinel-detection code, and all users of olpc_ofw_header are
somewhat protected through checking for the OLPC_OFW_SIG magic value
before using it. So this should not cause any problems for anyone.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/20130809221420.618E6FAB03@dev.laptop.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.9+
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
