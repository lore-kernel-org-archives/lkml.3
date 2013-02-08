Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262Ab3BHSnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:43:12 -0500
Received: from relay3.sgi.com ([192.48.152.1]:33690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760206Ab3BHSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:43:08 -0500
Message-Id: <20130208184305.619798080@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 08 Feb 2013 12:43:08 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: [PATCH 3/7] x86: UV3 Update Hub Info
References: <20130208184305.132404589@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=uv3-update-hub-info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the UV HUB info for UV3.  The "is_uv3_hub" and
"is_uvx_hub" (UV2 or UV3) functions are added as well as the addresses
and sizes of the MMR regions for UV3.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h |   44 +++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
@@ -5,7 +5,7 @@
  *
  * SGI UV architectural definitions
  *
- * Copyright (C) 2007-2010 Silicon Graphics, Inc. All rights reserved.
+ * Copyright (C) 2007-2013 Silicon Graphics, Inc. All rights reserved.
  */
 
 #ifndef _ASM_X86_UV_UV_HUB_H
@@ -175,6 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
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
@@ -599,6 +626,7 @@ static inline void uv_hub_send_ipi(int p
  *     1 - UV1 rev 1.0 initial silicon
  *     2 - UV1 rev 2.0 production silicon
  *     3 - UV2 rev 1.0 initial silicon
+ *     5 - UV3 rev 1.0 initial silicon
  */
 static inline int uv_get_min_hub_revision_id(void)
 {

