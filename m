Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbaJHMHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:07:05 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:56111 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbaJHMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:07:02 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 8 Oct 2014 14:04:10 +0200
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
Message-ID: <20141008120410.GE1990@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
 <1411661254-5204-2-git-send-email-octavian.purdila@intel.com>
 <20141008092347.GB1990@localhost>
 <CAE1zotKHq1Fj_AqKzfnBHoypetb6Yz3OsHnqfeHN5PrVJtuHVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotKHq1Fj_AqKzfnBHoypetb6Yz3OsHnqfeHN5PrVJtuHVw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:54:07PM +0300, Octavian Purdila wrote:
> On Wed, Oct 8, 2014 at 12:23 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Thu, Sep 25, 2014 at 07:07:31PM +0300, Octavian Purdila wrote:
> >
> >> +static void dln2_rx_transfer(struct dln2_dev *dln2, struct urb *urb,
> >> +                          u16 handle, u16 rx_slot)
> >> +{
> >> +     struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
> >> +     struct dln2_rx_context *rxc;
> >> +     struct device *dev = &dln2->interface->dev;
> >> +
> >> +     spin_lock(&rxs->lock);
> >
> > You must use spin_lock_irqsave here as you call it from the completion
> > handler.
> 
> Why? AFAICS the completion handler gets called from the HCD irq handler:

The completion handler is currently called with local interrupts
disabled but that is about to change once all drivers have been updated: 

	http://marc.info/?l=linux-usb&m=137353360511003&w=2

In this case you could probably get away with not disabling interrupts
anyway, but using the irqsave versions would make it obvious.

> >> +static void dln2_disconnect(struct usb_interface *interface)
> >> +{
> >> +     struct dln2_dev *dln2 = usb_get_intfdata(interface);
> >> +     int i, j;
> >> +
> >> +     /* don't allow starting new transfers */
> >> +     spin_lock(&dln2->disconnect_lock);
> >> +     dln2->disconnect = true;
> >> +     spin_unlock(&dln2->disconnect_lock);
> >> +
> >> +     /* cancel in progress transfers */
> >> +     for (i = 0; i < DLN2_HANDLES; i++) {
> >> +             struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[i];
> >> +             unsigned long flags;
> >> +
> >> +             spin_lock_irqsave(&rxs->lock, flags);
> >
> > Just stick to spin_lock in this function.
> 
> AFAICS disconnect is called from a kernel thread. Are there guarantees
> that we can't get a call to the completion routine while we are
> running it?

Brain fart, nevermind.

Johan
