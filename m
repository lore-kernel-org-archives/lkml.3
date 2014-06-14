Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaFNJzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 05:55:51 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59979 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaFNJzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 05:55:48 -0400
Message-ID: <539C1C1F.5060904@biereigel.de>
Date: Sat, 14 Jun 2014 11:55:43 +0200
From: Stefan Biereigel <stefan@biereigel.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel org" <linux-kernel@vger.kernel.org>
CC: linux-fbdev@vger.kernel.org, linux-console@vger.kernel.org,
        brian <brian.fonfara@gmx.de>
Subject: console / fbdev: fbcon support for bits_per_pixel = 1?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2hp8fX22uAiJ5ccmqPNRMDNJ0WCkIFrIKPYtMkC87Bu
 0AkaQdT0NwPuYRp/0d2oVox+gDR35Reb4C7dilL5wiKmpgIWnB
 FL1OagoiiYpntLwXXEv3/YR0Kd/EivTZJ1hkJ9Y3bWHjCuSKXN
 fbvgKzU5sqybmjlRArNJfHYE7WbaOnouLsXnCLMoskK0epqFNw
 gJtn0fyTZYvlkOP0e0P6H+8yLE8zKiHB/4R7djYqxzxJHz3EHO
 827VHtL4gi7qzx7rgOjY+X5j1wrb1LiMnutHtZLL89/yNiYLRA
 R3MfZw7pHjT/p64ASeRI6X4TjDtG5MCFrkyicQ2W8UH8V9f5GX
 G730qu84sbZaRJKZcFUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-console, linux-fbdev

Hello Kernel Developers,
for a university assignment we are developing a frame buffer driver for a monochrome
display. We succeeded so far in making a simple "RAM frame buffer" module, which is needed
as the basis (we don't have read access to the RAM in the LCD).
We are using the system-default fb_ops (fb_sys_{read,write},
sys_{fillrect,copyarea,imageblit), and all is well when we use bits_per_pixel = 8. When we
map a console to the RAM frame buffer (con2fbmap 1 1), do strg-alt-F1, type some
characters there, we can then 'cat /dev/fb1' and plot the ram contents in Matlab
(reshaping the data to be our display geometry first), where our typed characters and the
console appear.

If we however change bits_per_pixel to 1, and divide line_length by 8 (as it should
represent the line length in bytes), this suddenly stops working: echo and cat to fb1 work
as intended: We change our Matlab-Script to interpret every byte as 8 pixels, bytes
written into /dev/fb1 can be read out correctly. If we however map the console to fb1, no
console output can be seen in RAM - it is (seemingly) filled with garbage.

We're using fbcon as the console driver, and the first frame buffer for me is intelfb. I
see, that the bitblitting-calls for every typed character are depth 1 and have correct
geometry, but the whole bitblitting-builtin seems not to work for bits_per_pixel = 1, i
tried it with a simple test image after the initialisation...

Is this behavior intended or are we triggering a bug here (that no one noticed, because
who in the world uses monochrome framebuffers these days..). I can't see any comments that
monochrome consoles should not work with 1 bit per pixel. See the code below if you spot
some errors (ignore some missing error handling and mediocre style for now, please).

Thank you for any help and input.
Best regards,
Stefan Biereigel

8<--- testfb.c

#include <linux/init.h>
#include <linux/module.h>

#include <linux/fb.h>
#include <linux/slab.h>
#include <linux/wait.h>
#include <linux/errno.h>
#include <linux/platform_device.h>

#define DISPLAY_WIDTH	240
#define DISPLAY_HEIGHT	64
#define FB_MEM_SIZE 	(DISPLAY_WIDTH * DISPLAY_HEIGHT)/8

static struct platform_device *testfb_device;

static struct fb_ops fbops = {
	.owner		= THIS_MODULE,
	.fb_fillrect	= sys_fillrect,
	.fb_copyarea	= sys_copyarea,
	.fb_imageblit	= sys_imageblit,
	.fb_read	= fb_sys_read,
	.fb_write	= fb_sys_write,
	.fb_sync	= NULL,
};

static int __init testfb_probe (struct platform_device *pdev) {
	void *fb_mem = NULL;
	struct fb_info *fbinfo = NULL;

	fb_mem = kzalloc(FB_MEM_SIZE, GFP_KERNEL);

	if (!fb_mem) {
		pr_err("testfb: memory allocation for framebuffer failed\n");
		return(-ENOMEM);
	}
	else
		pr_debug("testfb: allocated framebuffer memory successfully\n");

	fbinfo = framebuffer_alloc(0, &pdev->dev);

	if (!fbinfo) {
		pr_err("testfb: framebuffer_alloc() failed\n");
		kfree(fb_mem);
		return(-1);
	}
	else
		pr_debug("testfb: framebuffer_alloc was successful\n");

	fbinfo->fix.smem_start = (unsigned long) fb_mem;
	fbinfo->screen_base = (char __iomem *) fb_mem;
	fbinfo->fix.smem_len = FB_MEM_SIZE;
	fbinfo->fbops = &fbops;

	fbinfo->node			= 0;				/* ?int */
	fbinfo->device			= &pdev->dev;
	fbinfo->flags			= FBINFO_DEFAULT;		/*  */
	fbinfo->var.xres		= DISPLAY_WIDTH;		/* visible resolution */
	fbinfo->var.yres		= DISPLAY_HEIGHT;		/* visible resolution */
	fbinfo->var.xres_virtual	= DISPLAY_WIDTH;		/* virtual resolution */
	fbinfo->var.yres_virtual	= DISPLAY_HEIGHT;		/* virtual resolution */
	fbinfo->var.bits_per_pixel	= 1;				/* bits per pixel */
	fbinfo->var.activate		= FB_ACTIVATE_NOW;		/* set values immediately (or vbl) */
	fbinfo->var.sync		= 0;				/* ?see FB_SYNC_* */
	fbinfo->var.vmode		= FB_VMODE_NONINTERLACED;	/* non interlaced, see FB_VMODE_* */
	fbinfo->var.left_margin 	= 0;
	fbinfo->var.right_margin 	= 0;
	fbinfo->var.upper_margin 	= 0;
	fbinfo->var.lower_margin 	= 0;
	fbinfo->var.red.offset 		= 0;
	fbinfo->var.red.length 		= fbinfo->var.bits_per_pixel;
	fbinfo->var.green 		= fbinfo->var.red;
	fbinfo->var.blue  		= fbinfo->var.red;
	fbinfo->var.grayscale		= 1;
	strcpy(fbinfo->fix.id, "testfb");				/* identifier, 16 byte */
	fbinfo->fix.type		= FB_TYPE_PACKED_PIXELS;	/* pack pixels to avoid overhead */
	fbinfo->fix.visual		= FB_VISUAL_MONO10;		/* Monochr. 1=Black 0=White */
	fbinfo->fix.line_length		= DISPLAY_WIDTH/8;		/* length of a line in bytes */
	fbinfo->fix.accel		= FB_ACCEL_NONE;		/* no hardware accelerator */
	fbinfo->fix.xpanstep 		= 0;
	fbinfo->fix.ypanstep		= 0;
	fbinfo->fix.ywrapstep 		= 0;

	if (register_framebuffer(fbinfo) < 0) {
		pr_err("testfb: registering framebuffer failed\n");
		kfree((void *) fbinfo->fix.smem_start);
		framebuffer_release(fbinfo);
		return(-1);
	}
	else
		pr_debug("testfb: registered framebuffer\n");

	platform_set_drvdata(pdev, fbinfo);

	return 0;
}

static int testfb_remove(struct platform_device *pdev) {
	struct fb_info *fbinfo = NULL;

	fbinfo = platform_get_drvdata(pdev);

	if (!fbinfo) {
		pr_err("testfb: unable to get fbinfo from pdev\n");
		return(-1);
	}

	if (unregister_framebuffer(fbinfo) < 0)
		pr_err("testfb: unregistering framebuffer failed\n");
	else
		pr_debug("testfb: unregistered framebuffer\n");

	kfree((void *) fbinfo->fix.smem_start);

	framebuffer_release(fbinfo);

	return 0;
}

static struct platform_driver testfb_driver = {
	.probe = testfb_probe,
	.remove = testfb_remove,
	.driver = {
		.name = "testfb",
	},
};

static int __init testfb_init(void)
{
	int ret;

	ret = platform_driver_register(&testfb_driver);
	if (!ret) {
		testfb_device = platform_device_register_simple("testfb", 0,
								NULL, 0);

		if (IS_ERR(testfb_device)) {
			platform_driver_unregister(&testfb_driver);
			ret = PTR_ERR(testfb_device);
		} else {
			pr_info("testfb: platform_device registered\n");
		}

	}

	pr_info("testfb: module loaded\n");
	
	return 0;
}

static void __exit testfb_exit(void)
{
	platform_device_unregister(testfb_device);
	platform_driver_unregister(&testfb_driver);

	pr_info("testfb: module unloaded\n");
}

module_init(testfb_init);
module_exit(testfb_exit);

MODULE_LICENSE("GPL v2");
MODULE_ALIAS("testfb");
MODULE_AUTHOR("Brian Fonfara");
MODULE_DESCRIPTION("Ein Modul zum Test der Linux Framebuffer-Programmierung");
MODULE_DESCRIPTION("version 0.1");
