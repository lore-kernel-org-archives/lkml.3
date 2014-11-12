Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbaKLW6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:58:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:65471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaKLW6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:58:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415694184"
Date: Wed, 12 Nov 2014 14:58:04 -0800
From: "Sean O. Stalley" <sean.stalley@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephanie Wallick <stephanie.s.wallick@intel.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [V2 PATCH 01/10] added media agnostic (MA) USB HCD driver
Message-ID: <20141112225804.GA3715@sean.stalley.intel.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <Pine.LNX.4.44L0.1411111042160.8671-100000@netrider.rowland.org>
 <20141112214021.GA3531@sean.stalley.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112214021.GA3531@sean.stalley.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, for got to respond to a couple comments. See responses below.

On Wed, Nov 12, 2014 at 01:40:21PM -0800, Sean O. Stalley wrote:
> Thanks for reviewing. My responses are inline.
> 
> Greg has asked that we clean up this code internally before we
> send out another patchset to the mailing list. I will address
> the issues you pointed out, but it may be a while before you see
> another patchset.
> 
> Thanks Again,
> Sean
> 
> On Tue, Nov 11, 2014 at 10:54:30AM -0500, Alan Stern wrote:
> > On Mon, 10 Nov 2014, Stephanie Wallick wrote:
> > > +	/* If the endpoint isn't activated, we can't enqueue anything. */
> > > +	if (MAUSB_EP_HANDLE_UNASSIGNED == ep->ep_handle_state) {
> > > +		mausb_err(&mhcd, "%s: endpoint handle unassigned\n", __func__);
> > > +		return -EPIPE;
> > > +	}
> > > +
> > > +	if (USB_SPEED_FULL != urb->dev->speed) /* suppress checks */
> > > +		ep->max_pkt = usb_endpoint_maxp(&urb->ep->desc);
> > 
> > What happens to full-speed devices?  Don't they have maxpacket values?
> > 

This was part of a work-around.
Per the MA spec (section 7.3.2.2), wMaxPacketSize should be initially
set to 8 for EP0 of FS devices. The usbcore sets it to 64.

This makes sure the EPHandleReq Packet has the per-spec values.

> > > +	if (ret < 0) {
> > > +		mausb_err(&mhcd, "urb enqueue failed: error %d\n", ret);
> > > +		usb_hcd_unlink_urb_from_ep(hcd, urb);
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* get usb device and increment reference counter */
> > > +	if (!mhcd.udev) {
> > > +		mhcd.udev = urb->dev;
> > > +		usb_get_dev(mhcd.udev);
> > > +	}
> > 
> > What happens if more than one device is in use at a time?
> > 

This is wrong. This call should be in mausb_internal_alloc_dev(). Will fix.
