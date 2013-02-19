Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab3BSKuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:50:32 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43179 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3BSKua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:50:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[2]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Tue, 19 Feb 2013 10:49:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <dong.aisheng@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302181602.47157.arnd@arndb.de> <1361257381.497560655@f376.mail.ru>
In-Reply-To: <1361257381.497560655@f376.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302191049.31327.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013, Alexander Shiyan wrote:
> Hello.
> 
> Strange, but I not received an original answer from Arnd, have only this mail.

I got a reject notice from mail.ru, which apparently didn't like the
SMTP server of my German ISP. I already tried to resend my mail to you,
and now try to send it out through the gmail server. Please let me know
if you get it.

> > >> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> > >> index 4a7ed5a..3c0abcb 100644
> > >> --- a/drivers/mfd/syscon.c
> > >> +++ b/drivers/mfd/syscon.c
> > >
> > > Hi Alexander,
> > >
> > >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> > >>  {
> > >>       struct device_node *syscon_np;
> > >>       struct regmap *regmap;
> > >> +     struct syscon *syscon;
> > >> +     struct device *dev;
> > >>
> > >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
> > >> -     if (!syscon_np)
> > >> +     if (syscon_np) {
> > >> +             regmap = syscon_node_to_regmap(syscon_np);
> > >> +             of_node_put(syscon_np);
> > >> +
> > >> +             return regmap;
> > >> +     }
> > >> +
> > >> +     /* Fallback to search by id_entry.name string */
> > >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > >> +                              syscon_match_id);
> > >> +     if (!dev)
> > >>               return ERR_PTR(-ENODEV);
> > >>
> > >> -     regmap = syscon_node_to_regmap(syscon_np);
> > >> -     of_node_put(syscon_np);
> > >> +     syscon = dev_get_drvdata(dev);
> > >>
> > >> -     return regmap;
> > >> +     return syscon->regmap;
> > >>  }
> > >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> > >
> > > Since you are not actually comparing the "compatible" property here,
> > > I would suggest adding another function here,
> > 
> > Yes, i also think like that.
> 
> In this case we should provide two paths for drivers which can work as with DT
> and without DT. In my case we can use platform_device_id.name field with
> "compatible" string. My way in this case is transparency for driver which is
> using "syscon".

But drivers should use the _by_phandle variant normally, which does
not work without DT, so you already have separate code paths.

	Arnd
