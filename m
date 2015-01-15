Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbbAONN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:13:58 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:17966 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbbAONNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:13:55 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Chandrakala Chavva <cchavva@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH v3 13/15] MIPS: OCTEON: More OCTEONIII support
Date: Thu, 15 Jan 2015 16:11:17 +0300
Message-ID: <1421327487-28679-14-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
References: <1421327487-28679-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chandrakala Chavva <cchavva@caviumnetworks.com>

Read clock rate from the correct CSR. Don't clear COP0_DCACHE for OCTEONIII.

Signed-off-by: Chandrakala Chavva <cchavva@caviumnetworks.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/cavium-octeon/csrc-octeon.c              |  11 +-
 arch/mips/cavium-octeon/setup.c                    |   8 +-
 .../asm/mach-cavium-octeon/kernel-entry-init.h     |   3 +
 arch/mips/include/asm/octeon/cvmx-rst-defs.h       | 306 +++++++++++++++++++++
 4 files changed, 326 insertions(+), 2 deletions(-)
 create mode 100644 arch/mips/include/asm/octeon/cvmx-rst-defs.h

diff --git a/arch/mips/cavium-octeon/csrc-octeon.c b/arch/mips/cavium-octeon/csrc-octeon.c
index b752c4e..1882e64 100644
--- a/arch/mips/cavium-octeon/csrc-octeon.c
+++ b/arch/mips/cavium-octeon/csrc-octeon.c
@@ -18,7 +18,7 @@
 #include <asm/octeon/octeon.h>
 #include <asm/octeon/cvmx-ipd-defs.h>
 #include <asm/octeon/cvmx-mio-defs.h>
-
+#include <asm/octeon/cvmx-rst-defs.h>
 
 static u64 f;
 static u64 rdiv;
@@ -39,11 +39,20 @@ void __init octeon_setup_delays(void)
 
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
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index aea091d..254f46c 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -42,6 +42,7 @@
 #include <asm/octeon/octeon.h>
 #include <asm/octeon/pci-octeon.h>
 #include <asm/octeon/cvmx-mio-defs.h>
+#include <asm/octeon/cvmx-rst-defs.h>
 
 extern struct plat_smp_ops octeon_smp_ops;
 
@@ -657,11 +658,16 @@ void __init prom_init(void)
 	sysinfo->dfa_ref_clock_hz = octeon_bootinfo->dfa_ref_clock_hz;
 	sysinfo->bootloader_config_flags = octeon_bootinfo->config_flags;
 
-	if (OCTEON_IS_OCTEON2() || OCTEON_IS_OCTEON3()) {
+	if (OCTEON_IS_OCTEON2()) {
 		/* I/O clock runs at a different rate than the CPU. */
 		union cvmx_mio_rst_boot rst_boot;
 		rst_boot.u64 = cvmx_read_csr(CVMX_MIO_RST_BOOT);
 		octeon_io_clock_rate = 50000000 * rst_boot.s.pnr_mul;
+	} else if (OCTEON_IS_OCTEON3()) {
+		/* I/O clock runs at a different rate than the CPU. */
+		union cvmx_rst_boot rst_boot;
+		rst_boot.u64 = cvmx_read_csr(CVMX_RST_BOOT);
+		octeon_io_clock_rate = 50000000 * rst_boot.s.pnr_mul;
 	} else {
 		octeon_io_clock_rate = sysinfo->cpu_clock_hz;
 	}
diff --git a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
index 4bef539..cf92fe7 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/kernel-entry-init.h
@@ -80,6 +80,9 @@
 	mfc0	v0, CP0_PRID_REG
 	bbit0	v0, 15, 1f
 	# OCTEON II or better have bit 15 set.  Clear the error bits.
+	and	t1, v0, 0xff00
+	dli	v0, 0x9500
+	bge	t1, v0, 1f  # OCTEON III has no DCACHE_ERR_REG COP0
 	dli	v0, 0x27
 	dmtc0	v0, CP0_DCACHE_ERR_REG
 1:
diff --git a/arch/mips/include/asm/octeon/cvmx-rst-defs.h b/arch/mips/include/asm/octeon/cvmx-rst-defs.h
new file mode 100644
index 0000000..0c9c3e7
--- /dev/null
+++ b/arch/mips/include/asm/octeon/cvmx-rst-defs.h
@@ -0,0 +1,306 @@
+/***********************license start***************
+ * Author: Cavium Inc.
+ *
+ * Contact: support@cavium.com
+ * This file is part of the OCTEON SDK
+ *
+ * Copyright (c) 2003-2014 Cavium Inc.
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This file is distributed in the hope that it will be useful, but
+ * AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ * NONINFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this file; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ * or visit http://www.gnu.org/licenses/.
+ *
+ * This file may also be available under a different license from Cavium.
+ * Contact Cavium Inc. for more information
+ ***********************license end**************************************/
+
+#ifndef __CVMX_RST_DEFS_H__
+#define __CVMX_RST_DEFS_H__
+
+#define CVMX_RST_BOOT (CVMX_ADD_IO_SEG(0x0001180006001600ull))
+#define CVMX_RST_CFG (CVMX_ADD_IO_SEG(0x0001180006001610ull))
+#define CVMX_RST_CKILL (CVMX_ADD_IO_SEG(0x0001180006001638ull))
+#define CVMX_RST_CTLX(offset) (CVMX_ADD_IO_SEG(0x0001180006001640ull) + ((offset) & 3) * 8)
+#define CVMX_RST_DELAY (CVMX_ADD_IO_SEG(0x0001180006001608ull))
+#define CVMX_RST_ECO (CVMX_ADD_IO_SEG(0x00011800060017B8ull))
+#define CVMX_RST_INT (CVMX_ADD_IO_SEG(0x0001180006001628ull))
+#define CVMX_RST_OCX (CVMX_ADD_IO_SEG(0x0001180006001618ull))
+#define CVMX_RST_POWER_DBG (CVMX_ADD_IO_SEG(0x0001180006001708ull))
+#define CVMX_RST_PP_POWER (CVMX_ADD_IO_SEG(0x0001180006001700ull))
+#define CVMX_RST_SOFT_PRSTX(offset) (CVMX_ADD_IO_SEG(0x00011800060016C0ull) + ((offset) & 3) * 8)
+#define CVMX_RST_SOFT_RST (CVMX_ADD_IO_SEG(0x0001180006001680ull))
+
+union cvmx_rst_boot {
+	uint64_t u64;
+	struct cvmx_rst_boot_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t chipkill:1;
+		uint64_t jtcsrdis:1;
+		uint64_t ejtagdis:1;
+		uint64_t romen:1;
+		uint64_t ckill_ppdis:1;
+		uint64_t jt_tstmode:1;
+		uint64_t vrm_err:1;
+		uint64_t reserved_37_56:20;
+		uint64_t c_mul:7;
+		uint64_t pnr_mul:6;
+		uint64_t reserved_21_23:3;
+		uint64_t lboot_oci:3;
+		uint64_t lboot_ext:6;
+		uint64_t lboot:10;
+		uint64_t rboot:1;
+		uint64_t rboot_pin:1;
+#else
+		uint64_t rboot_pin:1;
+		uint64_t rboot:1;
+		uint64_t lboot:10;
+		uint64_t lboot_ext:6;
+		uint64_t lboot_oci:3;
+		uint64_t reserved_21_23:3;
+		uint64_t pnr_mul:6;
+		uint64_t c_mul:7;
+		uint64_t reserved_37_56:20;
+		uint64_t vrm_err:1;
+		uint64_t jt_tstmode:1;
+		uint64_t ckill_ppdis:1;
+		uint64_t romen:1;
+		uint64_t ejtagdis:1;
+		uint64_t jtcsrdis:1;
+		uint64_t chipkill:1;
+#endif
+	} s;
+	struct cvmx_rst_boot_s cn70xx;
+	struct cvmx_rst_boot_s cn70xxp1;
+	struct cvmx_rst_boot_s cn78xx;
+};
+
+union cvmx_rst_cfg {
+	uint64_t u64;
+	struct cvmx_rst_cfg_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t bist_delay:58;
+		uint64_t reserved_3_5:3;
+		uint64_t cntl_clr_bist:1;
+		uint64_t warm_clr_bist:1;
+		uint64_t soft_clr_bist:1;
+#else
+		uint64_t soft_clr_bist:1;
+		uint64_t warm_clr_bist:1;
+		uint64_t cntl_clr_bist:1;
+		uint64_t reserved_3_5:3;
+		uint64_t bist_delay:58;
+#endif
+	} s;
+	struct cvmx_rst_cfg_s cn70xx;
+	struct cvmx_rst_cfg_s cn70xxp1;
+	struct cvmx_rst_cfg_s cn78xx;
+};
+
+union cvmx_rst_ckill {
+	uint64_t u64;
+	struct cvmx_rst_ckill_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_47_63:17;
+		uint64_t timer:47;
+#else
+		uint64_t timer:47;
+		uint64_t reserved_47_63:17;
+#endif
+	} s;
+	struct cvmx_rst_ckill_s cn70xx;
+	struct cvmx_rst_ckill_s cn70xxp1;
+	struct cvmx_rst_ckill_s cn78xx;
+};
+
+union cvmx_rst_ctlx {
+	uint64_t u64;
+	struct cvmx_rst_ctlx_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_10_63:54;
+		uint64_t prst_link:1;
+		uint64_t rst_done:1;
+		uint64_t rst_link:1;
+		uint64_t host_mode:1;
+		uint64_t reserved_4_5:2;
+		uint64_t rst_drv:1;
+		uint64_t rst_rcv:1;
+		uint64_t rst_chip:1;
+		uint64_t rst_val:1;
+#else
+		uint64_t rst_val:1;
+		uint64_t rst_chip:1;
+		uint64_t rst_rcv:1;
+		uint64_t rst_drv:1;
+		uint64_t reserved_4_5:2;
+		uint64_t host_mode:1;
+		uint64_t rst_link:1;
+		uint64_t rst_done:1;
+		uint64_t prst_link:1;
+		uint64_t reserved_10_63:54;
+#endif
+	} s;
+	struct cvmx_rst_ctlx_s cn70xx;
+	struct cvmx_rst_ctlx_s cn70xxp1;
+	struct cvmx_rst_ctlx_s cn78xx;
+};
+
+union cvmx_rst_delay {
+	uint64_t u64;
+	struct cvmx_rst_delay_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_32_63:32;
+		uint64_t warm_rst_dly:16;
+		uint64_t soft_rst_dly:16;
+#else
+		uint64_t soft_rst_dly:16;
+		uint64_t warm_rst_dly:16;
+		uint64_t reserved_32_63:32;
+#endif
+	} s;
+	struct cvmx_rst_delay_s cn70xx;
+	struct cvmx_rst_delay_s cn70xxp1;
+	struct cvmx_rst_delay_s cn78xx;
+};
+
+union cvmx_rst_eco {
+	uint64_t u64;
+	struct cvmx_rst_eco_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_32_63:32;
+		uint64_t eco_rw:32;
+#else
+		uint64_t eco_rw:32;
+		uint64_t reserved_32_63:32;
+#endif
+	} s;
+	struct cvmx_rst_eco_s cn78xx;
+};
+
+union cvmx_rst_int {
+	uint64_t u64;
+	struct cvmx_rst_int_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_12_63:52;
+		uint64_t perst:4;
+		uint64_t reserved_4_7:4;
+		uint64_t rst_link:4;
+#else
+		uint64_t rst_link:4;
+		uint64_t reserved_4_7:4;
+		uint64_t perst:4;
+		uint64_t reserved_12_63:52;
+#endif
+	} s;
+	struct cvmx_rst_int_cn70xx {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_11_63:53;
+		uint64_t perst:3;
+		uint64_t reserved_3_7:5;
+		uint64_t rst_link:3;
+#else
+		uint64_t rst_link:3;
+		uint64_t reserved_3_7:5;
+		uint64_t perst:3;
+		uint64_t reserved_11_63:53;
+#endif
+	} cn70xx;
+	struct cvmx_rst_int_cn70xx cn70xxp1;
+	struct cvmx_rst_int_s cn78xx;
+};
+
+union cvmx_rst_ocx {
+	uint64_t u64;
+	struct cvmx_rst_ocx_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_3_63:61;
+		uint64_t rst_link:3;
+#else
+		uint64_t rst_link:3;
+		uint64_t reserved_3_63:61;
+#endif
+	} s;
+	struct cvmx_rst_ocx_s cn78xx;
+};
+
+union cvmx_rst_power_dbg {
+	uint64_t u64;
+	struct cvmx_rst_power_dbg_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_3_63:61;
+		uint64_t str:3;
+#else
+		uint64_t str:3;
+		uint64_t reserved_3_63:61;
+#endif
+	} s;
+	struct cvmx_rst_power_dbg_s cn78xx;
+};
+
+union cvmx_rst_pp_power {
+	uint64_t u64;
+	struct cvmx_rst_pp_power_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_48_63:16;
+		uint64_t gate:48;
+#else
+		uint64_t gate:48;
+		uint64_t reserved_48_63:16;
+#endif
+	} s;
+	struct cvmx_rst_pp_power_cn70xx {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_4_63:60;
+		uint64_t gate:4;
+#else
+		uint64_t gate:4;
+		uint64_t reserved_4_63:60;
+#endif
+	} cn70xx;
+	struct cvmx_rst_pp_power_cn70xx cn70xxp1;
+	struct cvmx_rst_pp_power_s cn78xx;
+};
+
+union cvmx_rst_soft_prstx {
+	uint64_t u64;
+	struct cvmx_rst_soft_prstx_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_1_63:63;
+		uint64_t soft_prst:1;
+#else
+		uint64_t soft_prst:1;
+		uint64_t reserved_1_63:63;
+#endif
+	} s;
+	struct cvmx_rst_soft_prstx_s cn70xx;
+	struct cvmx_rst_soft_prstx_s cn70xxp1;
+	struct cvmx_rst_soft_prstx_s cn78xx;
+};
+
+union cvmx_rst_soft_rst {
+	uint64_t u64;
+	struct cvmx_rst_soft_rst_s {
+#ifdef __BIG_ENDIAN_BITFIELD
+		uint64_t reserved_1_63:63;
+		uint64_t soft_rst:1;
+#else
+		uint64_t soft_rst:1;
+		uint64_t reserved_1_63:63;
+#endif
+	} s;
+	struct cvmx_rst_soft_rst_s cn70xx;
+	struct cvmx_rst_soft_rst_s cn70xxp1;
+	struct cvmx_rst_soft_rst_s cn78xx;
+};
+
+#endif
-- 
2.2.2

