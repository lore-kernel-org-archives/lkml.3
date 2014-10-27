Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaJ0OkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:40:12 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60741 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaJ0OkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:40:08 -0400
Date: Mon, 27 Oct 2014 15:36:58 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v8 1/4] mfd: add support for Diolan DLN-2 devices
Message-ID: <20141027143658.GB2006@localhost>
References: <1413384491-23703-1-git-send-email-octavian.purdila@intel.com>
 <1413384491-23703-2-git-send-email-octavian.purdila@intel.com>
 <20141023151643.GA7270@localhost>
 <CAE1zotKUk-LjLtb3X1tOdc+Xr4uiqn_Uxz8LKLpdQk59SWQ4hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotKUk-LjLtb3X1tOdc+Xr4uiqn_Uxz8LKLpdQk59SWQ4hA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 03:21:10PM +0200, Octavian Purdila wrote:
> On Thu, Oct 23, 2014 at 6:16 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Wed, Oct 15, 2014 at 05:48:08PM +0300, Octavian Purdila wrote:

> > > +struct dln2_event_cb_entry {
> > > +     struct list_head list;
> > > +     u16 id;
> > > +     struct platform_device *pdev;
> > > +     dln2_event_cb_t callback;
> > > +};
> > > +
> > > +int dln2_register_event_cb(struct platform_device *pdev, u16 id,
> > > +                        dln2_event_cb_t rx_cb)
> > > +{
> > > +     struct dln2_dev *dln2 = dev_get_drvdata(pdev->dev.parent);
> > > +     struct dln2_event_cb_entry *i, *new_cb;
> >
> > Can you use a name which does not have the same suffix as the actual
> > callback function (i.e. "_cb"). Just call it "entry" or something.
> >
> 
> OK.
> 
> > > +     unsigned long flags;
> > > +     int ret = 0;
> > > +
> > > +     new_cb = kmalloc(sizeof(*new_cb), GFP_KERNEL);
> >
> > Use kzalloc here.
> 
> Why kzalloc? All of the fields are initialized below.

It's good practise to clear any data structure at allocation. The cost
is negligible.
 
> > > +     if (!new_cb)
> > > +             return -ENOMEM;
> > > +
> > > +     new_cb->id = id;
> > > +     new_cb->callback = rx_cb;
> > > +     new_cb->pdev = pdev;
> > > +
> > > +     spin_lock_irqsave(&dln2->event_cb_lock, flags);
> > > +
> > > +     list_for_each_entry(i, &dln2->event_cb_list, list) {
> > > +             if (i->id == id) {
> > > +                     ret = -EBUSY;
> > > +                     break;
> > > +             }
> > > +     }
> > > +
> > > +     if (!ret)
> > > +             list_add_rcu(&new_cb->list, &dln2->event_cb_list);
> > > +
> > > +     spin_unlock_irqrestore(&dln2->event_cb_lock, flags);
> > > +
> > > +     if (ret)
> > > +             kfree(new_cb);
> > > +
> > > +     return ret;
> > > +}
> > > +EXPORT_SYMBOL(dln2_register_event_cb);

> > > +     ret = mfd_add_hotplug_devices(dev, dln2_devs, ARRAY_SIZE(dln2_devs));
> >
> > So this now depends on 15bb4d6e8534 ("mfd: core: Add helper function to
> > register hotplug devices") in the MFD tree.
> >
> > Please mention what tree the patch is against in your cover letter (I
> > noticed you had rebased when it no longer applied to 3.17).
> >
> > You should drop the gpiolib patch now that v3.18-rc1 is out as well.
> 
> This series is based against the Lee's for-mfd-next-v3.19 tree that
> does not yet contain the gpiolib patch.

Ok, but make sure to include that information in the cover letter.

Johan
