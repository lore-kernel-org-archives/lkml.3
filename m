Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3FBWMx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:12:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59731 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab3FBWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:12:46 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: matt.fleming@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] UEFI: Don't pass boot services regions to SetVirtualAddressMap()
Date: Sun,  2 Jun 2013 18:12:25 -0400
Message-Id: <1370211145-7273-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.4
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:c817:a39e:55c0:d358
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to map boot services regions during startup in order to avoid
firmware bugs, but we shouldn't be passing those regions to
SetVirtualAddressMap(). Ensure that we're only passing regions that are
marked as being mapped at runtime.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 arch/x86/platform/efi/efi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 63e167a..add0e37 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -922,6 +922,13 @@ void __init efi_enter_virtual_mode(void)
 			va = efi_ioremap(md->phys_addr, size,
 					 md->type, md->attribute);
 
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+			if (!va)
+				pr_err("ioremap of 0x%llX failed!\n",
+				       (unsigned long long)md->phys_addr);
+			continue;
+		}
+
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
-- 
1.8.1.4

