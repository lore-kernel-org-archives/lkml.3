Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaJMXrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 19:47:18 -0400
Received: from mail-bn1bon0093.outbound.protection.outlook.com ([157.56.111.93]:44917
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894AbaJMXrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 19:47:16 -0400
Date: Mon, 13 Oct 2014 16:47:07 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Alexandre Courbot <gnurou@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH RESEND] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1409853506-26279-1-git-send-email-soren.brinkmann@xilinx.com>
 <CAAVeFuJdCd9Wx+Fq3_9okcnyva70zhZJ5njOho8pmPfgWG3+nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVeFuJdCd9Wx+Fq3_9okcnyva70zhZJ5njOho8pmPfgWG3+nA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21020.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <6c5c08b2a2924366ac79837e89d3a0ed@BL2FFO11FD056.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(52604005)(51704005)(189002)(52044002)(164054003)(377454003)(53754006)(377424004)(110136001)(104016003)(4396001)(83506001)(50986999)(15975445006)(54356999)(76176999)(108616004)(87936001)(102836001)(85306004)(85182001)(85852003)(44976005)(19580405001)(6806004)(19580395003)(95666004)(50466002)(74316001)(85202003)(21056001)(107046002)(77096002)(106466001)(120916001)(23676002)(53416004)(80022003)(46102003)(99396003)(31966008)(1411001)(92566001)(86362001)(76482002)(20776003)(64706001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB028;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB028;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03630A6A4A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Sat, 2014-10-11 at 01:54PM +0900, Alexandre Courbot wrote:
> On Fri, Sep 5, 2014 at 2:58 AM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> > marking/unmarking a GPIO as wake IRQ.
> > The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> > is associated with that GPIO and the irqchip implements set_wake().
> > Writing 'enabled' to that file will enable wake for that GPIO, while
> > writing 'disabled' will disable wake.
> > Reading that file will return either 'disabled' or 'enabled' depening on
> > the currently set flag for the GPIO's IRQ.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > Hi all,
> >
> > I originally submitted this patch with a few fixes for Zynq's GPIO driver
> > (https://lkml.org/lkml/2014/8/29/391). Since this change is not just
> > Zynq-related and has broader impact, Linus asked me to post this again, separate
> > from the Zynq series.
> >
> > Let me just quote myself from the original submission:
> > "I'm still not fully convinced that the gpio_keys are the best
> > replacement for the sysfs interface when it comes to inputs. For that
> > reason and to have a way to do some quick wake testing, I'd like to
> > propose adding the ability to control wake through the sysfs interface
> > (patch 3)."
> 
> I'm really sorry that I did not provide feedback sooner.  This is the
> kind of area (IRQ) where I am not too confident and typically like to
> hear what Linus has to say first. But I also have a few questions that
> you could maybe answer for my own education. :)
> 
> >
> >         Thanks,
> >         Sören
> >
> >  drivers/gpio/gpiolib-sysfs.c | 75 ++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 69 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
> > index 5f2150b619a7..aaf021eaaff5 100644
> > --- a/drivers/gpio/gpiolib-sysfs.c
> > +++ b/drivers/gpio/gpiolib-sysfs.c
> > @@ -286,6 +286,56 @@ found:
> >
> >  static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
> >
> > +static ssize_t gpio_wakeup_show(struct device *dev,
> > +               struct device_attribute *attr, char *buf)
> > +{
> > +       ssize_t                 status;
> > +       const struct gpio_desc  *desc = dev_get_drvdata(dev);
> > +       int                     irq = gpiod_to_irq(desc);
> > +       struct irq_desc         *irq_desc = irq_to_desc(irq);
> > +
> > +       mutex_lock(&sysfs_lock);
> > +
> > +       if (irqd_is_wakeup_set(&irq_desc->irq_data))
> > +               status = sprintf(buf, "enabled\n");
> > +       else
> > +               status = sprintf(buf, "disabled\n");
> > +
> > +       mutex_unlock(&sysfs_lock);
> > +
> > +       return status;
> > +}
> > +
> > +static ssize_t gpio_wakeup_store(struct device *dev,
> > +               struct device_attribute *attr, const char *buf, size_t size)
> > +{
> > +       int                     ret;
> > +       unsigned int            on;
> > +       struct gpio_desc        *desc = dev_get_drvdata(dev);
> > +       int                     irq = gpiod_to_irq(desc);
> > +
> > +       mutex_lock(&sysfs_lock);
> > +
> > +       if (sysfs_streq("enabled", buf))
> > +               on = true;
> > +       else if (sysfs_streq("disabled", buf))
> > +               on = false;
> > +       else
> > +               return -EINVAL;
> 
> You forgot to release sysfs_lock before returning here.

Right, I will fix this and send a v2. Good catch.

> 
> > +
> > +       ret = irq_set_irq_wake(irq, on);
> 
> Just wondering: is it always safe to set the wake property of an IRQ
> even if the direction of its associated GPIO is output? Does it make
> sense at all to have the "wakeup" attribute file visible if the GPIO
> is an output one?
> 
> > +
> > +       mutex_unlock(&sysfs_lock);
> > +
> > +       if (ret)
> > +               pr_warn("%s: failed to %s wake\n", __func__,
> > +                               on ? "enable" : "disable");
> > +
> > +       return size;
> > +}
> > +
> > +static DEVICE_ATTR(wakeup, 0644, gpio_wakeup_show, gpio_wakeup_store);
> > +
> >  static int sysfs_set_active_low(struct gpio_desc *desc, struct device *dev,
> >                                 int value)
> >  {
> > @@ -526,7 +576,7 @@ static struct class gpio_class = {
> >  int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
> >  {
> >         unsigned long           flags;
> > -       int                     status;
> > +       int                     status, irq;
> >         const char              *ioname = NULL;
> >         struct device           *dev;
> >         int                     offset;
> > @@ -582,11 +632,24 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
> >                         goto fail_unregister_device;
> >         }
> >
> > -       if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
> > -                                      !test_bit(FLAG_IS_OUT, &desc->flags))) {
> > -               status = device_create_file(dev, &dev_attr_edge);
> > -               if (status)
> > -                       goto fail_unregister_device;
> > +       irq = gpiod_to_irq(desc);
> > +       if (irq >= 0) {
> > +               struct irq_desc *irq_desc = irq_to_desc(irq);
> > +               struct irq_chip *irqchip = irq_desc_get_chip(irq_desc);
> > +
> > +               if (direction_may_change ||
> > +                               !test_bit(FLAG_IS_OUT, &desc->flags)) {
> > +                       status = device_create_file(dev, &dev_attr_edge);
> > +                       if (status)
> > +                               goto fail_unregister_device;
> > +               }
> > +
> > +               if (irqchip->flags & IRQCHIP_SKIP_SET_WAKE ||
> > +                               irqchip->irq_set_wake) {
> > +                       status = device_create_file(dev, &dev_attr_wakeup);
> > +                       if (status)
> > +                               goto fail_unregister_device;
> > +               }
> 
> Ok, I guess that answers my question. The edge property is always
> visible so it probably doesn't hurt if the wakeup property also is.

Right, it is probably not optimal, but serves the purpose. Users still
might have to turn on their brain. But in general, setting those
properties should be safe, IMHO.
I think being able to mess with GPIO's direction and value is a much
bigger risk since they might be used for something more critical than
just LEDs :)
So, this does not really add a lot of more potential to break things :)

> 
> The only thing that bothers me a little bit is that both "edge" and
> "wakeup" are not very explicit names, but I guess it can't be helped.

I guess edge is ABI and that ship has sailed. For 'wakeup' we can still
discuss the name. But wakeup is the standard property that is exposed in
sysfs for other devices that support wake and choose to expose
user-space control for it. So, I thought 'wakeup' would be appropriate
here as well.

> 
> Typically I am not too fond of adding features to this sysfs
> interface, but since this patch is purely local to gpiolib-sysfs.c and
> exposes a property that is arguably not less worthy that the others to
> be exposed, I'm ok with it.
> 
> Once the lock issue I mentioned above is fixed, please feel free to add my
> 
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

Thanks for reviewing.

	Sören
