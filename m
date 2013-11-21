Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3KUGTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:19:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab3KUGTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:19:21 -0500
Message-Id: <20131121061753.741550355@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 14:17:07 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: [patch 3/9 v3] efi: reserve boot service fix
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=03-boot-service-fix.patch
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
 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -438,7 +438,7 @@ void __init efi_reserve_boot_services(vo
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
+		if ((start + size > __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {

