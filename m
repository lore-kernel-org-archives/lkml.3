Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966241Ab3DQMHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:07:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53013 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966071Ab3DQMHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:19 -0400
From: "B, Ravi" <ravibabu@ti.com>
To: "Bilovol, Ruslan" <ruslan.bilovol@ti.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: musb: gadget: fix enumeration on heavy-loaded
 systems
Thread-Topic: [PATCH] usb: musb: gadget: fix enumeration on heavy-loaded
 systems
Thread-Index: AQHOOrj9vvmkWKgZJUSEVp2nIwd7q5jZD1SwgADTvgCAAGl/0A==
Date: Wed, 17 Apr 2013 12:07:14 +0000
Message-ID: <6C6B28D4DC342643927BEAFCE8707BF63EAACBB8@DBDE01.ent.ti.com>
References: <1366126904-31605-1-git-send-email-ruslan.bilovol@ti.com>
	<6C6B28D4DC342643927BEAFCE8707BF63EAAC0E5@DBDE01.ent.ti.com>
 <CAB=otbS1R+QTDo=MynMRydCZnv4+idWyosRUQ3d1qiFvXaGPpw@mail.gmail.com>
In-Reply-To: <CAB=otbS1R+QTDo=MynMRydCZnv4+idWyosRUQ3d1qiFvXaGPpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.190.65]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ruslan

> >> Subject: [PATCH] usb: musb: gadget: fix enumeration on heavy-loaded
> >> systems
> >>
> >> From musb point of view, the Address Assignment sequence during
> >> device enumeration is next:
> >>  - first ep0 interrupt:
> >>       * read the address from USB_REQ_SET_ADDRESS request
> >>       * set up CSR0L.DataEnd bit (that is ACK
> >>         signalization for the host)
> >>  - second ep0 interrupt:
> >>       * indicates that the request completed successfully
> >>       * set up musb device address
> >>         Now musb device should answer to this address
> >>
> >> From the host perspective, if peripheral device acquires
> >> SET_ADDRESS request, it now may be accessed only using that address.
> >> However, on heavy loaded systems, time between first and
> >> second musb ep0 interrupts may be too long and musb controller
> >> misses requests between.
> >
> > What is meant by heavily loaded system? Is the device is heavily loaded
> during enumeration stage? Why second ep0 interrupt is too long? whether
> interrupt occurrence to interrupt service is taking too long?
> 
> I mean production system with aggressive power management and tens of
> interrupt sources.
> On such systems and in low CPU frequency case, you may meet condition
> when time between
> IRQ firing and ISR entering is increased in few times.
> 
> In particular case of OMAP4 where I met this issue, time between first
> and second ep0 interrupt
> sometimes may be up to 800-900 uS and in this case the USB30CV test fails.
> If this time is 200-300 uS, the test successfully passes.
> 
> Unfortunately, this time is not predictable and depends on many factors so
> this patch ensures we change the address as soon as sent ACK to the host.
> 
> >
> > As result, device enumeration may be
> >> unsuccessful. This can be checked on USB3.0 Host and
> >> using USB3.0 test suite (from usb.org) running ch9 tests
> >> for USB2.0 devices.
> >
> > You mean the usb2.0 musb controller (in device mode) connected to USB3.0
> host?
> 
> Correct. USB2.0 musb controller in device mode, connected to USB3.0
> host that runs
> USB30CV utility for USB2.0 devices
> 
> >
> >> Usually 'Addressed state/TD9.1: Device Descriptor Test' will fail
> >>
> >> The fix consists in checking CSR0L.DataEnd state and assigning
> >> the device address in the first ep0 interrupt handling, so
> >> delay is as minimal as possible
> >>
> >> Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
> >> ---
> >>  drivers/usb/musb/musb_gadget_ep0.c |   31
> +++++++++++++++++++++++++++++++
> >>  1 file changed, 31 insertions(+)
> >>
> >> diff --git a/drivers/usb/musb/musb_gadget_ep0.c
> >> b/drivers/usb/musb/musb_gadget_ep0.c
> >> index c9c1ac4..59bc5a5 100644
> >> --- a/drivers/usb/musb/musb_gadget_ep0.c
> >> +++ b/drivers/usb/musb/musb_gadget_ep0.c
> >> @@ -885,6 +885,37 @@ stall:
> >>  finish:
> >>                               musb_writew(regs, MUSB_CSR0,
> >>                                               musb->ackpend);
> >> +
> >> +                             /*
> >> +                              * If we are at end of SET_ADDRESS
> sequence,
> >> +                              * update the address immediately if
> possible,
> >> +                              * otherwise we may miss packets between
> >> +                              * sending ACK from musb side and musb's
> next
> >> +                              * interrupt handler firing (in which we
> update
> >> +                              * the address). At least this fixes next
> >> +                              * USB2.0 ch9 test of USB30CV utility:
> >> +                              * "Addressed state - Device Descriptor
> test"
> >> +                              */
> >> +                             if (musb->set_address && (musb->ackpend &
> >> +
> MUSB_CSR0_P_DATAEND) &&
> >> +                                             (musb->ep0_state ==
> >> +                                             MUSB_EP0_STAGE_STATUSIN))
> {
> >> +                                     u16 ack_delay = 500;
> >> +
> >> +                                     while ((musb_readw(regs,
> MUSB_CSR0) &
> >> +
> MUSB_CSR0_P_DATAEND) &&
> >> +                                                     --ack_delay) {
> >> +                                             cpu_relax();
> >> +                                             udelay(1);
> >> +                                     }
> >> +

No need to loop here. It is self clearing bit.

> >> +                                     if (ack_delay) {
> >> +                                             musb->set_address =
> false;
> >> +                                             musb_writeb(mbase,
> MUSB_FADDR,
> >> +                                                             musb-
> >address);
> >> +                                     }

Setting the address before status phase could lead to dropping of status  packet(IN token) by controller, because the status phase is addressed to device with zero address by host, but device controller already changed to new address.
I believe above delay loop is saving you in this case.

--
Ravi B
