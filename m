Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAPHEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:04:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:30792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaAPHEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:04:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,666,1384329600"; 
   d="scan'208";a="439661156"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Mark Brown <broonie@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "jarkko.nikula@linux.intel.com" <jarkko.nikula@linux.intel.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 4/4] OF: introduce OF style 'modalias' support for
 platform bus.
Thread-Topic: [PATCH 4/4] OF: introduce OF style 'modalias' support for
 platform bus.
Thread-Index: AQHPEQU79MHqrcjlOkKWxwUFayOYXJqFR+YAgAGoTAA=
Date: Thu, 16 Jan 2014 07:04:19 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B909263011CE77F@SHSMSX101.ccr.corp.intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
	<1389689198-2641-5-git-send-email-rui.zhang@intel.com>
 <CAL_JsqJFRQ+27N_9AwZXpx4V=g8HKn84WdVKtQ_Br_8SQTXY7g@mail.gmail.com>
In-Reply-To: <CAL_JsqJFRQ+27N_9AwZXpx4V=g8HKn84WdVKtQ_Br_8SQTXY7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Wednesday, January 15, 2014 9:45 PM
> To: Zhang, Rui
> Cc: linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org; linux-
> i2c@vger.kernel.org; linux-spi@vger.kernel.org; wsa@the-dreams.de; Mark
> Brown; Greg Kroah-Hartman; Wysocki, Rafael J; Grant Likely; Rob Herring;
> jarkko.nikula@linux.intel.com; mika.westerberg@linux.intel.com;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH 4/4] OF: introduce OF style 'modalias' support for
> platform bus.
> Importance: High
> 
> On Tue, Jan 14, 2014 at 2:46 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> > Fix a problem that, the platform bus supports the OF style modalias
> in
> > .uevent() call, but not in its device 'modalias' sysfs attribute.
> >
> > cc: devicetree@vger.kernel.org
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> As there doesn't appear any dependency with the rest of this series, I
> can take this.
> 
Thanks.

-rui
> One minor nit below.
> 
> > ---
> >  drivers/base/platform.c   |    4 ++++
> >  drivers/of/device.c       |    3 +++
> >  include/linux/of_device.h |    6 ++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c index
> > 2f4aea2..bc78848 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -679,6 +679,10 @@ static ssize_t modalias_show(struct device *dev,
> struct device_attribute *a,
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
> > diff --git a/drivers/of/device.c b/drivers/of/device.c index
> > f685e55..dafb973 100644
> > --- a/drivers/of/device.c
> > +++ b/drivers/of/device.c
> > @@ -85,6 +85,9 @@ ssize_t of_device_get_modalias(struct device *dev,
> char *str, ssize_t len)
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
> >                          dev->of_node->type); diff --git
> > a/include/linux/of_device.h b/include/linux/of_device.h index
> > 82ce324..8d7dd67 100644
> > --- a/include/linux/of_device.h
> > +++ b/include/linux/of_device.h
> > @@ -64,6 +64,12 @@ static inline int of_driver_match_device(struct
> > device *dev,  static inline void of_device_uevent(struct device *dev,
> >                         struct kobj_uevent_env *env) { }
> >
> > +static inline int of_device_get_modalias(struct device *dev,
> > +                                  char *str, ssize_t len) {
> > +       return -ENODEV;
> > +}
> > +
> >  static inline int of_device_uevent_modalias(struct device *dev,
> >                                    struct kobj_uevent_env *env)  {
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe devicetree"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
