Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3ITHG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:06:57 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48601 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3ITHGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:06:55 -0400
Message-ID: <523BF40B.1090002@gmail.com>
Date: Fri, 20 Sep 2013 17:06:51 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com
CC: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] video: Use fb_sys_write rather than open-coding in drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several video drivers open code the fb_write write function with code
which is very similar to fb_sys_write. Replace the open code versions
with calls to fb_sys_write. An fb_sync callback is added to each of
the drivers.
    
Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/drivers/video/auo_k190x.c b/drivers/video/auo_k190x.c
index 8d2499d..0eeeb26 100644
--- a/drivers/video/auo_k190x.c
+++ b/drivers/video/auo_k190x.c
@@ -362,50 +362,12 @@ out:
  * framebuffer operations
  */
 
-/*
- * this is the slow path from userspace. they can seek and write to
- * the fb. it's inefficient to do anything less than a full screen draw
- */
-static ssize_t auok190xfb_write(struct fb_info *info, const char __user *buf,
-				size_t count, loff_t *ppos)
+static int auok190xfb_sync(struct fb_info *info)
 {
 	struct auok190xfb_par *par = info->par;
-	unsigned long p = *ppos;
-	void *dst;
-	int err = 0;
-	unsigned long total_size;
-
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
-	total_size = info->fix.smem_len;
-
-	if (p > total_size)
-		return -EFBIG;
-
-	if (count > total_size) {
-		err = -EFBIG;
-		count = total_size;
-	}
-
-	if (count + p > total_size) {
-		if (!err)
-			err = -ENOSPC;
-
-		count = total_size - p;
-	}
-
-	dst = (void *)(info->screen_base + p);
-
-	if (copy_from_user(dst, buf, count))
-		err = -EFAULT;
-
-	if  (!err)
-		*ppos += count;
 
 	par->update_all(par);
-
-	return (err) ? err : count;
+	return 0;
 }
 
 static void auok190xfb_fillrect(struct fb_info *info,
@@ -565,7 +527,8 @@ static int auok190xfb_set_par(struct fb_info *info)
 static struct fb_ops auok190xfb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_read	= fb_sys_read,
-	.fb_write	= auok190xfb_write,
+	.fb_write	= fb_sys_write,
+	.fb_sync	= auok190xfb_sync,
 	.fb_fillrect	= auok190xfb_fillrect,
 	.fb_copyarea	= auok190xfb_copyarea,
 	.fb_imageblit	= auok190xfb_imageblit,
@@ -1066,6 +1029,7 @@ int auok190x_common_probe(struct platform_device *pdev,
 
 	memset(videomemory, 0, videomemorysize);
 	info->screen_base = (char *)videomemory;
+	info->screen_size = videomemorysize;
 	info->fix.smem_len = videomemorysize;
 
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
diff --git a/drivers/video/broadsheetfb.c b/drivers/video/broadsheetfb.c
index b09701c..4d6231a 100644
--- a/drivers/video/broadsheetfb.c
+++ b/drivers/video/broadsheetfb.c
@@ -924,6 +924,14 @@ static void broadsheetfb_dpy_update(struct broadsheetfb_par *par)
 	mutex_unlock(&(par->io_lock));
 }
 
+static int broadsheetfb_sync(struct fb_info *info)
+{
+	struct broadsheetfb_par *par = info->par;
+
+	broadsheetfb_dpy_update(par);
+	return 0;
+}
+
 /* this is called back from the deferred io workqueue */
 static void broadsheetfb_dpy_deferred_io(struct fb_info *info,
 				struct list_head *pagelist)
@@ -998,56 +1006,11 @@ static void broadsheetfb_imageblit(struct fb_info *info,
 	broadsheetfb_dpy_update(par);
 }
 
-/*
- * this is the slow path from userspace. they can seek and write to
- * the fb. it's inefficient to do anything less than a full screen draw
- */
-static ssize_t broadsheetfb_write(struct fb_info *info, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct broadsheetfb_par *par = info->par;
-	unsigned long p = *ppos;
-	void *dst;
-	int err = 0;
-	unsigned long total_size;
-
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
-	total_size = info->fix.smem_len;
-
-	if (p > total_size)
-		return -EFBIG;
-
-	if (count > total_size) {
-		err = -EFBIG;
-		count = total_size;
-	}
-
-	if (count + p > total_size) {
-		if (!err)
-			err = -ENOSPC;
-
-		count = total_size - p;
-	}
-
-	dst = (void *)(info->screen_base + p);
-
-	if (copy_from_user(dst, buf, count))
-		err = -EFAULT;
-
-	if  (!err)
-		*ppos += count;
-
-	broadsheetfb_dpy_update(par);
-
-	return (err) ? err : count;
-}
-
 static struct fb_ops broadsheetfb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_read        = fb_sys_read,
-	.fb_write	= broadsheetfb_write,
+	.fb_write	= fb_sys_write,
+	.fb_sync	= broadsheetfb_sync,
 	.fb_fillrect	= broadsheetfb_fillrect,
 	.fb_copyarea	= broadsheetfb_copyarea,
 	.fb_imageblit	= broadsheetfb_imageblit,
@@ -1106,6 +1069,7 @@ static int broadsheetfb_probe(struct platform_device *dev)
 		goto err_fb_rel;
 
 	info->screen_base = (char *)videomemory;
+	info->screen_size = videomemorysize;
 	info->fbops = &broadsheetfb_ops;
 
 	broadsheetfb_var.xres = dpyw;
diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index 59d2318..e8361e1 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -114,6 +114,14 @@ static void hecubafb_dpy_update(struct hecubafb_par *par)
 	apollo_send_command(par, APOLLO_DISPLAY_IMG);
 }
 
+static int hecubafb_sync(struct fb_info *info)
+{
+	struct hecubafb_par *par = info->par;
+
+	hecubafb_dpy_update(par);
+	return 0;
+}
+
 /* this is called back from the deferred io workqueue */
 static void hecubafb_dpy_deferred_io(struct fb_info *info,
 				struct list_head *pagelist)
@@ -151,56 +159,11 @@ static void hecubafb_imageblit(struct fb_info *info,
 	hecubafb_dpy_update(par);
 }
 
-/*
- * this is the slow path from userspace. they can seek and write to
- * the fb. it's inefficient to do anything less than a full screen draw
- */
-static ssize_t hecubafb_write(struct fb_info *info, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct hecubafb_par *par = info->par;
-	unsigned long p = *ppos;
-	void *dst;
-	int err = 0;
-	unsigned long total_size;
-
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
-	total_size = info->fix.smem_len;
-
-	if (p > total_size)
-		return -EFBIG;
-
-	if (count > total_size) {
-		err = -EFBIG;
-		count = total_size;
-	}
-
-	if (count + p > total_size) {
-		if (!err)
-			err = -ENOSPC;
-
-		count = total_size - p;
-	}
-
-	dst = (void __force *) (info->screen_base + p);
-
-	if (copy_from_user(dst, buf, count))
-		err = -EFAULT;
-
-	if  (!err)
-		*ppos += count;
-
-	hecubafb_dpy_update(par);
-
-	return (err) ? err : count;
-}
-
 static struct fb_ops hecubafb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_read        = fb_sys_read,
-	.fb_write	= hecubafb_write,
+	.fb_write	= fb_sys_write,
+	.fb_sync	= hecubafb_sync,
 	.fb_fillrect	= hecubafb_fillrect,
 	.fb_copyarea	= hecubafb_copyarea,
 	.fb_imageblit	= hecubafb_imageblit,
@@ -240,6 +203,7 @@ static int hecubafb_probe(struct platform_device *dev)
 		goto err_fballoc;
 
 	info->screen_base = (char __force __iomem *)videomemory;
+	info->screen_size = videomemorysize;
 	info->fbops = &hecubafb_ops;
 
 	info->var = hecubafb_var;
diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index f30150d..7f79916 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -447,6 +447,14 @@ static void metronomefb_dpy_update(struct metronomefb_par *par)
 	metronome_display_cmd(par);
 }
 
+static int metronomefb_sync(struct fb_info *info)
+{
+	struct metronomefb_par *par = info->par;
+
+	metronomefb_dpy_udpate(par);
+	return 0;
+}
+
 static u16 metronomefb_dpy_update_page(struct metronomefb_par *par, int index)
 {
 	int i;
@@ -510,55 +518,10 @@ static void metronomefb_imageblit(struct fb_info *info,
 	metronomefb_dpy_update(par);
 }
 
-/*
- * this is the slow path from userspace. they can seek and write to
- * the fb. it is based on fb_sys_write
- */
-static ssize_t metronomefb_write(struct fb_info *info, const char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	struct metronomefb_par *par = info->par;
-	unsigned long p = *ppos;
-	void *dst;
-	int err = 0;
-	unsigned long total_size;
-
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
-	total_size = info->fix.smem_len;
-
-	if (p > total_size)
-		return -EFBIG;
-
-	if (count > total_size) {
-		err = -EFBIG;
-		count = total_size;
-	}
-
-	if (count + p > total_size) {
-		if (!err)
-			err = -ENOSPC;
-
-		count = total_size - p;
-	}
-
-	dst = (void __force *)(info->screen_base + p);
-
-	if (copy_from_user(dst, buf, count))
-		err = -EFAULT;
-
-	if  (!err)
-		*ppos += count;
-
-	metronomefb_dpy_update(par);
-
-	return (err) ? err : count;
-}
-
 static struct fb_ops metronomefb_ops = {
 	.owner		= THIS_MODULE,
-	.fb_write	= metronomefb_write,
+	.fb_write	= fb_sys_write,
+	.fb_sync	= metronomefb_sync,
 	.fb_fillrect	= metronomefb_fillrect,
 	.fb_copyarea	= metronomefb_copyarea,
 	.fb_imageblit	= metronomefb_imageblit,
@@ -633,6 +596,7 @@ static int metronomefb_probe(struct platform_device *dev)
 		goto err_fb_rel;
 
 	info->screen_base = (char __force __iomem *)videomemory;
+	info->screen_size = videomemorysize;
 	info->fbops = &metronomefb_ops;
 
 	metronomefb_fix.line_length = fw;
diff --git a/drivers/video/ssd1307fb.c b/drivers/video/ssd1307fb.c
index 44967c8..2b46790 100644
--- a/drivers/video/ssd1307fb.c
+++ b/drivers/video/ssd1307fb.c
@@ -198,36 +198,12 @@ static void ssd1307fb_update_display(struct ssd1307fb_par *par)
 	kfree(array);
 }
 
-
-static ssize_t ssd1307fb_write(struct fb_info *info, const char __user *buf,
-		size_t count, loff_t *ppos)
+static int ssd1307fb_sync(struct fb_info *info)
 {
 	struct ssd1307fb_par *par = info->par;
-	unsigned long total_size;
-	unsigned long p = *ppos;
-	u8 __iomem *dst;
-
-	total_size = info->fix.smem_len;
-
-	if (p > total_size)
-		return -EINVAL;
-
-	if (count + p > total_size)
-		count = total_size - p;
-
-	if (!count)
-		return -EINVAL;
-
-	dst = (void __force *) (info->screen_base + p);
-
-	if (copy_from_user(dst, buf, count))
-		return -EFAULT;
 
 	ssd1307fb_update_display(par);
-
-	*ppos += count;
-
-	return count;
+	return 0;
 }
 
 static void ssd1307fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
@@ -254,7 +230,8 @@ static void ssd1307fb_imageblit(struct fb_info *info, const struct fb_image *ima
 static struct fb_ops ssd1307fb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_read	= fb_sys_read,
-	.fb_write	= ssd1307fb_write,
+	.fb_write	= fb_sys_write,
+	.fb_sync	= ssd1307fb_sync,
 	.fb_fillrect	= ssd1307fb_fillrect,
 	.fb_copyarea	= ssd1307fb_copyarea,
 	.fb_imageblit	= ssd1307fb_imageblit,
@@ -493,6 +470,7 @@ static int ssd1307fb_probe(struct i2c_client *client,
 	info->var.blue.offset = 0;
 
 	info->screen_base = (u8 __force __iomem *)vmem;
+	info->screen_size = vmem_size;
 	info->fix.smem_start = (unsigned long)vmem;
 	info->fix.smem_len = vmem_size;
 

