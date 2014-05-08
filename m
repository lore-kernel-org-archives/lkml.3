Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaEHQX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:23:58 -0400
Received: from mx0.aculab.com ([213.249.233.131]:41681 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755116AbaEHQXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:23:55 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [PATCH 03/10] usb: catch attempts to submit urbs with a
 vmalloc'd transfer buffer
Thread-Topic: [PATCH 03/10] usb: catch attempts to submit urbs with a
 vmalloc'd transfer buffer
Thread-Index: AQHPatjzaYp5Awm8dkq+2KD2bNocRps23Pcw
Date: Thu, 8 May 2014 16:22:27 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F70FC62@AcuExch.aculab.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
 <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
In-Reply-To: <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Save someone else the debug cycles of figuring out why a driver's
> transfer request is failing or causing undefined system behavior.
> Buffers submitted for dma must come from GFP allocated / DMA-able
> memory.
> 
> Return -EAGAIN matching the return value for dma_mapping_error() cases.

Won't that just cause the request to be resubmitted a few clock
cycles later?
Surely you either need to error the request, or panic.
In any case is this the right place for this sort of test?

(Yes I've spent some time before realising that Linux doesn't
have a proper vtop() function ....)

	David

...
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 9c4e292..adddc66 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
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


