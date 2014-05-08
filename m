Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaEHOZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:25:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42621 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754014AbaEHOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:25:47 -0400
Date: Thu, 8 May 2014 10:25:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <liping.zhou@intel.com>, <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
In-Reply-To: <20140508160046.GJ19925@intel.com>
Message-ID: <Pine.LNX.4.44L0.1405081019230.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Zhuang Jin Can wrote:

> > When the host already timed out the control transfer and started a new 
> > one.  Here's what I'm talking about:
> > 
> > 	Host sends a Set-Configuration request.
> > 
> > 	The UDC driver calls the gadget driver's setup function.
> > 
> > 	The setup function returns DELAYED_STATUS.
> > 
> > 	After a few seconds, the host gets tired of waiting and
> > 	sends a Get-Descriptor request
> My understanding is dwc3 will return NYET to host for this
> Get-Descriptor request transaction, as dwc3 is still in STATUS phase,
> there's no buffer to receive anything in ep0-out.

dwc3 _cannot_ return NYET to a SETUP packet.  The USB protocol does not 
allow it.  A device must always respond to SETUP with ACK.

On the other hand, dwc3 _can_ return NYET to the token packet that
follows the SETUP transaction.  That's what it should do.  But at this
point it should be in the DATA stage, not the STATUS stage.  Receiving
a SETUP packet should abort a STATUS stage.

>  And your below
> comments is not applicapable to dwc3.

True, they apply to composite.c rather than dwc3.  However, they
address an issue very similar to your patch, so I raised this topic in
your email thread.

Alan Stern

