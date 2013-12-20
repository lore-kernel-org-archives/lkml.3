Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3LTKEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:04:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab3LTKED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:04:03 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        mingo@kernel.org, msalter@redhat.com, leif.lindholm@linaro.org
Subject: [PATCH v7 05/12] efi: reserve boot service fix
Date: Fri, 20 Dec 2013 18:02:15 +0800
Message-Id: <1387533742-18018-6-git-send-email-dyoung@redhat.com>
In-Reply-To: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code check boot service region with kernel text region by:
start+size >= __pa_symbol(_text)
The end of the above region should be start + size - 1 instead.

I see this problem in ovmf + Fedora 19 grub boot:
text start: 1000000 md start: 800000 md size: 800000

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b1e07a4..f022294 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -438,7 +438,7 @@ void __init efi_reserve_boot_services(void)
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
+		if ((start + size > __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
-- 
1.8.3.1

