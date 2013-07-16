Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3GPQWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:22:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab3GPQWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:22:14 -0400
Date: Mon, 15 Jul 2013 23:41:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130716064107.GA10868@kroah.com>
References: <20130624160440.GA15201@kroah.com>
 <51C87DC7.50005@schinagl.nl>
 <20130624181509.GA8847@kroah.com>
 <51C8B84C.3020200@schinagl.nl>
 <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
 <20130706193646.GB9778@kroah.com>
 <51E466A3.4010503@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E466A3.4010503@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:16:19PM +0200, Oliver Schinagl wrote:
> 
> With your latest patches for binary attributes and your blog post, I 
> thought that you want to create your binary attributes before the probe 
> function, to avoid the userspace race. To do that, we have two options, 
> create them in init (ugly?) or fill the .group member if available so it 
> gets automatically created from the register function.

Yes, the .group thing should be what is needed here.

> Well in my case, I'm using the module_platform_driver() macro which 
> expects the struct platform_driver. Platform_driver has a device_driver 
> member .driver where the .groups is located. Great, using that works and 
> we should have the sysfs entry race-free. However I don't know hot to 
> exchange data between that and the rest of my driver.
> 
> Before I used to_platform_device(kobj_to_dev(kobj)) as passed via the 
> .read function to obtain a platform_device where i could use 
> platform_get_drvdata on. All was good, but that doesn't fly now and my 
> knowledge is a bit short as to why.

I don't understand, why not use the platform device that was passed to
the binary attribute write function?

> The second method is finding some other shared structure given that we 
> get a platform_device in the probe function, yet I couldn't find 
> anything and this platform_device isn't the same as the one from the .read.

It should be, why isn't it?

> Of course using a global var bypasses this issue, but I'm sure it won't 
> pass review ;)

The platform device structure should have what you need, right?

> So using these new patches for binary attributes, how can I pass data 
> between my driver and the sysfs files using a platform_driver? Or are 
> other 'hacks' needed and using the .groups attribute from 
> platform_driver->device_driver->groups is really the wrong approach.
> 
> I did ask around and still haven't figured it out so far, so I do 
> apologize if you feel I'm wasting your precious time.

How is the platform device not the same thing that was passed to your
probe function?

> 
> Oliver

> /*
>  * Copyright (c) 2013 Oliver Schinagl
>  * http://www.linux-sunxi.org
>  *
>  * Oliver Schinagl <oliver@schinagl.nl>
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>  * GNU General Public License for more details.
>  *
>  * This driver exposes the Allwinner security ID, a 128 bit eeprom, in byte
>  * sized chunks.
>  */
> 
> #include <linux/compiler.h>
> #include <linux/device.h>
> #include <linux/err.h>
> #include <linux/export.h>
> #include <linux/fs.h>
> #include <linux/init.h>
> #include <linux/io.h>
> #include <linux/kernel.h>
> #include <linux/kobject.h>
> #include <linux/module.h>
> #include <linux/platform_device.h>
> #include <linux/random.h>
> #include <linux/sysfs.h>
> #include <linux/types.h>
> 
> #define DRV_NAME "sunxi-sid"
> 
> /* There are 4 32-bit keys */
> #define SID_KEYS 4
> /* Each key is 4 bytes long */
> #define SID_SIZE (SID_KEYS * 4)
> 
> /* We read the entire key, due to a 32 bit read alignment requirement. Since we
>  * want to return the requested byte, this resuls in somewhat slower code and
>  * uses 4 times more reads as needed but keeps code simpler. Since the SID is
>  * only very rarly probed, this is not really an issue.
>  */
> static u8 sunxi_sid_read_byte(const void __iomem *sid_reg_base,
> 			      const unsigned int offset)
> {
> 	u32 sid_key;
> 
> 	if (offset >= SID_SIZE)
> 		return 0;
> 
> 	sid_key = ioread32be(sid_reg_base + round_down(offset, 4));
> 	sid_key >>= (offset % 4) * 8;
> 
> 	return sid_key; /* Only return the last byte */
> }
> 
> static ssize_t eeprom_read(struct file *fd, struct kobject *kobj,
> 			struct bin_attribute *attr, char *buf,
> 			loff_t pos, size_t size)
> {
> 	struct platform_device *pdev;
> 	void __iomem *sid_reg_base;
> 	int i;
> 
> 	pdev = to_platform_device(kobj_to_dev(kobj));
> 	sid_reg_base = (void __iomem *)platform_get_drvdata(pdev);

Great, isn't that what you need?

> 	printk("0x%x, 0x%x 0x%x 0x%x\n", kobj, kobj_to_dev(kobj), pdev, sid_reg_base);
> 
> 	if (pos < 0 || pos >= SID_SIZE)
> 		return 0;
> 	if (size > SID_SIZE - pos)
> 		size = SID_SIZE - pos;
> 
> 	for (i = 0; i < size; i++)
> 		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
> 
> 	return i;
> }

What are you missing in this function that you have in your probe
function?

This driver looks fine, what is not working properly?

totally confused,

greg k-h
