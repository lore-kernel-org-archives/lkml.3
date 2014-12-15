Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaLOSHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:07:24 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54018 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLOSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:07:02 -0500
From: Aleksey Makarov <feumilieu@gmail.com>
X-Google-Original-From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 14/14] MIPS: OCTEON: Handle OCTEON III in csrc-octeon.
Date: Mon, 15 Dec 2014 21:03:20 +0300
Message-Id: <1418666603-15159-15-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The clock divisors are kept in different registers on OCTEON III.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/cavium-octeon/csrc-octeon.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/mips/cavium-octeon/csrc-octeon.c b/arch/mips/cavium-octeon/csrc-octeon.c
index b752c4e..d270082 100644
--- a/arch/mips/cavium-octeon/csrc-octeon.c
+++ b/arch/mips/cavium-octeon/csrc-octeon.c
@@ -18,6 +18,7 @@
 #include <asm/octeon/octeon.h>
 #include <asm/octeon/cvmx-ipd-defs.h>
 #include <asm/octeon/cvmx-mio-defs.h>
+#include <asm/octeon/cvmx-rst-defs.h>
 
 
 static u64 f;
@@ -39,11 +40,20 @@ void __init octeon_setup_delays(void)
 
 	if (current_cpu_type() == CPU_CAVIUM_OCTEON2) {
 		union cvmx_mio_rst_boot rst_boot;
+
 		rst_boot.u64 = cvmx_read_csr(CVMX_MIO_RST_BOOT);
 		rdiv = rst_boot.s.c_mul;	/* CPU clock */
 		sdiv = rst_boot.s.pnr_mul;	/* I/O clock */
 		f = (0x8000000000000000ull / sdiv) * 2;
+	} else if (current_cpu_type() == CPU_CAVIUM_OCTEON3) {
+		union cvmx_rst_boot rst_boot;
+
+		rst_boot.u64 = cvmx_read_csr(CVMX_RST_BOOT);
+		rdiv = rst_boot.s.c_mul;	/* CPU clock */
+		sdiv = rst_boot.s.pnr_mul;	/* I/O clock */
+		f = (0x8000000000000000ull / sdiv) * 2;
 	}
+
 }
 
 /*
-- 
2.1.3

