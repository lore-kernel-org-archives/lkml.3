Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3CUVpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:45:44 -0400
Received: from mout.web.de ([212.227.17.11]:63548 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3CUVpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:45:43 -0400
Message-ID: <514B7F6C.2060200@web.de>
Date: Thu, 21 Mar 2013 22:45:16 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arnd Bergmann <arnd@arndb.de>, USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-mm@kvack.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, michael@amarulasolutions.com
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
References: <Pine.LNX.4.44L0.1303211708470.1899-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303211708470.1899-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:AztUF3a6hA3ahee1Ho5fRSBWXNWttVt+9LLQPSPeq1M
 GQ7+9KBj8TPzn+FKbT/rPsu+Veu0PdBcg54aoZHR4VlgXhzCV0
 mRQdpCGl0m9VjKN0AHI0IoG+SqbWC87JE8o/XXJC2o7ZRN2Yqk
 zJ8q6dpeR0l6j8FnN9nXUe8XE+j3eb1t52AF/LXTt29DohxEt1
 AvxFvDVUsiCePvH/g9YFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 22:12, Alan Stern wrote:
> On Thu, 21 Mar 2013, Alan Stern wrote:
>
>> On Thu, 21 Mar 2013, Soeren Moch wrote:
>>
>>> Now I found out what is going on here:
>>>
>>> In itd_urb_transaction() we allocate 9 iTDs for each URB with
>>> number_of_packets == 64 in my case. The iTDs are added to
>>> sched->td_list. For a frame-aligned scheduling we need 8 iTDs, the 9th
>>> one is released back to the front of the streams free_list in
>>> iso_sched_free(). This iTD was cleared after allocation and has a frame
>>> number of 0 now. So for each allocation when now_frame == 0 we allocate
>>> from the dma_pool, not from the free_list.
>>
>> Okay, that is a problem.  But it shouldn't be such a big problem,
>> because now_frame should not be equal to 0 very often.
>
> Oh, wait, now I get it.  We never reach a steady state, because the
> free list never shrinks, but occasionally it does increase when
> now_frame is equal to 0.  Even though that doesn't happen very often,
> the effects add up.

Correct. Approximately twice a second we allocate 9 iTDs from the 
dma_pool in my case (the frame numbers run from 0 to 511 - not up to 
2047, which I thought they should). But since we allocate iTDs every 8 
frames in my case (for each active stream), the pool allocations occur 
only when we hit the allocation sequence frame 0,8,16,... (not one of 
the other 7 opportunities frame 1,9,17,... - frame 7,15,23,...)

> Very good; tomorrow I will send your patch in.
>
> Alan Stern
>
Thank you. And also thanks to all who helped to track down this issue.

  Soeren
