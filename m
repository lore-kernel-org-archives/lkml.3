Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3KNXbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:31:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:38936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3KNXbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:31:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409050137"
Date: Thu, 14 Nov 2013 15:30:55 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "Alexis R. Cortes" <alexis.cortes@ti.com>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
Message-ID: <20131114233055.GR10371@xanatos>
References: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
 <Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 10:32:33AM -0500, Alan Stern wrote:
> On Wed, 6 Nov 2013, Julius Werner wrote:
> 
> > > What if the device is in USB_STATE_SUSPENDED?
> > 
> > I'm not sure that is possible at that point in hub_events(), I don't
> > know of a way that could lead to this situation. I could still add the
> > check just to be sure if you want it, though.
> 
> I don't know either.  But Sarah has said that ports can spontaneously
> go into Compliance Mode for no apparent reason.  If that can happen,
> maybe it can happen while the port is in U3 and the device is
> suspended.  In such cases, though, you'd need to do a reset-resume
> rather than a simple reset.

Looking at commits c3897aa5386faba77e5bbdf94902a1658d3a5b11 and
71c731a296f1b08a3724bd1b514b64f1bda87a23, it seems that the TI host
controllers' ports can go into compliance mode only when a device is
inserted.  Once the device is link trained by the redriver, the port
shouldn't go into compliance mode.  So we should never see compliance
mode on a port with an attached USB device in suspend.

Alex, can you confirm that the TI host's port won't go into compliance
mode while a connected device is suspended?

> > > Not at all.  If a device is unplugged, its state changes to NOTATTACHED
> > > before the driver is unbound.  During that time, the driver will see
> > > all its URBs failing, so it may very well try to reset the device.
> > > (For example, usbhid behaves like this.)  That isn't a bug.
> > 
> > Oh, okay, I wasn't quite sure how that plays together. Would you think
> > it's still valuable to print it out (maybe as dev_info() instead of
> > dev_warn()) instead of just silently ignoring the reset request? It
> > would have certainly been useful for me to find this problem faster,
> > but I can take it out again if you think it would result in too much
> > noise.
> 
> I think keeping dev_dbg() is best.  If you're searching for the
> solution to a problem, you should have debugging enabled and so you
> ought to see the message.
> 
> Alan Stern
> 
