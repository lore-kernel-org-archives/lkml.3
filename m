Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3LEQvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:51:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45407 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab3LEQvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:51:03 -0500
From: "Cortes, Alexis" <alexis.cortes@ti.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>,
        "Vincent Palatin" <vpalatin@chromium.org>
Subject: RE: [PATCH] usb: hub: Use correct reset for wedged USB3 devices
 that are NOTATTACHED
Thread-Topic: [PATCH] usb: hub: Use correct reset for wedged USB3 devices
 that are NOTATTACHED
Thread-Index: AQHO4ZGWIwMPqdqwwU67UO/vDDw2rJom0hOQgB5qaYCAALJSsA==
Date: Thu, 5 Dec 2013 16:50:56 +0000
Message-ID: <31F406F20B26204E8066CA524505279A269D794B@DFLE12.ent.ti.com>
References: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
 <Pine.LNX.4.44L0.1311071026480.1401-100000@iolanthe.rowland.org>
 <20131114233055.GR10371@xanatos>
 <31F406F20B26204E8066CA524505279A269C6840@DFLE12.ent.ti.com>
 <20131205000409.GA10678@xanatos>
In-Reply-To: <20131205000409.GA10678@xanatos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

Sorry for my delayed response, I was on vacation. Although I wasn't able to verify this on an actual system that is susceptible to the compliance mode issue, after reviewing the USB spec, I don't think it is possible that a port can enter compliance mode while a connected device is suspended. Per the spec, the only way to enter to Compliance Mode state is through the Polling state (after the 'first LFPS timeout'). Does this make sense? 

Best Regards,
Alexis Cortes.

-----Original Message-----
From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com] 
Sent: Wednesday, December 04, 2013 6:04 PM
To: Cortes, Alexis
Cc: Alan Stern; Julius Werner; Greg Kroah-Hartman; LKML; linux-usb@vger.kernel.org; Benson Leung; Vincent Palatin
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED


On Tue, Nov 19, 2013 at 02:53:22PM +0000, Cortes, Alexis wrote:
> Hi Sarah,
> 
> Sorry for my delayed response, I just saw your e-mail (it got filtered somehow). About your question: actually I'm not sure, I'll have to check that to confirm it. I'll get back to you with an answer as soon as I have it.

Ping, Alexis: any info on this question?

Sarah Sharp

> -----Original Message-----
> From: Sarah Sharp [mailto:sarah.a.sharp@linux.intel.com]
> Sent: Thursday, November 14, 2013 5:31 PM
> To: Alan Stern
> Cc: Julius Werner; Greg Kroah-Hartman; LKML; 
> linux-usb@vger.kernel.org; Benson Leung; Vincent Palatin; Cortes, 
> Alexis
> Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 
> devices that are NOTATTACHED
> 
> On Thu, Nov 07, 2013 at 10:32:33AM -0500, Alan Stern wrote:
> > On Wed, 6 Nov 2013, Julius Werner wrote:
> > 
> > > > What if the device is in USB_STATE_SUSPENDED?
> > > 
> > > I'm not sure that is possible at that point in hub_events(), I 
> > > don't know of a way that could lead to this situation. I could 
> > > still add the check just to be sure if you want it, though.
> > 
> > I don't know either.  But Sarah has said that ports can 
> > spontaneously go into Compliance Mode for no apparent reason.  If 
> > that can happen, maybe it can happen while the port is in U3 and the 
> > device is suspended.  In such cases, though, you'd need to do a 
> > reset-resume rather than a simple reset.
> 
> Looking at commits c3897aa5386faba77e5bbdf94902a1658d3a5b11 and 71c731a296f1b08a3724bd1b514b64f1bda87a23, it seems that the TI host controllers' ports can go into compliance mode only when a device is inserted.  Once the device is link trained by the redriver, the port shouldn't go into compliance mode.  So we should never see compliance mode on a port with an attached USB device in suspend.
> 
> Alex, can you confirm that the TI host's port won't go into compliance mode while a connected device is suspended?
> 
> > > > Not at all.  If a device is unplugged, its state changes to 
> > > > NOTATTACHED before the driver is unbound.  During that time, the 
> > > > driver will see all its URBs failing, so it may very well try to reset the device.
> > > > (For example, usbhid behaves like this.)  That isn't a bug.
> > > 
> > > Oh, okay, I wasn't quite sure how that plays together. Would you 
> > > think it's still valuable to print it out (maybe as dev_info() 
> > > instead of
> > > dev_warn()) instead of just silently ignoring the reset request? 
> > > It would have certainly been useful for me to find this problem 
> > > faster, but I can take it out again if you think it would result 
> > > in too much noise.
> > 
> > I think keeping dev_dbg() is best.  If you're searching for the 
> > solution to a problem, you should have debugging enabled and so you 
> > ought to see the message.
> > 
> > Alan Stern
> > 
