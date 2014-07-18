Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbaGROjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:39:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54795 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757925AbaGROjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:39:42 -0400
Date: Fri, 18 Jul 2014 10:39:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Amit Virdi <amit.virdi@st.com>
cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "hsi-ss-sw-devel@lists.codex.cro.st.com" 
	<hsi-ss-sw-devel@lists.codex.cro.st.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
In-Reply-To: <53C90B5F.7010505@st.com>
Message-ID: <Pine.LNX.4.44L0.1407181034220.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Amit Virdi wrote:

> On 7/17/2014 8:25 PM, Alan Stern wrote:
> > I can't say this is actually wrong, but have you ever encountered a
> > situation where this would be needed?  How often does anyone need to do
> > a multi-packet transfer over an interrupt endpoint?
> 
> Honestly, I haven't found any such real device yet. I did this change 
> while I was going through the code when adding support for interrupt 
> transfers in gadget zero. I'm a no expert, but the spec says it should 
> be supported so this code should be added.

I just remembered, the HID spec requires that all reports (except the
longest) end with a short packet.  And since output reports are allowed
to be sent over an Interrupt-OUT endpoint, we have to accept the
URB_ZERO_PACKET flag for interrupt URBs.

> However, I messed up a little in this patch. It should have been
> ---
>          case USB_ENDPOINT_XFER_ISOC:
>                  allowed |= URB_ISO_ASAP;
>                  break;
> +       case USB_ENDPOINT_XFER_INT:
> +               if (is_out)
> +                       allowed |= URB_ZERO_PACKET;
> +               else
> +                       allowed |= URB_SHORT_NOT_OK;
> +               break;
>          }
>          allowed &= urb->transfer_flags;
> 
> ---
> Otherwise, it sets zero packet flag for control out transfers too.
> 
> I'll send a V2 with this change if you agree to setting of the zero 
> packet flag for interrupt transfers.

How about this change instead?

 			URB_FREE_BUFFER);
 	switch (xfertype) {
 	case USB_ENDPOINT_XFER_BULK:
+	case USB_ENDPOINT_XFER_INT:
 		if (is_out)
 			allowed |= URB_ZERO_PACKET;
 		/* FALLTHROUGH */

Alan Stern

