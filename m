Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3FXVVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:21:20 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:44451 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3FXVVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:21:19 -0400
Message-ID: <51C8B84C.3020200@schinagl.nl>
Date: Mon, 24 Jun 2013 23:21:16 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl> <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl> <20130617225847.GA9494@kroah.com> <20130624092942.GG26008@lukather> <20130624160440.GA15201@kroah.com> <51C87DC7.50005@schinagl.nl> <20130624181509.GA8847@kroah.com>
In-Reply-To: <20130624181509.GA8847@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/13 20:15, Greg KH wrote:
> On Mon, Jun 24, 2013 at 07:11:35PM +0200, Oliver Schinagl wrote:
>> Hey Greg,
>> On 06/24/13 18:04, Greg KH wrote:
>>> On Mon, Jun 24, 2013 at 11:29:42AM +0200, Maxime Ripard wrote:
>>>> Hi Greg,
>>>>
>>>> On Mon, Jun 17, 2013 at 03:58:47PM -0700, Greg KH wrote:
>>>>> On Mon, Jun 17, 2013 at 10:59:37PM +0200, Oliver Schinagl wrote:
>>>>
>>>> [..]
>>>>
>>>>>> +static int __init sunxi_sid_probe(struct platform_device *pdev)
>>>>>> +{
>>>>>> +	u8 entropy[SID_SIZE];
>>>>>> +	unsigned int i;
>>>>>> +	struct resource *res;
>>>>>> +	void __iomem *sid_reg_base;
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>>> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
>>>>>> +	if (IS_ERR(sid_reg_base))
>>>>>> +		return PTR_ERR(sid_reg_base);
>>>>>> +	platform_set_drvdata(pdev, sid_reg_base);
>>>>>> +
>>>>>> +	ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>
>>>>> You just raced with userspace, having the file show up after the device
>>>>> was announced to users that it was there.  Please use the proper device
>>>>> file api to add default attributes to prevent this from happening.
>>>>
>>>> Sorry if the question looks dumb, but what kind of race can we generate
>>>> here?
>>>
>>> Userspace gets told about the device from the driver core, udev runs and
>>> reads all of the attributes, then your probe function comes along and
>>> adds a new attribute.  Userspace will then not know about it at all.
>>>
>>>> The device_create_bin_file is the last call that we make (if we except
>>>> the entropy stuff, but it doesn't really matter here), so after we
>>>> created the file, we have everything properly initialised so that our
>>>> functions can be called, right?
>>>>
>>>> And another dumb question for you, what is the "proper device file API"
>>>> you are referring to ? :)
>>>
>>> Please read Documentation/driver_model/device.txt and see the section on
>>> Attributes for what to do.  If you have specific questions after reading
>>> that, please let me know.
>> Since Maxime kinda asked for me, I hope you don't mind me following up.
>>
>> That doc doesn't mention the binary interface at all. Initially I
>> had both devices up, the 'read' device as a textual representation
>> and added the binary one later. Maxime and I decided the binary one
>> made more sense, as the only textual user would be a human and they
>> don't poke that entry that often.
>>
>> So what default way exists for binary files or how would that be solved?
>
> The same interface should work just fine for binary files, have you
> tried it?
I'll just take the plunge and make myself look stupid ;)

I tried to change things around, used DEVICE_ATTR(eeprom, S_IRUGO, 
sid_read, NULL); So far so good I'd hope.

Of course now I'll have to change the function's parameters from

static ssize_t sid_read(struct file *fd, struct kobject *kobj,
			struct bin_attribute *attr, char *buf,
			loff_t pos, size_t size)

to

static ssize_t sid_read(struct device *dev,
			struct device_attribute *attr, char *buf)

But now, I'm missing things like 'pos' and 'size', both which determine 
the requested bytes. True, in this specific driver we are talking about 
'only' 16 bytes, but what if it weren't but a few MiB and in sysfs we 
want to read some random byte, will we have to put the entire blok into 
the buffer?

So sorry for not understanding, but ... I don't understand :)

Oliver
>
> thanks,
>
> greg k-h
>

