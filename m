Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaD3GEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:04:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63884 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaD3GEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:04:08 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: fix skipping call to early_init_fdt_scan_reserved_mem
Date: Wed, 30 Apr 2014 01:03:52 -0500
Message-Id: <1398837832-30052-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The call to early_init_fdt_scan_reserved_mem will be skipped if
reserved-ranges is not found. Move the call earlier so that it is called
unconditionally.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Tested-by: Stephen Chivers <schivers@csc.com>
---
I found this issue in testing of my fdt clean-up series (thanks to 
Stephen). Since the reserved memory support is new, I don't think it is 
critical to fix this for 3.15. I plan to include this with my fdt series 
for 3.16 unless I hear otherwise.

Rob

 arch/powerpc/kernel/prom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 668aa47..d657549 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -567,6 +567,8 @@ static void __init early_reserve_mem_dt(void)
 	unsigned long i, len, dt_root;
 	const __be32 *prop;
 
+	early_init_fdt_scan_reserved_mem();
+
 	dt_root = of_get_flat_dt_root();
 
 	prop = of_get_flat_dt_prop(dt_root, "reserved-ranges", &len);
@@ -589,8 +591,6 @@ static void __init early_reserve_mem_dt(void)
 			memblock_reserve(base, size);
 		}
 	}
-
-	early_init_fdt_scan_reserved_mem();
 }
 
 static void __init early_reserve_mem(void)
-- 
1.9.1

