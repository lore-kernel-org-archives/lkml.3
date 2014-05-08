Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaEHRF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:05:59 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42372 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224AbaEHRF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <1399567654.7543.9.camel@joe-AO725>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
	<1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
	<1399567654.7543.9.camel@joe-AO725>
Date: Thu, 8 May 2014 10:05:56 -0700
Message-ID: <CAPcyv4iRZ5PX8QqLpGtkKJskzhB2qV0Vqs8awRgKCSfVUM9Zrw@mail.gmail.com>
Subject: Re: [PATCH 03/10] usb: catch attempts to submit urbs with a vmalloc'd
 transfer buffer
From: Dan Williams <dan.j.williams@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 9:47 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-05-08 at 19:25 +0300, Mathias Nyman wrote:
>> Save someone else the debug cycles of figuring out why a driver's
>> transfer request is failing or causing undefined system behavior.
>> Buffers submitted for dma must come from GFP allocated / DMA-able
>> memory.
>>
>> Return -EAGAIN matching the return value for dma_mapping_error() cases.
> []
>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> []
>> @@ -1502,6 +1502,9 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
>>                                       ret = -EAGAIN;
>>                               else
>>                                       urb->transfer_flags |= URB_DMA_MAP_PAGE;
>> +                     } else if (is_vmalloc_addr(urb->transfer_buffer)) {
>> +                             WARN_ONCE(1, "transfer buffer not dma capable\n");
>> +                             ret = -EAGAIN;
>>                       } else {
>>                               urb->transfer_dma = dma_map_single(
>>                                               hcd->self.controller,
>
> Perhaps this could be #ifdef'd here or moved to and
> tested in dma_map_single/dma_map_single_attr instead.
>

What problem are you trying to solve?  Adding it to dma_map() means
incurring the overhead of checking on every call and it would be akin
to adding dma_mapping_error() to dma_map().  Otherwise, if it is
ifdef'd that will miss the very same driver developers that didn't
know they couldn't do that.  USB core has already committed to
validating the input buffers in this routine, what's wrong with one
more check?
