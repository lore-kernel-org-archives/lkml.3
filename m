Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3FGHmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:42:55 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.115]:56862 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab3FGHmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:42:53 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-2.tower-194.messagelabs.com!1370590970!2243769!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 07 Jun 2013 09:42:50 +0200
Date: Fri, 7 Jun 2013 09:45:19 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Some problems with sysfs patch (was Re: [PATCH v6] watchdog: New
 watchdog driver for MEN A21 watchdogs)
Message-ID: <20130607074519.GA26046@jtlinux>
References: <20130531103654.GB5619@roeck-us.net>
 <20130531110846.GA15707@jtlinux>
 <20130531114037.GA13533@roeck-us.net>
 <20130531125519.GB8983@jtlinux>
 <20130601041523.GB4081@roeck-us.net>
 <20130603095026.GA21720@jtlinux>
 <20130606105103.GA25245@jtlinux>
 <20130606113110.GA5834@roeck-us.net>
 <20130606130055.GA27244@jtlinux>
 <20130606170828.GA30898@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130606170828.GA30898@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 07 Jun 2013 07:42:50.0054 (UTC) FILETIME=[9C44B660:01CE6352]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:08:28AM -0700, Guenter Roeck wrote:
> On Thu, Jun 06, 2013 at 03:00:55PM +0200, Johannes Thumshirn wrote:
> > On Thu, Jun 06, 2013 at 04:31:10AM -0700, Guenter Roeck wrote:
> > > On Thu, Jun 06, 2013 at 12:51:03PM +0200, Johannes Thumshirn wrote:
> > > > On Mon, Jun 03, 2013 at 11:50:26AM +0200, Johannes Thumshirn wrote:
> > > > > On Fri, May 31, 2013 at 09:15:23PM -0700, Guenter Roeck wrote:
> > > > > > On Fri, May 31, 2013 at 02:55:19PM +0200, Johannes Thumshirn wrote:
> > > > > > > Hi Guenther,
> > > > > > > On Fri, May 31, 2013 at 04:40:37AM -0700, Guenter Roeck wrote:
> > > > > > > > > +#define GPIO_WD_ENAB	169
> > > > > > > > > +#define GPIO_WD_FAST	170
> > > > > > > > > +#define GPIO_WD_TRIG	171
> > > > > > > > > +
> > > > > > > > > +#define GPIO_RST_CAUSE_BASE 166
> > > > > > > > > +
> > > > > > > >
> > > > > > > > I think I asked that before ... as you are supporting devicetree, gpio pins
> > > > > > > > should really be provided through devicetree properties and not be hardcoded.
> > > > > > > >
> > > > > > > Yes you did and I didn't come up with a solution to this problem yet. I understand
> > > > > > > and agree to your concerns but I'm lacking example code/documentation for it, maybe
> > > > > > > you can point me to an example on that and then I'll update my code accordingly.
> > > > > > >
> > > > > >
> > > > > > Have a look at Documentation/devicetree/bindings/gpio/gpio-fan.txt and
> > > > > > drivers/hwmon/gpio-fan.c.
> > > > >
> > > > > Thanks a lot, this really helped me out. Updated patch is comming today
> > > > > including the bindings document Arnd Bergmann requested. I only need to rebase
> > > > > the sysfs patch on top of that changes.
> > > > >
> > > > > Regards,
> > > > > Johannes
> > > >
> > > > Regarding the sysfs patch, I have a funny effect in my (rebased) sysfs code.
> > > >
> > > > Given the following code:
> > > >
> > > > +static ssize_t rebootcause_show(struct device *dev,
> > > > +                               struct device_attribute *attr,
> > > > +                               char *buf)
> > > > +{
> > > > +       struct a21_wdt_drv *drv = dev_get_drvdata(dev);
> > > > +       unsigned int reset = 0;
> > > > +
> > > > +       if (!drv)
> > > > +               return -EIO;
> > > > +
> > > > +       reset = a21_wdt_get_bootstatus(drv);
> > > > +
> > > > +       return sprintf(buf, "%s\n", reset_causes[reset]);
> > > > +}
> > > > +static DEVICE_ATTR(rebootcause, S_IRUGO, rebootcause_show, NULL);
> > > >
> > > > I actually need the check for if (!drv) to prevent an OOPS, as
> > > > dev_get_drvdata(dev) returns NULL., though it is set at the end of my probe
> > > > function via:
> > > >
> > > > [...]
> > > > +       ret = watchdog_register_device(&a21_wdt);
> > > > +       if (ret) {
> > > > +               dev_err(&pdev->dev, "Cannot register watchdog device\n");
> > > > +               goto err_register_wd;
> > > > +       }
> > > > +
> > > > +       dev_set_drvdata(&pdev->dev, drv);
> > > > +
> > > > +       return 0;
> > > > [...]
> > > >
> > > > The watchdog driver itself is working without any troubles.
> > > >
> > > > Some advice here would be worth its weight in gold.
> > > >
> > > It has to be set before the attribute is created. Are you doing that ? Also, is
> > > 'dev' the same device pointer (ie is the 'dev' in your function the same as
> > > &pdev->dev) ?
> > >
> > > Guenter
> >
> > Hi Guenter,
> >
> > Thanks for the quick reply. Indeed 'dev' in my function is a struct
> > watchdog_device's dev (for device_create_file) and not &pdev->dev. Which in turn
> > are not the same.
> >
> > A call to dev_set_drvdata(a21_wdt.dev, drv); solved the NULL pointer access. So
> > last question, is it save to set the drvdata of a dev inside the struct
> > watchdog_device or do I break something vital that way?
> >
> Good question. At issue is if your driver 'owns' struct watchdog_device,
> or if the watchdog core owns it.
>
> However, since you know that a21_wdt.dev is the device, you can use
> container_of() to get a reference to a21_wdt, and watchdog_get_drvdata
> to get access to drv from a21_wdt. So you should not really need it.
>
> Thanks,
> Guenter

OK, but doesn't the container_of() macro only work if the parent struct embeds
the child struct and not a pointer to it? But struct watchdog_device only has a
pointer to a struct device (checked my 3.10-rc4 as well as watchdog-next/master,
just in case I missed something).

This would also explain my compiler warnings about "initialization from
incompatible pointer type" when compiling this pice code:

static inline struct a21_wdt_drv *to_a21_wdt_drv(struct device *dev)
{
        struct watchdog_device *wdt = container_of(dev, struct watchdog_device, dev);
        struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);

        return drv;
}

Regards,
Johannes
