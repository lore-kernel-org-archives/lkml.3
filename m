Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3KLTnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:43:05 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:60542 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3KLTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:42:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-c6x-dev@linux-c6x.org,
        devicetree@vger.kernel.org
Subject: [PATCH RFC 16/17] c6x: Convert from _fdt_start to __dtb_start
Date: Tue, 12 Nov 2013 20:42:26 +0100
Message-Id: <1384285347-13506-17-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the c6x-specific __fdt_blob section, and start using .dtb.init.rodata
from <asm-generic/sections.h> for built-in DTBs, like most other DT enabled
architectures.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-c6x-dev@linux-c6x.org
Cc: devicetree@vger.kernel.org
---
Untested due to lack of cross-compiler, but the changes are similar to
microblaze.

QUESTION: The padding of the DTB is gone, is this OK?

TODO: Start using the DTB logic in scripts/Makefile.lib instead of
      arch/c6x/boot/dts/linked_dtb.S

 arch/c6x/boot/dts/linked_dtb.S  |    2 +-
 arch/c6x/include/asm/sections.h |    1 -
 arch/c6x/kernel/setup.c         |    2 +-
 arch/c6x/kernel/vmlinux.lds.S   |    9 ---------
 4 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/c6x/boot/dts/linked_dtb.S b/arch/c6x/boot/dts/linked_dtb.S
index cf347f1d16ce..a3447423abda 100644
--- a/arch/c6x/boot/dts/linked_dtb.S
+++ b/arch/c6x/boot/dts/linked_dtb.S
@@ -1,2 +1,2 @@
-.section __fdt_blob,"a"
+.section .dtb.init.rodata,"a"
 .incbin "arch/c6x/boot/dts/builtin.dtb"
diff --git a/arch/c6x/include/asm/sections.h b/arch/c6x/include/asm/sections.h
index f703989d837a..b0eeca16824f 100644
--- a/arch/c6x/include/asm/sections.h
+++ b/arch/c6x/include/asm/sections.h
@@ -7,6 +7,5 @@ extern char _vectors_start[];
 extern char _vectors_end[];
 
 extern char _data_lma[];
-extern char _fdt_start[], _fdt_end[];
 
 #endif /* _ASM_C6X_SECTIONS_H */
diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index 731db4b9014d..414353027ba9 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -266,7 +266,7 @@ int __init c6x_add_memory(phys_addr_t start, unsigned long size)
 notrace void __init machine_init(unsigned long dt_ptr)
 {
 	struct boot_param_header *dtb = __va(dt_ptr);
-	struct boot_param_header *fdt = (struct boot_param_header *)_fdt_start;
+	struct boot_param_header *fdt = &__dtb_start;
 
 	/* interrupts must be masked */
 	set_creg(IER, 2);
diff --git a/arch/c6x/kernel/vmlinux.lds.S b/arch/c6x/kernel/vmlinux.lds.S
index 5a6e141d1641..fea7f7a90f0f 100644
--- a/arch/c6x/kernel/vmlinux.lds.S
+++ b/arch/c6x/kernel/vmlinux.lds.S
@@ -88,15 +88,6 @@ SECTIONS
 	}
 
 	. = ALIGN (8) ;
-	__fdt_blob : AT(ADDR(__fdt_blob) - LOAD_OFFSET)
-	{
-		_fdt_start = . ;	/* place for fdt blob */
-		*(__fdt_blob) ;		/* Any link-placed DTB */
-		BYTE(0);		/* section always has contents */
-	        . = _fdt_start + 0x4000;	/* Pad up to 16kbyte */
-		_fdt_end = . ;
-	}
-
 	_etext = .;
 
 	/*
-- 
1.7.9.5

