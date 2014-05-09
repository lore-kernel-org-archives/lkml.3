Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaEHRFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:05:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:36207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbaEHRFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1012,1389772800"; 
   d="scan'208";a="528658084"
Date: Fri, 9 May 2014 01:03:48 -0400
From: Zhuang Jin Can <jin.can.zhuang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        liping.zhou@intel.com, david.a.cohen@linux.intel.com
Subject: Re: [PATCH] usb: dwc3: ep0: fix delayed status is queued too early
Message-ID: <20140509050348.GL19925@intel.com>
Reply-To: jin.can.zhuang@intel.com
References: <20140509030133.GK19925@intel.com>
 <Pine.LNX.4.44L0.1405081118480.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1405081118480.1087-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 11:22:36AM -0400, Alan Stern wrote:
> On Thu, 8 May 2014, Zhuang Jin Can wrote:
> 
> > > dwc3 _cannot_ return NYET to a SETUP packet.  The USB protocol does not 
> > > allow it.  A device must always respond to SETUP with ACK.
> > It true that device can not return NYET to a SETUP packet.
> > A device must always respond to SETUP with ACK _if_ the SETUP packet is
> > correctly received. Because there's no buffer prepared in ep0 for dwc3
> > to receive the SETUP packet, I guess there will be no handshake
> > returned to host. I can confirm this by doing an experiment tomorrow:)
> 
> The dwc3 driver should always prepare a buffer for the next ep0 SETUP
> packet as soon as it retrieves the information for the current SETUP 
> packet from the buffer.
> 
In current model dwc3 doesn't prepare a buffer for the next ep0 SETUP
packet, and normally host should not send another SETUP packet if the
current control transfer is not finished. So below model works well
if every control transfer succeeds one by one.

Here's the 2-stage control transfer model in dwc3.
*******************************************
*         SETUP PHASE:			  *
*Setup a Control-Setup TRB, start Transfer*<-------------
*******************************************		|
		|					|
	   XferComplete irq	 			|
		|					|
		V					|
	***********************				|
	*Interpret Setup bytes*				|
	***********************				|
		|					|
	      2 stage				   XferComplete
		|				Setup Pending=0 or 1					
		V					|
	*****************				|
	* Wait for Host *				|
	*****************				|
		|					|
	Status XferNotReady irq				|
		|					|
		V					|
*******************************************		|
*	STATUS PHASE:			  *		|
*Setup Control-Status2 TRB, Start Transfer*-------------|
*******************************************
(note: in *STATUS PHASE* it can't start transfer if
the delayed status request is not queued by gadget driver).

If the gadget driver can't queue the delayed status request in time,
dwc3 will stay at *STATUS PHASE*.
Then, current control transfer fails. Host starts to send a new SETUP
packet.
At this point, it really depends on how dwc3 controller will behave when
it receives the new SETUP packet. If it can move on to *SETUP PHASE*
with similar way to [Tree-stage back to back SETUP handling] (see
below), then the stale delayed status request could cause a problem.

[ Tree-stage back to back SETUP handling]
For a tree-stage control transfer, dwc3 can handle back to back
SETUP packets. Below is quoted from dwc3 ep0.c
/*
 * Unfortunately we have uncovered a limitation wrt the Data
 * Phase.
 *
 * Section 9.4 says we can wait for the XferNotReady(DATA) event
 * to
 * come before issueing Start Transfer command, but if we do, we
 * will
 * miss situations where the host starts another SETUP phase
 * instead of
 * the DATA phase.  Such cases happen at least on TD.7.6 of the
 * Link
 * Layer Compliance Suite.
 *
 * The problem surfaces due to the fact that in case of
 * back-to-back
 * SETUP packets there will be no XferNotReady(DATA) generated
 * and we
 * will be stuck waiting for XferNotReady(DATA) forever.
 *
 * By looking at tables 9-13 and 9-14 of the Databook, we can
 * see that
 * it tells us to start Data Phase right away. It also mentions
 * that if
 * we receive a SETUP phase instead of the DATA phase, core will
 * issue
 * XferComplete for the DATA phase, before actually initiating
 * it in
 * the wire, with the TRB's status set to "SETUP_PENDING". Such
 * status
 * can only be used to print some debugging logs, as the core
 * expects
 * us to go through to the STATUS phase and start a
 * CONTROL_STATUS TRB,
 * just so it completes right away, without transferring
 * anything and,
 * only then, we can go back to the SETUP phase.
 *
 * Because of this scenario, SNPS decided to change the
 * programming
 * model of control transfers and support on-demand transfers
 * only for
 * the STATUS phase. To fix the issue we have now, we will
 * always wait
 * for gadget driver to queue the DATA phase's struct
 * usb_request, then
 * start it right away.
 *
 * If we're actually in a 2-stage transfer, we will wait for
 * XferNotReady(STATUS).
 */

> Otherwise, as you described it, if the gadget driver never sends its 
> delayed status response then the UDC will never respond to any more 
> control transfers.
If the device already fails the SET_CONFIG, what's the benefit of device
being able to repond to succeeding control transfer? Stop responding
might not be bad idea, host should eventually reset the bus to
re-enumerate the device.


Jincan
