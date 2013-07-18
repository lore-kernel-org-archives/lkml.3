Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab3GRNuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:50:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55492 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754140Ab3GRNuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:50:39 -0400
Date: Thu, 18 Jul 2013 09:50:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Rong Wang <wr011235813@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
In-Reply-To: <20130718082240.GD11251@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1307180946380.1245-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jul 2013, Felipe Balbi wrote:

> > > yes. Only the UDC driver knows when the controller is moving among those
> > > states.
> > 
> > Not quite.  Only the gadget driver knows when the transition between 
> > ADDRESS and CONFIGURED occurs.  This should be added to composite.c.
> 
> that's not entirely true :-) See how we handle that in dwc3:
> 
> | static int dwc3_ep0_set_config(struct dwc3 *dwc, struct usb_ctrlrequest *ctrl)
> | {
> | 	enum usb_device_state state = dwc->gadget.state;
> | 	u32 cfg;
> | 	int ret;
> | 	u32 reg;
> | 
> | 	dwc->start_config_issued = false;
> | 	cfg = le16_to_cpu(ctrl->wValue);
> | 
> | 	switch (state) {
> | 	case USB_STATE_DEFAULT:
> | 		return -EINVAL;
> | 		break;
> | 
> | 	case USB_STATE_ADDRESS:
> | 		ret = dwc3_ep0_delegate_req(dwc, ctrl);
> | 		/* if the cfg matches and the cfg is non zero */
> | 		if (cfg && (!ret || (ret == USB_GADGET_DELAYED_STATUS))) {
> | 			usb_gadget_set_state(&dwc->gadget,
> | 					USB_STATE_CONFIGURED);

In theory, this should not occur until the gadget driver has finished 
the transition to the CONFIGURED state, which doesn't occur until later 
in the case of USB_GADGET_DELAYED_STATUS.

> | 
> | 			/*
> | 			 * Enable transition to U1/U2 state when
> | 			 * nothing is pending from application.
> | 			 */
> | 			reg = dwc3_readl(dwc->regs, DWC3_DCTL);
> | 			reg |= (DWC3_DCTL_ACCEPTU1ENA | DWC3_DCTL_ACCEPTU2ENA);
> | 			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> | 
> | 			dwc->resize_fifos = true;
> | 			dev_dbg(dwc->dev, "resize fifos flag SET\n");
> | 		}
> | 		break;
> | 
> | 	case USB_STATE_CONFIGURED:
> | 		ret = dwc3_ep0_delegate_req(dwc, ctrl);
> | 		if (!cfg)
> | 			usb_gadget_set_state(&dwc->gadget,
> | 					USB_STATE_ADDRESS);

No check on the value of ret?  What if the request was rejected?

> | 		break;
> | 	default:
> | 		ret = -EINVAL;
> | 	}
> | 	return ret;
> | }

This illustrates the folly of exposing your code to public review.  :-)
Nevertheless, I take your point.

> Also, until other gadget drivers add notifications to the other cases, I
> don't think it's wise to add a transition from NOTATTACHED to
> CONFIGURED.

Another good point.

Alan Stern

