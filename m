Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3BOW44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3BOW4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 10/10] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi" boot parameter
Date: Fri, 15 Feb 2013 14:56:42 -0800
Message-Id: <20130215225544.749265122@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225543.586012193@linuxfoundation.org>
References: <20130215225543.586012193@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


