Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaHNJS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:18:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbaHNJSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:18:14 -0400
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
        linux-efi@vger.kernel.org, Daniel Kiper <daniel.kiper@oracle.com>,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH 5/7] arm64/efi: do not enter virtual mode in case booting with efi=noruntime or noefi
Date: Thu, 14 Aug 2014 17:15:30 +0800
Message-Id: <1408007731-15081-5-git-send-email-dyoung@redhat.com>
In-Reply-To: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
should error out.

At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
the function or it will leak early mem.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/arm64/kernel/efi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 6ed0362..309fab1 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -392,11 +392,16 @@ static int __init arm64_enter_virtual_mode(void)
 		return -1;
 	}
 
+	mapsize = memmap.map_end - memmap.map;
+	if (efi_runtime_disabled()) {
+		early_memunmap(memmap.map, mapsize);
+		pr_info("EFI runtime services will be disabled.\n");
+		return -1;
+	}
+
 	pr_info("Remapping and enabling EFI services.\n");
 
 	/* replace early memmap mapping with permanent mapping */
-	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
 	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
 						   mapsize);
 	memmap.map_end = memmap.map + mapsize;
-- 
1.8.3.1

