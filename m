Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3BSSzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:55:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701Ab3BSSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:55:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 80/81] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter
Date: Tue, 19 Feb 2013 15:49:43 -0300
Message-Id: <1361299784-8830-81-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

commit 1de63d60cd5b0d33a812efa455d5933bf1564a51 upstream.

There was a serious problem in samsung-laptop that its platform driver is
designed to run under BIOS and running under EFI can cause the machine to
become bricked or can cause Machine Check Exceptions.

    Discussion about this problem:
    https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557
    https://bugzilla.kernel.org/show_bug.cgi?id=47121

    The patches to fix this problem:
    efi: Make 'efi_enabled' a function to query EFI facilities
    83e68189745ad931c2afd45d8ee3303929233e7f

    samsung-laptop: Disable on EFI hardware
    e0094244e41c4d0c7ad69920681972fc45d8ce34

Unfortunately this problem comes back again if users specify "noefi" option.
This parameter clears EFI_BOOT and that driver continues to run even if running
under EFI. Refer to the document, this parameter should clear
EFI_RUNTIME_SERVICES instead.

Documentation/kernel-parameters.txt:
===============================================================================
...
	noefi		[X86] Disable EFI runtime services support.
...
===============================================================================

Documentation/x86/x86_64/uefi.txt:
===============================================================================
...
- If some or all EFI runtime services don't work, you can try following
  kernel command line parameters to turn off some or all EFI runtime
  services.
	noefi		turn off all EFI runtime services
...
===============================================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Link: http://lkml.kernel.org/r/511C2C04.2070108@jp.fujitsu.com
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 6fcd4ad..3705bb0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(efi_enabled);
 
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_BOOT, &x86_efi_facility);
+	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	return 0;
 }
 early_param("noefi", setup_noefi);
-- 
1.7.9.5

