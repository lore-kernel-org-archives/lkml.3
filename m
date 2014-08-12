Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaHLGNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:13:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbaHLGNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:13:05 -0400
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 3/5] efi arm64: do not enter virtual mode in case booting with efi=noruntime or noefi
Date: Tue, 12 Aug 2014 14:10:20 +0800
Message-Id: <1407823822-23829-3-git-send-email-dyoung@redhat.com>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
should error out.

At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
the function or it will leak early mem.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/arm64/kernel/efi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e72f310..324cdd1 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -386,7 +386,10 @@ static int __init arm64_enter_virtual_mode(void)
 	int count = 0;
 	unsigned long flags;
 
-	if (!efi_enabled(EFI_BOOT)) {
+	mapsize = memmap.map_end - memmap.map;
+	early_memunmap(memmap.map, mapsize);
+
+	if (!efi_enabled(EFI_BOOT) || efi_runtime_disabled()) {
 		pr_info("EFI services will not be available.\n");
 		return -1;
 	}
@@ -394,8 +397,6 @@ static int __init arm64_enter_virtual_mode(void)
 	pr_info("Remapping and enabling EFI services.\n");
 
 	/* replace early memmap mapping with permanent mapping */
-	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
 	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
 						   mapsize);
 	memmap.map_end = memmap.map + mapsize;
-- 
1.8.3.1

