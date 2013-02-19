Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab3BSPp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:45:28 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58053 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab3BSPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:45:26 -0500
Date: Tue, 19 Feb 2013 16:45:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv changes for v3.9
Message-ID: <20130219154518.GA15750@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   HEAD: d924f947a44684796eee6fa488a9fe7876923c3b x86, uv, uv3: Trim MMR register definitions after code changes for SGI UV3

Support for the SGI Ultraviolet System 3 (UV3) platform - the 
upcoming third major iteration and upscaling of the SGI UV 
supercomputing platform.

out-of-topic modifications in x86-uv-for-linus:
-----------------------------------------------
drivers/misc/sgi-gru/grufile.c     # 385404e: x86, uv, uv3: Check current gru h

 Thanks,

	Ingo

------------------>
Mike Travis (7):
      x86, uv, uv3: Update MMR register definitions for SGI Ultraviolet System 3 (UV3)
      x86, uv, uv3: Update ACPI Check to include SGI UV3
      x86, uv, uv3: Update Hub Info for SGI UV3
      x86, uv, uv3: Update x2apic Support for SGI UV3
      x86, uv, uv3: Update Time Support for SGI UV3
      x86, uv, uv3: Check current gru hub support for SGI UV3
      x86, uv, uv3: Trim MMR register definitions after code changes for SGI UV3


 arch/x86/include/asm/uv/uv_hub.h   |   44 +-
 arch/x86/include/asm/uv/uv_mmrs.h  | 1496 +++++++++++++++++++++++++++---------
 arch/x86/kernel/apic/x2apic_uv_x.c |  206 ++++-
 arch/x86/pci/mmconfig-shared.c     |    3 +-
 arch/x86/platform/uv/uv_time.c     |   13 +-
 drivers/misc/sgi-gru/grufile.c     |    2 +-
 6 files changed, 1354 insertions(+), 410 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 21f7385..2c32df9 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -5,7 +5,7 @@
  *
  * SGI UV architectural definitions
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_HUB_H
@@ -175,6 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
  */
 #define UV1_HUB_REVISION_BASE		1
 #define UV2_HUB_REVISION_BASE		3
+#define UV3_HUB_REVISION_BASE		5
 
 static inline int is_uv1_hub(void)
 {
@@ -183,6 +184,23 @@ static inline int is_uv1_hub(void)
 
 static inline int is_uv2_hub(void)
 {
+	return ((uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE) &&
+		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE));
+}
+
+static inline int is_uv3_hub(void)
+{
+	return uv_hub_info->hub_revision >= UV3_HUB_REVISION_BASE;
+}
+
+static inline int is_uv_hub(void)
+{
+	return uv_hub_info->hub_revision;
+}
+
+/* code common to uv2 and uv3 only */
+static inline int is_uvx_hub(void)
+{
 	return uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE;
 }
 
@@ -230,14 +248,23 @@ union uvh_apicid {
 #define UV2_LOCAL_MMR_SIZE		(32UL * 1024 * 1024)
 #define UV2_GLOBAL_MMR32_SIZE		(32UL * 1024 * 1024)
 
-#define UV_LOCAL_MMR_BASE		(is_uv1_hub() ? UV1_LOCAL_MMR_BASE     \
-						: UV2_LOCAL_MMR_BASE)
-#define UV_GLOBAL_MMR32_BASE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_BASE  \
-						: UV2_GLOBAL_MMR32_BASE)
-#define UV_LOCAL_MMR_SIZE		(is_uv1_hub() ? UV1_LOCAL_MMR_SIZE :   \
-						UV2_LOCAL_MMR_SIZE)
+#define UV3_LOCAL_MMR_BASE		0xfa000000UL
+#define UV3_GLOBAL_MMR32_BASE		0xfc000000UL
+#define UV3_LOCAL_MMR_SIZE		(32UL * 1024 * 1024)
+#define UV3_GLOBAL_MMR32_SIZE		(32UL * 1024 * 1024)
+
+#define UV_LOCAL_MMR_BASE		(is_uv1_hub() ? UV1_LOCAL_MMR_BASE : \
+					(is_uv2_hub() ? UV2_LOCAL_MMR_BASE : \
+							UV3_LOCAL_MMR_BASE))
+#define UV_GLOBAL_MMR32_BASE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_BASE :\
+					(is_uv2_hub() ? UV2_GLOBAL_MMR32_BASE :\
+							UV3_GLOBAL_MMR32_BASE))
+#define UV_LOCAL_MMR_SIZE		(is_uv1_hub() ? UV1_LOCAL_MMR_SIZE : \
+					(is_uv2_hub() ? UV2_LOCAL_MMR_SIZE : \
+							UV3_LOCAL_MMR_SIZE))
 #define UV_GLOBAL_MMR32_SIZE		(is_uv1_hub() ? UV1_GLOBAL_MMR32_SIZE :\
-						UV2_GLOBAL_MMR32_SIZE)
+					(is_uv2_hub() ? UV2_GLOBAL_MMR32_SIZE :\
+							UV3_GLOBAL_MMR32_SIZE))
 #define UV_GLOBAL_MMR64_BASE		(uv_hub_info->global_mmr_base)
 
 #define UV_GLOBAL_GRU_MMR_BASE		0x4000000
@@ -599,6 +626,7 @@ static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
  *     1 - UV1 rev 1.0 initial silicon
  *     2 - UV1 rev 2.0 production silicon
  *     3 - UV2 rev 1.0 initial silicon
+ *     5 - UV3 rev 1.0 initial silicon
  */
 static inline int uv_get_min_hub_revision_id(void)
 {
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index cf1d736..bd5f80e 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -5,16 +5,25 @@
  *
  * SGI UV MMR definitions
  *
- * Copyright (C) 2007-2011 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_MMRS_H
 #define _ASM_X86_UV_UV_MMRS_H
 
 /*
- * This file contains MMR definitions for both UV1 & UV2 hubs.
+ * This file contains MMR definitions for all UV hubs types.
  *
- * In general, MMR addresses and structures are identical on both hubs.
+ * To minimize coding differences between hub types, the symbols are
+ * grouped by architecture types.
+ *
+ * UVH  - definitions common to all UV hub types.
+ * UVXH - definitions common to all UV eXtended hub types (currently 2 & 3).
+ * UV1H - definitions specific to UV type 1 hub.
+ * UV2H - definitions specific to UV type 2 hub.
+ * UV3H - definitions specific to UV type 3 hub.
+ *
+ * So in general, MMR addresses and structures are identical on all hubs types.
  * These MMRs are identified as:
  *	#define UVH_xxx		<address>
  *	union uvh_xxx {
@@ -23,24 +32,36 @@
  *		} s;
  *	};
  *
- * If the MMR exists on both hub type but has different addresses or
- * contents, the MMR definition is similar to:
- *	#define UV1H_xxx	<uv1 address>
- *	#define UV2H_xxx	<uv2address>
- *	#define UVH_xxx		(is_uv1_hub() ? UV1H_xxx : UV2H_xxx)
+ * If the MMR exists on all hub types but have different addresses:
+ *	#define UV1Hxxx	a
+ *	#define UV2Hxxx	b
+ *	#define UV3Hxxx	c
+ *	#define UVHxxx	(is_uv1_hub() ? UV1Hxxx :
+ *			(is_uv2_hub() ? UV2Hxxx :
+ *					UV3Hxxx))
+ *
+ * If the MMR exists on all hub types > 1 but have different addresses:
+ *	#define UV2Hxxx	b
+ *	#define UV3Hxxx	c
+ *	#define UVXHxxx (is_uv2_hub() ? UV2Hxxx :
+ *					UV3Hxxx))
+ *
  *	union uvh_xxx {
  *		unsigned long       v;
- *		struct uv1h_int_cmpd_s {	 (Common fields only)
+ *		struct uvh_xxx_s {	 # Common fields only
  *		} s;
- *		struct uv1h_int_cmpd_s {	 (Full UV1 definition)
+ *		struct uv1h_xxx_s {	 # Full UV1 definition (*)
  *		} s1;
- *		struct uv2h_int_cmpd_s {	 (Full UV2 definition)
+ *		struct uv2h_xxx_s {	 # Full UV2 definition (*)
  *		} s2;
+ *		struct uv3h_xxx_s {	 # Full UV3 definition (*)
+ *		} s3;
  *	};
+ *		(* - if present and different than the common struct)
  *
- * Only essential difference are enumerated. For example, if the address is
- * the same for both UV1 & UV2, only a single #define is generated. Likewise,
- * if the contents is the same for both hubs, only the "s" structure is
+ * Only essential differences are enumerated. For example, if the address is
+ * the same for all UV's, only a single #define is generated. Likewise,
+ * if the contents is the same for all hubs, only the "s" structure is
  * generated.
  *
  * If the MMR exists on ONLY 1 type of hub, no generic definition is
@@ -51,6 +72,8 @@
  *		struct uvh_int_cmpd_s {
  *		} sn;
  *	};
+ *
+ * (GEN Flags: mflags_opt= undefs=0 UV23=UVXH)
  */
 
 #define UV_MMR_ENABLE		(1UL << 63)
@@ -58,15 +81,18 @@
 #define UV1_HUB_PART_NUMBER	0x88a5
 #define UV2_HUB_PART_NUMBER	0x8eb8
 #define UV2_HUB_PART_NUMBER_X	0x1111
+#define UV3_HUB_PART_NUMBER	0x9578
+#define UV3_HUB_PART_NUMBER_X	0x4321
 
-/* Compat: if this #define is present, UV headers support UV2 */
+/* Compat: Indicate which UV Hubs are supported. */
 #define UV2_HUB_IS_SUPPORTED	1
+#define UV3_HUB_IS_SUPPORTED	1
 
 /* ========================================================================= */
 /*                          UVH_BAU_DATA_BROADCAST                           */
 /* ========================================================================= */
-#define UVH_BAU_DATA_BROADCAST				0x61688UL
-#define UVH_BAU_DATA_BROADCAST_32			0x440
+#define UVH_BAU_DATA_BROADCAST 0x61688UL
+#define UVH_BAU_DATA_BROADCAST_32 0x440
 
 #define UVH_BAU_DATA_BROADCAST_ENABLE_SHFT		0
 #define UVH_BAU_DATA_BROADCAST_ENABLE_MASK		0x0000000000000001UL
@@ -82,8 +108,8 @@ union uvh_bau_data_broadcast_u {
 /* ========================================================================= */
 /*                           UVH_BAU_DATA_CONFIG                             */
 /* ========================================================================= */
-#define UVH_BAU_DATA_CONFIG				0x61680UL
-#define UVH_BAU_DATA_CONFIG_32				0x438
+#define UVH_BAU_DATA_CONFIG 0x61680UL
+#define UVH_BAU_DATA_CONFIG_32 0x438
 
 #define UVH_BAU_DATA_CONFIG_VECTOR_SHFT			0
 #define UVH_BAU_DATA_CONFIG_DM_SHFT			8
@@ -121,10 +147,14 @@ union uvh_bau_data_config_u {
 /* ========================================================================= */
 /*                           UVH_EVENT_OCCURRED0                             */
 /* ========================================================================= */
-#define UVH_EVENT_OCCURRED0				0x70000UL
-#define UVH_EVENT_OCCURRED0_32				0x5e8
+#define UVH_EVENT_OCCURRED0 0x70000UL
+#define UVH_EVENT_OCCURRED0_32 0x5e8
+
+#define UVH_EVENT_OCCURRED0_LB_HCERR_SHFT		0
+#define UVH_EVENT_OCCURRED0_RH_AOERR0_SHFT		11
+#define UVH_EVENT_OCCURRED0_LB_HCERR_MASK		0x0000000000000001UL
+#define UVH_EVENT_OCCURRED0_RH_AOERR0_MASK		0x0000000000000800UL
 
-#define UV1H_EVENT_OCCURRED0_LB_HCERR_SHFT		0
 #define UV1H_EVENT_OCCURRED0_GR0_HCERR_SHFT		1
 #define UV1H_EVENT_OCCURRED0_GR1_HCERR_SHFT		2
 #define UV1H_EVENT_OCCURRED0_LH_HCERR_SHFT		3
@@ -135,7 +165,6 @@ union uvh_bau_data_config_u {
 #define UV1H_EVENT_OCCURRED0_GR0_AOERR0_SHFT		8
 #define UV1H_EVENT_OCCURRED0_GR1_AOERR0_SHFT		9
 #define UV1H_EVENT_OCCURRED0_LH_AOERR0_SHFT		10
-#define UV1H_EVENT_OCCURRED0_RH_AOERR0_SHFT		11
 #define UV1H_EVENT_OCCURRED0_XN_AOERR0_SHFT		12
 #define UV1H_EVENT_OCCURRED0_SI_AOERR0_SHFT		13
 #define UV1H_EVENT_OCCURRED0_LB_AOERR1_SHFT		14
@@ -181,7 +210,6 @@ union uvh_bau_data_config_u {
 #define UV1H_EVENT_OCCURRED0_RTC3_SHFT			54
 #define UV1H_EVENT_OCCURRED0_BAU_DATA_SHFT		55
 #define UV1H_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_SHFT	56
-#define UV1H_EVENT_OCCURRED0_LB_HCERR_MASK		0x0000000000000001UL
 #define UV1H_EVENT_OCCURRED0_GR0_HCERR_MASK		0x0000000000000002UL
 #define UV1H_EVENT_OCCURRED0_GR1_HCERR_MASK		0x0000000000000004UL
 #define UV1H_EVENT_OCCURRED0_LH_HCERR_MASK		0x0000000000000008UL
@@ -192,7 +220,6 @@ union uvh_bau_data_config_u {
 #define UV1H_EVENT_OCCURRED0_GR0_AOERR0_MASK		0x0000000000000100UL
 #define UV1H_EVENT_OCCURRED0_GR1_AOERR0_MASK		0x0000000000000200UL
 #define UV1H_EVENT_OCCURRED0_LH_AOERR0_MASK		0x0000000000000400UL
-#define UV1H_EVENT_OCCURRED0_RH_AOERR0_MASK		0x0000000000000800UL
 #define UV1H_EVENT_OCCURRED0_XN_AOERR0_MASK		0x0000000000001000UL
 #define UV1H_EVENT_OCCURRED0_SI_AOERR0_MASK		0x0000000000002000UL
 #define UV1H_EVENT_OCCURRED0_LB_AOERR1_MASK		0x0000000000004000UL
@@ -239,188 +266,130 @@ union uvh_bau_data_config_u {
 #define UV1H_EVENT_OCCURRED0_BAU_DATA_MASK		0x0080000000000000UL
 #define UV1H_EVENT_OCCURRED0_POWER_MANAGEMENT_REQ_MASK	0x0100000000000000UL
 
-#define UV2H_EVENT_OCCURRED0_LB_HCERR_SHFT		0
-#define UV2H_EVENT_OCCURRED0_QP_HCERR_SHFT		1
-#define UV2H_EVENT_OCCURRED0_RH_HCERR_SHFT		2
-#define UV2H_EVENT_OCCURRED0_LH0_HCERR_SHFT		3
-#define UV2H_EVENT_OCCURRED0_LH1_HCERR_SHFT		4
-#define UV2H_EVENT_OCCURRED0_GR0_HCERR_SHFT		5
-#define UV2H_EVENT_OCCURRED0_GR1_HCERR_SHFT		6
-#define UV2H_EVENT_OCCURRED0_NI0_HCERR_SHFT		7
-#define UV2H_EVENT_OCCURRED0_NI1_HCERR_SHFT		8
-#define UV2H_EVENT_OCCURRED0_LB_AOERR0_SHFT		9
-#define UV2H_EVENT_OCCURRED0_QP_AOERR0_SHFT		10
-#define UV2H_EVENT_OCCURRED0_RH_AOERR0_SHFT		11
-#define UV2H_EVENT_OCCURRED0_LH0_AOERR0_SHFT		12
-#define UV2H_EVENT_OCCURRED0_LH1_AOERR0_SHFT		13
-#define UV2H_EVENT_OCCURRED0_GR0_AOERR0_SHFT		14
-#define UV2H_EVENT_OCCURRED0_GR1_AOERR0_SHFT		15
-#define UV2H_EVENT_OCCURRED0_XB_AOERR0_SHFT		16
-#define UV2H_EVENT_OCCURRED0_RT_AOERR0_SHFT		17
-#define UV2H_EVENT_OCCURRED0_NI0_AOERR0_SHFT		18
-#define UV2H_EVENT_OCCURRED0_NI1_AOERR0_SHFT		19
-#define UV2H_EVENT_OCCURRED0_LB_AOERR1_SHFT		20
-#define UV2H_EVENT_OCCURRED0_QP_AOERR1_SHFT		21
-#define UV2H_EVENT_OCCURRED0_RH_AOERR1_SHFT		22
-#define UV2H_EVENT_OCCURRED0_LH0_AOERR1_SHFT		23
-#define UV2H_EVENT_OCCURRED0_LH1_AOERR1_SHFT		24
-#define UV2H_EVENT_OCCURRED0_GR0_AOERR1_SHFT		25
-#define UV2H_EVENT_OCCURRED0_GR1_AOERR1_SHFT		26
-#define UV2H_EVENT_OCCURRED0_XB_AOERR1_SHFT		27
-#define UV2H_EVENT_OCCURRED0_RT_AOERR1_SHFT		28
-#define UV2H_EVENT_OCCURRED0_NI0_AOERR1_SHFT		29
-#define UV2H_EVENT_OCCURRED0_NI1_AOERR1_SHFT		30
-#define UV2H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT	31
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT		32
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT		33
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT		34
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT		35
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT		36
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT		37
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT		38
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT		39
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT		40
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT		41
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT		42
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT		43
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT		44
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT		45
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT		46
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT		47
-#define UV2H_EVENT_OCCURRED0_L1_NMI_INT_SHFT		48
-#define UV2H_EVENT_OCCURRED0_STOP_CLOCK_SHFT		49
-#define UV2H_EVENT_OCCURRED0_ASIC_TO_L1_SHFT		50
-#define UV2H_EVENT_OCCURRED0_L1_TO_ASIC_SHFT		51
-#define UV2H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT	52
-#define UV2H_EVENT_OCCURRED0_IPI_INT_SHFT		53
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT0_SHFT		54
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT1_SHFT		55
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT2_SHFT		56
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT3_SHFT		57
-#define UV2H_EVENT_OCCURRED0_PROFILE_INT_SHFT		58
-#define UV2H_EVENT_OCCURRED0_LB_HCERR_MASK		0x0000000000000001UL
-#define UV2H_EVENT_OCCURRED0_QP_HCERR_MASK		0x0000000000000002UL
-#define UV2H_EVENT_OCCURRED0_RH_HCERR_MASK		0x0000000000000004UL
-#define UV2H_EVENT_OCCURRED0_LH0_HCERR_MASK		0x0000000000000008UL
-#define UV2H_EVENT_OCCURRED0_LH1_HCERR_MASK		0x0000000000000010UL
-#define UV2H_EVENT_OCCURRED0_GR0_HCERR_MASK		0x0000000000000020UL
-#define UV2H_EVENT_OCCURRED0_GR1_HCERR_MASK		0x0000000000000040UL
-#define UV2H_EVENT_OCCURRED0_NI0_HCERR_MASK		0x0000000000000080UL
-#define UV2H_EVENT_OCCURRED0_NI1_HCERR_MASK		0x0000000000000100UL
-#define UV2H_EVENT_OCCURRED0_LB_AOERR0_MASK		0x0000000000000200UL
-#define UV2H_EVENT_OCCURRED0_QP_AOERR0_MASK		0x0000000000000400UL
-#define UV2H_EVENT_OCCURRED0_RH_AOERR0_MASK		0x0000000000000800UL
-#define UV2H_EVENT_OCCURRED0_LH0_AOERR0_MASK		0x0000000000001000UL
-#define UV2H_EVENT_OCCURRED0_LH1_AOERR0_MASK		0x0000000000002000UL
-#define UV2H_EVENT_OCCURRED0_GR0_AOERR0_MASK		0x0000000000004000UL
-#define UV2H_EVENT_OCCURRED0_GR1_AOERR0_MASK		0x0000000000008000UL
-#define UV2H_EVENT_OCCURRED0_XB_AOERR0_MASK		0x0000000000010000UL
-#define UV2H_EVENT_OCCURRED0_RT_AOERR0_MASK		0x0000000000020000UL
-#define UV2H_EVENT_OCCURRED0_NI0_AOERR0_MASK		0x0000000000040000UL
-#define UV2H_EVENT_OCCURRED0_NI1_AOERR0_MASK		0x0000000000080000UL
-#define UV2H_EVENT_OCCURRED0_LB_AOERR1_MASK		0x0000000000100000UL
-#define UV2H_EVENT_OCCURRED0_QP_AOERR1_MASK		0x0000000000200000UL
-#define UV2H_EVENT_OCCURRED0_RH_AOERR1_MASK		0x0000000000400000UL
-#define UV2H_EVENT_OCCURRED0_LH0_AOERR1_MASK		0x0000000000800000UL
-#define UV2H_EVENT_OCCURRED0_LH1_AOERR1_MASK		0x0000000001000000UL
-#define UV2H_EVENT_OCCURRED0_GR0_AOERR1_MASK		0x0000000002000000UL
-#define UV2H_EVENT_OCCURRED0_GR1_AOERR1_MASK		0x0000000004000000UL
-#define UV2H_EVENT_OCCURRED0_XB_AOERR1_MASK		0x0000000008000000UL
-#define UV2H_EVENT_OCCURRED0_RT_AOERR1_MASK		0x0000000010000000UL
-#define UV2H_EVENT_OCCURRED0_NI0_AOERR1_MASK		0x0000000020000000UL
-#define UV2H_EVENT_OCCURRED0_NI1_AOERR1_MASK		0x0000000040000000UL
-#define UV2H_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK	0x0000000080000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK		0x0000000100000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK		0x0000000200000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK		0x0000000400000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK		0x0000000800000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK		0x0000001000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK		0x0000002000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK		0x0000004000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK		0x0000008000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK		0x0000010000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK		0x0000020000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK		0x0000040000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK		0x0000080000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK		0x0000100000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK		0x0000200000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK		0x0000400000000000UL
-#define UV2H_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK		0x0000800000000000UL
-#define UV2H_EVENT_OCCURRED0_L1_NMI_INT_MASK		0x0001000000000000UL
-#define UV2H_EVENT_OCCURRED0_STOP_CLOCK_MASK		0x0002000000000000UL
-#define UV2H_EVENT_OCCURRED0_ASIC_TO_L1_MASK		0x0004000000000000UL
-#define UV2H_EVENT_OCCURRED0_L1_TO_ASIC_MASK		0x0008000000000000UL
-#define UV2H_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK	0x0010000000000000UL
-#define UV2H_EVENT_OCCURRED0_IPI_INT_MASK		0x0020000000000000UL
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT0_MASK		0x0040000000000000UL
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT1_MASK		0x0080000000000000UL
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT2_MASK		0x0100000000000000UL
-#define UV2H_EVENT_OCCURRED0_EXTIO_INT3_MASK		0x0200000000000000UL
-#define UV2H_EVENT_OCCURRED0_PROFILE_INT_MASK		0x0400000000000000UL
+#define UVXH_EVENT_OCCURRED0_QP_HCERR_SHFT		1
+#define UVXH_EVENT_OCCURRED0_RH_HCERR_SHFT		2
+#define UVXH_EVENT_OCCURRED0_LH0_HCERR_SHFT		3
+#define UVXH_EVENT_OCCURRED0_LH1_HCERR_SHFT		4
+#define UVXH_EVENT_OCCURRED0_GR0_HCERR_SHFT		5
+#define UVXH_EVENT_OCCURRED0_GR1_HCERR_SHFT		6
+#define UVXH_EVENT_OCCURRED0_NI0_HCERR_SHFT		7
+#define UVXH_EVENT_OCCURRED0_NI1_HCERR_SHFT		8
+#define UVXH_EVENT_OCCURRED0_LB_AOERR0_SHFT		9
+#define UVXH_EVENT_OCCURRED0_QP_AOERR0_SHFT		10
+#define UVXH_EVENT_OCCURRED0_LH0_AOERR0_SHFT		12
+#define UVXH_EVENT_OCCURRED0_LH1_AOERR0_SHFT		13
+#define UVXH_EVENT_OCCURRED0_GR0_AOERR0_SHFT		14
+#define UVXH_EVENT_OCCURRED0_GR1_AOERR0_SHFT		15
+#define UVXH_EVENT_OCCURRED0_XB_AOERR0_SHFT		16
+#define UVXH_EVENT_OCCURRED0_RT_AOERR0_SHFT		17
+#define UVXH_EVENT_OCCURRED0_NI0_AOERR0_SHFT		18
+#define UVXH_EVENT_OCCURRED0_NI1_AOERR0_SHFT		19
+#define UVXH_EVENT_OCCURRED0_LB_AOERR1_SHFT		20
+#define UVXH_EVENT_OCCURRED0_QP_AOERR1_SHFT		21
+#define UVXH_EVENT_OCCURRED0_RH_AOERR1_SHFT		22
+#define UVXH_EVENT_OCCURRED0_LH0_AOERR1_SHFT		23
+#define UVXH_EVENT_OCCURRED0_LH1_AOERR1_SHFT		24
+#define UVXH_EVENT_OCCURRED0_GR0_AOERR1_SHFT		25
+#define UVXH_EVENT_OCCURRED0_GR1_AOERR1_SHFT		26
+#define UVXH_EVENT_OCCURRED0_XB_AOERR1_SHFT		27
+#define UVXH_EVENT_OCCURRED0_RT_AOERR1_SHFT		28
+#define UVXH_EVENT_OCCURRED0_NI0_AOERR1_SHFT		29
+#define UVXH_EVENT_OCCURRED0_NI1_AOERR1_SHFT		30
+#define UVXH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_SHFT	31
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_0_SHFT		32
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_1_SHFT		33
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_2_SHFT		34
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_3_SHFT		35
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_4_SHFT		36
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_5_SHFT		37
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_6_SHFT		38
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_7_SHFT		39
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_8_SHFT		40
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_9_SHFT		41
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_10_SHFT		42
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_11_SHFT		43
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_12_SHFT		44
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_13_SHFT		45
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_14_SHFT		46
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_15_SHFT		47
+#define UVXH_EVENT_OCCURRED0_L1_NMI_INT_SHFT		48
+#define UVXH_EVENT_OCCURRED0_STOP_CLOCK_SHFT		49
+#define UVXH_EVENT_OCCURRED0_ASIC_TO_L1_SHFT		50
+#define UVXH_EVENT_OCCURRED0_L1_TO_ASIC_SHFT		51
+#define UVXH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_SHFT	52
+#define UVXH_EVENT_OCCURRED0_IPI_INT_SHFT		53
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT0_SHFT		54
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT1_SHFT		55
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT2_SHFT		56
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT3_SHFT		57
+#define UVXH_EVENT_OCCURRED0_PROFILE_INT_SHFT		58
+#define UVXH_EVENT_OCCURRED0_QP_HCERR_MASK		0x0000000000000002UL
+#define UVXH_EVENT_OCCURRED0_RH_HCERR_MASK		0x0000000000000004UL
+#define UVXH_EVENT_OCCURRED0_LH0_HCERR_MASK		0x0000000000000008UL
+#define UVXH_EVENT_OCCURRED0_LH1_HCERR_MASK		0x0000000000000010UL
+#define UVXH_EVENT_OCCURRED0_GR0_HCERR_MASK		0x0000000000000020UL
+#define UVXH_EVENT_OCCURRED0_GR1_HCERR_MASK		0x0000000000000040UL
+#define UVXH_EVENT_OCCURRED0_NI0_HCERR_MASK		0x0000000000000080UL
+#define UVXH_EVENT_OCCURRED0_NI1_HCERR_MASK		0x0000000000000100UL
+#define UVXH_EVENT_OCCURRED0_LB_AOERR0_MASK		0x0000000000000200UL
+#define UVXH_EVENT_OCCURRED0_QP_AOERR0_MASK		0x0000000000000400UL
+#define UVXH_EVENT_OCCURRED0_LH0_AOERR0_MASK		0x0000000000001000UL
+#define UVXH_EVENT_OCCURRED0_LH1_AOERR0_MASK		0x0000000000002000UL
+#define UVXH_EVENT_OCCURRED0_GR0_AOERR0_MASK		0x0000000000004000UL
+#define UVXH_EVENT_OCCURRED0_GR1_AOERR0_MASK		0x0000000000008000UL
+#define UVXH_EVENT_OCCURRED0_XB_AOERR0_MASK		0x0000000000010000UL
+#define UVXH_EVENT_OCCURRED0_RT_AOERR0_MASK		0x0000000000020000UL
+#define UVXH_EVENT_OCCURRED0_NI0_AOERR0_MASK		0x0000000000040000UL
+#define UVXH_EVENT_OCCURRED0_NI1_AOERR0_MASK		0x0000000000080000UL
+#define UVXH_EVENT_OCCURRED0_LB_AOERR1_MASK		0x0000000000100000UL
+#define UVXH_EVENT_OCCURRED0_QP_AOERR1_MASK		0x0000000000200000UL
+#define UVXH_EVENT_OCCURRED0_RH_AOERR1_MASK		0x0000000000400000UL
+#define UVXH_EVENT_OCCURRED0_LH0_AOERR1_MASK		0x0000000000800000UL
+#define UVXH_EVENT_OCCURRED0_LH1_AOERR1_MASK		0x0000000001000000UL
+#define UVXH_EVENT_OCCURRED0_GR0_AOERR1_MASK		0x0000000002000000UL
+#define UVXH_EVENT_OCCURRED0_GR1_AOERR1_MASK		0x0000000004000000UL
+#define UVXH_EVENT_OCCURRED0_XB_AOERR1_MASK		0x0000000008000000UL
+#define UVXH_EVENT_OCCURRED0_RT_AOERR1_MASK		0x0000000010000000UL
+#define UVXH_EVENT_OCCURRED0_NI0_AOERR1_MASK		0x0000000020000000UL
+#define UVXH_EVENT_OCCURRED0_NI1_AOERR1_MASK		0x0000000040000000UL
+#define UVXH_EVENT_OCCURRED0_SYSTEM_SHUTDOWN_INT_MASK	0x0000000080000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_0_MASK		0x0000000100000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_1_MASK		0x0000000200000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_2_MASK		0x0000000400000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_3_MASK		0x0000000800000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_4_MASK		0x0000001000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_5_MASK		0x0000002000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_6_MASK		0x0000004000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_7_MASK		0x0000008000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_8_MASK		0x0000010000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_9_MASK		0x0000020000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_10_MASK		0x0000040000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_11_MASK		0x0000080000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_12_MASK		0x0000100000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_13_MASK		0x0000200000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_14_MASK		0x0000400000000000UL
+#define UVXH_EVENT_OCCURRED0_LB_IRQ_INT_15_MASK		0x0000800000000000UL
+#define UVXH_EVENT_OCCURRED0_L1_NMI_INT_MASK		0x0001000000000000UL
+#define UVXH_EVENT_OCCURRED0_STOP_CLOCK_MASK		0x0002000000000000UL
+#define UVXH_EVENT_OCCURRED0_ASIC_TO_L1_MASK		0x0004000000000000UL
+#define UVXH_EVENT_OCCURRED0_L1_TO_ASIC_MASK		0x0008000000000000UL
+#define UVXH_EVENT_OCCURRED0_LA_SEQ_TRIGGER_MASK	0x0010000000000000UL
+#define UVXH_EVENT_OCCURRED0_IPI_INT_MASK		0x0020000000000000UL
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT0_MASK		0x0040000000000000UL
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT1_MASK		0x0080000000000000UL
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT2_MASK		0x0100000000000000UL
+#define UVXH_EVENT_OCCURRED0_EXTIO_INT3_MASK		0x0200000000000000UL
+#define UVXH_EVENT_OCCURRED0_PROFILE_INT_MASK		0x0400000000000000UL
 
 union uvh_event_occurred0_u {
 	unsigned long	v;
-	struct uv1h_event_occurred0_s {
+	struct uvh_event_occurred0_s {
 		unsigned long	lb_hcerr:1;			/* RW, W1C */
-		unsigned long	gr0_hcerr:1;			/* RW, W1C */
-		unsigned long	gr1_hcerr:1;			/* RW, W1C */
-		unsigned long	lh_hcerr:1;			/* RW, W1C */
-		unsigned long	rh_hcerr:1;			/* RW, W1C */
-		unsigned long	xn_hcerr:1;			/* RW, W1C */
-		unsigned long	si_hcerr:1;			/* RW, W1C */
-		unsigned long	lb_aoerr0:1;			/* RW, W1C */
-		unsigned long	gr0_aoerr0:1;			/* RW, W1C */
-		unsigned long	gr1_aoerr0:1;			/* RW, W1C */
-		unsigned long	lh_aoerr0:1;			/* RW, W1C */
+		unsigned long	rsvd_1_10:10;
 		unsigned long	rh_aoerr0:1;			/* RW, W1C */
-		unsigned long	xn_aoerr0:1;			/* RW, W1C */
-		unsigned long	si_aoerr0:1;			/* RW, W1C */
-		unsigned long	lb_aoerr1:1;			/* RW, W1C */
-		unsigned long	gr0_aoerr1:1;			/* RW, W1C */
-		unsigned long	gr1_aoerr1:1;			/* RW, W1C */
-		unsigned long	lh_aoerr1:1;			/* RW, W1C */
-		unsigned long	rh_aoerr1:1;			/* RW, W1C */
-		unsigned long	xn_aoerr1:1;			/* RW, W1C */
-		unsigned long	si_aoerr1:1;			/* RW, W1C */
-		unsigned long	rh_vpi_int:1;			/* RW, W1C */
-		unsigned long	system_shutdown_int:1;		/* RW, W1C */
-		unsigned long	lb_irq_int_0:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_1:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_2:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_3:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_4:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_5:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_6:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_7:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_8:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_9:1;			/* RW, W1C */
-		unsigned long	lb_irq_int_10:1;		/* RW, W1C */
-		unsigned long	lb_irq_int_11:1;		/* RW, W1C */
-		unsigned long	lb_irq_int_12:1;		/* RW, W1C */
-		unsigned long	lb_irq_int_13:1;		/* RW, W1C */
-		unsigned long	lb_irq_int_14:1;		/* RW, W1C */
-		unsigned long	lb_irq_int_15:1;		/* RW, W1C */
-		unsigned long	l1_nmi_int:1;			/* RW, W1C */
-		unsigned long	stop_clock:1;			/* RW, W1C */
-		unsigned long	asic_to_l1:1;			/* RW, W1C */
-		unsigned long	l1_to_asic:1;			/* RW, W1C */
-		unsigned long	ltc_int:1;			/* RW, W1C */
-		unsigned long	la_seq_trigger:1;		/* RW, W1C */
-		unsigned long	ipi_int:1;			/* RW, W1C */
-		unsigned long	extio_int0:1;			/* RW, W1C */
-		unsigned long	extio_int1:1;			/* RW, W1C */
-		unsigned long	extio_int2:1;			/* RW, W1C */
-		unsigned long	extio_int3:1;			/* RW, W1C */
-		unsigned long	profile_int:1;			/* RW, W1C */
-		unsigned long	rtc0:1;				/* RW, W1C */
-		unsigned long	rtc1:1;				/* RW, W1C */
-		unsigned long	rtc2:1;				/* RW, W1C */
-		unsigned long	rtc3:1;				/* RW, W1C */
-		unsigned long	bau_data:1;			/* RW, W1C */
-		unsigned long	power_management_req:1;		/* RW, W1C */
-		unsigned long	rsvd_57_63:7;
-	} s1;
-	struct uv2h_event_occurred0_s {
+		unsigned long	rsvd_12_63:52;
+	} s;
+	struct uvxh_event_occurred0_s {
 		unsigned long	lb_hcerr:1;			/* RW */
 		unsigned long	qp_hcerr:1;			/* RW */
 		unsigned long	rh_hcerr:1;			/* RW */
@@ -481,19 +450,20 @@ union uvh_event_occurred0_u {
 		unsigned long	extio_int3:1;			/* RW */
 		unsigned long	profile_int:1;			/* RW */
 		unsigned long	rsvd_59_63:5;
-	} s2;
+	} sx;
 };
 
 /* ========================================================================= */
 /*                        UVH_EVENT_OCCURRED0_ALIAS                          */
 /* ========================================================================= */
-#define UVH_EVENT_OCCURRED0_ALIAS			0x0000000000070008UL
-#define UVH_EVENT_OCCURRED0_ALIAS_32			0x5f0
+#define UVH_EVENT_OCCURRED0_ALIAS 0x70008UL
+#define UVH_EVENT_OCCURRED0_ALIAS_32 0x5f0
+
 
 /* ========================================================================= */
 /*                         UVH_GR0_TLB_INT0_CONFIG                           */
 /* ========================================================================= */
-#define UVH_GR0_TLB_INT0_CONFIG				0x61b00UL
+#define UVH_GR0_TLB_INT0_CONFIG 0x61b00UL
 
 #define UVH_GR0_TLB_INT0_CONFIG_VECTOR_SHFT		0
 #define UVH_GR0_TLB_INT0_CONFIG_DM_SHFT			8
@@ -531,7 +501,7 @@ union uvh_gr0_tlb_int0_config_u {
 /* ========================================================================= */
 /*                         UVH_GR0_TLB_INT1_CONFIG                           */
 /* ========================================================================= */
-#define UVH_GR0_TLB_INT1_CONFIG				0x61b40UL
+#define UVH_GR0_TLB_INT1_CONFIG 0x61b40UL
 
 #define UVH_GR0_TLB_INT1_CONFIG_VECTOR_SHFT		0
 #define UVH_GR0_TLB_INT1_CONFIG_DM_SHFT			8
@@ -571,9 +541,11 @@ union uvh_gr0_tlb_int1_config_u {
 /* ========================================================================= */
 #define UV1H_GR0_TLB_MMR_CONTROL 0x401080UL
 #define UV2H_GR0_TLB_MMR_CONTROL 0xc01080UL
-#define UVH_GR0_TLB_MMR_CONTROL (is_uv1_hub() ?				\
-			UV1H_GR0_TLB_MMR_CONTROL :			\
-			UV2H_GR0_TLB_MMR_CONTROL)
+#define UV3H_GR0_TLB_MMR_CONTROL 0xc01080UL
+#define UVH_GR0_TLB_MMR_CONTROL						\
+		(is_uv1_hub() ? UV1H_GR0_TLB_MMR_CONTROL :		\
+		(is_uv2_hub() ? UV2H_GR0_TLB_MMR_CONTROL :		\
+				UV3H_GR0_TLB_MMR_CONTROL))
 
 #define UVH_GR0_TLB_MMR_CONTROL_INDEX_SHFT		0
 #define UVH_GR0_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
@@ -611,6 +583,21 @@ union uvh_gr0_tlb_int1_config_u {
 #define UV1H_GR0_TLB_MMR_CONTROL_MMR_INJ_TLBRREG_MASK	0x0100000000000000UL
 #define UV1H_GR0_TLB_MMR_CONTROL_MMR_INJ_TLBLRUV_MASK	0x1000000000000000UL
 
+#define UVXH_GR0_TLB_MMR_CONTROL_INDEX_SHFT		0
+#define UVXH_GR0_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
+#define UVXH_GR0_TLB_MMR_CONTROL_AUTO_VALID_EN_SHFT	16
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_SHFT	20
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_WRITE_SHFT		30
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_READ_SHFT		31
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_OP_DONE_SHFT	32
+#define UVXH_GR0_TLB_MMR_CONTROL_INDEX_MASK		0x0000000000000fffUL
+#define UVXH_GR0_TLB_MMR_CONTROL_MEM_SEL_MASK		0x0000000000003000UL
+#define UVXH_GR0_TLB_MMR_CONTROL_AUTO_VALID_EN_MASK	0x0000000000010000UL
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_MASK	0x0000000000100000UL
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_WRITE_MASK		0x0000000040000000UL
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_READ_MASK		0x0000000080000000UL
+#define UVXH_GR0_TLB_MMR_CONTROL_MMR_OP_DONE_MASK	0x0000000100000000UL
+
 #define UV2H_GR0_TLB_MMR_CONTROL_INDEX_SHFT		0
 #define UV2H_GR0_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
 #define UV2H_GR0_TLB_MMR_CONTROL_AUTO_VALID_EN_SHFT	16
@@ -630,6 +617,23 @@ union uvh_gr0_tlb_int1_config_u {
 #define UV2H_GR0_TLB_MMR_CONTROL_MMR_INJ_CON_MASK	0x0001000000000000UL
 #define UV2H_GR0_TLB_MMR_CONTROL_MMR_INJ_TLBRAM_MASK	0x0010000000000000UL
 
+#define UV3H_GR0_TLB_MMR_CONTROL_INDEX_SHFT		0
+#define UV3H_GR0_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
+#define UV3H_GR0_TLB_MMR_CONTROL_AUTO_VALID_EN_SHFT	16
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_SHFT	20
+#define UV3H_GR0_TLB_MMR_CONTROL_ECC_SEL_SHFT		21
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_WRITE_SHFT		30
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_READ_SHFT		31
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_OP_DONE_SHFT	32
+#define UV3H_GR0_TLB_MMR_CONTROL_INDEX_MASK		0x0000000000000fffUL
+#define UV3H_GR0_TLB_MMR_CONTROL_MEM_SEL_MASK		0x0000000000003000UL
+#define UV3H_GR0_TLB_MMR_CONTROL_AUTO_VALID_EN_MASK	0x0000000000010000UL
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_MASK	0x0000000000100000UL
+#define UV3H_GR0_TLB_MMR_CONTROL_ECC_SEL_MASK		0x0000000000200000UL
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_WRITE_MASK		0x0000000040000000UL
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_READ_MASK		0x0000000080000000UL
+#define UV3H_GR0_TLB_MMR_CONTROL_MMR_OP_DONE_MASK	0x0000000100000000UL
+
 union uvh_gr0_tlb_mmr_control_u {
 	unsigned long	v;
 	struct uvh_gr0_tlb_mmr_control_s {
@@ -642,7 +646,9 @@ union uvh_gr0_tlb_mmr_control_u {
 		unsigned long	rsvd_21_29:9;
 		unsigned long	mmr_write:1;			/* WP */
 		unsigned long	mmr_read:1;			/* WP */
-		unsigned long	rsvd_32_63:32;
+		unsigned long	rsvd_32_48:17;
+		unsigned long	rsvd_49_51:3;
+		unsigned long	rsvd_52_63:12;
 	} s;
 	struct uv1h_gr0_tlb_mmr_control_s {
 		unsigned long	index:12;			/* RW */
@@ -666,6 +672,23 @@ union uvh_gr0_tlb_mmr_control_u {
 		unsigned long	mmr_inj_tlblruv:1;		/* RW */
 		unsigned long	rsvd_61_63:3;
 	} s1;
+	struct uvxh_gr0_tlb_mmr_control_s {
+		unsigned long	index:12;			/* RW */
+		unsigned long	mem_sel:2;			/* RW */
+		unsigned long	rsvd_14_15:2;
+		unsigned long	auto_valid_en:1;		/* RW */
+		unsigned long	rsvd_17_19:3;
+		unsigned long	mmr_hash_index_en:1;		/* RW */
+		unsigned long	rsvd_21_29:9;
+		unsigned long	mmr_write:1;			/* WP */
+		unsigned long	mmr_read:1;			/* WP */
+		unsigned long	mmr_op_done:1;			/* RW */
+		unsigned long	rsvd_33_47:15;
+		unsigned long	rsvd_48:1;
+		unsigned long	rsvd_49_51:3;
+		unsigned long	rsvd_52:1;
+		unsigned long	rsvd_53_63:11;
+	} sx;
 	struct uv2h_gr0_tlb_mmr_control_s {
 		unsigned long	index:12;			/* RW */
 		unsigned long	mem_sel:2;			/* RW */
@@ -683,6 +706,24 @@ union uvh_gr0_tlb_mmr_control_u {
 		unsigned long	mmr_inj_tlbram:1;		/* RW */
 		unsigned long	rsvd_53_63:11;
 	} s2;
+	struct uv3h_gr0_tlb_mmr_control_s {
+		unsigned long	index:12;			/* RW */
+		unsigned long	mem_sel:2;			/* RW */
+		unsigned long	rsvd_14_15:2;
+		unsigned long	auto_valid_en:1;		/* RW */
+		unsigned long	rsvd_17_19:3;
+		unsigned long	mmr_hash_index_en:1;		/* RW */
+		unsigned long	ecc_sel:1;			/* RW */
+		unsigned long	rsvd_22_29:8;
+		unsigned long	mmr_write:1;			/* WP */
+		unsigned long	mmr_read:1;			/* WP */
+		unsigned long	mmr_op_done:1;			/* RW */
+		unsigned long	rsvd_33_47:15;
+		unsigned long	undef_48:1;			/* Undefined */
+		unsigned long	rsvd_49_51:3;
+		unsigned long	undef_52:1;			/* Undefined */
+		unsigned long	rsvd_53_63:11;
+	} s3;
 };
 
 /* ========================================================================= */
@@ -690,9 +731,11 @@ union uvh_gr0_tlb_mmr_control_u {
 /* ========================================================================= */
 #define UV1H_GR0_TLB_MMR_READ_DATA_HI 0x4010a0UL
 #define UV2H_GR0_TLB_MMR_READ_DATA_HI 0xc010a0UL
-#define UVH_GR0_TLB_MMR_READ_DATA_HI (is_uv1_hub() ?			\
-			UV1H_GR0_TLB_MMR_READ_DATA_HI :			\
-			UV2H_GR0_TLB_MMR_READ_DATA_HI)
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI 0xc010a0UL
+#define UVH_GR0_TLB_MMR_READ_DATA_HI					\
+		(is_uv1_hub() ? UV1H_GR0_TLB_MMR_READ_DATA_HI :		\
+		(is_uv2_hub() ? UV2H_GR0_TLB_MMR_READ_DATA_HI :		\
+				UV3H_GR0_TLB_MMR_READ_DATA_HI))
 
 #define UVH_GR0_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
 #define UVH_GR0_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
@@ -703,6 +746,46 @@ union uvh_gr0_tlb_mmr_control_u {
 #define UVH_GR0_TLB_MMR_READ_DATA_HI_DIRTY_MASK		0x0000080000000000UL
 #define UVH_GR0_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
 
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UV1H_GR0_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UVXH_GR0_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UV2H_GR0_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_AA_EXT_SHFT	45
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_WAY_ECC_SHFT	55
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_AA_EXT_MASK	0x0000200000000000UL
+#define UV3H_GR0_TLB_MMR_READ_DATA_HI_WAY_ECC_MASK	0xff80000000000000UL
+
 union uvh_gr0_tlb_mmr_read_data_hi_u {
 	unsigned long	v;
 	struct uvh_gr0_tlb_mmr_read_data_hi_s {
@@ -712,6 +795,36 @@ union uvh_gr0_tlb_mmr_read_data_hi_u {
 		unsigned long	larger:1;			/* RO */
 		unsigned long	rsvd_45_63:19;
 	} s;
+	struct uv1h_gr0_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	rsvd_45_63:19;
+	} s1;
+	struct uvxh_gr0_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	rsvd_45_63:19;
+	} sx;
+	struct uv2h_gr0_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	rsvd_45_63:19;
+	} s2;
+	struct uv3h_gr0_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	aa_ext:1;			/* RO */
+		unsigned long	undef_46_54:9;			/* Undefined */
+		unsigned long	way_ecc:9;			/* RO */
+	} s3;
 };
 
 /* ========================================================================= */
@@ -719,9 +832,11 @@ union uvh_gr0_tlb_mmr_read_data_hi_u {
 /* ========================================================================= */
 #define UV1H_GR0_TLB_MMR_READ_DATA_LO 0x4010a8UL
 #define UV2H_GR0_TLB_MMR_READ_DATA_LO 0xc010a8UL
-#define UVH_GR0_TLB_MMR_READ_DATA_LO (is_uv1_hub() ?			\
-			UV1H_GR0_TLB_MMR_READ_DATA_LO :			\
-			UV2H_GR0_TLB_MMR_READ_DATA_LO)
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO 0xc010a8UL
+#define UVH_GR0_TLB_MMR_READ_DATA_LO					\
+		(is_uv1_hub() ? UV1H_GR0_TLB_MMR_READ_DATA_LO :		\
+		(is_uv2_hub() ? UV2H_GR0_TLB_MMR_READ_DATA_LO :		\
+				UV3H_GR0_TLB_MMR_READ_DATA_LO))
 
 #define UVH_GR0_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
 #define UVH_GR0_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
@@ -730,6 +845,34 @@ union uvh_gr0_tlb_mmr_read_data_hi_u {
 #define UVH_GR0_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
 #define UVH_GR0_TLB_MMR_READ_DATA_LO_VALID_MASK		0x8000000000000000UL
 
+#define UV1H_GR0_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UV1H_GR0_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UV1H_GR0_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UV1H_GR0_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UV1H_GR0_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UV1H_GR0_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
+#define UVXH_GR0_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UVXH_GR0_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UVXH_GR0_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UVXH_GR0_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UVXH_GR0_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UVXH_GR0_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
+#define UV2H_GR0_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UV2H_GR0_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UV2H_GR0_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UV2H_GR0_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UV2H_GR0_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UV2H_GR0_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UV3H_GR0_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
 union uvh_gr0_tlb_mmr_read_data_lo_u {
 	unsigned long	v;
 	struct uvh_gr0_tlb_mmr_read_data_lo_s {
@@ -737,12 +880,32 @@ union uvh_gr0_tlb_mmr_read_data_lo_u {
 		unsigned long	asid:24;			/* RO */
 		unsigned long	valid:1;			/* RO */
 	} s;
+	struct uv1h_gr0_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} s1;
+	struct uvxh_gr0_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} sx;
+	struct uv2h_gr0_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} s2;
+	struct uv3h_gr0_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} s3;
 };
 
 /* ========================================================================= */
 /*                         UVH_GR1_TLB_INT0_CONFIG                           */
 /* ========================================================================= */
-#define UVH_GR1_TLB_INT0_CONFIG				0x61f00UL
+#define UVH_GR1_TLB_INT0_CONFIG 0x61f00UL
 
 #define UVH_GR1_TLB_INT0_CONFIG_VECTOR_SHFT		0
 #define UVH_GR1_TLB_INT0_CONFIG_DM_SHFT			8
@@ -780,7 +943,7 @@ union uvh_gr1_tlb_int0_config_u {
 /* ========================================================================= */
 /*                         UVH_GR1_TLB_INT1_CONFIG                           */
 /* ========================================================================= */
-#define UVH_GR1_TLB_INT1_CONFIG				0x61f40UL
+#define UVH_GR1_TLB_INT1_CONFIG 0x61f40UL
 
 #define UVH_GR1_TLB_INT1_CONFIG_VECTOR_SHFT		0
 #define UVH_GR1_TLB_INT1_CONFIG_DM_SHFT			8
@@ -820,9 +983,11 @@ union uvh_gr1_tlb_int1_config_u {
 /* ========================================================================= */
 #define UV1H_GR1_TLB_MMR_CONTROL 0x801080UL
 #define UV2H_GR1_TLB_MMR_CONTROL 0x1001080UL
-#define UVH_GR1_TLB_MMR_CONTROL (is_uv1_hub() ?				\
-			UV1H_GR1_TLB_MMR_CONTROL :			\
-			UV2H_GR1_TLB_MMR_CONTROL)
+#define UV3H_GR1_TLB_MMR_CONTROL 0x1001080UL
+#define UVH_GR1_TLB_MMR_CONTROL						\
+		(is_uv1_hub() ? UV1H_GR1_TLB_MMR_CONTROL :		\
+		(is_uv2_hub() ? UV2H_GR1_TLB_MMR_CONTROL :		\
+				UV3H_GR1_TLB_MMR_CONTROL))
 
 #define UVH_GR1_TLB_MMR_CONTROL_INDEX_SHFT		0
 #define UVH_GR1_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
@@ -860,6 +1025,21 @@ union uvh_gr1_tlb_int1_config_u {
 #define UV1H_GR1_TLB_MMR_CONTROL_MMR_INJ_TLBRREG_MASK	0x0100000000000000UL
 #define UV1H_GR1_TLB_MMR_CONTROL_MMR_INJ_TLBLRUV_MASK	0x1000000000000000UL
 
+#define UVXH_GR1_TLB_MMR_CONTROL_INDEX_SHFT		0
+#define UVXH_GR1_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
+#define UVXH_GR1_TLB_MMR_CONTROL_AUTO_VALID_EN_SHFT	16
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_SHFT	20
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_WRITE_SHFT		30
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_READ_SHFT		31
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_OP_DONE_SHFT	32
+#define UVXH_GR1_TLB_MMR_CONTROL_INDEX_MASK		0x0000000000000fffUL
+#define UVXH_GR1_TLB_MMR_CONTROL_MEM_SEL_MASK		0x0000000000003000UL
+#define UVXH_GR1_TLB_MMR_CONTROL_AUTO_VALID_EN_MASK	0x0000000000010000UL
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_MASK	0x0000000000100000UL
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_WRITE_MASK		0x0000000040000000UL
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_READ_MASK		0x0000000080000000UL
+#define UVXH_GR1_TLB_MMR_CONTROL_MMR_OP_DONE_MASK	0x0000000100000000UL
+
 #define UV2H_GR1_TLB_MMR_CONTROL_INDEX_SHFT		0
 #define UV2H_GR1_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
 #define UV2H_GR1_TLB_MMR_CONTROL_AUTO_VALID_EN_SHFT	16
@@ -879,6 +1059,23 @@ union uvh_gr1_tlb_int1_config_u {
 #define UV2H_GR1_TLB_MMR_CONTROL_MMR_INJ_CON_MASK	0x0001000000000000UL
 #define UV2H_GR1_TLB_MMR_CONTROL_MMR_INJ_TLBRAM_MASK	0x0010000000000000UL
 
+#define UV3H_GR1_TLB_MMR_CONTROL_INDEX_SHFT		0
+#define UV3H_GR1_TLB_MMR_CONTROL_MEM_SEL_SHFT		12
+#define UV3H_GR1_TLB_MMR_CONTROL_AUTO_VALID_EN_SHFT	16
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_SHFT	20
+#define UV3H_GR1_TLB_MMR_CONTROL_ECC_SEL_SHFT		21
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_WRITE_SHFT		30
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_READ_SHFT		31
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_OP_DONE_SHFT	32
+#define UV3H_GR1_TLB_MMR_CONTROL_INDEX_MASK		0x0000000000000fffUL
+#define UV3H_GR1_TLB_MMR_CONTROL_MEM_SEL_MASK		0x0000000000003000UL
+#define UV3H_GR1_TLB_MMR_CONTROL_AUTO_VALID_EN_MASK	0x0000000000010000UL
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_HASH_INDEX_EN_MASK	0x0000000000100000UL
+#define UV3H_GR1_TLB_MMR_CONTROL_ECC_SEL_MASK		0x0000000000200000UL
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_WRITE_MASK		0x0000000040000000UL
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_READ_MASK		0x0000000080000000UL
+#define UV3H_GR1_TLB_MMR_CONTROL_MMR_OP_DONE_MASK	0x0000000100000000UL
+
 union uvh_gr1_tlb_mmr_control_u {
 	unsigned long	v;
 	struct uvh_gr1_tlb_mmr_control_s {
@@ -891,7 +1088,9 @@ union uvh_gr1_tlb_mmr_control_u {
 		unsigned long	rsvd_21_29:9;
 		unsigned long	mmr_write:1;			/* WP */
 		unsigned long	mmr_read:1;			/* WP */
-		unsigned long	rsvd_32_63:32;
+		unsigned long	rsvd_32_48:17;
+		unsigned long	rsvd_49_51:3;
+		unsigned long	rsvd_52_63:12;
 	} s;
 	struct uv1h_gr1_tlb_mmr_control_s {
 		unsigned long	index:12;			/* RW */
@@ -915,6 +1114,23 @@ union uvh_gr1_tlb_mmr_control_u {
 		unsigned long	mmr_inj_tlblruv:1;		/* RW */
 		unsigned long	rsvd_61_63:3;
 	} s1;
+	struct uvxh_gr1_tlb_mmr_control_s {
+		unsigned long	index:12;			/* RW */
+		unsigned long	mem_sel:2;			/* RW */
+		unsigned long	rsvd_14_15:2;
+		unsigned long	auto_valid_en:1;		/* RW */
+		unsigned long	rsvd_17_19:3;
+		unsigned long	mmr_hash_index_en:1;		/* RW */
+		unsigned long	rsvd_21_29:9;
+		unsigned long	mmr_write:1;			/* WP */
+		unsigned long	mmr_read:1;			/* WP */
+		unsigned long	mmr_op_done:1;			/* RW */
+		unsigned long	rsvd_33_47:15;
+		unsigned long	rsvd_48:1;
+		unsigned long	rsvd_49_51:3;
+		unsigned long	rsvd_52:1;
+		unsigned long	rsvd_53_63:11;
+	} sx;
 	struct uv2h_gr1_tlb_mmr_control_s {
 		unsigned long	index:12;			/* RW */
 		unsigned long	mem_sel:2;			/* RW */
@@ -932,6 +1148,24 @@ union uvh_gr1_tlb_mmr_control_u {
 		unsigned long	mmr_inj_tlbram:1;		/* RW */
 		unsigned long	rsvd_53_63:11;
 	} s2;
+	struct uv3h_gr1_tlb_mmr_control_s {
+		unsigned long	index:12;			/* RW */
+		unsigned long	mem_sel:2;			/* RW */
+		unsigned long	rsvd_14_15:2;
+		unsigned long	auto_valid_en:1;		/* RW */
+		unsigned long	rsvd_17_19:3;
+		unsigned long	mmr_hash_index_en:1;		/* RW */
+		unsigned long	ecc_sel:1;			/* RW */
+		unsigned long	rsvd_22_29:8;
+		unsigned long	mmr_write:1;			/* WP */
+		unsigned long	mmr_read:1;			/* WP */
+		unsigned long	mmr_op_done:1;			/* RW */
+		unsigned long	rsvd_33_47:15;
+		unsigned long	undef_48:1;			/* Undefined */
+		unsigned long	rsvd_49_51:3;
+		unsigned long	undef_52:1;			/* Undefined */
+		unsigned long	rsvd_53_63:11;
+	} s3;
 };
 
 /* ========================================================================= */
@@ -939,9 +1173,11 @@ union uvh_gr1_tlb_mmr_control_u {
 /* ========================================================================= */
 #define UV1H_GR1_TLB_MMR_READ_DATA_HI 0x8010a0UL
 #define UV2H_GR1_TLB_MMR_READ_DATA_HI 0x10010a0UL
-#define UVH_GR1_TLB_MMR_READ_DATA_HI (is_uv1_hub() ?			\
-			UV1H_GR1_TLB_MMR_READ_DATA_HI :			\
-			UV2H_GR1_TLB_MMR_READ_DATA_HI)
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI 0x10010a0UL
+#define UVH_GR1_TLB_MMR_READ_DATA_HI					\
+		(is_uv1_hub() ? UV1H_GR1_TLB_MMR_READ_DATA_HI :		\
+		(is_uv2_hub() ? UV2H_GR1_TLB_MMR_READ_DATA_HI :		\
+				UV3H_GR1_TLB_MMR_READ_DATA_HI))
 
 #define UVH_GR1_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
 #define UVH_GR1_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
@@ -952,6 +1188,46 @@ union uvh_gr1_tlb_mmr_control_u {
 #define UVH_GR1_TLB_MMR_READ_DATA_HI_DIRTY_MASK		0x0000080000000000UL
 #define UVH_GR1_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
 
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UV1H_GR1_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UVXH_GR1_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UV2H_GR1_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_PFN_SHFT		0
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_GAA_SHFT		41
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_DIRTY_SHFT	43
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_LARGER_SHFT	44
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_AA_EXT_SHFT	45
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_WAY_ECC_SHFT	55
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_PFN_MASK		0x000001ffffffffffUL
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_GAA_MASK		0x0000060000000000UL
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_DIRTY_MASK	0x0000080000000000UL
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_LARGER_MASK	0x0000100000000000UL
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_AA_EXT_MASK	0x0000200000000000UL
+#define UV3H_GR1_TLB_MMR_READ_DATA_HI_WAY_ECC_MASK	0xff80000000000000UL
+
 union uvh_gr1_tlb_mmr_read_data_hi_u {
 	unsigned long	v;
 	struct uvh_gr1_tlb_mmr_read_data_hi_s {
@@ -961,6 +1237,36 @@ union uvh_gr1_tlb_mmr_read_data_hi_u {
 		unsigned long	larger:1;			/* RO */
 		unsigned long	rsvd_45_63:19;
 	} s;
+	struct uv1h_gr1_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	rsvd_45_63:19;
+	} s1;
+	struct uvxh_gr1_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	rsvd_45_63:19;
+	} sx;
+	struct uv2h_gr1_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	rsvd_45_63:19;
+	} s2;
+	struct uv3h_gr1_tlb_mmr_read_data_hi_s {
+		unsigned long	pfn:41;				/* RO */
+		unsigned long	gaa:2;				/* RO */
+		unsigned long	dirty:1;			/* RO */
+		unsigned long	larger:1;			/* RO */
+		unsigned long	aa_ext:1;			/* RO */
+		unsigned long	undef_46_54:9;			/* Undefined */
+		unsigned long	way_ecc:9;			/* RO */
+	} s3;
 };
 
 /* ========================================================================= */
@@ -968,9 +1274,11 @@ union uvh_gr1_tlb_mmr_read_data_hi_u {
 /* ========================================================================= */
 #define UV1H_GR1_TLB_MMR_READ_DATA_LO 0x8010a8UL
 #define UV2H_GR1_TLB_MMR_READ_DATA_LO 0x10010a8UL
-#define UVH_GR1_TLB_MMR_READ_DATA_LO (is_uv1_hub() ?			\
-			UV1H_GR1_TLB_MMR_READ_DATA_LO :			\
-			UV2H_GR1_TLB_MMR_READ_DATA_LO)
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO 0x10010a8UL
+#define UVH_GR1_TLB_MMR_READ_DATA_LO					\
+		(is_uv1_hub() ? UV1H_GR1_TLB_MMR_READ_DATA_LO :		\
+		(is_uv2_hub() ? UV2H_GR1_TLB_MMR_READ_DATA_LO :		\
+				UV3H_GR1_TLB_MMR_READ_DATA_LO))
 
 #define UVH_GR1_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
 #define UVH_GR1_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
@@ -979,6 +1287,34 @@ union uvh_gr1_tlb_mmr_read_data_hi_u {
 #define UVH_GR1_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
 #define UVH_GR1_TLB_MMR_READ_DATA_LO_VALID_MASK		0x8000000000000000UL
 
+#define UV1H_GR1_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UV1H_GR1_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UV1H_GR1_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UV1H_GR1_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UV1H_GR1_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UV1H_GR1_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
+#define UVXH_GR1_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UVXH_GR1_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UVXH_GR1_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UVXH_GR1_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UVXH_GR1_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UVXH_GR1_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
+#define UV2H_GR1_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UV2H_GR1_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UV2H_GR1_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UV2H_GR1_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UV2H_GR1_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UV2H_GR1_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO_VPN_SHFT		0
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO_ASID_SHFT		39
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO_VALID_SHFT	63
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO_VPN_MASK		0x0000007fffffffffUL
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO_ASID_MASK		0x7fffff8000000000UL
+#define UV3H_GR1_TLB_MMR_READ_DATA_LO_VALID_MASK	0x8000000000000000UL
+
 union uvh_gr1_tlb_mmr_read_data_lo_u {
 	unsigned long	v;
 	struct uvh_gr1_tlb_mmr_read_data_lo_s {
@@ -986,12 +1322,32 @@ union uvh_gr1_tlb_mmr_read_data_lo_u {
 		unsigned long	asid:24;			/* RO */
 		unsigned long	valid:1;			/* RO */
 	} s;
+	struct uv1h_gr1_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} s1;
+	struct uvxh_gr1_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} sx;
+	struct uv2h_gr1_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} s2;
+	struct uv3h_gr1_tlb_mmr_read_data_lo_s {
+		unsigned long	vpn:39;				/* RO */
+		unsigned long	asid:24;			/* RO */
+		unsigned long	valid:1;			/* RO */
+	} s3;
 };
 
 /* ========================================================================= */
 /*                               UVH_INT_CMPB                                */
 /* ========================================================================= */
-#define UVH_INT_CMPB					0x22080UL
+#define UVH_INT_CMPB 0x22080UL
 
 #define UVH_INT_CMPB_REAL_TIME_CMPB_SHFT		0
 #define UVH_INT_CMPB_REAL_TIME_CMPB_MASK		0x00ffffffffffffffUL
@@ -1007,10 +1363,13 @@ union uvh_int_cmpb_u {
 /* ========================================================================= */
 /*                               UVH_INT_CMPC                                */
 /* ========================================================================= */
-#define UVH_INT_CMPC					0x22100UL
+#define UVH_INT_CMPC 0x22100UL
+
+#define UV1H_INT_CMPC_REAL_TIME_CMPC_SHFT		0
+#define UV1H_INT_CMPC_REAL_TIME_CMPC_MASK		0x00ffffffffffffffUL
 
-#define UVH_INT_CMPC_REAL_TIME_CMPC_SHFT		0
-#define UVH_INT_CMPC_REAL_TIME_CMPC_MASK		0xffffffffffffffUL
+#define UVXH_INT_CMPC_REAL_TIME_CMP_2_SHFT		0
+#define UVXH_INT_CMPC_REAL_TIME_CMP_2_MASK		0x00ffffffffffffffUL
 
 union uvh_int_cmpc_u {
 	unsigned long	v;
@@ -1023,10 +1382,13 @@ union uvh_int_cmpc_u {
 /* ========================================================================= */
 /*                               UVH_INT_CMPD                                */
 /* ========================================================================= */
-#define UVH_INT_CMPD					0x22180UL
+#define UVH_INT_CMPD 0x22180UL
 
-#define UVH_INT_CMPD_REAL_TIME_CMPD_SHFT		0
-#define UVH_INT_CMPD_REAL_TIME_CMPD_MASK		0xffffffffffffffUL
+#define UV1H_INT_CMPD_REAL_TIME_CMPD_SHFT		0
+#define UV1H_INT_CMPD_REAL_TIME_CMPD_MASK		0x00ffffffffffffffUL
+
+#define UVXH_INT_CMPD_REAL_TIME_CMP_3_SHFT		0
+#define UVXH_INT_CMPD_REAL_TIME_CMP_3_MASK		0x00ffffffffffffffUL
 
 union uvh_int_cmpd_u {
 	unsigned long	v;
@@ -1039,8 +1401,8 @@ union uvh_int_cmpd_u {
 /* ========================================================================= */
 /*                               UVH_IPI_INT                                 */
 /* ========================================================================= */
-#define UVH_IPI_INT					0x60500UL
-#define UVH_IPI_INT_32					0x348
+#define UVH_IPI_INT 0x60500UL
+#define UVH_IPI_INT_32 0x348
 
 #define UVH_IPI_INT_VECTOR_SHFT				0
 #define UVH_IPI_INT_DELIVERY_MODE_SHFT			8
@@ -1069,8 +1431,8 @@ union uvh_ipi_int_u {
 /* ========================================================================= */
 /*                   UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST                     */
 /* ========================================================================= */
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST		0x320050UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32		0x9c0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST 0x320050UL
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_32 0x9c0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_ADDRESS_SHFT 4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_FIRST_NODE_ID_SHFT 49
@@ -1091,8 +1453,8 @@ union uvh_lb_bau_intd_payload_queue_first_u {
 /* ========================================================================= */
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST                     */
 /* ========================================================================= */
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST		0x320060UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32		0x9c8
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST 0x320060UL
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_32 0x9c8
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_SHFT	4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_LAST_ADDRESS_MASK	0x000007fffffffff0UL
@@ -1109,8 +1471,8 @@ union uvh_lb_bau_intd_payload_queue_last_u {
 /* ========================================================================= */
 /*                    UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL                     */
 /* ========================================================================= */
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL		0x320070UL
-#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32		0x9d0
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL 0x320070UL
+#define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_32 0x9d0
 
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_SHFT	4
 #define UVH_LB_BAU_INTD_PAYLOAD_QUEUE_TAIL_ADDRESS_MASK	0x000007fffffffff0UL
@@ -1127,8 +1489,8 @@ union uvh_lb_bau_intd_payload_queue_tail_u {
 /* ========================================================================= */
 /*                   UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE                    */
 /* ========================================================================= */
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE		0x320080UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32		0xa68
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE 0x320080UL
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_32 0xa68
 
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_0_SHFT 0
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_PENDING_1_SHFT 1
@@ -1189,14 +1551,21 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 /* ========================================================================= */
 /*                UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS                 */
 /* ========================================================================= */
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS	0x0000000000320088UL
-#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32	0xa70
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS 0x320088UL
+#define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0xa70
+
 
 /* ========================================================================= */
 /*                         UVH_LB_BAU_MISC_CONTROL                           */
 /* ========================================================================= */
-#define UVH_LB_BAU_MISC_CONTROL				0x320170UL
-#define UVH_LB_BAU_MISC_CONTROL_32			0xa10
+#define UVH_LB_BAU_MISC_CONTROL 0x320170UL
+#define UV1H_LB_BAU_MISC_CONTROL 0x320170UL
+#define UV2H_LB_BAU_MISC_CONTROL 0x320170UL
+#define UV3H_LB_BAU_MISC_CONTROL 0x320170UL
+#define UVH_LB_BAU_MISC_CONTROL_32 0xa10
+#define UV1H_LB_BAU_MISC_CONTROL_32 0x320170UL
+#define UV2H_LB_BAU_MISC_CONTROL_32 0x320170UL
+#define UV3H_LB_BAU_MISC_CONTROL_32 0x320170UL
 
 #define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT	0
 #define UVH_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT		8
@@ -1213,6 +1582,7 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UVH_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
 #define UVH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UVH_LB_BAU_MISC_CONTROL_FUN_SHFT		48
 #define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK	0x00000000000000ffUL
 #define UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK		0x0000000000000100UL
 #define UVH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK	0x0000000000000200UL
@@ -1228,6 +1598,7 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UVH_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
 #define UVH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
 #define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UVH_LB_BAU_MISC_CONTROL_FUN_MASK		0xffff000000000000UL
 
 #define UV1H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT	0
 #define UV1H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT		8
@@ -1262,6 +1633,53 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UV1H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
 #define UV1H_LB_BAU_MISC_CONTROL_FUN_MASK		0xffff000000000000UL
 
+#define UVXH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT	0
+#define UVXH_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT		8
+#define UVXH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT	9
+#define UVXH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT	10
+#define UVXH_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UVXH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UVXH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UVXH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UVXH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UVXH_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UVXH_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UVXH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_SHFT 29
+#define UVXH_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_SHFT	30
+#define UVXH_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_SHFT 31
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_SHFT 32
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT 33
+#define UVXH_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_SHFT 34
+#define UVXH_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT 35
+#define UVXH_LB_BAU_MISC_CONTROL_FUN_SHFT		48
+#define UVXH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK	0x00000000000000ffUL
+#define UVXH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK		0x0000000000000100UL
+#define UVXH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK	0x0000000000000200UL
+#define UVXH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK	0x0000000000000400UL
+#define UVXH_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UVXH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UVXH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UVXH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UVXH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UVXH_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UVXH_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_MASK 0x0000000020000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_MASK	0x0000000040000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_MASK 0x0000000080000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_MASK 0x0000000100000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_MASK 0x0000000200000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_MASK 0x0000000400000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_MASK 0x0000000800000000UL
+#define UVXH_LB_BAU_MISC_CONTROL_FUN_MASK		0xffff000000000000UL
+
 #define UV2H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT	0
 #define UV2H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT		8
 #define UV2H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT	9
@@ -1309,6 +1727,59 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_MASK 0x0000000800000000UL
 #define UV2H_LB_BAU_MISC_CONTROL_FUN_MASK		0xffff000000000000UL
 
+#define UV3H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT	0
+#define UV3H_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT		8
+#define UV3H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT	9
+#define UV3H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT	10
+#define UV3H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UV3H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UV3H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UV3H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UV3H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UV3H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UV3H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_SHFT 29
+#define UV3H_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_SHFT	30
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_SHFT 31
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_SHFT 32
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT 33
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_SHFT 34
+#define UV3H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT 35
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_QUIESCE_MSGS_TO_QPI_SHFT 36
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_INTD_PREFETCH_HINT_SHFT 37
+#define UV3H_LB_BAU_MISC_CONTROL_THREAD_KILL_TIMEBASE_SHFT 38
+#define UV3H_LB_BAU_MISC_CONTROL_FUN_SHFT		48
+#define UV3H_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK	0x00000000000000ffUL
+#define UV3H_LB_BAU_MISC_CONTROL_APIC_MODE_MASK		0x0000000000000100UL
+#define UV3H_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK	0x0000000000000200UL
+#define UV3H_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK	0x0000000000000400UL
+#define UV3H_LB_BAU_MISC_CONTROL_QPI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UV3H_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UV3H_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UV3H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UV3H_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UV3H_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_AUTOMATIC_APIC_MODE_SELECTION_MASK 0x0000000020000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_APIC_MODE_STATUS_MASK	0x0000000040000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_INTERRUPTS_TO_SELF_MASK 0x0000000080000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_LOCK_BASED_SYSTEM_FLUSH_MASK 0x0000000100000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_MASK 0x0000000200000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_INT_PRIO_UDT_TO_SELF_MASK 0x0000000400000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_MASK 0x0000000800000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_SUPPRESS_QUIESCE_MSGS_TO_QPI_MASK 0x0000001000000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_ENABLE_INTD_PREFETCH_HINT_MASK 0x0000002000000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_THREAD_KILL_TIMEBASE_MASK 0x00003fc000000000UL
+#define UV3H_LB_BAU_MISC_CONTROL_FUN_MASK		0xffff000000000000UL
+
 union uvh_lb_bau_misc_control_u {
 	unsigned long	v;
 	struct uvh_lb_bau_misc_control_s {
@@ -1327,7 +1798,8 @@ union uvh_lb_bau_misc_control_u {
 		unsigned long	programmed_initial_priority:3;	/* RW */
 		unsigned long	use_incoming_priority:1;	/* RW */
 		unsigned long	enable_programmed_initial_priority:1;/* RW */
-		unsigned long	rsvd_29_63:35;
+		unsigned long	rsvd_29_47:19;
+		unsigned long	fun:16;				/* RW */
 	} s;
 	struct uv1h_lb_bau_misc_control_s {
 		unsigned long	rejection_delay:8;		/* RW */
@@ -1348,6 +1820,32 @@ union uvh_lb_bau_misc_control_u {
 		unsigned long	rsvd_29_47:19;
 		unsigned long	fun:16;				/* RW */
 	} s1;
+	struct uvxh_lb_bau_misc_control_s {
+		unsigned long	rejection_delay:8;		/* RW */
+		unsigned long	apic_mode:1;			/* RW */
+		unsigned long	force_broadcast:1;		/* RW */
+		unsigned long	force_lock_nop:1;		/* RW */
+		unsigned long	qpi_agent_presence_vector:3;	/* RW */
+		unsigned long	descriptor_fetch_mode:1;	/* RW */
+		unsigned long	enable_intd_soft_ack_mode:1;	/* RW */
+		unsigned long	intd_soft_ack_timeout_period:4;	/* RW */
+		unsigned long	enable_dual_mapping_mode:1;	/* RW */
+		unsigned long	vga_io_port_decode_enable:1;	/* RW */
+		unsigned long	vga_io_port_16_bit_decode:1;	/* RW */
+		unsigned long	suppress_dest_registration:1;	/* RW */
+		unsigned long	programmed_initial_priority:3;	/* RW */
+		unsigned long	use_incoming_priority:1;	/* RW */
+		unsigned long	enable_programmed_initial_priority:1;/* RW */
+		unsigned long	enable_automatic_apic_mode_selection:1;/* RW */
+		unsigned long	apic_mode_status:1;		/* RO */
+		unsigned long	suppress_interrupts_to_self:1;	/* RW */
+		unsigned long	enable_lock_based_system_flush:1;/* RW */
+		unsigned long	enable_extended_sb_status:1;	/* RW */
+		unsigned long	suppress_int_prio_udt_to_self:1;/* RW */
+		unsigned long	use_legacy_descriptor_formats:1;/* RW */
+		unsigned long	rsvd_36_47:12;
+		unsigned long	fun:16;				/* RW */
+	} sx;
 	struct uv2h_lb_bau_misc_control_s {
 		unsigned long	rejection_delay:8;		/* RW */
 		unsigned long	apic_mode:1;			/* RW */
@@ -1374,13 +1872,42 @@ union uvh_lb_bau_misc_control_u {
 		unsigned long	rsvd_36_47:12;
 		unsigned long	fun:16;				/* RW */
 	} s2;
+	struct uv3h_lb_bau_misc_control_s {
+		unsigned long	rejection_delay:8;		/* RW */
+		unsigned long	apic_mode:1;			/* RW */
+		unsigned long	force_broadcast:1;		/* RW */
+		unsigned long	force_lock_nop:1;		/* RW */
+		unsigned long	qpi_agent_presence_vector:3;	/* RW */
+		unsigned long	descriptor_fetch_mode:1;	/* RW */
+		unsigned long	enable_intd_soft_ack_mode:1;	/* RW */
+		unsigned long	intd_soft_ack_timeout_period:4;	/* RW */
+		unsigned long	enable_dual_mapping_mode:1;	/* RW */
+		unsigned long	vga_io_port_decode_enable:1;	/* RW */
+		unsigned long	vga_io_port_16_bit_decode:1;	/* RW */
+		unsigned long	suppress_dest_registration:1;	/* RW */
+		unsigned long	programmed_initial_priority:3;	/* RW */
+		unsigned long	use_incoming_priority:1;	/* RW */
+		unsigned long	enable_programmed_initial_priority:1;/* RW */
+		unsigned long	enable_automatic_apic_mode_selection:1;/* RW */
+		unsigned long	apic_mode_status:1;		/* RO */
+		unsigned long	suppress_interrupts_to_self:1;	/* RW */
+		unsigned long	enable_lock_based_system_flush:1;/* RW */
+		unsigned long	enable_extended_sb_status:1;	/* RW */
+		unsigned long	suppress_int_prio_udt_to_self:1;/* RW */
+		unsigned long	use_legacy_descriptor_formats:1;/* RW */
+		unsigned long	suppress_quiesce_msgs_to_qpi:1;	/* RW */
+		unsigned long	enable_intd_prefetch_hint:1;	/* RW */
+		unsigned long	thread_kill_timebase:8;		/* RW */
+		unsigned long	rsvd_46_47:2;
+		unsigned long	fun:16;				/* RW */
+	} s3;
 };
 
 /* ========================================================================= */
 /*                     UVH_LB_BAU_SB_ACTIVATION_CONTROL                      */
 /* ========================================================================= */
-#define UVH_LB_BAU_SB_ACTIVATION_CONTROL		0x320020UL
-#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32		0x9a8
+#define UVH_LB_BAU_SB_ACTIVATION_CONTROL 0x320020UL
+#define UVH_LB_BAU_SB_ACTIVATION_CONTROL_32 0x9a8
 
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_INDEX_SHFT	0
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT	62
@@ -1402,8 +1929,8 @@ union uvh_lb_bau_sb_activation_control_u {
 /* ========================================================================= */
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_0                      */
 /* ========================================================================= */
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0		0x320030UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32		0x9b0
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0 0x320030UL
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_32 0x9b0
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_SHFT	0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_0_STATUS_MASK	0xffffffffffffffffUL
@@ -1418,8 +1945,8 @@ union uvh_lb_bau_sb_activation_status_0_u {
 /* ========================================================================= */
 /*                    UVH_LB_BAU_SB_ACTIVATION_STATUS_1                      */
 /* ========================================================================= */
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1		0x320040UL
-#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32		0x9b8
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1 0x320040UL
+#define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_32 0x9b8
 
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_SHFT	0
 #define UVH_LB_BAU_SB_ACTIVATION_STATUS_1_STATUS_MASK	0xffffffffffffffffUL
@@ -1434,8 +1961,8 @@ union uvh_lb_bau_sb_activation_status_1_u {
 /* ========================================================================= */
 /*                      UVH_LB_BAU_SB_DESCRIPTOR_BASE                        */
 /* ========================================================================= */
-#define UVH_LB_BAU_SB_DESCRIPTOR_BASE			0x320010UL
-#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32		0x9a0
+#define UVH_LB_BAU_SB_DESCRIPTOR_BASE 0x320010UL
+#define UVH_LB_BAU_SB_DESCRIPTOR_BASE_32 0x9a0
 
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_PAGE_ADDRESS_SHFT	12
 #define UVH_LB_BAU_SB_DESCRIPTOR_BASE_NODE_ID_SHFT	49
@@ -1456,7 +1983,10 @@ union uvh_lb_bau_sb_descriptor_base_u {
 /* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
-#define UVH_NODE_ID					0x0UL
+#define UVH_NODE_ID 0x0UL
+#define UV1H_NODE_ID 0x0UL
+#define UV2H_NODE_ID 0x0UL
+#define UV3H_NODE_ID 0x0UL
 
 #define UVH_NODE_ID_FORCE1_SHFT				0
 #define UVH_NODE_ID_MANUFACTURER_SHFT			1
@@ -1484,6 +2014,21 @@ union uvh_lb_bau_sb_descriptor_base_u {
 #define UV1H_NODE_ID_NODES_PER_BIT_MASK			0x007f000000000000UL
 #define UV1H_NODE_ID_NI_PORT_MASK			0x0f00000000000000UL
 
+#define UVXH_NODE_ID_FORCE1_SHFT			0
+#define UVXH_NODE_ID_MANUFACTURER_SHFT			1
+#define UVXH_NODE_ID_PART_NUMBER_SHFT			12
+#define UVXH_NODE_ID_REVISION_SHFT			28
+#define UVXH_NODE_ID_NODE_ID_SHFT			32
+#define UVXH_NODE_ID_NODES_PER_BIT_SHFT			50
+#define UVXH_NODE_ID_NI_PORT_SHFT			57
+#define UVXH_NODE_ID_FORCE1_MASK			0x0000000000000001UL
+#define UVXH_NODE_ID_MANUFACTURER_MASK			0x0000000000000ffeUL
+#define UVXH_NODE_ID_PART_NUMBER_MASK			0x000000000ffff000UL
+#define UVXH_NODE_ID_REVISION_MASK			0x00000000f0000000UL
+#define UVXH_NODE_ID_NODE_ID_MASK			0x00007fff00000000UL
+#define UVXH_NODE_ID_NODES_PER_BIT_MASK			0x01fc000000000000UL
+#define UVXH_NODE_ID_NI_PORT_MASK			0x3e00000000000000UL
+
 #define UV2H_NODE_ID_FORCE1_SHFT			0
 #define UV2H_NODE_ID_MANUFACTURER_SHFT			1
 #define UV2H_NODE_ID_PART_NUMBER_SHFT			12
@@ -1499,6 +2044,25 @@ union uvh_lb_bau_sb_descriptor_base_u {
 #define UV2H_NODE_ID_NODES_PER_BIT_MASK			0x01fc000000000000UL
 #define UV2H_NODE_ID_NI_PORT_MASK			0x3e00000000000000UL
 
+#define UV3H_NODE_ID_FORCE1_SHFT			0
+#define UV3H_NODE_ID_MANUFACTURER_SHFT			1
+#define UV3H_NODE_ID_PART_NUMBER_SHFT			12
+#define UV3H_NODE_ID_REVISION_SHFT			28
+#define UV3H_NODE_ID_NODE_ID_SHFT			32
+#define UV3H_NODE_ID_ROUTER_SELECT_SHFT			48
+#define UV3H_NODE_ID_RESERVED_2_SHFT			49
+#define UV3H_NODE_ID_NODES_PER_BIT_SHFT			50
+#define UV3H_NODE_ID_NI_PORT_SHFT			57
+#define UV3H_NODE_ID_FORCE1_MASK			0x0000000000000001UL
+#define UV3H_NODE_ID_MANUFACTURER_MASK			0x0000000000000ffeUL
+#define UV3H_NODE_ID_PART_NUMBER_MASK			0x000000000ffff000UL
+#define UV3H_NODE_ID_REVISION_MASK			0x00000000f0000000UL
+#define UV3H_NODE_ID_NODE_ID_MASK			0x00007fff00000000UL
+#define UV3H_NODE_ID_ROUTER_SELECT_MASK			0x0001000000000000UL
+#define UV3H_NODE_ID_RESERVED_2_MASK			0x0002000000000000UL
+#define UV3H_NODE_ID_NODES_PER_BIT_MASK			0x01fc000000000000UL
+#define UV3H_NODE_ID_NI_PORT_MASK			0x3e00000000000000UL
+
 union uvh_node_id_u {
 	unsigned long	v;
 	struct uvh_node_id_s {
@@ -1521,6 +2085,17 @@ union uvh_node_id_u {
 		unsigned long	ni_port:4;			/* RO */
 		unsigned long	rsvd_60_63:4;
 	} s1;
+	struct uvxh_node_id_s {
+		unsigned long	force1:1;			/* RO */
+		unsigned long	manufacturer:11;		/* RO */
+		unsigned long	part_number:16;			/* RO */
+		unsigned long	revision:4;			/* RO */
+		unsigned long	node_id:15;			/* RW */
+		unsigned long	rsvd_47_49:3;
+		unsigned long	nodes_per_bit:7;		/* RO */
+		unsigned long	ni_port:5;			/* RO */
+		unsigned long	rsvd_62_63:2;
+	} sx;
 	struct uv2h_node_id_s {
 		unsigned long	force1:1;			/* RO */
 		unsigned long	manufacturer:11;		/* RO */
@@ -1532,13 +2107,26 @@ union uvh_node_id_u {
 		unsigned long	ni_port:5;			/* RO */
 		unsigned long	rsvd_62_63:2;
 	} s2;
+	struct uv3h_node_id_s {
+		unsigned long	force1:1;			/* RO */
+		unsigned long	manufacturer:11;		/* RO */
+		unsigned long	part_number:16;			/* RO */
+		unsigned long	revision:4;			/* RO */
+		unsigned long	node_id:15;			/* RW */
+		unsigned long	rsvd_47:1;
+		unsigned long	router_select:1;		/* RO */
+		unsigned long	rsvd_49:1;
+		unsigned long	nodes_per_bit:7;		/* RO */
+		unsigned long	ni_port:5;			/* RO */
+		unsigned long	rsvd_62_63:2;
+	} s3;
 };
 
 /* ========================================================================= */
 /*                          UVH_NODE_PRESENT_TABLE                           */
 /* ========================================================================= */
-#define UVH_NODE_PRESENT_TABLE				0x1400UL
-#define UVH_NODE_PRESENT_TABLE_DEPTH			16
+#define UVH_NODE_PRESENT_TABLE 0x1400UL
+#define UVH_NODE_PRESENT_TABLE_DEPTH 16
 
 #define UVH_NODE_PRESENT_TABLE_NODES_SHFT		0
 #define UVH_NODE_PRESENT_TABLE_NODES_MASK		0xffffffffffffffffUL
@@ -1553,7 +2141,7 @@ union uvh_node_present_table_u {
 /* ========================================================================= */
 /*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR                  */
 /* ========================================================================= */
-#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR	0x16000c8UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR 0x16000c8UL
 
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_BASE_SHFT 24
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_0_MMR_M_ALIAS_SHFT 48
@@ -1577,7 +2165,7 @@ union uvh_rh_gam_alias210_overlay_config_0_mmr_u {
 /* ========================================================================= */
 /*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR                  */
 /* ========================================================================= */
-#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR	0x16000d8UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR 0x16000d8UL
 
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_BASE_SHFT 24
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_1_MMR_M_ALIAS_SHFT 48
@@ -1601,7 +2189,7 @@ union uvh_rh_gam_alias210_overlay_config_1_mmr_u {
 /* ========================================================================= */
 /*                 UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR                  */
 /* ========================================================================= */
-#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR	0x16000e8UL
+#define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR 0x16000e8UL
 
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_BASE_SHFT 24
 #define UVH_RH_GAM_ALIAS210_OVERLAY_CONFIG_2_MMR_M_ALIAS_SHFT 48
@@ -1625,7 +2213,7 @@ union uvh_rh_gam_alias210_overlay_config_2_mmr_u {
 /* ========================================================================= */
 /*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR                  */
 /* ========================================================================= */
-#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR	0x16000d0UL
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR 0x16000d0UL
 
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_SHFT 24
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_0_MMR_DEST_BASE_MASK 0x00003fffff000000UL
@@ -1642,7 +2230,7 @@ union uvh_rh_gam_alias210_redirect_config_0_mmr_u {
 /* ========================================================================= */
 /*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR                  */
 /* ========================================================================= */
-#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR	0x16000e0UL
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR 0x16000e0UL
 
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR_DEST_BASE_SHFT 24
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_1_MMR_DEST_BASE_MASK 0x00003fffff000000UL
@@ -1659,7 +2247,7 @@ union uvh_rh_gam_alias210_redirect_config_1_mmr_u {
 /* ========================================================================= */
 /*                UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR                  */
 /* ========================================================================= */
-#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR	0x16000f0UL
+#define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR 0x16000f0UL
 
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR_DEST_BASE_SHFT 24
 #define UVH_RH_GAM_ALIAS210_REDIRECT_CONFIG_2_MMR_DEST_BASE_MASK 0x00003fffff000000UL
@@ -1676,7 +2264,10 @@ union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
 /* ========================================================================= */
 /*                          UVH_RH_GAM_CONFIG_MMR                            */
 /* ========================================================================= */
-#define UVH_RH_GAM_CONFIG_MMR				0x1600000UL
+#define UVH_RH_GAM_CONFIG_MMR 0x1600000UL
+#define UV1H_RH_GAM_CONFIG_MMR 0x1600000UL
+#define UV2H_RH_GAM_CONFIG_MMR 0x1600000UL
+#define UV3H_RH_GAM_CONFIG_MMR 0x1600000UL
 
 #define UVH_RH_GAM_CONFIG_MMR_M_SKT_SHFT		0
 #define UVH_RH_GAM_CONFIG_MMR_N_SKT_SHFT		6
@@ -1690,11 +2281,21 @@ union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
 #define UV1H_RH_GAM_CONFIG_MMR_N_SKT_MASK		0x00000000000003c0UL
 #define UV1H_RH_GAM_CONFIG_MMR_MMIOL_CFG_MASK		0x0000000000001000UL
 
+#define UVXH_RH_GAM_CONFIG_MMR_M_SKT_SHFT		0
+#define UVXH_RH_GAM_CONFIG_MMR_N_SKT_SHFT		6
+#define UVXH_RH_GAM_CONFIG_MMR_M_SKT_MASK		0x000000000000003fUL
+#define UVXH_RH_GAM_CONFIG_MMR_N_SKT_MASK		0x00000000000003c0UL
+
 #define UV2H_RH_GAM_CONFIG_MMR_M_SKT_SHFT		0
 #define UV2H_RH_GAM_CONFIG_MMR_N_SKT_SHFT		6
 #define UV2H_RH_GAM_CONFIG_MMR_M_SKT_MASK		0x000000000000003fUL
 #define UV2H_RH_GAM_CONFIG_MMR_N_SKT_MASK		0x00000000000003c0UL
 
+#define UV3H_RH_GAM_CONFIG_MMR_M_SKT_SHFT		0
+#define UV3H_RH_GAM_CONFIG_MMR_N_SKT_SHFT		6
+#define UV3H_RH_GAM_CONFIG_MMR_M_SKT_MASK		0x000000000000003fUL
+#define UV3H_RH_GAM_CONFIG_MMR_N_SKT_MASK		0x00000000000003c0UL
+
 union uvh_rh_gam_config_mmr_u {
 	unsigned long	v;
 	struct uvh_rh_gam_config_mmr_s {
@@ -1709,20 +2310,37 @@ union uvh_rh_gam_config_mmr_u {
 		unsigned long	mmiol_cfg:1;			/* RW */
 		unsigned long	rsvd_13_63:51;
 	} s1;
+	struct uvxh_rh_gam_config_mmr_s {
+		unsigned long	m_skt:6;			/* RW */
+		unsigned long	n_skt:4;			/* RW */
+		unsigned long	rsvd_10_63:54;
+	} sx;
 	struct uv2h_rh_gam_config_mmr_s {
 		unsigned long	m_skt:6;			/* RW */
 		unsigned long	n_skt:4;			/* RW */
 		unsigned long	rsvd_10_63:54;
 	} s2;
+	struct uv3h_rh_gam_config_mmr_s {
+		unsigned long	m_skt:6;			/* RW */
+		unsigned long	n_skt:4;			/* RW */
+		unsigned long	rsvd_10_63:54;
+	} s3;
 };
 
 /* ========================================================================= */
 /*                    UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
-#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR		0x1600010UL
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
+#define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
+#define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
 
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT	28
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT	52
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffff0000000UL
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK	0x00f0000000000000UL
+#define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
 
 #define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT	28
 #define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_GR4_SHFT	48
@@ -1733,6 +2351,13 @@ union uvh_rh_gam_config_mmr_u {
 #define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK	0x00f0000000000000UL
 #define UV1H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
 
+#define UVXH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT	28
+#define UVXH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT	52
+#define UVXH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
+#define UVXH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffff0000000UL
+#define UVXH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK	0x00f0000000000000UL
+#define UVXH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
+
 #define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT	28
 #define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT	52
 #define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
@@ -1740,12 +2365,23 @@ union uvh_rh_gam_config_mmr_u {
 #define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK	0x00f0000000000000UL
 #define UV2H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
 
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT	28
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_SHFT	52
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_MODE_SHFT	62
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffff0000000UL
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_N_GRU_MASK	0x00f0000000000000UL
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_MODE_MASK	0x4000000000000000UL
+#define UV3H_RH_GAM_GRU_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
+
 union uvh_rh_gam_gru_overlay_config_mmr_u {
 	unsigned long	v;
 	struct uvh_rh_gam_gru_overlay_config_mmr_s {
 		unsigned long	rsvd_0_27:28;
 		unsigned long	base:18;			/* RW */
-		unsigned long	rsvd_46_62:17;
+		unsigned long	rsvd_46_51:6;
+		unsigned long	n_gru:4;			/* RW */
+		unsigned long	rsvd_56_62:7;
 		unsigned long	enable:1;			/* RW */
 	} s;
 	struct uv1h_rh_gam_gru_overlay_config_mmr_s {
@@ -1758,6 +2394,14 @@ union uvh_rh_gam_gru_overlay_config_mmr_u {
 		unsigned long	rsvd_56_62:7;
 		unsigned long	enable:1;			/* RW */
 	} s1;
+	struct uvxh_rh_gam_gru_overlay_config_mmr_s {
+		unsigned long	rsvd_0_27:28;
+		unsigned long	base:18;			/* RW */
+		unsigned long	rsvd_46_51:6;
+		unsigned long	n_gru:4;			/* RW */
+		unsigned long	rsvd_56_62:7;
+		unsigned long	enable:1;			/* RW */
+	} sx;
 	struct uv2h_rh_gam_gru_overlay_config_mmr_s {
 		unsigned long	rsvd_0_27:28;
 		unsigned long	base:18;			/* RW */
@@ -1766,12 +2410,22 @@ union uvh_rh_gam_gru_overlay_config_mmr_u {
 		unsigned long	rsvd_56_62:7;
 		unsigned long	enable:1;			/* RW */
 	} s2;
+	struct uv3h_rh_gam_gru_overlay_config_mmr_s {
+		unsigned long	rsvd_0_27:28;
+		unsigned long	base:18;			/* RW */
+		unsigned long	rsvd_46_51:6;
+		unsigned long	n_gru:4;			/* RW */
+		unsigned long	rsvd_56_61:6;
+		unsigned long	mode:1;				/* RW */
+		unsigned long	enable:1;			/* RW */
+	} s3;
 };
 
 /* ========================================================================= */
 /*                   UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR                     */
 /* ========================================================================= */
-#define UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR		0x1600030UL
+#define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
+#define UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR 0x1600030UL
 
 #define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT	30
 #define UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_M_IO_SHFT	46
@@ -1814,10 +2468,15 @@ union uvh_rh_gam_mmioh_overlay_config_mmr_u {
 /* ========================================================================= */
 /*                    UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
-#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR		0x1600028UL
+#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
+#define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
+#define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
+#define UV3H_RH_GAM_MMR_OVERLAY_CONFIG_MMR 0x1600028UL
 
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT	26
+#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
 #define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffffc000000UL
+#define UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
 
 #define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT	26
 #define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_SHFT 46
@@ -1826,11 +2485,21 @@ union uvh_rh_gam_mmioh_overlay_config_mmr_u {
 #define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_DUAL_HUB_MASK 0x0000400000000000UL
 #define UV1H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
 
+#define UVXH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT	26
+#define UVXH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
+#define UVXH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffffc000000UL
+#define UVXH_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
+
 #define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT	26
 #define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
 #define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffffc000000UL
 #define UV2H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
 
+#define UV3H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_SHFT	26
+#define UV3H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_SHFT	63
+#define UV3H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_BASE_MASK	0x00003ffffc000000UL
+#define UV3H_RH_GAM_MMR_OVERLAY_CONFIG_MMR_ENABLE_MASK	0x8000000000000000UL
+
 union uvh_rh_gam_mmr_overlay_config_mmr_u {
 	unsigned long	v;
 	struct uvh_rh_gam_mmr_overlay_config_mmr_s {
@@ -1846,18 +2515,30 @@ union uvh_rh_gam_mmr_overlay_config_mmr_u {
 		unsigned long	rsvd_47_62:16;
 		unsigned long	enable:1;			/* RW */
 	} s1;
+	struct uvxh_rh_gam_mmr_overlay_config_mmr_s {
+		unsigned long	rsvd_0_25:26;
+		unsigned long	base:20;			/* RW */
+		unsigned long	rsvd_46_62:17;
+		unsigned long	enable:1;			/* RW */
+	} sx;
 	struct uv2h_rh_gam_mmr_overlay_config_mmr_s {
 		unsigned long	rsvd_0_25:26;
 		unsigned long	base:20;			/* RW */
 		unsigned long	rsvd_46_62:17;
 		unsigned long	enable:1;			/* RW */
 	} s2;
+	struct uv3h_rh_gam_mmr_overlay_config_mmr_s {
+		unsigned long	rsvd_0_25:26;
+		unsigned long	base:20;			/* RW */
+		unsigned long	rsvd_46_62:17;
+		unsigned long	enable:1;			/* RW */
+	} s3;
 };
 
 /* ========================================================================= */
 /*                                 UVH_RTC                                   */
 /* ========================================================================= */
-#define UVH_RTC						0x340000UL
+#define UVH_RTC 0x340000UL
 
 #define UVH_RTC_REAL_TIME_CLOCK_SHFT			0
 #define UVH_RTC_REAL_TIME_CLOCK_MASK			0x00ffffffffffffffUL
@@ -1873,7 +2554,7 @@ union uvh_rtc_u {
 /* ========================================================================= */
 /*                           UVH_RTC1_INT_CONFIG                             */
 /* ========================================================================= */
-#define UVH_RTC1_INT_CONFIG				0x615c0UL
+#define UVH_RTC1_INT_CONFIG 0x615c0UL
 
 #define UVH_RTC1_INT_CONFIG_VECTOR_SHFT			0
 #define UVH_RTC1_INT_CONFIG_DM_SHFT			8
@@ -1911,8 +2592,8 @@ union uvh_rtc1_int_config_u {
 /* ========================================================================= */
 /*                               UVH_SCRATCH5                                */
 /* ========================================================================= */
-#define UVH_SCRATCH5					0x2d0200UL
-#define UVH_SCRATCH5_32					0x778
+#define UVH_SCRATCH5 0x2d0200UL
+#define UVH_SCRATCH5_32 0x778
 
 #define UVH_SCRATCH5_SCRATCH5_SHFT			0
 #define UVH_SCRATCH5_SCRATCH5_MASK			0xffffffffffffffffUL
@@ -1925,79 +2606,79 @@ union uvh_scratch5_u {
 };
 
 /* ========================================================================= */
-/*                           UV2H_EVENT_OCCURRED2                            */
-/* ========================================================================= */
-#define UV2H_EVENT_OCCURRED2				0x70100UL
-#define UV2H_EVENT_OCCURRED2_32				0xb68
-
-#define UV2H_EVENT_OCCURRED2_RTC_0_SHFT			0
-#define UV2H_EVENT_OCCURRED2_RTC_1_SHFT			1
-#define UV2H_EVENT_OCCURRED2_RTC_2_SHFT			2
-#define UV2H_EVENT_OCCURRED2_RTC_3_SHFT			3
-#define UV2H_EVENT_OCCURRED2_RTC_4_SHFT			4
-#define UV2H_EVENT_OCCURRED2_RTC_5_SHFT			5
-#define UV2H_EVENT_OCCURRED2_RTC_6_SHFT			6
-#define UV2H_EVENT_OCCURRED2_RTC_7_SHFT			7
-#define UV2H_EVENT_OCCURRED2_RTC_8_SHFT			8
-#define UV2H_EVENT_OCCURRED2_RTC_9_SHFT			9
-#define UV2H_EVENT_OCCURRED2_RTC_10_SHFT		10
-#define UV2H_EVENT_OCCURRED2_RTC_11_SHFT		11
-#define UV2H_EVENT_OCCURRED2_RTC_12_SHFT		12
-#define UV2H_EVENT_OCCURRED2_RTC_13_SHFT		13
-#define UV2H_EVENT_OCCURRED2_RTC_14_SHFT		14
-#define UV2H_EVENT_OCCURRED2_RTC_15_SHFT		15
-#define UV2H_EVENT_OCCURRED2_RTC_16_SHFT		16
-#define UV2H_EVENT_OCCURRED2_RTC_17_SHFT		17
-#define UV2H_EVENT_OCCURRED2_RTC_18_SHFT		18
-#define UV2H_EVENT_OCCURRED2_RTC_19_SHFT		19
-#define UV2H_EVENT_OCCURRED2_RTC_20_SHFT		20
-#define UV2H_EVENT_OCCURRED2_RTC_21_SHFT		21
-#define UV2H_EVENT_OCCURRED2_RTC_22_SHFT		22
-#define UV2H_EVENT_OCCURRED2_RTC_23_SHFT		23
-#define UV2H_EVENT_OCCURRED2_RTC_24_SHFT		24
-#define UV2H_EVENT_OCCURRED2_RTC_25_SHFT		25
-#define UV2H_EVENT_OCCURRED2_RTC_26_SHFT		26
-#define UV2H_EVENT_OCCURRED2_RTC_27_SHFT		27
-#define UV2H_EVENT_OCCURRED2_RTC_28_SHFT		28
-#define UV2H_EVENT_OCCURRED2_RTC_29_SHFT		29
-#define UV2H_EVENT_OCCURRED2_RTC_30_SHFT		30
-#define UV2H_EVENT_OCCURRED2_RTC_31_SHFT		31
-#define UV2H_EVENT_OCCURRED2_RTC_0_MASK			0x0000000000000001UL
-#define UV2H_EVENT_OCCURRED2_RTC_1_MASK			0x0000000000000002UL
-#define UV2H_EVENT_OCCURRED2_RTC_2_MASK			0x0000000000000004UL
-#define UV2H_EVENT_OCCURRED2_RTC_3_MASK			0x0000000000000008UL
-#define UV2H_EVENT_OCCURRED2_RTC_4_MASK			0x0000000000000010UL
-#define UV2H_EVENT_OCCURRED2_RTC_5_MASK			0x0000000000000020UL
-#define UV2H_EVENT_OCCURRED2_RTC_6_MASK			0x0000000000000040UL
-#define UV2H_EVENT_OCCURRED2_RTC_7_MASK			0x0000000000000080UL
-#define UV2H_EVENT_OCCURRED2_RTC_8_MASK			0x0000000000000100UL
-#define UV2H_EVENT_OCCURRED2_RTC_9_MASK			0x0000000000000200UL
-#define UV2H_EVENT_OCCURRED2_RTC_10_MASK		0x0000000000000400UL
-#define UV2H_EVENT_OCCURRED2_RTC_11_MASK		0x0000000000000800UL
-#define UV2H_EVENT_OCCURRED2_RTC_12_MASK		0x0000000000001000UL
-#define UV2H_EVENT_OCCURRED2_RTC_13_MASK		0x0000000000002000UL
-#define UV2H_EVENT_OCCURRED2_RTC_14_MASK		0x0000000000004000UL
-#define UV2H_EVENT_OCCURRED2_RTC_15_MASK		0x0000000000008000UL
-#define UV2H_EVENT_OCCURRED2_RTC_16_MASK		0x0000000000010000UL
-#define UV2H_EVENT_OCCURRED2_RTC_17_MASK		0x0000000000020000UL
-#define UV2H_EVENT_OCCURRED2_RTC_18_MASK		0x0000000000040000UL
-#define UV2H_EVENT_OCCURRED2_RTC_19_MASK		0x0000000000080000UL
-#define UV2H_EVENT_OCCURRED2_RTC_20_MASK		0x0000000000100000UL
-#define UV2H_EVENT_OCCURRED2_RTC_21_MASK		0x0000000000200000UL
-#define UV2H_EVENT_OCCURRED2_RTC_22_MASK		0x0000000000400000UL
-#define UV2H_EVENT_OCCURRED2_RTC_23_MASK		0x0000000000800000UL
-#define UV2H_EVENT_OCCURRED2_RTC_24_MASK		0x0000000001000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_25_MASK		0x0000000002000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_26_MASK		0x0000000004000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_27_MASK		0x0000000008000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_28_MASK		0x0000000010000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_29_MASK		0x0000000020000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_30_MASK		0x0000000040000000UL
-#define UV2H_EVENT_OCCURRED2_RTC_31_MASK		0x0000000080000000UL
-
-union uv2h_event_occurred2_u {
+/*                          UVXH_EVENT_OCCURRED2                             */
+/* ========================================================================= */
+#define UVXH_EVENT_OCCURRED2 0x70100UL
+#define UVXH_EVENT_OCCURRED2_32 0xb68
+
+#define UVXH_EVENT_OCCURRED2_RTC_0_SHFT			0
+#define UVXH_EVENT_OCCURRED2_RTC_1_SHFT			1
+#define UVXH_EVENT_OCCURRED2_RTC_2_SHFT			2
+#define UVXH_EVENT_OCCURRED2_RTC_3_SHFT			3
+#define UVXH_EVENT_OCCURRED2_RTC_4_SHFT			4
+#define UVXH_EVENT_OCCURRED2_RTC_5_SHFT			5
+#define UVXH_EVENT_OCCURRED2_RTC_6_SHFT			6
+#define UVXH_EVENT_OCCURRED2_RTC_7_SHFT			7
+#define UVXH_EVENT_OCCURRED2_RTC_8_SHFT			8
+#define UVXH_EVENT_OCCURRED2_RTC_9_SHFT			9
+#define UVXH_EVENT_OCCURRED2_RTC_10_SHFT		10
+#define UVXH_EVENT_OCCURRED2_RTC_11_SHFT		11
+#define UVXH_EVENT_OCCURRED2_RTC_12_SHFT		12
+#define UVXH_EVENT_OCCURRED2_RTC_13_SHFT		13
+#define UVXH_EVENT_OCCURRED2_RTC_14_SHFT		14
+#define UVXH_EVENT_OCCURRED2_RTC_15_SHFT		15
+#define UVXH_EVENT_OCCURRED2_RTC_16_SHFT		16
+#define UVXH_EVENT_OCCURRED2_RTC_17_SHFT		17
+#define UVXH_EVENT_OCCURRED2_RTC_18_SHFT		18
+#define UVXH_EVENT_OCCURRED2_RTC_19_SHFT		19
+#define UVXH_EVENT_OCCURRED2_RTC_20_SHFT		20
+#define UVXH_EVENT_OCCURRED2_RTC_21_SHFT		21
+#define UVXH_EVENT_OCCURRED2_RTC_22_SHFT		22
+#define UVXH_EVENT_OCCURRED2_RTC_23_SHFT		23
+#define UVXH_EVENT_OCCURRED2_RTC_24_SHFT		24
+#define UVXH_EVENT_OCCURRED2_RTC_25_SHFT		25
+#define UVXH_EVENT_OCCURRED2_RTC_26_SHFT		26
+#define UVXH_EVENT_OCCURRED2_RTC_27_SHFT		27
+#define UVXH_EVENT_OCCURRED2_RTC_28_SHFT		28
+#define UVXH_EVENT_OCCURRED2_RTC_29_SHFT		29
+#define UVXH_EVENT_OCCURRED2_RTC_30_SHFT		30
+#define UVXH_EVENT_OCCURRED2_RTC_31_SHFT		31
+#define UVXH_EVENT_OCCURRED2_RTC_0_MASK			0x0000000000000001UL
+#define UVXH_EVENT_OCCURRED2_RTC_1_MASK			0x0000000000000002UL
+#define UVXH_EVENT_OCCURRED2_RTC_2_MASK			0x0000000000000004UL
+#define UVXH_EVENT_OCCURRED2_RTC_3_MASK			0x0000000000000008UL
+#define UVXH_EVENT_OCCURRED2_RTC_4_MASK			0x0000000000000010UL
+#define UVXH_EVENT_OCCURRED2_RTC_5_MASK			0x0000000000000020UL
+#define UVXH_EVENT_OCCURRED2_RTC_6_MASK			0x0000000000000040UL
+#define UVXH_EVENT_OCCURRED2_RTC_7_MASK			0x0000000000000080UL
+#define UVXH_EVENT_OCCURRED2_RTC_8_MASK			0x0000000000000100UL
+#define UVXH_EVENT_OCCURRED2_RTC_9_MASK			0x0000000000000200UL
+#define UVXH_EVENT_OCCURRED2_RTC_10_MASK		0x0000000000000400UL
+#define UVXH_EVENT_OCCURRED2_RTC_11_MASK		0x0000000000000800UL
+#define UVXH_EVENT_OCCURRED2_RTC_12_MASK		0x0000000000001000UL
+#define UVXH_EVENT_OCCURRED2_RTC_13_MASK		0x0000000000002000UL
+#define UVXH_EVENT_OCCURRED2_RTC_14_MASK		0x0000000000004000UL
+#define UVXH_EVENT_OCCURRED2_RTC_15_MASK		0x0000000000008000UL
+#define UVXH_EVENT_OCCURRED2_RTC_16_MASK		0x0000000000010000UL
+#define UVXH_EVENT_OCCURRED2_RTC_17_MASK		0x0000000000020000UL
+#define UVXH_EVENT_OCCURRED2_RTC_18_MASK		0x0000000000040000UL
+#define UVXH_EVENT_OCCURRED2_RTC_19_MASK		0x0000000000080000UL
+#define UVXH_EVENT_OCCURRED2_RTC_20_MASK		0x0000000000100000UL
+#define UVXH_EVENT_OCCURRED2_RTC_21_MASK		0x0000000000200000UL
+#define UVXH_EVENT_OCCURRED2_RTC_22_MASK		0x0000000000400000UL
+#define UVXH_EVENT_OCCURRED2_RTC_23_MASK		0x0000000000800000UL
+#define UVXH_EVENT_OCCURRED2_RTC_24_MASK		0x0000000001000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_25_MASK		0x0000000002000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_26_MASK		0x0000000004000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_27_MASK		0x0000000008000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_28_MASK		0x0000000010000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_29_MASK		0x0000000020000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_30_MASK		0x0000000040000000UL
+#define UVXH_EVENT_OCCURRED2_RTC_31_MASK		0x0000000080000000UL
+
+union uvxh_event_occurred2_u {
 	unsigned long	v;
-	struct uv2h_event_occurred2_s {
+	struct uvxh_event_occurred2_s {
 		unsigned long	rtc_0:1;			/* RW */
 		unsigned long	rtc_1:1;			/* RW */
 		unsigned long	rtc_2:1;			/* RW */
@@ -2031,29 +2712,46 @@ union uv2h_event_occurred2_u {
 		unsigned long	rtc_30:1;			/* RW */
 		unsigned long	rtc_31:1;			/* RW */
 		unsigned long	rsvd_32_63:32;
-	} s1;
+	} sx;
 };
 
 /* ========================================================================= */
-/*                        UV2H_EVENT_OCCURRED2_ALIAS                         */
+/*                       UVXH_EVENT_OCCURRED2_ALIAS                          */
 /* ========================================================================= */
-#define UV2H_EVENT_OCCURRED2_ALIAS			0x70108UL
-#define UV2H_EVENT_OCCURRED2_ALIAS_32			0xb70
+#define UVXH_EVENT_OCCURRED2_ALIAS 0x70108UL
+#define UVXH_EVENT_OCCURRED2_ALIAS_32 0xb70
+
 
 /* ========================================================================= */
-/*                    UV2H_LB_BAU_SB_ACTIVATION_STATUS_2                     */
+/*                   UVXH_LB_BAU_SB_ACTIVATION_STATUS_2                      */
 /* ========================================================================= */
-#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2		0x320130UL
-#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_32		0x9f0
+#define UVXH_LB_BAU_SB_ACTIVATION_STATUS_2 0x320130UL
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2 0x320130UL
+#define UV3H_LB_BAU_SB_ACTIVATION_STATUS_2 0x320130UL
+#define UVXH_LB_BAU_SB_ACTIVATION_STATUS_2_32 0x9f0
+#define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_32 0x320130UL
+#define UV3H_LB_BAU_SB_ACTIVATION_STATUS_2_32 0x320130UL
+
+#define UVXH_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_SHFT 0
+#define UVXH_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_MASK 0xffffffffffffffffUL
 
 #define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_SHFT 0
 #define UV2H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_MASK 0xffffffffffffffffUL
 
-union uv2h_lb_bau_sb_activation_status_2_u {
+#define UV3H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_SHFT 0
+#define UV3H_LB_BAU_SB_ACTIVATION_STATUS_2_AUX_ERROR_MASK 0xffffffffffffffffUL
+
+union uvxh_lb_bau_sb_activation_status_2_u {
 	unsigned long	v;
+	struct uvxh_lb_bau_sb_activation_status_2_s {
+		unsigned long	aux_error:64;			/* RW */
+	} sx;
 	struct uv2h_lb_bau_sb_activation_status_2_s {
 		unsigned long	aux_error:64;			/* RW */
-	} s1;
+	} s2;
+	struct uv3h_lb_bau_sb_activation_status_2_s {
+		unsigned long	aux_error:64;			/* RW */
+	} s3;
 };
 
 /* ========================================================================= */
@@ -2073,5 +2771,87 @@ union uv1h_lb_target_physical_apic_id_mask_u {
 	} s1;
 };
 
+/* ========================================================================= */
+/*                   UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR                   */
+/* ========================================================================= */
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR		0x1603000UL
+
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_BASE_SHFT	26
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_M_IO_SHFT	46
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_ENABLE_SHFT 63
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_BASE_MASK	0x00003ffffc000000UL
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_M_IO_MASK	0x000fc00000000000UL
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uv3h_rh_gam_mmioh_overlay_config0_mmr_u {
+	unsigned long	v;
+	struct uv3h_rh_gam_mmioh_overlay_config0_mmr_s {
+		unsigned long	rsvd_0_25:26;
+		unsigned long	base:20;			/* RW */
+		unsigned long	m_io:6;				/* RW */
+		unsigned long	n_io:4;
+		unsigned long	rsvd_56_62:7;
+		unsigned long	enable:1;			/* RW */
+	} s3;
+};
+
+/* ========================================================================= */
+/*                   UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR                   */
+/* ========================================================================= */
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR		0x1604000UL
+
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR_BASE_SHFT	26
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR_M_IO_SHFT	46
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR_ENABLE_SHFT 63
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR_BASE_MASK	0x00003ffffc000000UL
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR_M_IO_MASK	0x000fc00000000000UL
+#define UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR_ENABLE_MASK 0x8000000000000000UL
+
+union uv3h_rh_gam_mmioh_overlay_config1_mmr_u {
+	unsigned long	v;
+	struct uv3h_rh_gam_mmioh_overlay_config1_mmr_s {
+		unsigned long	rsvd_0_25:26;
+		unsigned long	base:20;			/* RW */
+		unsigned long	m_io:6;				/* RW */
+		unsigned long	n_io:4;
+		unsigned long	rsvd_56_62:7;
+		unsigned long	enable:1;			/* RW */
+	} s3;
+};
+
+/* ========================================================================= */
+/*                  UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR                   */
+/* ========================================================================= */
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR		0x1603800UL
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR_DEPTH	128
+
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR_NASID_SHFT 0
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR_NASID_MASK 0x0000000000007fffUL
+
+union uv3h_rh_gam_mmioh_redirect_config0_mmr_u {
+	unsigned long	v;
+	struct uv3h_rh_gam_mmioh_redirect_config0_mmr_s {
+		unsigned long	nasid:15;			/* RW */
+		unsigned long	rsvd_15_63:49;
+	} s3;
+};
+
+/* ========================================================================= */
+/*                  UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR                   */
+/* ========================================================================= */
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR		0x1604800UL
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR_DEPTH	128
+
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR_NASID_SHFT 0
+#define UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR_NASID_MASK 0x0000000000007fffUL
+
+union uv3h_rh_gam_mmioh_redirect_config1_mmr_u {
+	unsigned long	v;
+	struct uv3h_rh_gam_mmioh_redirect_config1_mmr_s {
+		unsigned long	nasid:15;			/* RW */
+		unsigned long	rsvd_15_63:49;
+	} s3;
+};
+
 
 #endif /* _ASM_X86_UV_UV_MMRS_H */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 8cfade9..794f6eb 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -5,7 +5,7 @@
  *
  * SGI UV APIC functions (note: not an Intel compatible APIC)
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
  */
 #include <linux/cpumask.h>
 #include <linux/hardirq.h>
@@ -91,10 +91,16 @@ static int __init early_get_pnodeid(void)
 	m_n_config.v = uv_early_read_mmr(UVH_RH_GAM_CONFIG_MMR);
 	uv_min_hub_revision_id = node_id.s.revision;
 
-	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
-		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
-	if (node_id.s.part_number == UV2_HUB_PART_NUMBER_X)
+	switch (node_id.s.part_number) {
+	case UV2_HUB_PART_NUMBER:
+	case UV2_HUB_PART_NUMBER_X:
 		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+		break;
+	case UV3_HUB_PART_NUMBER:
+	case UV3_HUB_PART_NUMBER_X:
+		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE - 1;
+		break;
+	}
 
 	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
@@ -130,13 +136,16 @@ static void __init uv_set_apicid_hibit(void)
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int pnodeid, is_uv1, is_uv2;
+	int pnodeid, is_uv1, is_uv2, is_uv3;
 
 	is_uv1 = !strcmp(oem_id, "SGI");
 	is_uv2 = !strcmp(oem_id, "SGI2");
-	if (is_uv1 || is_uv2) {
+	is_uv3 = !strncmp(oem_id, "SGI3", 4);	/* there are varieties of UV3 */
+	if (is_uv1 || is_uv2 || is_uv3) {
 		uv_hub_info->hub_revision =
-			is_uv1 ? UV1_HUB_REVISION_BASE : UV2_HUB_REVISION_BASE;
+			(is_uv1 ? UV1_HUB_REVISION_BASE :
+			(is_uv2 ? UV2_HUB_REVISION_BASE :
+				  UV3_HUB_REVISION_BASE));
 		pnodeid = early_get_pnodeid();
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
@@ -450,14 +459,17 @@ static __init void map_high(char *id, unsigned long base, int pshift,
 
 	paddr = base << pshift;
 	bytes = (1UL << bshift) * (max_pnode + 1);
-	printk(KERN_INFO "UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr,
-						paddr + bytes);
+	if (!paddr) {
+		pr_info("UV: Map %s_HI base address NULL\n", id);
+		return;
+	}
+	pr_info("UV: Map %s_HI 0x%lx - 0x%lx\n", id, paddr, paddr + bytes);
 	if (map_type == map_uc)
 		init_extra_mapping_uc(paddr, bytes);
 	else
 		init_extra_mapping_wb(paddr, bytes);
-
 }
+
 static __init void map_gru_high(int max_pnode)
 {
 	union uvh_rh_gam_gru_overlay_config_mmr_u gru;
@@ -468,7 +480,8 @@ static __init void map_gru_high(int max_pnode)
 		map_high("GRU", gru.s.base, shift, shift, max_pnode, map_wb);
 		gru_start_paddr = ((u64)gru.s.base << shift);
 		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
-
+	} else {
+		pr_info("UV: GRU disabled\n");
 	}
 }
 
@@ -480,23 +493,146 @@ static __init void map_mmr_high(int max_pnode)
 	mmr.v = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR);
 	if (mmr.s.enable)
 		map_high("MMR", mmr.s.base, shift, shift, max_pnode, map_uc);
+	else
+		pr_info("UV: MMR disabled\n");
+}
+
+/*
+ * This commonality works because both 0 & 1 versions of the MMIOH OVERLAY
+ * and REDIRECT MMR regs are exactly the same on UV3.
+ */
+struct mmioh_config {
+	unsigned long overlay;
+	unsigned long redirect;
+	char *id;
+};
+
+static __initdata struct mmioh_config mmiohs[] = {
+	{
+		UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR,
+		UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR,
+		"MMIOH0"
+	},
+	{
+		UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG1_MMR,
+		UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG1_MMR,
+		"MMIOH1"
+	},
+};
+
+static __init void map_mmioh_high_uv3(int index, int min_pnode, int max_pnode)
+{
+	union uv3h_rh_gam_mmioh_overlay_config0_mmr_u overlay;
+	unsigned long mmr;
+	unsigned long base;
+	int i, n, shift, m_io, max_io;
+	int nasid, lnasid, fi, li;
+	char *id;
+
+	id = mmiohs[index].id;
+	overlay.v = uv_read_local_mmr(mmiohs[index].overlay);
+	pr_info("UV: %s overlay 0x%lx base:0x%x m_io:%d\n",
+		id, overlay.v, overlay.s3.base, overlay.s3.m_io);
+	if (!overlay.s3.enable) {
+		pr_info("UV: %s disabled\n", id);
+		return;
+	}
+
+	shift = UV3H_RH_GAM_MMIOH_OVERLAY_CONFIG0_MMR_BASE_SHFT;
+	base = (unsigned long)overlay.s3.base;
+	m_io = overlay.s3.m_io;
+	mmr = mmiohs[index].redirect;
+	n = UV3H_RH_GAM_MMIOH_REDIRECT_CONFIG0_MMR_DEPTH;
+	min_pnode *= 2;				/* convert to NASID */
+	max_pnode *= 2;
+	max_io = lnasid = fi = li = -1;
+
+	for (i = 0; i < n; i++) {
+		union uv3h_rh_gam_mmioh_redirect_config0_mmr_u redirect;
+
+		redirect.v = uv_read_local_mmr(mmr + i * 8);
+		nasid = redirect.s3.nasid;
+		if (nasid < min_pnode || max_pnode < nasid)
+			nasid = -1;		/* invalid NASID */
+
+		if (nasid == lnasid) {
+			li = i;
+			if (i != n-1)		/* last entry check */
+				continue;
+		}
+
+		/* check if we have a cached (or last) redirect to print */
+		if (lnasid != -1 || (i == n-1 && nasid != -1))  {
+			unsigned long addr1, addr2;
+			int f, l;
+
+			if (lnasid == -1) {
+				f = l = i;
+				lnasid = nasid;
+			} else {
+				f = fi;
+				l = li;
+			}
+			addr1 = (base << shift) +
+				f * (unsigned long)(1 << m_io);
+			addr2 = (base << shift) +
+				(l + 1) * (unsigned long)(1 << m_io);
+			pr_info("UV: %s[%03d..%03d] NASID 0x%04x ADDR 0x%016lx - 0x%016lx\n",
+				id, fi, li, lnasid, addr1, addr2);
+			if (max_io < l)
+				max_io = l;
+		}
+		fi = li = i;
+		lnasid = nasid;
+	}
+
+	pr_info("UV: %s base:0x%lx shift:%d M_IO:%d MAX_IO:%d\n",
+		id, base, shift, m_io, max_io);
+
+	if (max_io >= 0)
+		map_high(id, base, shift, m_io, max_io, map_uc);
 }
 
-static __init void map_mmioh_high(int max_pnode)
+static __init void map_mmioh_high(int min_pnode, int max_pnode)
 {
 	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
-	int shift;
+	unsigned long mmr, base;
+	int shift, enable, m_io, n_io;
 
-	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	if (is_uv1_hub() && mmioh.s1.enable) {
-		shift = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
-		map_high("MMIOH", mmioh.s1.base, shift, mmioh.s1.m_io,
-			max_pnode, map_uc);
+	if (is_uv3_hub()) {
+		/* Map both MMIOH Regions */
+		map_mmioh_high_uv3(0, min_pnode, max_pnode);
+		map_mmioh_high_uv3(1, min_pnode, max_pnode);
+		return;
 	}
-	if (is_uv2_hub() && mmioh.s2.enable) {
+
+	if (is_uv1_hub()) {
+		mmr = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR;
+		shift = UV1H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
+		mmioh.v = uv_read_local_mmr(mmr);
+		enable = !!mmioh.s1.enable;
+		base = mmioh.s1.base;
+		m_io = mmioh.s1.m_io;
+		n_io = mmioh.s1.n_io;
+	} else if (is_uv2_hub()) {
+		mmr = UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR;
 		shift = UV2H_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR_BASE_SHFT;
-		map_high("MMIOH", mmioh.s2.base, shift, mmioh.s2.m_io,
-			max_pnode, map_uc);
+		mmioh.v = uv_read_local_mmr(mmr);
+		enable = !!mmioh.s2.enable;
+		base = mmioh.s2.base;
+		m_io = mmioh.s2.m_io;
+		n_io = mmioh.s2.n_io;
+	} else
+		return;
+
+	if (enable) {
+		max_pnode &= (1 << n_io) - 1;
+		pr_info(
+		    "UV: base:0x%lx shift:%d N_IO:%d M_IO:%d max_pnode:0x%x\n",
+			base, shift, m_io, n_io, max_pnode);
+		map_high("MMIOH", base, shift, m_io, max_pnode, map_uc);
+	} else {
+		pr_info("UV: MMIOH disabled\n");
 	}
 }
 
@@ -724,42 +860,41 @@ void uv_nmi_init(void)
 void __init uv_system_init(void)
 {
 	union uvh_rh_gam_config_mmr_u  m_n_config;
-	union uvh_rh_gam_mmioh_overlay_config_mmr_u mmioh;
 	union uvh_node_id_u node_id;
 	unsigned long gnode_upper, lowmem_redir_base, lowmem_redir_size;
-	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val, n_io;
-	int gnode_extra, max_pnode = 0;
+	int bytes, nid, cpu, lcpu, pnode, blade, i, j, m_val, n_val;
+	int gnode_extra, min_pnode = 999999, max_pnode = -1;
 	unsigned long mmr_base, present, paddr;
-	unsigned short pnode_mask, pnode_io_mask;
+	unsigned short pnode_mask;
+	char *hub = (is_uv1_hub() ? "UV1" :
+		    (is_uv2_hub() ? "UV2" :
+				    "UV3"));
 
-	printk(KERN_INFO "UV: Found %s hub\n", is_uv1_hub() ? "UV1" : "UV2");
+	pr_info("UV: Found %s hub\n", hub);
 	map_low_mmrs();
 
 	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
-	mmioh.v = uv_read_local_mmr(UVH_RH_GAM_MMIOH_OVERLAY_CONFIG_MMR);
-	n_io = is_uv1_hub() ? mmioh.s1.n_io : mmioh.s2.n_io;
+	pnode_mask = (1 << n_val) - 1;
 	mmr_base =
 	    uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
 	    ~UV_MMR_ENABLE;
-	pnode_mask = (1 << n_val) - 1;
-	pnode_io_mask = (1 << n_io) - 1;
 
 	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
 	gnode_extra = (node_id.s.node_id & ~((1 << n_val) - 1)) >> 1;
 	gnode_upper = ((unsigned long)gnode_extra  << m_val);
-	printk(KERN_INFO "UV: N %d, M %d, N_IO: %d, gnode_upper 0x%lx, gnode_extra 0x%x, pnode_mask 0x%x, pnode_io_mask 0x%x\n",
-			n_val, m_val, n_io, gnode_upper, gnode_extra, pnode_mask, pnode_io_mask);
+	pr_info("UV: N:%d M:%d pnode_mask:0x%x gnode_upper/extra:0x%lx/0x%x\n",
+			n_val, m_val, pnode_mask, gnode_upper, gnode_extra);
 
-	printk(KERN_DEBUG "UV: global MMR base 0x%lx\n", mmr_base);
+	pr_info("UV: global MMR base 0x%lx\n", mmr_base);
 
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
 		uv_possible_blades +=
 		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
 
 	/* uv_num_possible_blades() is really the hub count */
-	printk(KERN_INFO "UV: Found %d blades, %d hubs\n",
+	pr_info("UV: Found %d blades, %d hubs\n",
 			is_uv1_hub() ? uv_num_possible_blades() :
 			(uv_num_possible_blades() + 1) / 2,
 			uv_num_possible_blades());
@@ -794,6 +929,7 @@ void __init uv_system_init(void)
 			uv_blade_info[blade].nr_possible_cpus = 0;
 			uv_blade_info[blade].nr_online_cpus = 0;
 			spin_lock_init(&uv_blade_info[blade].nmi_lock);
+			min_pnode = min(pnode, min_pnode);
 			max_pnode = max(pnode, max_pnode);
 			blade++;
 		}
@@ -856,7 +992,7 @@ void __init uv_system_init(void)
 
 	map_gru_high(max_pnode);
 	map_mmr_high(max_pnode);
-	map_mmioh_high(max_pnode & pnode_io_mask);
+	map_mmioh_high(min_pnode, max_pnode);
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index fb29968..082e881 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -548,8 +548,7 @@ static int __init acpi_mcfg_check_entry(struct acpi_table_mcfg *mcfg,
 	if (cfg->address < 0xFFFFFFFF)
 		return 0;
 
-	if (!strcmp(mcfg->header.oem_id, "SGI") ||
-			!strcmp(mcfg->header.oem_id, "SGI2"))
+	if (!strncmp(mcfg->header.oem_id, "SGI", 3))
 		return 0;
 
 	if (mcfg->header.revision >= 1) {
diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 5032e0d..98718f6 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -15,7 +15,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- *  Copyright (c) 2009 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2009-2013 Silicon Graphics, Inc.  All Rights Reserved.
  *  Copyright (c) Dimitri Sivanich
  */
 #include <linux/clockchips.h>
@@ -102,9 +102,10 @@ static int uv_intr_pending(int pnode)
 	if (is_uv1_hub())
 		return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
 			UV1H_EVENT_OCCURRED0_RTC1_MASK;
-	else
-		return uv_read_global_mmr64(pnode, UV2H_EVENT_OCCURRED2) &
-			UV2H_EVENT_OCCURRED2_RTC_1_MASK;
+	else if (is_uvx_hub())
+		return uv_read_global_mmr64(pnode, UVXH_EVENT_OCCURRED2) &
+			UVXH_EVENT_OCCURRED2_RTC_1_MASK;
+	return 0;
 }
 
 /* Setup interrupt and return non-zero if early expiration occurred. */
@@ -122,8 +123,8 @@ static int uv_setup_intr(int cpu, u64 expires)
 		uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
 				UV1H_EVENT_OCCURRED0_RTC1_MASK);
 	else
-		uv_write_global_mmr64(pnode, UV2H_EVENT_OCCURRED2_ALIAS,
-				UV2H_EVENT_OCCURRED2_RTC_1_MASK);
+		uv_write_global_mmr64(pnode, UVXH_EVENT_OCCURRED2_ALIAS,
+				UVXH_EVENT_OCCURRED2_RTC_1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
 		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 492c8ca..44d273c 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -517,7 +517,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system())
+	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
 		return 0;
 
 #if defined CONFIG_IA64
