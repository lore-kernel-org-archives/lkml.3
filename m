Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbaCUPkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:40:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:25510 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaCUPkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:40:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,704,1389772800"; 
   d="scan'208";a="504854308"
Message-ID: <532C5F62.2030709@linux.intel.com>
Date: Fri, 21 Mar 2014 17:48:50 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: sarah.a.sharp@linux.intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 4/4] xhci: rework command timeout and cancellation,
References: <1395394517-31451-1-git-send-email-mathias.nyman@linux.intel.com> <1395394517-31451-5-git-send-email-mathias.nyman@linux.intel.com>
In-Reply-To: <1395394517-31451-5-git-send-email-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 03/21/2014 11:35 AM, Mathias Nyman wrote:

> +void xhci_handle_command_timeout(unsigned long data)
> +{
> +	struct xhci_hcd *xhci;
> +	int ret;
> +	unsigned long flags;
> +	xhci = (struct xhci_hcd *) data;
> +	/* mark this command to be cancelled */
> +	spin_lock_irqsave(&xhci->lock, flags);
> +	if (xhci->current_cmd)
> +		xhci->current_cmd->status = COMP_CMD_ABORT;
> +	spin_unlock_irqrestore(&xhci->lock, flags);
> +
> +	ret = xhci_abort_cmd_ring(xhci);
> +
> +	if (ret) {
> +		xhci_err(xhci, "Abort command ring failed\n");
> +		if (unlikely(ret == -ESHUTDOWN)) {
> +			xhci_cleanup_command_queue(xhci);
> +			usb_hc_died(xhci_to_hcd(xhci)->primary_hcd);
> +			xhci_dbg(xhci, "xHCI host controller is dead.\n");
> +		}
> +	}
> +	return;
> +}
> +

After some more testing and fault injection it turns out that 
xhci_abort_cmd_ring() returns 0 if command ring is already stopped. In 
this case the command submitter will still be left hanging, and khubd 
wait forever.

So one more round to fix this is still needed.

-Mathias

