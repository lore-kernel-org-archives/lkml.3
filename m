Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3CQQ5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:57:40 -0400
Received: from mout.web.de ([212.227.17.12]:61407 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab3CQQ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:57:38 -0400
Message-ID: <5145F5BB.4030107@web.de>
Date: Sun, 17 Mar 2013 17:56:27 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arnd Bergmann <arnd@arndb.de>, USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-mm@kvack.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
References: <Pine.LNX.4.44L0.1303161303500.7276-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303161303500.7276-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:f+MaAY0AliloKqpkn96Fx4xRj87qkJd6sm/BwJg+h8+
 x6VdYF3PuhlEBU2nHpfiawDjcGiDhkstGIABfcBmgUVLcqW4N0
 cLd/KB/gwWIKJbZcIN+wQWZnDB6nXSxrAL8cQawlI+pIi4YGzu
 fQW8ZE/O5nn1crjCM3Axh9GMMfhpvTXC3nBJnYaEnd5U+OP5r7
 ZNFpJVwho0PHGRcU4/Gsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.2013 18:39, Alan Stern wrote:
> On Sat, 16 Mar 2013, Soeren Moch wrote:
>
>> I implemented the counter. The max value is sampled at the beginning of
>> end_free_itds(), the current counter value is sampled at the end of this
>> function. Counter values w/o a max number are from the error path in
>> itd_urb_transaction().
>> The number of allocated iTDs can grow to higher values (why?), but
>> normally the iTDs are freed during normal operation. Due to some reason
>> the number of iTDs suddenly increases until coherent pool exhaustion.
>> There is no permanent memory leak, all iTDs are released when the user
>> application ends. But imho several thousands of iTDs cannot be the
>> intended behavior...
>
> No, it's not.  Here's how it's supposed to work:
>
> Each ehci_iso_stream structure corresponds to a single isochronous
> endpoint.  The structure has a free list of iTDs that aren't currently
> in use; when an URB is submitted, its iTDs are taken from the start of
> this free list if possible.  Otherwise new iTDs are allocated from the
> DMA pool.
>
> iTDs on the free list aren't always available.  This is because the
> hardware can continue to access an iTD for up to 1 ms after the iTD has
> completed.  itd->frame stores the frame number (one frame per ms) for
> when the iTD completes, and ehci->now_frame contains a best estimate of
> the current frame number.  This explains the logic in
> itd_urb_transaction().  Near the end of itd_complete() you can see
> where a completed iTD gets added back to the end of the free list.
>
> At the very end of itd_complete() is a section of code that takes the
> entries on the iso_stream's free list and moves them to a global free
> list (ehci->cached_itd_list).  This happens only when the endpoint is
> no longer in use, i.e., no iTDs are queued for it.  The end_free_itds()
> routine in ehci_timer.c takes iTDs from this global list and releases
> them back to the DMA pool.  The routine doesn't run until at least 1 ms
> after start_free_itds() is called, to wait for the hardware to stop
> accessing the iTDs on the list.
>
> The idea is that during normal use we will quickly reach a steady
> state, where an endpoint always has about N URBs queued for it, each
> URB uses about M iTDs, and there are one or two URB's worth of unused
> iTDs.  Thus there will be N*M iTDs in use plus maybe another 2*M iTDs
> on the iso_stream's free list.  Once we reach this point, every new URB
> should be able to get the iTDs it needs from the free list (assuming a
> new URB is submitted every time an URB completes).  When the URBs stop
> being submitted, the pipeline will empty out and after a couple more
> milliseconds, all (N+2)*M iTDs should be released back to the pool.
>
> In your case the situation is complicated by the fact that you're using
> two devices, each of which has up to four isochronous endpoints.  This
> makes it harder to see what's going on.  Probably not all of the
> endpoints were being used for data transfers.  But even if they were,
> there should not have been more then 800 iTDs allocated at any time
> (figure that N is around 5 and M is 9).  You could simplify the testing
> by using only one device -- it might not exhaust the pool but your iTD
> counter would still indicate if something wasn't right.
>
> I'm not sure how to figure out what's causing the problem.  Maybe you
> can think of a good way to see where the actual operation differs from
> the description above.  Perhaps start by keeping track of the number of
> iTDs on each iso_stream's free list and the number in use by each
> iso_stream.


For each device only one isochronous endpoint is used (EP IN4, 1x 940 
Bytes, Interval 1).
When the ENOMEM error occurs, a huge number of iTDs is in the free_list 
of one stream. This number is much higher than the 2*M entries, which 
should be there according to your description.

  Soeren Moch


Mar 17 17:06:49 guruvdr kernel: free iso_stream:0xd802d840
Mar 17 17:06:49 guruvdr kernel: iso_stream_init: stream:0xd802d7e0 dev:5 
ep:132 int:1 maxp:940 bw:152
Mar 17 17:06:50 guruvdr kernel: free iso_stream:0xd802d9c0
Mar 17 17:06:50 guruvdr kernel: iso_stream_init: stream:0xd802d360 dev:6 
ep:132 int:1 maxp:940 bw:152
Mar 17 17:07:09 guruvdr kernel: itd_counter:42 (max:4549)
Mar 17 17:07:09 guruvdr kernel: itd_counter:0 (max:4549)
Mar 17 17:07:10 guruvdr kernel: free iso_stream:0xd802d7e0
Mar 17 17:07:11 guruvdr kernel: iso_stream_init: stream:0xd802d7e0 dev:5 
ep:132 int:1 maxp:940 bw:152
Mar 17 17:07:11 guruvdr kernel: free iso_stream:0xd802d360
Mar 17 17:07:11 guruvdr kernel: iso_stream_init: stream:0xd802d360 dev:6 
ep:132 int:1 maxp:940 bw:152
Mar 17 17:15:13 guruvdr kernel: ERROR: 1024 KiB atomic DMA coherent pool 
is too small!
Mar 17 17:15:13 guruvdr kernel: Please increase it with coherent_pool= 
kernel parameter!
Mar 17 17:15:13 guruvdr kernel: itd_counter:6275
Mar 17 17:15:13 guruvdr kernel: stream0 num_td_list_entries:33 
num_free_list_entries:6200
Mar 17 17:15:13 guruvdr kernel: stream1 num_td_list_entries:36 
num_free_list_entries:6
Mar 17 17:15:13 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 17 17:15:13 guruvdr kernel: itd_counter:6275
Mar 17 17:15:13 guruvdr kernel: stream0 num_td_list_entries:25 
num_free_list_entries:6208
Mar 17 17:15:13 guruvdr kernel: stream1 num_td_list_entries:35 
num_free_list_entries:7
Mar 17 17:15:13 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 17 17:15:14 guruvdr kernel: itd_counter:6275
Mar 17 17:15:14 guruvdr kernel: stream0 num_td_list_entries:17 
num_free_list_entries:6216
Mar 17 17:15:14 guruvdr kernel: stream1 num_td_list_entries:35 
num_free_list_entries:7
Mar 17 17:15:14 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 17 17:15:14 guruvdr kernel: itd_counter:6275
Mar 17 17:15:14 guruvdr kernel: stream0 num_td_list_entries:9 
num_free_list_entries:6224
Mar 17 17:15:14 guruvdr kernel: stream1 num_td_list_entries:35 
num_free_list_entries:7
Mar 17 17:15:14 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 17 17:15:16 guruvdr kernel: itd_counter:6275
Mar 17 17:15:16 guruvdr kernel: stream0 num_td_list_entries:1 
num_free_list_entries:6232
Mar 17 17:15:16 guruvdr kernel: stream1 num_td_list_entries:40 
num_free_list_entries:2
Mar 17 17:15:16 guruvdr kernel: orion-ehci orion-ehci.0: can't init itds
Mar 17 17:15:16 guruvdr kernel: itd_counter:42 (max:6275)
Mar 17 17:16:31 guruvdr kernel: itd_counter:0 (max:6275)
Mar 17 17:16:32 guruvdr kernel: free iso_stream:0xd802d7e0
Mar 17 17:16:32 guruvdr kernel: iso_stream_init: stream:0xd802d6c0 dev:5 
ep:132 int:1 maxp:940 bw:152
Mar 17 17:16:36 guruvdr kernel: free iso_stream:0xd802d360
Mar 17 17:16:36 guruvdr kernel: iso_stream_init: stream:0xd802da20 dev:6 
ep:132 int:1 maxp:940 bw:152

