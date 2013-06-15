Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3FOJe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 05:34:57 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:52018 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab3FOJez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 05:34:55 -0400
Message-ID: <51BC353D.5010001@schinagl.nl>
Date: Sat, 15 Jun 2013 11:34:53 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "maxime.ripard" <maxime.ripard@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl> <1371251781-17167-2-git-send-email-oliver+list@schinagl.nl> <CAHp75VdOrSA8EomPruMKzMgnSaVdtEEV0uB9bRpRGv7LiBsRPA@mail.gmail.com>
In-Reply-To: <CAHp75VdOrSA8EomPruMKzMgnSaVdtEEV0uB9bRpRGv7LiBsRPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/13 04:14, Andy Shevchenko wrote:
> On Sat, Jun 15, 2013 at 2:16 AM, Oliver Schinagl
> <oliver+list@schinagl.nl> wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> Allwinner has electric fuses (efuse) on their line of chips. This driver
>> reads those fuses, seeds the kernel entropy and exports them as a sysfs node.
>>
>> These fuses are most likly to be programmed at the factory, encoding
>> things like Chip ID, some sort of serial number etc and appear to be
>> reasonable unique.
>> While in theory, these should be writeable by the user, it will probably
>> be inconvinient to do so. Allwinner recommends that a certain input pin,
>> labeled 'efuse_vddq', be connected to GND. To write these fuses, 2.5 V
>> needs to be applied to this pin.
>>
>> Even so, they can still be used to generate a board-unique mac from, board
>> unique RSA key and seed the kernel RNG.
>>
>> Currently supported are the following known chips:
>> Allwinner sun4i (A10)
>> Allwinner sun5i (A10s, A13)
>
> Few comments below.
>
>> +++ b/drivers/misc/eeprom/sunxi_sid.c
>
>> +#include <linux/compiler.h>
>
> Are you sure this has to be explicitly mentioned?
Well we use __iomem from it, so I think yes
>
>> +#define SID_SIZE (SID_KEYS * 4)
>> +
>> +
>
> Extra line.
to seperate defines/includes from the code?
>
>> +/* We read the entire key, but only return the requested byte. This is of
>> + * course slower then it could be and uses 4 times more reads as needed but
>> + * keeps code simpler.
>
> May be better to rewrite this logic and save CPU and I/O resources?
Well we can only read 32 bits at a time and we only want to return 8 
bits. The only think I can think of, is read 32 bits and store those 
statically to the function and store with an extra int the location. 
Then check against the location and if it's the same use the int. Not 
sure all that is worth it.
>
>> + */
>> +static u8 sunxi_sid_read_byte(const void __iomem *sid_reg_base,
>> +                             const unsigned int offset)
>> +{
>> +       u32 sid_key = 0;
>> +
>> +       if (offset >= SID_SIZE)
>> +               goto exit;
>
> Just return here.
Well as said before, return vs goto; i choose goto ;)
>
>> +       sid_key = ioread32be(sid_reg_base + round_down(offset, 4));
>> +       sid_key >>= (offset % 4) * 8;
>> +       sid_key &= 0xff;
>
> Redundant 0xff.
Yes, but does clarify the intention, which helps in readability?
>
>> +       /* fall through */
>> +
>> +exit:
>> +       return (u8)sid_key;
>
> No need to have explicit casting here.
Also here, it makes the intention clear, that we are only interested in 
the last 8 bits. The compiler should optimize this and the above bit 
away so it's only for readability.
>
>> +       pdev = (struct platform_device *)to_platform_device(kobj_to_dev(kobj));
>
> Ditto.
Yes, I just looked more closy to container_of, and the 'const 
typeof(((type *)0)->member) takes care of the typecast, does it not?
>
>> +       sid_reg_base = (void __iomem *)platform_get_drvdata(pdev);
>
> Ditto.
Not sure on this one, since technically, it returns only void * (always) 
and we had a void '__iomem *' pointer. for clarity and completness I 
would keep it?
>
>> +static int sunxi_sid_remove(struct platform_device *pdev)
>> +{
>> +       device_remove_bin_file(&pdev->dev, &sid_bin_attr);
>> +       dev_info(&pdev->dev, "sunxi SID driver unloaded\n");
>
> Often this is useless message. In what case this is crucial?
well it's dev_info, so it is only information to the user.
>
>> +static int __init sunxi_sid_probe(struct platform_device *pdev)
>> +{
>> +       int entropy[SID_SIZE], i;
>> +       struct resource *res;
>> +       void __iomem *sid_reg_base;
>> +       int ret;
>> +
>> +       if (!pdev->dev.of_node) {
>> +               dev_err(&pdev->dev, "No devicetree data available\n");
>> +               ret = -ENXIO;
>> +               goto exit;
>
> You have only return, use it. It's common practice in the .probe() function.
>
>> +       if (IS_ERR(sid_reg_base)) {
>> +               ret = PTR_ERR(sid_reg_base);
>> +               goto exit;
>
> Ditto.
>
>> +       ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Unable to create sysfs bin entry\n");
>> +               goto exit;
>
> Ditto.
>
>> +       dev_info(&pdev->dev, "sunxi SID ver %s loaded\n", DRV_VERSION);
>> +       ret = 0;
>> +       /* fall through */
>
> Ditto.
>
>> +
>> +exit:
>> +       return ret;
>
> Useless lines.
>
>> +module_platform_driver(sunxi_sid_driver);
>> +
>> +
>
> Extra line.
Seperate the code from the trailing macro's
>
>
> --
> With Best Regards,
> Andy Shevchenko
>

