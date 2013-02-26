Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab3B0Aw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:52:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab3BZX6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>, Timur Tabi <timur@tabi.org>
Subject: [ 115/150] drivers/video: fsl-diu-fb: fix bugs in interrupt handling
Date: Tue, 26 Feb 2013 15:56:12 -0800
Message-Id: <20130226235536.032114299@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit b2639b5f1d01f218dc95537a1c352b3a551c4dd5 upstream.

Since commit f74de500 "drivers/video: fsl-diu-fb: streamline
enabling of interrupts" the interrupt handling in the driver
is broken. Enabling diu interrupt causes an interrupt storm and
results in system lockup.

The cookie for the interrupt handler function passed to request_irq()
is wrong (it must be a pointer to the diu struct, and not the address
of the pointer to the diu struct). As a result the interrupt handler
can not read diu registers and acknowledge the interrupt. Fix cookie
arguments for request_irq() and free_irq().

Registering the diu interrupt handler in probe() must happen before
install_fb() calls since this function registers framebuffer devices
and if fbcon tries to take over framebuffer after registering a frame
buffer device, it will call fb_open of the diu driver and enable the
interrupts. At this time the diu interrupt handler must be registered
already.

Disabling the interrupts in fsl_diu_release() must happen only if all
other AOIs are closed. Otherwise closing an overlay plane will disable
the interrupts even if the primary frame buffer plane is opened. Add
an appropriate check in the release function.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Timur Tabi <timur@tabi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fsl-diu-fb.c |   58 +++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -1232,6 +1232,16 @@ static int fsl_diu_ioctl(struct fb_info
 	return 0;
 }
 
+static inline void fsl_diu_enable_interrupts(struct fsl_diu_data *data)
+{
+	u32 int_mask = INT_UNDRUN; /* enable underrun detection */
+
+	if (IS_ENABLED(CONFIG_NOT_COHERENT_CACHE))
+		int_mask |= INT_VSYNC; /* enable vertical sync */
+
+	clrbits32(&data->diu_reg->int_mask, int_mask);
+}
+
 /* turn on fb if count == 1
  */
 static int fsl_diu_open(struct fb_info *info, int user)
@@ -1251,19 +1261,7 @@ static int fsl_diu_open(struct fb_info *
 		if (res < 0)
 			mfbi->count--;
 		else {
-			struct fsl_diu_data *data = mfbi->parent;
-
-#ifdef CONFIG_NOT_COHERENT_CACHE
-			/*
-			 * Enable underrun detection and vertical sync
-			 * interrupts.
-			 */
-			clrbits32(&data->diu_reg->int_mask,
-				  INT_UNDRUN | INT_VSYNC);
-#else
-			/* Enable underrun detection */
-			clrbits32(&data->diu_reg->int_mask, INT_UNDRUN);
-#endif
+			fsl_diu_enable_interrupts(mfbi->parent);
 			fsl_diu_enable_panel(info);
 		}
 	}
@@ -1283,9 +1281,18 @@ static int fsl_diu_release(struct fb_inf
 	mfbi->count--;
 	if (mfbi->count == 0) {
 		struct fsl_diu_data *data = mfbi->parent;
+		bool disable = true;
+		int i;
+
+		/* Disable interrupts only if all AOIs are closed */
+		for (i = 0; i < NUM_AOIS; i++) {
+			struct mfb_info *mi = data->fsl_diu_info[i].par;
 
-		/* Disable interrupts */
-		out_be32(&data->diu_reg->int_mask, 0xffffffff);
+			if (mi->count)
+				disable = false;
+		}
+		if (disable)
+			out_be32(&data->diu_reg->int_mask, 0xffffffff);
 		fsl_diu_disable_panel(info);
 	}
 
@@ -1614,14 +1621,6 @@ static int fsl_diu_probe(struct platform
 	out_be32(&data->diu_reg->desc[1], data->dummy_ad.paddr);
 	out_be32(&data->diu_reg->desc[2], data->dummy_ad.paddr);
 
-	for (i = 0; i < NUM_AOIS; i++) {
-		ret = install_fb(&data->fsl_diu_info[i]);
-		if (ret) {
-			dev_err(&pdev->dev, "could not register fb %d\n", i);
-			goto error;
-		}
-	}
-
 	/*
 	 * Older versions of U-Boot leave interrupts enabled, so disable
 	 * all of them and clear the status register.
@@ -1630,12 +1629,21 @@ static int fsl_diu_probe(struct platform
 	in_be32(&data->diu_reg->int_status);
 
 	ret = request_irq(data->irq, fsl_diu_isr, 0, "fsl-diu-fb",
-			  &data->diu_reg);
+			  data->diu_reg);
 	if (ret) {
 		dev_err(&pdev->dev, "could not claim irq\n");
 		goto error;
 	}
 
+	for (i = 0; i < NUM_AOIS; i++) {
+		ret = install_fb(&data->fsl_diu_info[i]);
+		if (ret) {
+			dev_err(&pdev->dev, "could not register fb %d\n", i);
+			free_irq(data->irq, data->diu_reg);
+			goto error;
+		}
+	}
+
 	sysfs_attr_init(&data->dev_attr.attr);
 	data->dev_attr.attr.name = "monitor";
 	data->dev_attr.attr.mode = S_IRUGO|S_IWUSR;
@@ -1667,7 +1675,7 @@ static int fsl_diu_remove(struct platfor
 	data = dev_get_drvdata(&pdev->dev);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
-	free_irq(data->irq, &data->diu_reg);
+	free_irq(data->irq, data->diu_reg);
 
 	for (i = 0; i < NUM_AOIS; i++)
 		uninstall_fb(&data->fsl_diu_info[i]);


