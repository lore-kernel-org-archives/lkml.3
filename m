Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaCaAWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36315 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Young" <dyoung@redhat.com>,
        "Matt Fleming" <matt.fleming@intel.com>,
        "Borislav Petkov" <bp@suse.de>, "Toshi Kani" <toshi.kani@hp.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.444261984@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 012/200] x86/efi: Fix off-by-one bug in EFI Boot
 Services reservation
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Young <dyoung@redhat.com>

commit a7f84f03f660d93574ac88835d056c0d6468aebe upstream.

Current code check boot service region with kernel text region by:
start+size >= __pa_symbol(_text)
The end of the above region should be start + size - 1 instead.

I see this problem in ovmf + Fedora 19 grub boot:
text start: 1000000 md start: 800000 md size: 800000

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Tested-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[bwh: Backported to 3.2: s/__pa_symbol/virt_to_phys/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -424,7 +424,7 @@ void __init efi_reserve_boot_services(vo
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= virt_to_phys(_text)
+		if ((start + size > virt_to_phys(_text)
 				&& start <= virt_to_phys(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_x86_check_reserved_size(&start, &size,

