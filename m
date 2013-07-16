Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab3GPVC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:02:28 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:46372 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320Ab3GPVC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:02:26 -0400
Message-ID: <51E5B4DE.5060002@schinagl.nl>
Date: Tue, 16 Jul 2013 23:02:22 +0200
From: Oliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Oliver Schinagl <oliver+list@schinagl.nl>, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
References: <20130624160440.GA15201@kroah.com> <51C87DC7.50005@schinagl.nl> <20130624181509.GA8847@kroah.com> <51C8B84C.3020200@schinagl.nl> <20130624214615.GA17604@kroah.com> <51CAA709.4060801@schinagl.nl> <20130626175144.GC2222@kroah.com> <51D674BF.9030207@schinagl.nl> <20130706193646.GB9778@kroah.com> <51E466A3.4010503@schinagl.nl> <20130716064107.GA10868@kroah.com>
In-Reply-To: <20130716064107.GA10868@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/13 08:41, Greg KH wrote:
> On Mon, Jul 15, 2013 at 11:16:19PM +0200, Oliver Schinagl wrote:
>> With your latest patches for binary attributes and your blog post, I
>> thought that you want to create your binary attributes before the probe
>> function, to avoid the userspace race. To do that, we have two options,
>> create them in init (ugly?) or fill the .group member if available so it
>> gets automatically created from the register function.
> Yes, the .group thing should be what is needed here.
That's what I thought (and used).
>
>> Well in my case, I'm using the module_platform_driver() macro which
>> expects the struct platform_driver. Platform_driver has a device_driver
>> member .driver where the .groups is located. Great, using that works and
>> we should have the sysfs entry race-free. However I don't know hot to
>> exchange data between that and the rest of my driver.
>>
>> Before I used to_platform_device(kobj_to_dev(kobj)) as passed via the
>> .read function to obtain a platform_device where i could use
>> platform_get_drvdata on. All was good, but that doesn't fly now and my
>> knowledge is a bit short as to why.
> I don't understand, why not use the platform device that was passed to
> the binary attribute write function?
Because the pointers don't match and I get a null pointer from 
platform_get_data
>
>> The second method is finding some other shared structure given that we
>> get a platform_device in the probe function, yet I couldn't find
>> anything and this platform_device isn't the same as the one from the .read.
> It should be, why isn't it?
I think that's a little above my grasp :p
>
>> Of course using a global var bypasses this issue, but I'm sure it won't
>> pass review ;)
> The platform device structure should have what you need, right?
Should, but doesn't :(
>
>> So using these new patches for binary attributes, how can I pass data
>> between my driver and the sysfs files using a platform_driver? Or are
>> other 'hacks' needed and using the .groups attribute from
>> platform_driver->device_driver->groups is really the wrong approach.
>>
>> I did ask around and still haven't figured it out so far, so I do
>> apologize if you feel I'm wasting your precious time.
> How is the platform device not the same thing that was passed to your
> probe function?
I don't know :( But i'll add the relevant sections with printk results 
below, which I should have done before, then again those printk's were 
not supposed to be in that e-mail to begin with ;)

So if I'm not seeing something stupidly obvious, feel free to shout at me :)

static ssize_t sid_read(struct file *fd, struct kobject *kobj,
             struct bin_attribute *attr, char *buf,
             loff_t pos, size_t size)
{
     struct platform_device *pdev;
     void __iomem *sid_reg_base;
     int i;

     pdev = to_platform_device(kobj_to_dev(kobj));
     sid_reg_base = (void __iomem *)platform_get_drvdata(pdev);
     printk("0x%p, 0x%p, 0x%p, 0x%p\n", kobj, kobj_to_dev(kobj), pdev, 
sid_reg_base);

0xef1e7c80, 0xef1e7c78, 0xef1e7c68, 0x  (null)

     if (pos < 0 || pos >= SID_SIZE)
         return 0;
     if (size > SID_SIZE - pos)
         size = SID_SIZE - pos;

     for (i = 0; i < size; i++)
         buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);

     return i;
}


static struct bin_attribute sid_bin_attr = {
     .attr = { .name = "eeprom", .mode = S_IRUGO, },
     .size = SID_SIZE,
     .read = sid_read,
};

static struct bin_attribute *sunxi_sid_attrs[] = {
     &sid_bin_attr,
     NULL,
};

static const struct attribute_group sunxi_sid_group = {
     .bin_attrs = sunxi_sid_attrs,
};

static const struct attribute_group *sunxi_sid_groups[] = {
     &sunxi_sid_group,
     NULL,
};

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

     for (i = 0; i < SID_SIZE; i++)
         entropy[i] = sunxi_sid_read_byte(sid_reg_base, i);
     add_device_randomness(entropy, SID_SIZE);
     dev_dbg(&pdev->dev, "%s loaded\n", DRV_NAME);
     printk("0x%p, 0x%p\n", pdev, sid_reg_base);

0xef02b000, 0xf1c23800

     return 0;
}


