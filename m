Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3KMA1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:27:02 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:59878 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3KMA0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:26:54 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 2/2] check quirk to pad epout buf size when not
 aligned to maxpacketsize
Thread-Topic: [PATCHv2 2/2] check quirk to pad epout buf size when not
 aligned to maxpacketsize
Thread-Index: AQHO3tBOeLMhVoTiIk+6n1TA9pz2Zpog/4kAgAANr4CAABUigIABI/uA///nnfCAAJySgP//et9w
Date: Wed, 13 Nov 2013 00:24:08 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E243BC@US01WEMBX2.internal.synopsys.com>
References: <5281595D.9030602@linux.intel.com>
 <Pine.LNX.4.44L0.1311121046200.1200-100000@iolanthe.rowland.org>
 <A2CA0424C0A6F04399FB9E1CD98E030458E24316@US01WEMBX2.internal.synopsys.com>
 <5282BD2D.4070303@linux.intel.com>
In-Reply-To: <5282BD2D.4070303@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Cohen [mailto:david.a.cohen@linux.intel.com]
> Sent: Tuesday, November 12, 2013 3:44 PM
> 
> On 11/12/2013 03:09 PM, Paul Zimmerman wrote:
> 
> >> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Alan Stern
> >> Sent: Tuesday, November 12, 2013 7:51 AM
> >>
> >> On Mon, 11 Nov 2013, David Cohen wrote:
> >>
> >>> In order to avoid DWC3 to stall, we need to update req->length (this is
> >>> the most important fix). kmalloc() is updated too to prevent USB
> >>> controller to overflow buffer boundaries.
> >>
> >> Here I disagree.
> >>
> >> If the DWC3 hardware stalls, it is up to the DWC3 UDC driver to fix it.
> >> Gadget drivers should not have to worry.  Most especially, gadget
> >> drivers should not lie about a request length.
> >
> > The whole point of this quirk is to lie to the DWC3 driver. The quirk is
> > only enabled for the DWC3 driver.
> >
> >> If the UDC driver decides to round up req->length before sending it to
> >> the hardware, that's okay.
> >
> > Not really. If the DWC3 driver unconditionally rounds up req->length,
> > then in the case where the buffer has not been expanded to a multiple of
> > maxpacket, by this quirk or otherwise, there is the potential to write
> > beyond the end of the allocation.
> >
> > If we do what you suggest, then all the gadgets will have to be audited
> > to make sure an OUT buffer with a non-aligned length is never passed to
> > the DWC3 driver.
> 
> I was really convinced about not updating rep->length was a better idea
> until I read this argument of yours: with this approach buffer overflow
> can silently happen.
> 
> >
> > I still think that's the best solution anyway. Just make that the rule,
> > and then there is no need for this quirk at all. And there is no need to
> > round up req->length in the DWC3 driver either.
> 
> I'd have nothing against that, but I'm not sure how it would affect
> other environments, given embedded environments are pretty sensitive to
> memory consumption (and performance).

There would be no performance impact. The memory impact would be less than
1024 bytes per OUT ep (worst case), and most gadget devices only have a
couple of OUT eps. I don't think it's a problem.

> >
> >> But req->length should be set to len, not data_len.
> >
> > According to gadget.h:
> >
> > 	@buf: Buffer used for data
> > 	@length: Length of that data
> >
> > So why shouldn't length be the length of the allocated data buffer?
> > Remember, this is for the OUT direction only, so the host has control
> > over how much data is actually sent. You could even argue that an OUT
> > data buffer should always be a multiple of the max packet size, given
> > how USB works.
> 
> How about something like this, to let USB controllers to know about
> whole allocated memory and avoid hidden overflows. Does that make sense
> to you?
> 
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 25a5007f92e3..973b57b709ab 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -31,13 +31,16 @@ struct usb_ep;
>    * struct usb_request - describes one i/o request
>    * @buf: Buffer used for data.  Always provide this; some controllers
>    *     only use PIO, or don't use DMA for some endpoints.
> + * @length: Length of that data
> + * @buf_pad: Some USB controllers may need to pad buffer size due to
> alignment
> + *     constraints. This keeps track of how much memory was allocated
> to @buf
> + *     in addition to @length.
>    * @dma: DMA address corresponding to 'buf'.  If you don't set this
>    *     field, and the usb controller needs one, it is responsible
>    *     for mapping and unmapping the buffer.
>    * @sg: a scatterlist for SG-capable controllers.
>    * @num_sgs: number of SG entries
>    * @num_mapped_sgs: number of SG entries mapped to DMA (internal)
> - * @length: Length of that data
>    * @stream_id: The stream id, when USB3.0 bulk streams are being used
>    * @no_interrupt: If true, hints that no completion irq is needed.
>    *     Helpful sometimes with deep request queues that are handled
> @@ -91,6 +94,7 @@ struct usb_ep;
>   struct usb_request {
>          void                    *buf;
>          unsigned                length;
> +       unsigned                buf_pad;
>          dma_addr_t              dma;
> 
>          struct scatterlist      *sg;

Yes, I think that would work. But you only need 11 bits or so for
buf_pad, so make it 'unsigned buf_pad:11" and move it down with the
rest of the bitfields.

And you could also report -EOVERFLOW in the DWC3 driver, as Alan
suggested, if the received data is more than 'length'.

-- 
Paul

