Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaBJQ0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:26:22 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56359 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaBJQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:26:19 -0500
Message-ID: <52F8FDA7.7070809@kernel.dk>
Date: Mon, 10 Feb 2014 09:26:15 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
References: <20131231033827.GA31994@kernel.org> <20140104210804.GA24199@kmo-pixel> <20140105131300.GB4186@kernel.org> <20140106204641.GB9037@kmo> <52CB1783.4050205@kernel.dk> <20140106214726.GD9037@kmo> <20140209155006.GA16149@dhcp-26-207.brq.redhat.com> <20140210103211.GA28396@infradead.org>
In-Reply-To: <20140210103211.GA28396@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/10/2014 03:32 AM, Christoph Hellwig wrote:
> On Sun, Feb 09, 2014 at 04:50:07PM +0100, Alexander Gordeev wrote:
>> Yeah, that was my first thought when I posted "percpu_ida: Allow variable
>> maximum number of cached tags" patch some few months ago. But I am back-
>> pedalling as it does not appear solves the fundamental problem - what is the
>> best threshold?
>>
>> May be we can walk off with a per-cpu timeout that flushes batch nr of tags
>> from local caches to the pool? Each local allocation would restart the timer,
>> but once allocation requests stopped coming on a CPU the tags would not gather
>> dust in local caches.
>
> We'll defintively need a fix to be able to allow the whole tag space.

Certainly. The current situation of effectively only allowing half the 
tags (if spread) is pretty crappy with (by far) most hardware.

> For large numbers of tags per device the flush might work, but for
> devices with low number of tags we need something more efficient.  The
> case of less tags than CPUs isn't that unusual either and we probably
> want to switch to an allocator without per cpu allocations for them to
> avoid all this.  E.g. for many ATA devices we just have a single tag,
> and many scsi drivers also only want single digit outstanding commands
> per LUN.

Even for cases where you have as many (or more) CPUs than tags, per-cpu 
allocation is not necessarily a bad idea. It's a rare case where you 
have all the CPUs touching the device at the same time, after all.

-- 
Jens Axboe
