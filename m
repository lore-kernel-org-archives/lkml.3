Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaEHQrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:47:41 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:57649 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753866AbaEHQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:47:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4250:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boat48_5f68332872d57
X-Filterd-Recvd-Size: 2028
Message-ID: <1399567654.7543.9.camel@joe-AO725>
Subject: Re: [PATCH 03/10] usb: catch attempts to submit urbs with a
 vmalloc'd transfer buffer
From: Joe Perches <joe@perches.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        Dan Williams <dan.j.williams@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Date: Thu, 08 May 2014 09:47:34 -0700
In-Reply-To: <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
	 <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 19:25 +0300, Mathias Nyman wrote:
> Save someone else the debug cycles of figuring out why a driver's
> transfer request is failing or causing undefined system behavior.
> Buffers submitted for dma must come from GFP allocated / DMA-able
> memory.
> 
> Return -EAGAIN matching the return value for dma_mapping_error() cases.
[]
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
[]
> @@ -1502,6 +1502,9 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
>  					ret = -EAGAIN;
>  				else
>  					urb->transfer_flags |= URB_DMA_MAP_PAGE;
> +			} else if (is_vmalloc_addr(urb->transfer_buffer)) {
> +				WARN_ONCE(1, "transfer buffer not dma capable\n");
> +				ret = -EAGAIN;
>  			} else {
>  				urb->transfer_dma = dma_map_single(
>  						hcd->self.controller,

Perhaps this could be #ifdef'd here or moved to and
tested in dma_map_single/dma_map_single_attr instead.

