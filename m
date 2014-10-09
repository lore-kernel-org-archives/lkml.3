Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaJINTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:19:37 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:51900 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbaJINT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:19:26 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 9 Oct 2014 15:16:36 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 1/4] mfd: add support for Diolan DLN-2 devices
Message-ID: <20141009131636.GO1990@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
 <1411661254-5204-2-git-send-email-octavian.purdila@intel.com>
 <20141008092347.GB1990@localhost>
 <CAE1zotKHq1Fj_AqKzfnBHoypetb6Yz3OsHnqfeHN5PrVJtuHVw@mail.gmail.com>
 <20141008120410.GE1990@localhost>
 <CAE1zot+muJn5ngxpq8LeF9J+7kZqCiStzvcxLLP0wf08TjWG4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zot+muJn5ngxpq8LeF9J+7kZqCiStzvcxLLP0wf08TjWG4A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:33:28PM +0300, Octavian Purdila wrote:
> On Wed, Oct 8, 2014 at 3:04 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Wed, Oct 08, 2014 at 01:54:07PM +0300, Octavian Purdila wrote:
> >> On Wed, Oct 8, 2014 at 12:23 PM, Johan Hovold <johan@kernel.org> wrote:
> >> > On Thu, Sep 25, 2014 at 07:07:31PM +0300, Octavian Purdila wrote:
> >> >
> >> >> +static void dln2_rx_transfer(struct dln2_dev *dln2, struct urb *urb,
> >> >> +                          u16 handle, u16 rx_slot)
> >> >> +{
> >> >> +     struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> >> >> +     struct dln2_rx_context *rxc;
> >> >> +     struct device *dev = &dln2->interface->dev;
> >> >> +
> >> >> +     spin_lock(&rxs->lock);
> >> >
> >> > You must use spin_lock_irqsave here as you call it from the completion
> >> > handler.
> >>
> >> Why? AFAICS the completion handler gets called from the HCD irq handler:
> >
> > The completion handler is currently called with local interrupts
> > disabled but that is about to change once all drivers have been updated:
> >
> >         http://marc.info/?l=linux-usb&m=137353360511003&w=2
> >
> > In this case you could probably get away with not disabling interrupts
> > anyway, but using the irqsave versions would make it obvious.
> >
> 
> I was not assuming that interrupts are disabled while running the
> completion handler. Since that spinlock is not touched by any other
> interrupt context code I don't think irqsave is necessary.

No, it isn't necessary so leave it as it is.

But you are exporting interfaces to other drivers and it may appear to
someone that those could possibly end up indirectly calling a function
taking that lock in IRQ context. We know that isn't the case now, but I
bet someone will post conversion patch for that spinlock at some point.
;)

Johan
