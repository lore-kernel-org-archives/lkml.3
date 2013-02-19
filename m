Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3BSHDa (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 19 Feb 2013 02:03:30 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:54457 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3BSHD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:03:29 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2M10gbWZkOiBzeXNjb246IEFkZCBub24tRFQgc3Vw?=
 =?UTF-8?B?cG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 19 Feb 2013 11:03:01 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361257381.497560655@f376.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302181602.47157.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1J73fHa017582

Hello.

Strange, but I not received an original answer from Arnd, have only this mail.

...
> >> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> >> index 4a7ed5a..3c0abcb 100644
> >> --- a/drivers/mfd/syscon.c
> >> +++ b/drivers/mfd/syscon.c
> >
> > Hi Alexander,
> >
> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> >>  {
> >>       struct device_node *syscon_np;
> >>       struct regmap *regmap;
> >> +     struct syscon *syscon;
> >> +     struct device *dev;
> >>
> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
> >> -     if (!syscon_np)
> >> +     if (syscon_np) {
> >> +             regmap = syscon_node_to_regmap(syscon_np);
> >> +             of_node_put(syscon_np);
> >> +
> >> +             return regmap;
> >> +     }
> >> +
> >> +     /* Fallback to search by id_entry.name string */
> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> >> +                              syscon_match_id);
> >> +     if (!dev)
> >>               return ERR_PTR(-ENODEV);
> >>
> >> -     regmap = syscon_node_to_regmap(syscon_np);
> >> -     of_node_put(syscon_np);
> >> +     syscon = dev_get_drvdata(dev);
> >>
> >> -     return regmap;
> >> +     return syscon->regmap;
> >>  }
> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> >
> > Since you are not actually comparing the "compatible" property here,
> > I would suggest adding another function here,
> 
> Yes, i also think like that.

In this case we should provide two paths for drivers which can work as with DT
and without DT. In my case we can use platform_device_id.name field with
"compatible" string. My way in this case is transparency for driver which is
using "syscon".

> 
> > something like
> > syscon_regmap_lookup_by_pdevname() that you can use in device
> > drivers that are not DT-enabled.
> 
> IMHO i would like syscon_dev_to_regmap, then we do not need to
> care in case pdevname changes.
> See:
> http://www.gossamer-threads.com/lists/linux/kernel/1675210#1675210
> What do you think?

For me, I still do not understand how we get syscon_dev from driver.

> > I would also recommend enclosing
> > that function in #ifdef CONFIG_ATAGS.
> >
> > Which code do you have in mind that would call this anyway?
> > The changeset description does not really explain what ATAG
> > boot support in syscon is good for.
> >
> >> +     if (IS_ENABLED(CONFIG_OF) && np) {
> >> +             syscon->base = of_iomap(np, 0);
> >> +             if (!syscon->base)
> >> +                     return -EADDRNOTAVAIL;
> >> +
> >> +             res = &res_of;
> >> +             ret = of_address_to_resource(np, 0, res);
> >> +             if (ret) {
> >> +                     iounmap(syscon->base);
> >> +                     return ret;
> >> +             }
> >> +     } else {
> >> +             res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +             if (!res)
> >> +                     return -ENOENT;
> >> +
> >> +             if (!devm_request_mem_region(dev, res->start,
> >> +                                          resource_size(res),
> >> +                                          dev_name(&pdev->dev)))
> >> +                     return -EBUSY;
> >> +
> >> +             syscon->base = ioremap(res->start, resource_size(res));
> >> +             if (!syscon->base)
> >> +                     return -EADDRNOTAVAIL;
> >> +     }
> >
> > These two code paths look equivalent. Why not always use the second
> > one? Also, you might want to convert this to devm_ioremap_resource()
> > to simplify the code in the process.
> >
> 
> These two code paths have a slight difference.
> The path1 does not request the mem region, the main reason of that is we meet
> some devices register ranges used as syscon maybe overlapped with
> other exist drivers.
> e.g imx6q.dtsi
> The gpr is a few registers contained in iomuxc.
> gpr: iomuxc-gpr@020e0000 {
>         compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
>         reg = <0x020e0000 0x38>;
> };
> 
> iomuxc: iomuxc@020e0000 {
>         compatible = "fsl,imx6q-iomuxc";
>         reg = <0x020e0000 0x4000>;
> ...
> };
> 
> The iomuxc already has a pinctrl driver, so there are conflicts if both
> request the same mem region.
> 
> So i wonder maybe we also do not need request mem region in non-dt case,
> then we can only  use second code path.

So, you suggest completely remove CONFIG_OF-dependent code from "probe"?
I am not a guru in DT, is it will work correct?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
