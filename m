Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390Ab3BNANk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 19:13:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47823 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761189Ab3BNANi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 19:13:38 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <511C2C04.2070108@jp.fujitsu.com>
Date: Thu, 14 Feb 2013 09:12:52 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux EFI ml <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable ml <stable@vger.kernel.org>,
        linux x86 ml <x86@kernel.org>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by "noefi"
 boot parameter
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

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
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Peter Jones <pjones@redhat.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Steve Langasek <steve.langasek@canonical.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
---
 arch/x86/platform/efi/efi.c |    2 +-
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
-- 1.7.10.4 

