Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3GOVQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:16:24 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:58679 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab3GOVQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:16:23 -0400
Message-ID: <51E466A3.4010503@schinagl.nl>
Date: Mon, 15 Jul 2013 23:16:19 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com
CC: Greg KH <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
References: <20130617225847.GA9494@kroah.com> <20130624092942.GG26008@lukather> <20130624160440.GA15201@kroah.com> <51C87DC7.50005@schinagl.nl> <20130624181509.GA8847@kroah.com> <51C8B84C.3020200@schinagl.nl> <20130624214615.GA17604@kroah.com> <51CAA709.4060801@schinagl.nl> <20130626175144.GC2222@kroah.com> <51D674BF.9030207@schinagl.nl> <20130706193646.GB9778@kroah.com>
In-Reply-To: <20130706193646.GB9778@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------010201060703050506050901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010201060703050506050901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/06/13 21:36, Greg KH wrote:
> On Fri, Jul 05, 2013 at 09:24:47AM +0200, Oliver Schinagl wrote:
>> The other 'broken' drivers that where linked earlier, also use the
>> BINARY attributes.
>>
>> So Greg, if you could be so kind and give me an example how to
>> implement this properly, I am at loss and don't know :(
>
> Ah crap, devices don't have a binary attribute group, like struct class
> does.  I'll go add that on Monday and send you the patch to see if that
> helps you out.  I'll also go through and fix up all of the binary
> attribute drivers to keep them from doing that...
>
> Sorry, I missed that earlier, but thanks for trying and pointing out my
> mistake.
>
> greg k-h
>

Greg,

I know you are a busy man and I hate take away some of your time, but 
could you be so kind and point me into the right direction and show me 
what I should do?

With your latest patches for binary attributes and your blog post, I 
thought that you want to create your binary attributes before the probe 
function, to avoid the userspace race. To do that, we have two options, 
create them in init (ugly?) or fill the .group member if available so it 
gets automatically created from the register function.

Well in my case, I'm using the module_platform_driver() macro which 
expects the struct platform_driver. Platform_driver has a device_driver 
member .driver where the .groups is located. Great, using that works and 
we should have the sysfs entry race-free. However I don't know hot to 
exchange data between that and the rest of my driver.

Before I used to_platform_device(kobj_to_dev(kobj)) as passed via the 
.read function to obtain a platform_device where i could use 
platform_get_drvdata on. All was good, but that doesn't fly now and my 
knowledge is a bit short as to why.

The second method is finding some other shared structure given that we 
get a platform_device in the probe function, yet I couldn't find 
anything and this platform_device isn't the same as the one from the .read.

Of course using a global var bypasses this issue, but I'm sure it won't 
pass review ;)

So using these new patches for binary attributes, how can I pass data 
between my driver and the sysfs files using a platform_driver? Or are 
other 'hacks' needed and using the .groups attribute from 
platform_driver->device_driver->groups is really the wrong approach.

I did ask around and still haven't figured it out so far, so I do 
apologize if you feel I'm wasting your precious time.

Oliver

--------------010201060703050506050901
Content-Type: text/x-csrc;
 name="sunxi_sid.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sunxi_sid.c"

/*
 * Copyright (c) 2013 Oliver Schinagl
 * http://www.linux-sunxi.org
 *
 * Oliver Schinagl <oliver@schinagl.nl>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * This driver exposes the Allwinner security ID, a 128 bit eeprom, in byte
 * sized chunks.
 */

#include <linux/compiler.h>
#include <linux/device.h>
#include <linux/err.h>
#include <linux/export.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/io.h>
#include <linux/kernel.h>
#include <linux/kobject.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/random.h>
#include <linux/sysfs.h>
#include <linux/types.h>

#define DRV_NAME "sunxi-sid"

/* There are 4 32-bit keys */
#define SID_KEYS 4
/* Each key is 4 bytes long */
#define SID_SIZE (SID_KEYS * 4)

/* We read the entire key, due to a 32 bit read alignment requirement. Since we
 * want to return the requested byte, this resuls in somewhat slower code and
 * uses 4 times more reads as needed but keeps code simpler. Since the SID is
 * only very rarly probed, this is not really an issue.
 */
static u8 sunxi_sid_read_byte(const void __iomem *sid_reg_base,
			      const unsigned int offset)
{
	u32 sid_key;

	if (offset >= SID_SIZE)
		return 0;

	sid_key = ioread32be(sid_reg_base + round_down(offset, 4));
	sid_key >>= (offset % 4) * 8;

	return sid_key; /* Only return the last byte */
}

static ssize_t eeprom_read(struct file *fd, struct kobject *kobj,
			struct bin_attribute *attr, char *buf,
			loff_t pos, size_t size)
{
	struct platform_device *pdev;
	void __iomem *sid_reg_base;
	int i;

	pdev = to_platform_device(kobj_to_dev(kobj));
	sid_reg_base = (void __iomem *)platform_get_drvdata(pdev);
	printk("0x%x, 0x%x 0x%x 0x%x\n", kobj, kobj_to_dev(kobj), pdev, sid_reg_base);

	if (pos < 0 || pos >= SID_SIZE)
		return 0;
	if (size > SID_SIZE - pos)
		size = SID_SIZE - pos;

	for (i = 0; i < size; i++)
		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);

	return i;
}

static const struct of_device_id sunxi_sid_of_match[] = {
	{ .compatible = "allwinner,sun4i-sid", },
	{/* sentinel */},
};
MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);

static int sunxi_sid_remove(struct platform_device *pdev)
{
	dev_dbg(&pdev->dev, "%s driver unloaded\n", DRV_NAME);

	return 0;
}

static int __init sunxi_sid_probe(struct platform_device *pdev)
{
	struct resource *res;
	void __iomem *sid_reg_base;
	u8 entropy[SID_SIZE];
	unsigned int i;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
	if (IS_ERR(sid_reg_base))
		return PTR_ERR(sid_reg_base);
	platform_set_drvdata(pdev, sid_reg_base);
	printk("0x%x, 0%x, 0x%x\n", sid_reg_base, pdev, &pdev->dev.kobj);

	for (i = 0; i < SID_SIZE; i++)
		entropy[i] = sunxi_sid_read_byte(sid_reg_base, i);
	add_device_randomness(entropy, SID_SIZE);
	dev_dbg(&pdev->dev, "%s loaded\n", DRV_NAME);

	return 0;
}

struct bin_attribute sunxi_sid_bin_attr = __BIN_ATTR_RO(eeprom, SID_SIZE);

struct bin_attribute *sunxi_sid_bin_attrs[] = {
	&sunxi_sid_bin_attr,
	NULL,
};

static const struct attribute_group sunxi_sid_bin_group = {
	.bin_attrs = sunxi_sid_bin_attrs,
};

static const struct attribute_group *sunxi_sid_bin_groups[] = {
	&sunxi_sid_bin_group,
	NULL,
};

static struct platform_driver sunxi_sid_driver = {
	.probe = sunxi_sid_probe,
	.remove = sunxi_sid_remove,
	.driver = {
		.name = DRV_NAME,
		.owner = THIS_MODULE,
		.of_match_table = sunxi_sid_of_match,
		.groups = sunxi_sid_bin_groups,
	},
};
module_platform_driver(sunxi_sid_driver);

MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
MODULE_DESCRIPTION("Allwinner sunxi security id driver");
MODULE_LICENSE("GPL");

--------------010201060703050506050901--
