Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbbANHbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbbANHbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.18 132/150] arm64/efi: add missing call to early_ioremap_reset()
Date: Tue, 13 Jan 2015 23:23:23 -0800
Message-Id: <20150114072101.834893333@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/efi.c   |    2 +-
 arch/arm64/kernel/setup.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -327,6 +327,7 @@ void __init efi_idmap_init(void)
 
 	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
 	efi_setup_idmap();
+	early_memunmap(memmap.map, memmap.map_end - memmap.map);
 }
 
 static int __init remap_region(efi_memory_desc_t *md, void **new)
@@ -381,7 +382,6 @@ static int __init arm64_enter_virtual_mo
 	}
 
 	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
 
 	if (efi_runtime_disabled()) {
 		pr_info("EFI runtime services will be disabled.\n");
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -394,6 +394,7 @@ void __init setup_arch(char **cmdline_p)
 	request_standard_resources();
 
 	efi_idmap_init();
+	early_ioremap_reset();
 
 	unflatten_device_tree();
 


