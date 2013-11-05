Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3KESOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:14:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:13637 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3KESOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:14:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="385018227"
Message-ID: <5279351E.2000300@linux.intel.com>
Date: Tue, 05 Nov 2013 10:12:46 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when
 not aligned to maxpacketsize
References: <Pine.LNX.4.44L0.1311051026390.1360-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1311051026390.1360-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 11/05/2013 07:38 AM, Alan Stern wrote:
> On Tue, 5 Nov 2013, David Cohen wrote:
> 
>>>> +		/*
>>>> +		 * Controller requires buffer size to be aligned to
>>>> +		 * maxpacketsize of an out endpoint.
>>>> +		 */
>>>> +		if (gadget->quirk_ep_out_aligned_size && read) {
>>>> +			/*
>>>> +			 * We pass 'orig_len' to usp_ep_align_maxpacketsize()
>>>> +			 * due to we're in a loop and 'len' may have been
>>>> +			 * changed.
>>>> +			 */
>>>> +			len = usb_ep_align_maxpacketsize(ep->ep, orig_len);
>>>> +			if (data && len > data_len) {
>>>> +				kfree(data);
>>>> +				data = NULL;
>>>> +				data_len = 0;
>>>> +			}
>>>> +		}
>>>
>>> Since the value of orig_len never changes, there's no point calling 
>>> usb_ep_align_maxpacketsize() inside the loop.  You should call it only 
>>> once, before the loop starts.  Once you do that, you won't need 
>>> orig_len at all.
>>
>> orig_len doesn't change but ep->ep does. If USB specs say max packet
>> size won't change even if ep does, than we can call it from outside the
>> loop.
> 
> I'm not too familiar with this driver.  It looks like the only way 
> ep->ep can change is if the endpoint gets enabled while you're sitting 
> inside the wait_event_interruptible() call.
> 
> In fact, the whole structure of that loop looks peculiar.  Why not
> acquire the mutex first and then do everything else?

I'm not 100% familiar with this driver too. I'd keep this change to
another patch.

> 
> Does it even make sense for ep to change?  Would this change be visible
> to the host?  What if the host changes the alternate setting while this
> loop is running -- does it make sense for the userspace program to
> start a read or write under one altsetting but then have the read/write
> take place under a different altsetting?

It doesn't make sense to do so, but gadget driver allows it. If we just
ignore, it would be a security or instability issue possible to xploit
(for DWC3 and any other controller which may depend on this quirk).

Br, David Cohen
