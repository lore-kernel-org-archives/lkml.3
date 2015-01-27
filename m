Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbbA0MRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34901 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbbA0MRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 023/126] arm64/efi: add missing call to early_ioremap_reset()
Date: Tue, 27 Jan 2015 12:15:28 +0000
Message-Id: <1422361031-19364-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit 0e63ea48b4d8035dd0e91a3fa6fb79458b47adfb upstream.

The early ioremap support introduced by patch bf4b558eba92
("arm64: add early_ioremap support") failed to add a call to
early_ioremap_reset() at an appropriate time. Without this call,
invocations of early_ioremap etc. that are done too late will go
unnoticed and may cause corruption.

This is exactly what happened when the first user of this feature
was added in patch f84d02755f5a ("arm64: add EFI runtime services").
The early mapping of the EFI memory map is unmapped during an early
initcall, at which time the early ioremap support is long gone.

Fix by adding the missing call to early_ioremap_reset() to
setup_arch(), and move the offending early_memunmap() to right after
the point where the early mapping of the EFI memory map is last used.

Fixes: f84d02755f5a ("arm64: add EFI runtime services")
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/efi.c   | 2 +-
 arch/arm64/kernel/setup.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index c0aead7d1a72..6b6bc795f72d 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -338,6 +338,7 @@ void __init efi_idmap_init(void)
 
 	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
 	efi_setup_idmap();
+	early_memunmap(memmap.map, memmap.map_end - memmap.map);
 }
 
 static int __init remap_region(efi_memory_desc_t *md, void **new)
@@ -395,7 +396,6 @@ static int __init arm64_enter_virtual_mode(void)
 
 	/* replace early memmap mapping with permanent mapping */
 	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
 	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
 						   mapsize);
 	memmap.map_end = memmap.map + mapsize;
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 9e03a1485cc3..209070d08ee3 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -390,6 +390,7 @@ void __init setup_arch(char **cmdline_p)
 	request_standard_resources();
 
 	efi_idmap_init();
+	early_ioremap_reset();
 
 	unflatten_device_tree();
 
-- 
2.1.4

