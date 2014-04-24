Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaDXTqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:46:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaDXTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:46:12 -0400
Date: Thu, 24 Apr 2014 12:49:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH 1/5] usb: xhci: Prefer endpoint context dequeue pointer
 over stopped_trb
Message-ID: <20140424194905.GA12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
 <1398169382-12097-2-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398169382-12097-2-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:22:58PM +0300, Mathias Nyman wrote:
> From: Julius Werner <jwerner@chromium.org>
> 
> We have observed a rare cycle state desync bug after Set TR Dequeue
> Pointer commands on Intel LynxPoint xHCs (resulting in an endpoint that
> doesn't fetch new TRBs and thus an unresponsive USB device). It always
> triggers when a previous Set TR Dequeue Pointer command has set the
> pointer to the final Link TRB of a segment, and then another URB gets
> enqueued and cancelled again before it can be completed. Further
> investigation showed that the xHC had returned the Link TRB in the TRB
> Pointer field of the Transfer Event (CC == Stopped -- Length Invalid),
> but when xhci_find_new_dequeue_state() later accesses the Endpoint
> Context's TR Dequeue Pointer field it is set to the first TRB of the
> next segment.
> 
> The driver expects those two values to be the same in this situation,
> and uses the cycle state of the latter together with the address of the
> former. This should be fine according to the XHCI specification, since
> the endpoint ring should be stopped when returning the Transfer Event
> and thus should not advance over the Link TRB before it gets restarted.
> However, real-world XHCI implementations apparently don't really care
> that much about these details, so the driver should follow a more
> defensive approach to try to work around HC spec violations.
> 
> This patch removes the stopped_trb variable that had been used to store
> the TRB Pointer from the last Transfer Event of a stopped TRB. Instead,
> xhci_find_new_dequeue_state() now relies only on the Endpoint Context,
> requiring a small amount of additional processing to find the virtual
> address corresponding to the TR Dequeue Pointer. Some other parts of the
> function were slightly rearranged to better fit into this model.
> 
> This patch should be backported to kernels as old as 2.6.31 that contain
> the commit ae636747146ea97efa18e04576acd3416e2514f5 "USB: xhci: URB
> cancellation support."

Ok, but:

> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

You don't actually add the stable@ tag here, why not?

You have read Documentation/stable_kernel_rules.txt for how stable
kernel trees work, so why not add the label here?

greg k-h
