Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaFOHr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 03:47:59 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:60040 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaFOHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 03:47:57 -0400
Message-ID: <539D4FA6.9060003@biereigel-wb.de>
Date: Sun, 15 Jun 2014 09:47:50 +0200
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stefan Biereigel <stefan@biereigel.de>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org, brian <brian.fonfara@gmx.de>
Subject: Re: console / fbdev: fbcon support for bits_per_pixel = 1?
References: <539C1C1F.5060904@biereigel.de> <20140614143550.59367463@neptune.home>
In-Reply-To: <20140614143550.59367463@neptune.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:AFl6+K7ZhtcTJFYXRncg7Gr4JMWIgKeDECIgkudqkMn
 l3/BrR7g4JQKeERCF6u3TMRNmFbMChdr116addLc7lMjPawT8R
 sZL4lmp5aK/CborptFGeHoJVolrCDPQmhlRbduNYwm9GEe2xm7
 jwsB1Uz6cMyjA2c5R1mPYTE5M51uf/LqEEou1VWfPaXvBauDaU
 +fOJTR7YImx5jAqpG6nHdfIzli8MPwiVOGVjssyb2z6tOwUswS
 TZHc0qiXJyBO0lgTV7THXWb/T4hq9gNuV5/zWyKX2FHxrBi0k0
 IGQYC2vCiO6VMNJjiEldVid7eJScFXhzV4IIX0fHD7vNJoiMz7
 612Si1GpkxQXhnJMDnmJqMiYSaqoCG10Tw2SkVLoT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bruno,

are you sure that fbcon really uses the 1bpp mode and that it works correctly? I tried to
match all var-settings to yours, and 1bpp support still seems broken. Well, a workaround
would be doing it like you are: using 8bpp shadow memory and translating it to packed
pixels (8px per byte) when doing LCD updates. I guess, for now that will be the way to go.
I'll be there to investigate further if needed.

Thank you,
Stefan

Am 14.06.2014 14:35, schrieb Bruno Prémont:
> Hi Stefan,
> 
> On Sat, 14 June 2014 Stefan Biereigel <stefan@biereigel.de> wrote:
>> CC: linux-console, linux-fbdev
>>
>> Hello Kernel Developers,
>> for a university assignment we are developing a frame buffer driver for a monochrome
>> display. We succeeded so far in making a simple "RAM frame buffer" module, which is needed
>> as the basis (we don't have read access to the RAM in the LCD).
>> We are using the system-default fb_ops (fb_sys_{read,write},
>> sys_{fillrect,copyarea,imageblit), and all is well when we use bits_per_pixel = 8. When we
>> map a console to the RAM frame buffer (con2fbmap 1 1), do strg-alt-F1, type some
>> characters there, we can then 'cat /dev/fb1' and plot the ram contents in Matlab
>> (reshaping the data to be our display geometry first), where our typed characters and the
>> console appear.
>>
>> If we however change bits_per_pixel to 1, and divide line_length by 8 (as it should
>> represent the line length in bytes), this suddenly stops working: echo and cat to fb1 work
>> as intended: We change our Matlab-Script to interpret every byte as 8 pixels, bytes
>> written into /dev/fb1 can be read out correctly. If we however map the console to fb1, no
>> console output can be seen in RAM - it is (seemingly) filled with garbage.
>>
>> We're using fbcon as the console driver, and the first frame buffer for me is intelfb. I
>> see, that the bitblitting-calls for every typed character are depth 1 and have correct
>> geometry, but the whole bitblitting-builtin seems not to work for bits_per_pixel = 1, i
>> tried it with a simple test image after the initialisation...
>>
>> Is this behavior intended or are we triggering a bug here (that no one noticed, because
>> who in the world uses monochrome framebuffers these days..). I can't see any comments that
>> monochrome consoles should not work with 1 bit per pixel. See the code below if you spot
>> some errors (ignore some missing error handling and mediocre style for now, please).
> 
> fbcon on 1bpp frambuffer worked for me with picoLCD (though I have found no userspace
> framebuffer application willing to operate at 1bpp).
> Thus I allow for 1bpp or 8bpp and convert 8bpp to 1bpp for the picolcd. As for your case,
> picoLCD is "write-only" monochrome LCD backed by in-RAM shadow framebuffer.
> 
> (see drivers/hid/hid-picolcd_fb.c)
> 
> Bruno
> 
>> Thank you for any help and input.
>> Best regards,
>> Stefan Biereigel
>>
>> 8<--- testfb.c
>>
>> #include <linux/init.h>
>> #include <linux/module.h>
>>
>> #include <linux/fb.h>
>> #include <linux/slab.h>
>> #include <linux/wait.h>
>> #include <linux/errno.h>
>> #include <linux/platform_device.h>
>>
>> #define DISPLAY_WIDTH	240
>> #define DISPLAY_HEIGHT	64
>> #define FB_MEM_SIZE 	(DISPLAY_WIDTH * DISPLAY_HEIGHT)/8
>>
>> static struct platform_device *testfb_device;
>>
>> static struct fb_ops fbops = {
>> 	.owner		= THIS_MODULE,
>> 	.fb_fillrect	= sys_fillrect,
>> 	.fb_copyarea	= sys_copyarea,
>> 	.fb_imageblit	= sys_imageblit,
>> 	.fb_read	= fb_sys_read,
>> 	.fb_write	= fb_sys_write,
>> 	.fb_sync	= NULL,
>> };
>>
>> static int __init testfb_probe (struct platform_device *pdev) {
>> 	void *fb_mem = NULL;
>> 	struct fb_info *fbinfo = NULL;
>>
>> 	fb_mem = kzalloc(FB_MEM_SIZE, GFP_KERNEL);
>>
>> 	if (!fb_mem) {
>> 		pr_err("testfb: memory allocation for framebuffer failed\n");
>> 		return(-ENOMEM);
>> 	}
>> 	else
>> 		pr_debug("testfb: allocated framebuffer memory successfully\n");
>>
>> 	fbinfo = framebuffer_alloc(0, &pdev->dev);
>>
>> 	if (!fbinfo) {
>> 		pr_err("testfb: framebuffer_alloc() failed\n");
>> 		kfree(fb_mem);
>> 		return(-1);
>> 	}
>> 	else
>> 		pr_debug("testfb: framebuffer_alloc was successful\n");
>>
>> 	fbinfo->fix.smem_start = (unsigned long) fb_mem;
>> 	fbinfo->screen_base = (char __iomem *) fb_mem;
>> 	fbinfo->fix.smem_len = FB_MEM_SIZE;
>> 	fbinfo->fbops = &fbops;
>>
>> 	fbinfo->node			= 0;				/* ?int */
>> 	fbinfo->device			= &pdev->dev;
>> 	fbinfo->flags			= FBINFO_DEFAULT;		/*  */
>> 	fbinfo->var.xres		= DISPLAY_WIDTH;		/* visible resolution */
>> 	fbinfo->var.yres		= DISPLAY_HEIGHT;		/* visible resolution */
>> 	fbinfo->var.xres_virtual	= DISPLAY_WIDTH;		/* virtual resolution */
>> 	fbinfo->var.yres_virtual	= DISPLAY_HEIGHT;		/* virtual resolution */
>> 	fbinfo->var.bits_per_pixel	= 1;				/* bits per pixel */
>> 	fbinfo->var.activate		= FB_ACTIVATE_NOW;		/* set values immediately (or vbl) */
>> 	fbinfo->var.sync		= 0;				/* ?see FB_SYNC_* */
>> 	fbinfo->var.vmode		= FB_VMODE_NONINTERLACED;	/* non interlaced, see FB_VMODE_* */
>> 	fbinfo->var.left_margin 	= 0;
>> 	fbinfo->var.right_margin 	= 0;
>> 	fbinfo->var.upper_margin 	= 0;
>> 	fbinfo->var.lower_margin 	= 0;
>> 	fbinfo->var.red.offset 		= 0;
>> 	fbinfo->var.red.length 		= fbinfo->var.bits_per_pixel;
>> 	fbinfo->var.green 		= fbinfo->var.red;
>> 	fbinfo->var.blue  		= fbinfo->var.red;
>> 	fbinfo->var.grayscale		= 1;
>> 	strcpy(fbinfo->fix.id, "testfb");				/* identifier, 16 byte */
>> 	fbinfo->fix.type		= FB_TYPE_PACKED_PIXELS;	/* pack pixels to avoid overhead */
>> 	fbinfo->fix.visual		= FB_VISUAL_MONO10;		/* Monochr. 1=Black 0=White */
>> 	fbinfo->fix.line_length		= DISPLAY_WIDTH/8;		/* length of a line in bytes */
>> 	fbinfo->fix.accel		= FB_ACCEL_NONE;		/* no hardware accelerator */
>> 	fbinfo->fix.xpanstep 		= 0;
>> 	fbinfo->fix.ypanstep		= 0;
>> 	fbinfo->fix.ywrapstep 		= 0;
>>
>> 	if (register_framebuffer(fbinfo) < 0) {
>> 		pr_err("testfb: registering framebuffer failed\n");
>> 		kfree((void *) fbinfo->fix.smem_start);
>> 		framebuffer_release(fbinfo);
>> 		return(-1);
>> 	}
>> 	else
>> 		pr_debug("testfb: registered framebuffer\n");
>>
>> 	platform_set_drvdata(pdev, fbinfo);
>>
>> 	return 0;
>> }
>>
>> static int testfb_remove(struct platform_device *pdev) {
>> 	struct fb_info *fbinfo = NULL;
>>
>> 	fbinfo = platform_get_drvdata(pdev);
>>
>> 	if (!fbinfo) {
>> 		pr_err("testfb: unable to get fbinfo from pdev\n");
>> 		return(-1);
>> 	}
>>
>> 	if (unregister_framebuffer(fbinfo) < 0)
>> 		pr_err("testfb: unregistering framebuffer failed\n");
>> 	else
>> 		pr_debug("testfb: unregistered framebuffer\n");
>>
>> 	kfree((void *) fbinfo->fix.smem_start);
>>
>> 	framebuffer_release(fbinfo);
>>
>> 	return 0;
>> }
>>
>> static struct platform_driver testfb_driver = {
>> 	.probe = testfb_probe,
>> 	.remove = testfb_remove,
>> 	.driver = {
>> 		.name = "testfb",
>> 	},
>> };
>>
>> static int __init testfb_init(void)
>> {
>> 	int ret;
>>
>> 	ret = platform_driver_register(&testfb_driver);
>> 	if (!ret) {
>> 		testfb_device = platform_device_register_simple("testfb", 0,
>> 								NULL, 0);
>>
>> 		if (IS_ERR(testfb_device)) {
>> 			platform_driver_unregister(&testfb_driver);
>> 			ret = PTR_ERR(testfb_device);
>> 		} else {
>> 			pr_info("testfb: platform_device registered\n");
>> 		}
>>
>> 	}
>>
>> 	pr_info("testfb: module loaded\n");
>> 	
>> 	return 0;
>> }
>>
>> static void __exit testfb_exit(void)
>> {
>> 	platform_device_unregister(testfb_device);
>> 	platform_driver_unregister(&testfb_driver);
>>
>> 	pr_info("testfb: module unloaded\n");
>> }
>>
>> module_init(testfb_init);
>> module_exit(testfb_exit);
>>
>> MODULE_LICENSE("GPL v2");
>> MODULE_ALIAS("testfb");
>> MODULE_AUTHOR("Brian Fonfara");
>> MODULE_DESCRIPTION("Ein Modul zum Test der Linux Framebuffer-Programmierung");
>> MODULE_DESCRIPTION("version 0.1");
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
