Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab3CGEyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:54:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3CGEyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:54:19 -0500
Date: Wed, 6 Mar 2013 20:53:07 -0800
From: tip-bot for Josh Boyer <tipbot@zytor.com>
Message-ID: <tip-2e604c0f19dcdd433b3863ffc3da9bc0787ca765@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        holt@sgi.com, tglx@linutronix.de, jwboyer@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        holt@sgi.com, tglx@linutronix.de, jwboyer@gmail.com
In-Reply-To: <CA+5PVA51-FT14p4CRYKbicykugVb=PiaEycdQ57CK2km_OQuRQ@mail.gmail.com>
References: <CA+5PVA51-FT14p4CRYKbicykugVb=PiaEycdQ57CK2km_OQuRQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don'
 t clear efi_info even if the sentinel hits
Git-Commit-ID: 2e604c0f19dcdd433b3863ffc3da9bc0787ca765
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 20:53:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e604c0f19dcdd433b3863ffc3da9bc0787ca765
Gitweb:     http://git.kernel.org/tip/2e604c0f19dcdd433b3863ffc3da9bc0787ca765
Author:     Josh Boyer <jwboyer@gmail.com>
AuthorDate: Wed, 6 Mar 2013 20:23:30 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Mar 2013 20:23:30 -0800

x86: Don't clear efi_info even if the sentinel hits

When boot_params->sentinel is set, all we really know is that some
undefined set of fields in struct boot_params contain garbage.  In the
particular case of efi_info, however, there is a private magic for
that substructure, so it is generally safe to leave it even if the
bootloader is broken.

kexec (for which we did the initial analysis) did not initialize this
field, but of course all the EFI bootloaders do, and most EFI
bootloaders are broken in this respect (and should be fixed.)

Reported-by: Robin Holt <holt@sgi.com>
Link: http://lkml.kernel.org/r/CA%2B5PVA51-FT14p4CRYKbicykugVb=PiaEycdQ57CK2km_OQuRQ@mail.gmail.com
Tested-by: Josh Boyer <jwboyer@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/bootparam_utils.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 5b5e9cb..ff808ef 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -14,13 +14,15 @@
  * analysis of kexec-tools; if other broken bootloaders initialize a
  * different set of fields we will need to figure out how to disambiguate.
  *
+ * Note: efi_info is commonly left uninitialized, but that field has a
+ * private magic, so it is better to leave it unchanged.
  */
 static void sanitize_boot_params(struct boot_params *boot_params)
 {
 	if (boot_params->sentinel) {
 		/*fields in boot_params are not valid, clear them */
 		memset(&boot_params->olpc_ofw_header, 0,
-		       (char *)&boot_params->alt_mem_k -
+		       (char *)&boot_params->efi_info -
 			(char *)&boot_params->olpc_ofw_header);
 		memset(&boot_params->kbd_status, 0,
 		       (char *)&boot_params->hdr -
