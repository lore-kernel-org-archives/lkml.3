Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3IEU21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab3IEU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jakob Bornecrantz <jakob@vmware.com>, Biran Paul <brianp@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Dave Airlie <airlied@gmail.com>
Subject: [ 16/36] drm/vmwgfx: Split GMR2_REMAP commands if they are to large
Date: Thu,  5 Sep 2013 13:27:45 -0700
Message-Id: <20130905202704.184857801@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Bornecrantz <jakob@vmware.com>

commit 6e4dcff3adbf25acb87e74500a58e3c07bdec40f upstream.

This fixes the piglit test texturing/max-texture-size
causing the VM to die due to a too large SVGA command.

Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
Reviewed-by: Biran Paul <brianp@vmware.com>
Reviewed-by: Zack Rusin <zackr@vmware.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c |   60 ++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c
@@ -29,7 +29,9 @@
 #include <drm/drmP.h>
 #include <drm/ttm/ttm_bo_driver.h>
 
-#define VMW_PPN_SIZE sizeof(unsigned long)
+#define VMW_PPN_SIZE (sizeof(unsigned long))
+/* A future safe maximum remap size. */
+#define VMW_PPN_PER_REMAP ((31 * 1024) / VMW_PPN_SIZE)
 
 static int vmw_gmr2_bind(struct vmw_private *dev_priv,
 			 struct page *pages[],
@@ -38,43 +40,61 @@ static int vmw_gmr2_bind(struct vmw_priv
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
-
-	for (i = 0; i < num_pages; ++i) {
-		if (VMW_PPN_SIZE <= 4)
-			*cmd = page_to_pfn(*pages++);
-		else
-			*((uint64_t *)cmd) = page_to_pfn(*pages++);
+		*cmd++ = SVGA_CMD_REMAP_GMR2;
+		memcpy(cmd, &remap_cmd, sizeof(remap_cmd));
+		cmd += sizeof(remap_cmd) / sizeof(*cmd);
+
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


