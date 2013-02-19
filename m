Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3BSLuN (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 19 Feb 2013 06:50:13 -0500
Received: from fallback6.mail.ru ([94.100.176.134]:44446 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3BSLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:50:12 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbNl06IFtQQVRDSCB2M10gbWZkOiBzeXNjb246IEFkZCBub24tRFQgc3Vw?=
 =?UTF-8?B?cG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 19 Feb 2013 14:54:28 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361271268.592027245@f310.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361264161.333682302@f131.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1JBoNs0025653

...
> >> >> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> >> >> >>  {
> >> >> >>       struct device_node *syscon_np;
> >> >> >>       struct regmap *regmap;
> >> >> >> +     struct syscon *syscon;
> >> >> >> +     struct device *dev;
> >> >> >>
> >> >> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
> >> >> >> -     if (!syscon_np)
> >> >> >> +     if (syscon_np) {
> >> >> >> +             regmap = syscon_node_to_regmap(syscon_np);
> >> >> >> +             of_node_put(syscon_np);
> >> >> >> +
> >> >> >> +             return regmap;
> >> >> >> +     }
> >> >> >> +
> >> >> >> +     /* Fallback to search by id_entry.name string */
> >> >> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> >> >> >> +                              syscon_match_id);
> >> >> >> +     if (!dev)
> >> >> >>               return ERR_PTR(-ENODEV);
> >> >> >>
> >> >> >> -     regmap = syscon_node_to_regmap(syscon_np);
> >> >> >> -     of_node_put(syscon_np);
> >> >> >> +     syscon = dev_get_drvdata(dev);
> >> >> >>
> >> >> >> -     return regmap;
> >> >> >> +     return syscon->regmap;
> >> >> >>  }
> >> >> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> >> >> >
> >> >> > Since you are not actually comparing the "compatible" property here,
> >> >> > I would suggest adding another function here,
> >> >>
> >> >> Yes, i also think like that.
> >> >
> >> > In this case we should provide two paths for drivers which can work as with DT
> >> > and without DT.
> >>
> >> Yes.
> >
> > I still think the universal procedure is better for the driver.
> >
> 
> Why?
> I did not see your reply on my other comments on the problems of using universal
> procedure?
> Please let me know if you think they're not issues.

Yes, I do not see a problem here.
I will try to show the code.

In the driver:
struct regmap *r;
r = syscon_regmap_lookup_by_compatible("my_super_syscon");

For DT case:
syscon@123456 {
  compatible = "my_super_syscon", "syscon";
  ...
};

For non-DT case:
struct platform_device_id id = { .name = "my_super_syscon", };
struct platform_device syscon_pdev = {                                           
  .name = "syscon",
  .id_entry = &id,
  ...
};
platform_device_register(&syscon_pdev);

Do I understand what you mean?
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
