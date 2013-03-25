Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab3CYVcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:32:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62995 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3CYVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130325164600.GA11734@gmail.com>
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
	<1364223758-17621-2-git-send-email-lee.jones@linaro.org>
	<201303251540.51104.arnd@arndb.de>
	<20130325164600.GA11734@gmail.com>
Date: Mon, 25 Mar 2013 22:32:40 +0100
Message-ID: <CACRpkdbn4WARSp7_MUpCZTghTrsPYvsa9GEUC31T7nP_=9oZag@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address
 from Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, devicetree-discuss@lists.ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 5:46 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> >         res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>> >                                            "prcmu-tcpm");
>> >         if (!res) {
>> > -               dev_err(&pdev->dev,
>> > -                       "Error: no prcmu tcpm memory region provided\n");
>> > -               return;
>> > -       }
>> > -       tcpm_base = ioremap(res->start, resource_size(res));
>> > +               if (np) {
>> > +                       tcpm_np = of_find_node_by_name(np->parent,
>> > +                                                      "prcmu-tcpm-per4");
>> > +                       if (!tcpm_np) {
>> > +                               dev_err(&pdev->dev,
>> > +                                       "no prcmu tcpm mem region provided\n");
>> > +                               return;
>> > +                       }
>> > +                       tcpm_base = of_iomap(tcpm_np, 0);
>> > +               }
>> > +       } else
>> > +               tcpm_base = ioremap(res->start, resource_size(res));
>> > +
>>
>> Why don't you just add these extra registers to the prcmu node itself like
>>
>> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
>> index 9de9309..6ee6c31 100644
>> --- a/arch/arm/boot/dts/dbx5x0.dtsi
>> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
>> @@ -191,8 +191,8 @@
>>
>>               prcmu: prcmu@80157000 {
>>                       compatible = "stericsson,db8500-prcmu";
>> -                     reg = <0x80157000 0x1000>;
>> -                     reg-names = "prcmu";
>> +                     reg = <0x80157000 0x1000>, <0x801b0000 0x1000>, <0x801b8000 0x1000>;
>> +                     reg-names = "prcmu", "prcmu-tcpm", "prcmu-tcdm-per4";
>>                       interrupts = <0 47 0x4>;
>>                       #address-cells = <1>;
>>                       #size-cells = <1>;
>>
>>
>> and document those in the prcmu binding?
>>
>> That would keep the code simpler and the same for both cases.
>
> I'm not sure you can. These addresses differ from platform to
> platform, so I'd need to provide the base PRCMU address in
> dbx5x0.dtsi, then the other two in the dts files. Can you do that?

Better ask on devicetree-discuss.

What it reflects are differences between SoC:s, so I think the
right solution is to split it in a three-layer cake:

dbx5x0.dtsi -> included by
db8500.dtsi -> included by
snowball/hrefv60plus.dts

dbx5x0.dtsi -> included by
dbx540.dtsi -> included by
ccu9540/ccu8540.dts

Here you may insert the reg property into the node at the
db8500.dtsi or dbx540.dtsi layer.

If you prefer I can cook a patch...

Yours,
Linus Walleij
