Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaFXOKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:10:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaFXOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:10:40 -0400
Date: Tue, 24 Jun 2014 10:10:28 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH 3/5] usb: xhci: Correct last context entry calculation
 for Configure Endpoint
Message-ID: <20140624141028.GA2844@kroah.com>
References: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
 <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
 <1403619322-24704-3-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403619322-24704-3-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 05:14:42PM +0300, Mathias Nyman wrote:
> From: Julius Werner <jwerner@chromium.org>
> 
> The current XHCI driver recalculates the Context Entries field in the
> Slot Context on every add_endpoint() and drop_endpoint() call. In the
> case of drop_endpoint(), it seems to assume that the add_flags will
> always contain every endpoint for the new configuration, which is not
> necessarily correct if you don't make assumptions about how the USB core
> uses the add_endpoint/drop_endpoint interface (add_flags only contains
> endpoints that are new additions in the new configuration).
> 
> Furthermore, EP0_FLAG is not consistently set in add_flags throughout
> the lifetime of a device. This means that when all endpoints are
> dropped, the Context Entries field can be set to 0 (which is invalid and
> may cause a Parameter Error) or -1 (which is interpreted as 31 and
> causes the driver to keep using the old, incorrect value).
> 
> The only surefire way to set this field right is to also take all
> existing endpoints into account, and to force the value to 1 (meaning
> only EP0 is active) if no other endpoint is found. This patch implements
> that as a single step in the final check_bandwidth() call and removes
> the intermediary calculations from add_endpoint() and drop_endpoint().
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci.c | 51 +++++++++++++++++--------------------------------
>  1 file changed, 18 insertions(+), 33 deletions(-)

Is this something for older (i.e. stable) kernels?

thanks,

greg k-h
