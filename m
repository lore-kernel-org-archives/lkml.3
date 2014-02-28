Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaB1SHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:07:40 -0500
Received: from shelob.surriel.com ([74.92.59.67]:40042 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaB1SHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:07:39 -0500
Message-ID: <5310D060.1090504@surriel.com>
Date: Fri, 28 Feb 2014 13:07:28 -0500
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Kelley Nielsen <kelleynnn@gmail.com>
CC: akpm@linux-foundation.org, gnomes@lxorguk.ukuu.org.uk,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, opw-kernel@googlegroups.com, jamieliu@google.com,
        sjenning@linux.vnet.ibm.com
Subject: Re: [RFC] mm:prototype for the updated swapoff implementation
References: <20140219003522.GA8887@kelleynnn-virtual-machine> <alpine.LSU.2.11.1402271054390.7000@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1402271054390.7000@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 07:33 PM, Hugh Dickins wrote:
> On Tue, 18 Feb 2014, Kelley Nielsen wrote:
> 
>> The function try_to_unuse() is of quadratic complexity, with a lot of
>> wasted effort. It unuses swap entries one by one, potentially iterating
>> over all the page tables for all the processes in the system for each
>> one.
> 
> You've chosen a good target, and I like the look of what you've done.
> But I'm afraid it will have to get uglier before it's ready, and I'm
> unsure whether your approach will prove to be a clear win or not.

I am more optimistic than you, because I have seen swapoff
on my Nehalem system proceed at under 1MB/s for several hours,
to clear maybe 3-4GB of stuff out of swap :)

>> This new proposed implementation of try_to_unuse simplifies its
>> complexity to linear. It iterates over the system's mms once, unusing
>> all the affected entries as it walks each set of page tables. It also
>> makes similar changes to shmem_unuse.
>>
>> Improvement
>>
>> swapoff was called on a swap partition containing about 50M of data,
>> and calls to the function unuse_pte_range were counted.
>>
>> Present implementation....about 22.5M calls.
>> Prototype.................about  7.0K   calls.
> 
> That's nice, but mostly it's the time spent that matters.
> 
> I should explain why we've left the try_to_unuse() implementation as is
> for so many years: it's a matter of tradeoff between fast cpu and slow
> seeking disk.

> I'll be surprised if your approach does not improve swapoff from SSD
> (and brd and zram and zswap) very significantly; but the case to worry
> about is swapoff from hard disk.  You are changing swapoff to use the
> cpu much more efficiently; but now that you no longer move linearly up
> the swap_map, you are making the disk head seek around very much more.

I suspect proper read-around of the swap area should take care of
IO patterns well enough. The quadratic nature of the current
try_to_unuse search can easily slow things down to comically low
speeds...

-- 
All rights reversed.
