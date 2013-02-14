Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3BNEyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:54:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3BNEyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:54:18 -0500
Date: Wed, 13 Feb 2013 20:52:55 -0800
From: tip-bot for Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <tip-1de63d60cd5b0d33a812efa455d5933bf1564a51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, matt.fleming@intel.com,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, matt.fleming@intel.com,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <511C2C04.2070108@jp.fujitsu.com>
References: <511C2C04.2070108@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] efi:
  Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter
Git-Commit-ID: 1de63d60cd5b0d33a812efa455d5933bf1564a51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 13 Feb 2013 20:53:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1de63d60cd5b0d33a812efa455d5933bf1564a51
Gitweb:     http://git.kernel.org/tip/1de63d60cd5b0d33a812efa455d5933bf1564a51
Author:     Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
AuthorDate: Thu, 14 Feb 2013 09:12:52 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 13 Feb 2013 17:24:11 -0800

efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter

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
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 77cf009..928bf83 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -87,7 +87,7 @@ EXPORT_SYMBOL(efi_enabled);
 
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_BOOT, &x86_efi_facility);
+	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	return 0;
 }
 early_param("noefi", setup_noefi);
