Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3GEH0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:26:10 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:47498 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3GEH0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:26:09 -0400
Message-ID: <51D674BF.9030207@schinagl.nl>
Date: Fri, 05 Jul 2013 09:24:47 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl> <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl> <20130617225847.GA9494@kroah.com> <20130624092942.GG26008@lukather> <20130624160440.GA15201@kroah.com> <51C87DC7.50005@schinagl.nl> <20130624181509.GA8847@kroah.com> <51C8B84C.3020200@schinagl.nl> <20130624214615.GA17604@kroah.com> <51CAA709.4060801@schinagl.nl> <20130626175144.GC2222@kroah.com>
In-Reply-To: <20130626175144.GC2222@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

Thanks for the blog post :) it was very helpful and at least something 
good came from the less-nice bit of the discussion, but:

On 26-06-13 19:51, Greg KH wrote:
> On Wed, Jun 26, 2013 at 10:32:09AM +0200, Oliver Schinagl wrote:
>> On 24-06-13 23:46, Greg KH wrote:
>>> On Mon, Jun 24, 2013 at 11:21:16PM +0200, Oliver Schinagl wrote:
>>>> On 06/24/13 20:15, Greg KH wrote:
>>>>> On Mon, Jun 24, 2013 at 07:11:35PM +0200, Oliver Schinagl wrote:
>>>>>> Hey Greg,
>>>>>> On 06/24/13 18:04, Greg KH wrote:
>>>>>>> On Mon, Jun 24, 2013 at 11:29:42AM +0200, Maxime Ripard wrote:
>>>>>>>> Hi Greg,
>>>>>>>>
>>>>>>>> On Mon, Jun 17, 2013 at 03:58:47PM -0700, Greg KH wrote:
>>>>>>>>> On Mon, Jun 17, 2013 at 10:59:37PM +0200, Oliver Schinagl wrote:
>>>>>>>>
>>>>>>>> [..]
>>>>>>>>
>>>>>>>>>> +static int __init sunxi_sid_probe(struct platform_device *pdev)
>>>>>>>>>> +{
>>>>>>>>>> +	u8 entropy[SID_SIZE];
>>>>>>>>>> +	unsigned int i;
>>>>>>>>>> +	struct resource *res;
>>>>>>>>>> +	void __iomem *sid_reg_base;
>>>>>>>>>> +	int ret;
>>>>>>>>>> +
>>>>>>>>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>>>>>>> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
>>>>>>>>>> +	if (IS_ERR(sid_reg_base))
>>>>>>>>>> +		return PTR_ERR(sid_reg_base);
>>>>>>>>>> +	platform_set_drvdata(pdev, sid_reg_base);
>>>>>>>>>> +
>>>>>>>>>> +	ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
>>>>>>>>>> +	if (ret)
>>>>>>>>>> +		return ret;
>>>>>>>>>
>>>>>>>>> You just raced with userspace, having the file show up after the device
>>>>>>>>> was announced to users that it was there.  Please use the proper device
>>>>>>>>> file api to add default attributes to prevent this from happening.
>>>>>>>>
>>>>>>>> Sorry if the question looks dumb, but what kind of race can we generate
>>>>>>>> here?
>>>>>>>
>>>>>>> Userspace gets told about the device from the driver core, udev runs and
>>>>>>> reads all of the attributes, then your probe function comes along and
>>>>>>> adds a new attribute.  Userspace will then not know about it at all.
>>>>>>>
>>>>>>>> The device_create_bin_file is the last call that we make (if we except
>>>>>>>> the entropy stuff, but it doesn't really matter here), so after we
>>>>>>>> created the file, we have everything properly initialised so that our
>>>>>>>> functions can be called, right?
>>>>>>>>
>>>>>>>> And another dumb question for you, what is the "proper device file API"
>>>>>>>> you are referring to ? :)
>>>>>>>
>>>>>>> Please read Documentation/driver_model/device.txt and see the section on
>>>>>>> Attributes for what to do.  If you have specific questions after reading
>>>>>>> that, please let me know.
>>>>>> Since Maxime kinda asked for me, I hope you don't mind me following up.
>>>>>>
>>>>>> That doc doesn't mention the binary interface at all. Initially I
>>>>>> had both devices up, the 'read' device as a textual representation
>>>>>> and added the binary one later. Maxime and I decided the binary one
>>>>>> made more sense, as the only textual user would be a human and they
>>>>>> don't poke that entry that often.
>>>>>>
>>>>>> So what default way exists for binary files or how would that be solved?
>>>>>
>>>>> The same interface should work just fine for binary files, have you
>>>>> tried it?
>>>> I'll just take the plunge and make myself look stupid ;)
>>>>
>>>> I tried to change things around, used DEVICE_ATTR(eeprom, S_IRUGO,
>>>> sid_read, NULL); So far so good I'd hope.
>>>
>>> Ick, no.
>>>
>>>> Of course now I'll have to change the function's parameters from
>>>>
>>>> static ssize_t sid_read(struct file *fd, struct kobject *kobj,
>>>> 			struct bin_attribute *attr, char *buf,
>>>> 			loff_t pos, size_t size)
>>>>
>>>> to
>>>>
>>>> static ssize_t sid_read(struct device *dev,
>>>> 			struct device_attribute *attr, char *buf)
>>>
>>> Which is what do you do not want, as you find out:
>>>
>>>> But now, I'm missing things like 'pos' and 'size', both which
>>>> determine the requested bytes. True, in this specific driver we are
>>>> talking about 'only' 16 bytes, but what if it weren't but a few MiB
>>>> and in sysfs we want to read some random byte, will we have to put
>>>> the entire blok into the buffer?
>>>>
>>>> So sorry for not understanding, but ... I don't understand :)
>>>
>>> Stick with a binary attribute, and attach that to the proper class
>>> structure and all should be fine.
>>>
>>> Ah crap, you're using a platform device.
>>>
>>> {sigh}
>>>
>>> Why?  Why not use a "real" device which has a "real" class, and then use
>>> the interfaces there?
>> Because, as I was told, this really is a platform device. If you
>> have some example code I can look at and learn from that would be
>> awesome. I'm still learning after all, and apparently I'm doing it
>> wrong now :)
>
> I was wrong, you can do this with a platform device just fine.  Set the
> "groups" field in your platform device->device structure, and all will
> work properly, right?
Not for me :(

Firstly, I have a platform_driver structure, but it has a .driver field 
and i can set the .groups field there just fine, as your blog post said 
I believe, so that got me on the right track.

static struct platform_driver sunxi_sid_driver = {
         .probe = sunxi_sid_probe,
         .remove = sunxi_sid_remove,
         .driver = {
                 .name = DRV_NAME,
                 .owner = THIS_MODULE,
                 .of_match_table = sunxi_sid_of_match,
                 .groups = sunxi_sid_attr_groups,
         },
};
module_platform_driver(sunxi_sid_driver);


After jumping through a few hoops, creating an array of 
attribute_groups, filling that with an array of attribute I finally can 
assign an attribute to .attr, but I have a bin_attribute.

static struct attribute *sunxi_sid_attrs[] = {
         &sid_bin_attr.attr,
         NULL,
};

static const struct attribute_group sunxi_sid_attr_group = {
         .attrs = sunxi_sid_attrs,
};

static const struct attribute_group *sunxi_sid_attr_groups[] = {
         &sunxi_sid_attr_group,
         NULL,
};

A feeble attempt to use the .attr from the bin_attribute makes it all 
crash naturally.

Being reminded of LDD3, chapter 14, section 2, re-reading sub-section 3) 
Binary Attributes

We clearly read:
"Binary attributes must be created explicitly; they cannot be set up as 
default attributes. To create a binary attribute, call:

int sysfs_create_bin_file();

Which brings us right back to where we started.

So I clearly am missing something ;)

The other 'broken' drivers that where linked earlier, also use the 
BINARY attributes.

So Greg, if you could be so kind and give me an example how to implement 
this properly, I am at loss and don't know :(

Oliver
>
> thanks,
>
> greg k-h
>

