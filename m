Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3CATp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3CATpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Walt Nelson Jr <walt0924@gmail.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 23/77] x86, efi: Make "noefi" really disable EFI runtime serivces
Date: Fri,  1 Mar 2013 11:44:08 -0800
Message-Id: <20130301194354.452595684@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -85,9 +85,10 @@ int efi_enabled(int facility)
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
@@ -734,7 +735,7 @@ void __init efi_init(void)
 	if (!efi_is_native())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
-		if (efi_runtime_init())
+		if (disable_runtime || efi_runtime_init())
 			return;
 		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	}


