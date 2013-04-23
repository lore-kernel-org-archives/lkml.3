Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3DWGiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:38:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49961 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab3DWGh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:28 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Bernie Thompson <bernie@plugable.com>
Subject: [PATCH 11/11] fbdev: improve fb_mmap bounds checks
Date: Tue, 23 Apr 2013 09:36:58 +0300
Message-ID: <1366699018-5439-11-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366699018-5439-1-git-send-email-tomi.valkeinen@ti.com>
References: <1366699018-5439-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve fb_mmap bounds checks in gbefb, smscufx, udlfb and vfb drivers to
prevent possible uint overflows.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Bernie Thompson <bernie@plugable.com>
---
 drivers/video/gbefb.c   |    4 +++-
 drivers/video/smscufx.c |    6 +++++-
 drivers/video/udlfb.c   |    6 +++++-
 drivers/video/vfb.c     |    7 +++++--
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index bda5e39..ceab370 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1016,7 +1016,9 @@ static int gbefb_mmap(struct fb_info *info,
 	/* check range */
 	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
 		return -EINVAL;
-	if (offset + size > gbe_mem_size)
+	if (size > gbe_mem_size)
+		return -EINVAL;
+	if (offset > gbe_mem_size - size)
 		return -EINVAL;
 
 	/* remap using the fastest write-through mode on architecture */
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index 97bd662..b2b33fc 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -782,7 +782,11 @@ static int ufx_ops_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long page, pos;
 
-	if (offset + size > info->fix.smem_len)
+	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
+		return -EINVAL;
+	if (size > info->fix.smem_len)
+		return -EINVAL;
+	if (offset > info->fix.smem_len - size)
 		return -EINVAL;
 
 	pos = (unsigned long)info->fix.smem_start + offset;
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 86d449e..ec03e72 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -324,7 +324,11 @@ static int dlfb_ops_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long page, pos;
 
-	if (offset + size > info->fix.smem_len)
+	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
+		return -EINVAL;
+	if (size > info->fix.smem_len)
+		return -EINVAL;
+	if (offset > info->fix.smem_len - size)
 		return -EINVAL;
 
 	pos = (unsigned long)info->fix.smem_start + offset;
diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index 8bc1f93..ee5985e 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -420,9 +420,12 @@ static int vfb_mmap(struct fb_info *info,
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long page, pos;
 
-	if (offset + size > info->fix.smem_len) {
+	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
+		return -EINVAL;
+	if (size > info->fix.smem_len)
+		return -EINVAL;
+	if (offset > info->fix.smem_len - size)
 		return -EINVAL;
-	}
 
 	pos = (unsigned long)info->fix.smem_start + offset;
 
-- 
1.7.10.4

