Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab3JPIfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:35:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281Ab3JPIfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:35:46 -0400
Date: Wed, 16 Oct 2013 16:35:13 +0800
From: Dave Young <dyoung@redhat.com>
To: matt@console-pimps.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com, maarten.lankhorst@canonical.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        linux-efi@vger.kernel.org, pjones@redhat.com
Subject: [PATCH v2] x86 efi: efi reverve boot service fix
Message-ID: <20131016083513.GC27678@dhcp-16-126.nay.redhat.com>
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code check boot service region with kernel text region by: 
start+size >= __pa_symbol(_text)
The end of the above region should be start + size - 1 instead.

I see this problem in ovmf + Fedora 19 grub boot:
text start: 1000000 md start: 800000 md size: 800000

Signed-off-by: Dave Young <dyoung@redhat.com>
---
v2: use > instead of >= per hpa

 arch/x86/platform/efi/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
+		if ((start + size > __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
