Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3IKE5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab3IKE4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:48 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=mslTC35FPAgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QeDm1IhOnSgA:10 a=eh1Yez-EAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=W6U7dDoXpqQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=vclTjuxIhu5pgb36:21 a=JLOIu208uNFYZLsV:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042933.553432625@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jakob Bornecrantz <jakob@vmware.com>, Biran Paul <brianp@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Dave Airlie <airlied@gmail.com>
Subject: [246/251] drm/vmwgfx: Split GMR2_REMAP commands if they are to large
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0246-drm-vmwgfx-Split-GMR2_REMAP-commands-if-they-are-to-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jakob Bornecrantz <jakob@vmware.com>

[ Upstream commit 6e4dcff3adbf25acb87e74500a58e3c07bdec40f ]

This fixes the piglit test texturing/max-texture-size
causing the VM to die due to a too large SVGA command.

Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
Reviewed-by: Biran Paul <brianp@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c |   58 +++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
index 21ee782..e1978a2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -29,7 +29,9 @@
 #include "drmP.h"
 #include "ttm/ttm_bo_driver.h"
 
-#define VMW_PPN_SIZE sizeof(unsigned long)
+#define VMW_PPN_SIZE (sizeof(unsigned long))
+/* A future safe maximum remap size. */
+#define VMW_PPN_PER_REMAP ((31 * 1024) / VMW_PPN_SIZE)
 
 static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 			 struct page *pages[],
@@ -38,43 +40,61 @@ static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 {
 	SVGAFifoCmdDefineGMR2 define_cmd;
 	SVGAFifoCmdRemapGMR2 remap_cmd;
-	uint32_t define_size = sizeof(define_cmd) + 4;
-	uint32_t remap_size = VMW_PPN_SIZE * num_pages + sizeof(remap_cmd) + 4;
 	uint32_t *cmd;
 	uint32_t *cmd_orig;
+	uint32_t define_size = sizeof(define_cmd) + sizeof(*cmd);
+	uint32_t remap_num = num_pages / VMW_PPN_PER_REMAP + ((num_pages % VMW_PPN_PER_REMAP) > 0);
+	uint32_t remap_size = VMW_PPN_SIZE * num_pages + (sizeof(remap_cmd) + sizeof(*cmd)) * remap_num;
+	uint32_t remap_pos = 0;
+	uint32_t cmd_size = define_size + remap_size;
 	uint32_t i;
 
-	cmd_orig = cmd = vmw_fifo_reserve(dev_priv, define_size + remap_size);
+	cmd_orig = cmd = vmw_fifo_reserve(dev_priv, cmd_size);
 	if (unlikely(cmd == NULL))
 		return -ENOMEM;
 
 	define_cmd.gmrId = gmr_id;
 	define_cmd.numPages = num_pages;
 
+	*cmd++ = SVGA_CMD_DEFINE_GMR2;
+	memcpy(cmd, &define_cmd, sizeof(define_cmd));
+	cmd += sizeof(define_cmd) / sizeof(*cmd);
+
+	/*
+	 * Need to split the command if there are too many
+	 * pages that goes into the gmr.
+	 */
+
 	remap_cmd.gmrId = gmr_id;
 	remap_cmd.flags = (VMW_PPN_SIZE > sizeof(*cmd)) ?
 		SVGA_REMAP_GMR2_PPN64 : SVGA_REMAP_GMR2_PPN32;
-	remap_cmd.offsetPages = 0;
-	remap_cmd.numPages = num_pages;
 
-	*cmd++ = SVGA_CMD_DEFINE_GMR2;
-	memcpy(cmd, &define_cmd, sizeof(define_cmd));
-	cmd += sizeof(define_cmd) / sizeof(uint32);
+	while (num_pages > 0) {
+		unsigned long nr = min(num_pages, (unsigned long)VMW_PPN_PER_REMAP);
+
+		remap_cmd.offsetPages = remap_pos;
+		remap_cmd.numPages = nr;
 
-	*cmd++ = SVGA_CMD_REMAP_GMR2;
-	memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
-	cmd += sizeof(remap_cmd) / sizeof(uint32);
+		*cmd++ = SVGA_CMD_REMAP_GMR2;
+		memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
+		cmd += sizeof(remap_cmd) / sizeof(*cmd);
 
-	for (i = 0; i < num_pages; ++i) {
-		if (VMW_PPN_SIZE <= 4)
-			*cmd = page_to_pfn(*pages++);
-		else
-			*((uint64_t *)cmd) = page_to_pfn(*pages++);
+		for (i = 0; i < nr; ++i) {
+			if (VMW_PPN_SIZE <= 4)
+				*cmd = page_to_pfn(*pages++);
+			else
+				*((uint64_t *)cmd) = page_to_pfn(*pages++);
 
-		cmd += VMW_PPN_SIZE / sizeof(*cmd);
+			cmd += VMW_PPN_SIZE / sizeof(*cmd);
+		}
+
+		num_pages -= nr;
+		remap_pos += nr;
 	}
 
-	vmw_fifo_commit(dev_priv, define_size + remap_size);
+	BUG_ON(cmd != cmd_orig + cmd_size / sizeof(*cmd));
+
+	vmw_fifo_commit(dev_priv, cmd_size);
 
 	return 0;
 }
-- 
1.7.10.4


