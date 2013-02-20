Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3BTFl1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 20 Feb 2013 00:41:27 -0500
Received: from f173.mail.ru ([94.100.178.91]:38951 "EHLO f173.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab3BTFl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:41:26 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbOF06IFtQQVRDSCB2M10gbWZkOiBzeXNjb246IEFkZCBub24tRFQgc3Vw?=
 =?UTF-8?B?cG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Wed, 20 Feb 2013 09:41:22 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361338882.986089809@f173.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361271268.592027245@f310.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1K5fbOE021822

> > ...
> >> >> >> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> >> >> >> >>  {
> >> >> >> >>       struct device_node *syscon_np;
> >> >> >> >>       struct regmap *regmap;
> >> >> >> >> +     struct syscon *syscon;
> >> >> >> >> +     struct device *dev;
> >> >> >> >>
> >> >> >> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
> >> >> >> >> -     if (!syscon_np)
> >> >> >> >> +     if (syscon_np) {
> >> >> >> >> +             regmap = syscon_node_to_regmap(syscon_np);
> >> >> >> >> +             of_node_put(syscon_np);
> >> >> >> >> +
> >> >> >> >> +             return regmap;
> >> >> >> >> +     }
> >> >> >> >> +
> >> >> >> >> +     /* Fallback to search by id_entry.name string */
> >> >> >> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> >> >> >> >> +                              syscon_match_id);
> >> >> >> >> +     if (!dev)
> >> >> >> >>               return ERR_PTR(-ENODEV);
> >> >> >> >>
> >> >> >> >> -     regmap = syscon_node_to_regmap(syscon_np);
> >> >> >> >> -     of_node_put(syscon_np);
> >> >> >> >> +     syscon = dev_get_drvdata(dev);
> >> >> >> >>
> >> >> >> >> -     return regmap;
> >> >> >> >> +     return syscon->regmap;
> >> >> >> >>  }
> >> >> >> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> >> >> >> >
> >> >> >> > Since you are not actually comparing the "compatible" property here,
> >> >> >> > I would suggest adding another function here,
> >> >> >>
> >> >> >> Yes, i also think like that.
> >> >> >
> >> >> > In this case we should provide two paths for drivers which can work as with DT
> >> >> > and without DT.
> >> >>
> >> >> Yes.
> >> >
> >> > I still think the universal procedure is better for the driver.
> >> >
> >>
> >> Why?
> >> I did not see your reply on my other comments on the problems of using universal
> >> procedure?
> >> Please let me know if you think they're not issues.
> >
> > Yes, I do not see a problem here.
> > I will try to show the code.
> >
> > In the driver:
> > struct regmap *r;
> > r = syscon_regmap_lookup_by_compatible("my_super_syscon");
> >
> > For DT case:
> > syscon@123456 {
> >   compatible = "my_super_syscon", "syscon";
> >   ...
> > };
> >
> > For non-DT case:
> > struct platform_device_id id = { .name = "my_super_syscon", };
> > struct platform_device syscon_pdev = {
> >   .name = "syscon",
> >   .id_entry = &id,
> 
> This is really strange to me and i've never seen such using.
> Usually the id_table is provided by the driver and the match process then will
> set the correct id_entry for the platform device once it matches.
> Please see the platform_bus match process: drivers/base/platform.c

Yes, this is non-standard usage. Currently we do not have platform_device_id
entries for a "syscon" driver, so this field is untouched for a platform device
and we can use it. At least this works, but, of course, more experts should
fix me on this question if I think incorrect.

> 
> >   ...
> > };
> > platform_device_register(&syscon_pdev);
> >
> > Do I understand what you mean?
> >
> 
> My understanding for non-dt case is something like:
> In client driver:
> struct regmap *r;
> r = syscon_regmap_lookup_by_pdevname("my_super_syscon");
> 
> In board code:
> struct platform_device syscon_pdev = {
> .name = "my_super_syscon",
> ...
> };
>  platform_device_register(&syscon_pdev);
> 
> In syscon driver:
> static struct platform_device_id syscon_device_ids[] = {
>         {
>                 .name = "my_super_syscon",
>         }, {
>                 /* sentinel */
>         }
> };
> MODULE_DEVICE_TABLE(platform, syscon_device_ids);
> 
> static struct platform_driver syscon_driver = {
>         .driver = {
>                 .name = "syscon",
>                 .owner = THIS_MODULE,
>                 .of_match_table = of_syscon_match,
>         },
>         .id_table       = syscon_device_ids,
>         .probe          = syscon_probe,
>         .remove         = syscon_remove,
> };
> 
> One problem is that every user needs to add their syscon compatible device
> support(platform_device_id) in syscon driver first before they can use it.
> But it looks to me just like how other driver generally does.

I agree, this is a more proper way, but in this case we should create a big table
here with records for each device...

> Arnd,
> Do you think this is an issue?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
