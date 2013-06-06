Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3FFKsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:48:41 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.116]:32770 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932141Ab3FFKsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:48:38 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-194.messagelabs.com!1370515714!12681379!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 06 Jun 2013 12:48:34 +0200
Date: Thu, 6 Jun 2013 12:51:03 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Guenter Roeck <linux@roeck-us.net>, <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: Some problems with sysfs patch (was Re: [PATCH v6] watchdog: New
 watchdog driver for MEN A21 watchdogs)
Message-ID: <20130606105103.GA25245@jtlinux>
References: <20130531103654.GB5619@roeck-us.net>
 <20130531110846.GA15707@jtlinux>
 <20130531114037.GA13533@roeck-us.net>
 <20130531125519.GB8983@jtlinux>
 <20130601041523.GB4081@roeck-us.net>
 <20130603095026.GA21720@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130603095026.GA21720@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 06 Jun 2013 10:48:33.0968 (UTC) FILETIME=[64254B00:01CE62A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:50:26AM +0200, Johannes Thumshirn wrote:
> On Fri, May 31, 2013 at 09:15:23PM -0700, Guenter Roeck wrote:
> > On Fri, May 31, 2013 at 02:55:19PM +0200, Johannes Thumshirn wrote:
> > > Hi Guenther,
> > > On Fri, May 31, 2013 at 04:40:37AM -0700, Guenter Roeck wrote:
> > > > > +#define GPIO_WD_ENAB	169
> > > > > +#define GPIO_WD_FAST	170
> > > > > +#define GPIO_WD_TRIG	171
> > > > > +
> > > > > +#define GPIO_RST_CAUSE_BASE 166
> > > > > +
> > > >
> > > > I think I asked that before ... as you are supporting devicetree, gpio pins
> > > > should really be provided through devicetree properties and not be hardcoded.
> > > >
> > > Yes you did and I didn't come up with a solution to this problem yet. I understand
> > > and agree to your concerns but I'm lacking example code/documentation for it, maybe
> > > you can point me to an example on that and then I'll update my code accordingly.
> > >
> >
> > Have a look at Documentation/devicetree/bindings/gpio/gpio-fan.txt and
> > drivers/hwmon/gpio-fan.c.
>
> Thanks a lot, this really helped me out. Updated patch is comming today
> including the bindings document Arnd Bergmann requested. I only need to rebase
> the sysfs patch on top of that changes.
>
> Regards,
> Johannes

Regarding the sysfs patch, I have a funny effect in my (rebased) sysfs code.

Given the following code:

+static ssize_t rebootcause_show(struct device *dev,
+                               struct device_attribute *attr,
+                               char *buf)
+{
+       struct a21_wdt_drv *drv = dev_get_drvdata(dev);
+       unsigned int reset = 0;
+
+       if (!drv)
+               return -EIO;
+
+       reset = a21_wdt_get_bootstatus(drv);
+
+       return sprintf(buf, "%s\n", reset_causes[reset]);
+}
+static DEVICE_ATTR(rebootcause, S_IRUGO, rebootcause_show, NULL);

I actually need the check for if (!drv) to prevent an OOPS, as
dev_get_drvdata(dev) returns NULL., though it is set at the end of my probe
function via:

[...]
+       ret = watchdog_register_device(&a21_wdt);
+       if (ret) {
+               dev_err(&pdev->dev, "Cannot register watchdog device\n");
+               goto err_register_wd;
+       }
+
+       dev_set_drvdata(&pdev->dev, drv);
+
+       return 0;
[...]

The watchdog driver itself is working without any troubles.

Some advice here would be worth its weight in gold.

Thanks,
Johannes
