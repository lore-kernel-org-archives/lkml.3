Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3BTX1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:27:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3BTX1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:27:09 -0500
Date: Wed, 20 Feb 2013 15:25:50 -0800
From: tip-bot for Matt Fleming <tipbot@zytor.com>
Message-ID: <tip-fb834c7acc5e140cf4f9e86da93a66de8c0514da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, matt.fleming@intel.com,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com, walt0924@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, matt.fleming@intel.com,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de, walt0924@gmail.com,
        hpa@linux.intel.com
In-Reply-To: <1361392572-25657-1-git-send-email-matt@console-pimps.org>
References: <1361392572-25657-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Make "noefi"
  really disable EFI runtime serivces
Git-Commit-ID: fb834c7acc5e140cf4f9e86da93a66de8c0514da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 20 Feb 2013 15:25:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb834c7acc5e140cf4f9e86da93a66de8c0514da
Gitweb:     http://git.kernel.org/tip/fb834c7acc5e140cf4f9e86da93a66de8c0514da
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Wed, 20 Feb 2013 20:36:12 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Feb 2013 13:18:36 -0800

x86, efi: Make "noefi" really disable EFI runtime serivces

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1361392572-25657-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 928bf83..e2cd38f 100644
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
