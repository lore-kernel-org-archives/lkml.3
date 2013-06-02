Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3FBPWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 11:22:01 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:37372 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3FBPVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 11:21:54 -0400
Message-ID: <51AB630F.9040109@schinagl.nl>
Date: Sun, 02 Jun 2013 17:21:51 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130528 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: maxime.ripard@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, Oliver Schinagl <oliver@schinagl.nl>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1370185130-15332-1-git-send-email-oliver+list@schinagl.nl> <1370185130-15332-2-git-send-email-oliver+list@schinagl.nl> <20130602150946.GF18614@n2100.arm.linux.org.uk>
In-Reply-To: <20130602150946.GF18614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/13 17:09, Russell King - ARM Linux wrote:
> On Sun, Jun 02, 2013 at 04:58:49PM +0200, Oliver Schinagl wrote:
>> +#include <asm/io.h>
>
> We have an include file called linux/io.h.  Please use linux/*.h files which
> include asm/*.h files in preference to directly using asm/*.h.
>
> In fact, no driver should include an asm/*.h header.
And I didn't have that there, but it kept refusing to find ioread32be. 
Of course, now I change it back to linux/io.h (which I had, I swear) and 
all works swell.

Concider it changed.
>
>> +#include <linux/compiler.h>
>> +#include <linux/device.h>
>> +#include <linux/err.h>
>> +#include <linux/errno.h>
>> +#include <linux/export.h>
>> +#include <linux/fs.h>
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/kobject.h>
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/random.h>
>> +#include <linux/stat.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/types.h>
>> +
>> +#define DRV_NAME "sunxi-sid"
>> +#define DRV_VERSION "1.0"
>> +
>> +/* There are 4 32-bit keys */
>> +#define SID_KEYS 4
>> +/* and 4 byte sized keys per 32-bit key */
>> +#define SID_SIZE (SID_KEYS * 4)
>> +
>> +static void __iomem *p_sid_reg_base;
>> +
>> +/* We read the entire key, but only return the requested byte. This is of
>> + * course slower then it could be and uses 4 times more reads as needed but
>> + * keeps code a simpler.
>> + */
>> +u8 sunxi_sid_read_byte(const int offset)
>> +{
>> +	u32 sid_key;
>> +	u8 ret;
>> +
>> +	ret = 0;
>> +
>> +	if (likely((SID_SIZE))) {
>> +		sid_key = ioread32be(p_sid_reg_base + round_down(offset, 4));
>> +		sid_key >>= (offset % 4) * 8;
>> +		ret = sid_key & 0xff;
>> +	}
>
> What happens if you unbind the device in sysfs and then try and use
> this function?
>
>> +static int sunxi_sid_remove(struct platform_device *pdev)
>> +{
>> +	device_remove_bin_file(&pdev->dev, &sid_bin_attr);
>> +	dev_info(&pdev->dev, "Sunxi SID driver unloaded successfully.\n");
>
> Maybe you want to set p_sid_reg_base to NULL here?
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init sunxi_sid_probe(struct platform_device *pdev)
>> +{
>> +	int entropy[SID_SIZE], i, ret;
>> +	struct device *dev;
>> +	struct resource *res;
>> +	void __iomem *sid_reg_base;
>> +
>> +	dev = &pdev->dev;
>> +	if (unlikely(!pdev->dev.of_node)) {
>> +		dev_err(dev, "No devicetree data available\n");
>> +		ret = -EFAULT;
>> +		goto exit;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(sid_reg_base)) {
>> +		dev_err(dev, "Unable to obtain resource\n");
>> +		ret = PTR_ERR(sid_reg_base);
>> +		goto exit;
>> +	}
>> +	platform_set_drvdata(pdev, sid_reg_base);
>> +	p_sid_reg_base = sid_reg_base;
>
> So what happens if you have two of these devices?  Maybe you want to check
> whether p_sid_reg_base is already set?
>
>> +
>> +	ret = device_create_bin_file(dev, &sid_bin_attr);
>> +	if (unlikely(ret)) {
>> +		dev_err(dev, "Unable to create sysfs bin entry\n");
>> +		goto exit;
>> +	}
>> +
>> +	for (i = 0; i < SID_SIZE; i++)
>> +		entropy[i] = sunxi_sid_read_byte(i);
>> +	add_device_randomness(entropy, SID_SIZE);
>> +
>> +	dev_info(dev, "Sunxi SID driver loaded successfully.\n");
>
> Do we really need to report that the driver "loaded successfully" ?
> Do we need lots of lines in the kernel log telling us simply that
> random driver X was built into the kernel or the module was loaded?
>

