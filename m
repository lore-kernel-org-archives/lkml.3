Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3IWC2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:28:03 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47180 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753069Ab3IWC2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:28:01 -0400
Date: Sun, 22 Sep 2013 22:28:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kurt Garloff <kurt@garloff.de>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb/core/devio.c:tolerate wrong direction flag in control
 endpoints
In-Reply-To: <2dd04636-8439-4823-9383-a82583849b53@email.android.com>
Message-ID: <Pine.LNX.4.44L0.1309222206520.7047-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep 2013, Kurt Garloff wrote:

> Hi Alan,
> 
> thanks for your review and your constructive comments!

You're welcome.

> >> Hi,
> >> 
> >> USB devio rejects control messages when the index does not have the
> >> direction bit set correctly.
> >
> >I wouldn't describe it that way.  It would be more accurate to say that
> >the message is rejected when wIndex contains an invalid endpoint
> >address.
> 
> Well, this seems to be a question of terminology, no?
> I saw the endpoint byte as consisting of endpoint index plus the direction bit.

See the entry for "Endpoint Address" in Chapter 2 (Terms and 
Abbreviations) of the USB 2.0 specification.  The definition says:

	The combination of an endpoint number and an endpoint direction
	on a USB device. Each endpoint address supports data transfer
	in one direction.

> >> This breaks windows apps in KVM -- and might be overly strict
> >according
> >> to my reading of USB HID spec.
> >
> >It is not overly strict.
> 
> OK, you certainly know the USB specs better than I do.
> 
> If the message is not according to spec because the windex byte (which
> should reference the endpoint) has the endpoint direction flag wrong,
> then the question may become whether the kernel should reject it or
> leave that to the device.
> Rejecting by the kernel has the risk that somewhat non-compliant devices
> with somewhat non-compliant (userspace) drivers are prevented from working.
> While not rejecting has the risk that overly sensitive devices might freak out
> on receiving a non-compliant transfer. The fact that Win does not not seem to
> filter here however might make that risk rather small.
> (Long years have taught us that companies don't test against the spec but this
>  "OS" from Redmond.)

This is a good explanation of why the patch should be accepted.

> >>     From: Kurt Garloff <kurt@garloff.de>
> >>     Subject: Tolerate wrong direction bit endpoint index for control messages
> >>     Signed-off-by: Kurt Garloff <kurt@garloff.de>
> >>     
> >>     Trying to read data from the Pegasus Technologies NoteTaker (0e20:0101)
> >>     [1] with the Windows App (EasyNote) works natively but fails when
> >>     WIndows is running under KVM (and the USB device handed to KVM).
> >>     
> >>     The reason is a USB control message
> >>      usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200 wIndex=0001 wLength=0008
> >>     This goes to endpoint 1 (wIndex), however, the endpoint is an input
> >>     endpoint and thus enumerated 0x81.
> >>     
> >>     The kernel thus rejects the IO and thus we see the failure.
> >>     
> >>     Apparently, Linux is more strict here than Windows ... we can't change
> >>     the Win app easily, so that's a problem.
> >
> >Indeed, this indicates that the device itself is also buggy.  If it 
> >worked correctly, it would reject the incorrect control message.
> 
> It seems to interpret wIndex differently indeed. Not sure whether
> that qualifies as a bug or not. Maybe it should not claim to be a
> HID device then?

Maybe not.  This particular combination of bRequestType and bRequest 
values (0x22, 0x09) is not defined in the HID 1.11 spec.  Do you know 
if it is defined somewhere else?

> Looking at the code, it seems that printers do something strange
> here, and it might be that the device in question here is not 100%
> HID in that it also assumes a non-standard meaning to this byte.
> 
> Strange enough, the app does want to talk to the control interface it seems:
> Sep 19 09:47:21 nehalem kernel: [44539.730269] usb 4-2.2: usbdev_do_ioctl: SUBMITURB
> Sep 19 09:47:21 nehalem kernel: [44539.730276] usb 4-2.2: proc_submiturb: URB 02 00 0 00000000 0000000001a83420 16 0
> Sep 19 09:47:21 nehalem kernel: [44539.730280] usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200 wIndex=0001 wLength=0008
> Sep 19 09:47:21 nehalem kernel: [44539.730285] usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01 but needs 81 (or 00)
> Sep 19 09:47:21 nehalem kernel: [44539.730290] usb 4-2.2: userurb 0000000001b56f00, ep0 ctrl-out, length 8
> Sep 19 09:47:21 nehalem kernel: [44539.730294] data: 02 01 b5 00 00 00 00 00                                                                          ........
> Sep 19 09:47:21 nehalem kernel: [44539.730301] usb 4-2.2: proc_submiturb: return 0
> 
> The second line here comes from instrumentation I have inserted in proc_submiturb():
> 
>         snoop(&ps->dev->dev, "%s: URB %02x %02x %i %08x %p %i %i\n",
>                 __func__, uurb.type, uurb.endpoint, uurb.status,
>                 uurb.flags, uurb.buffer, uurb.buffer_length,
>                 uurb.actual_length);
> 
> and it shows that uurb.endpoint actually is set to 0.

That's right.  The URB is sent to endpoint 0.  The value in
bRequestType indicates that the recipient of the request is an
endpoint, and the value of wIndex indicates which endpoint.  So even
though the request is sent to endpoint 0, it actually refers to
endpoint 0x01 (or 0x81, as the case may be).

As an analogy, consider the Clear-Halt request.  This request is sent 
to endpoint 0, and it tells the device to clear the Halt feature for 
some other endpoint -- that other endpoint is specified in wIndex.

> >>     - We don't risk sending to a wrong endpoint, as there can't be two
> >>       endpoints with same index and just different direction.
> >
> >Of course there can be.  It is entirely possible to have one endpoint
> >with address 0x01 and another with address 0x81.
> 
> Hmmm, none of the devices I have show this.
> My impression was that the EP byte is composed of 
>   ep = epindex | (dir==in? 0x80: 0)
> and that index alone must be unique already. But then again, I'm in no
> way an expert in USB specs and may just have jumped to conclusions
> from the wording.

The spec is pretty clear about this.  For example, it says that in
addition to endpoint 0, a device can have up to 15 input endpoints and 
up to 15 output endpoints (section 5.3.1.2).

> (And again the behavior might not be enforced by the spec, but maybe
> by Windows?)

More likely the behavior isn't enforced at all.  The device may simply 
be buggy.

> >> +				dev_info(&ps->dev->dev , 
> >> +					"%s: process %i (%s) requesting ep %02x but needs %02x (or
> >00)\n",
> >
> >Why do you have the "(or 00)" part?  It doesn't seem to make any sense.
> 
> Based on the observation that uurb.endpoint = 0 (see above), I have
> changed my code in the Linux program (at [2]) to use 0x00 as wIndex 
> instead of 0x81 (or formerly 0x01). It still worked.
> So it's questionable, whether wIndex should even point to an EP ...
> and the hardware might just ignore it.

It looks that way.  The request claims to be class-specific, so it 
would be nice to know which class document defines the request's 
format.

> Thanks for the review! I will submit a new patch.

Good.

Alan Stern


