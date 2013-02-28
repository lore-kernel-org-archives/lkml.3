Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873Ab3B1O6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:58:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab3B1Oub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 112/139] x86, efi: Make "noefi" really disable EFI runtime serivces
Date: Thu, 28 Feb 2013 14:44:22 +0000
Message-Id: <1362062689-2567-113-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit fb834c7acc5e140cf4f9e86da93a66de8c0514da upstream.

commit 1de63d60cd5b ("efi: Clear EFI_RUNTIME_SERVICES rather than
EFI_BOOT by "noefi" boot parameter") attempted to make "noefi" true to
its documentation and disable EFI runtime services to prevent the
bricking bug described in commit e0094244e41c ("samsung-laptop:
Disable on EFI hardware"). However, it's not possible to clear
EFI_RUNTIME_SERVICES from an early param function because
EFI_RUNTIME_SERVICES is set in efi_init() *after* parse_early_param().

This resulted in "noefi" effectively becoming a no-op and no longer
providing users with a way to disable EFI, which is bad for those
users that have buggy machines.

Reported-by: Walt Nelson Jr <walt0924@gmail.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1361392572-25657-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/platform/efi/efi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3705bb0..1e40637 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -84,9 +84,10 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
+static bool disable_runtime = false;
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
+	disable_runtime = true;
 	return 0;
 }
 early_param("noefi", setup_noefi);
@@ -733,7 +734,7 @@ void __init efi_init(void)
 	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
-		if (efi_runtime_init())
+		if (disable_runtime || efi_runtime_init())
 			return;
 		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	}
-- 
1.8.1.2

