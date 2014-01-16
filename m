Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaAPAz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:55:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61270 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752090AbaAPAzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:55:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, wsa@the-dreams.de,
        Mark Brown <broonie@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael.j.wysocki@intel.com, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/4] OF: introduce OF style 'modalias' support for platform bus.
Date: Thu, 16 Jan 2014 02:09:55 +0100
Message-ID: <77231285.q8OGi4Gmjj@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAL_JsqJFRQ+27N_9AwZXpx4V=g8HKn84WdVKtQ_Br_8SQTXY7g@mail.gmail.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com> <1389689198-2641-5-git-send-email-rui.zhang@intel.com> <CAL_JsqJFRQ+27N_9AwZXpx4V=g8HKn84WdVKtQ_Br_8SQTXY7g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 15, 2014 07:45:18 AM Rob Herring wrote:
> On Tue, Jan 14, 2014 at 2:46 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> > Fix a problem that, the platform bus supports the OF style modalias
> > in .uevent() call, but not in its device 'modalias' sysfs attribute.
> >
> > cc: devicetree@vger.kernel.org
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> As there doesn't appear any dependency with the rest of this series, I
> can take this.

Please do, thanks!

> One minor nit below.
> 
> > ---
> >  drivers/base/platform.c   |    4 ++++
> >  drivers/of/device.c       |    3 +++
> >  include/linux/of_device.h |    6 ++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 2f4aea2..bc78848 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -679,6 +679,10 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
> >         struct platform_device  *pdev = to_platform_device(dev);
> >         int len;
> >
> > +       len = of_device_get_modalias(dev, buf, PAGE_SIZE -1);
> > +       if (len != -ENODEV)
> > +               return len;
> > +
> >         len = acpi_device_modalias(dev, buf, PAGE_SIZE -1);
> >         if (len != -ENODEV)
> >                 return len;
> > diff --git a/drivers/of/device.c b/drivers/of/device.c
> > index f685e55..dafb973 100644
> > --- a/drivers/of/device.c
> > +++ b/drivers/of/device.c
> > @@ -85,6 +85,9 @@ ssize_t of_device_get_modalias(struct device *dev, char *str, ssize_t len)
> >         int cplen, i;
> >         ssize_t tsize, csize, repend;
> >
> > +       if ((!dev) || (!dev->of_node))\
> 
> Don't need the parentheses here.
> 
> > +               return -ENODEV;
> > +
> >         /* Name & Type */
> >         csize = snprintf(str, len, "of:N%sT%s", dev->of_node->name,
> >                          dev->of_node->type);
> > diff --git a/include/linux/of_device.h b/include/linux/of_device.h
> > index 82ce324..8d7dd67 100644
> > --- a/include/linux/of_device.h
> > +++ b/include/linux/of_device.h
> > @@ -64,6 +64,12 @@ static inline int of_driver_match_device(struct device *dev,
> >  static inline void of_device_uevent(struct device *dev,
> >                         struct kobj_uevent_env *env) { }
> >
> > +static inline int of_device_get_modalias(struct device *dev,
> > +                                  char *str, ssize_t len)
> > +{
> > +       return -ENODEV;
> > +}
> > +
> >  static inline int of_device_uevent_modalias(struct device *dev,
> >                                    struct kobj_uevent_env *env)
> >  {
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe devicetree" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
