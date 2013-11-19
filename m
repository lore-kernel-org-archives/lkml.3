Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab3KTDQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 22:16:37 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44223 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3KTDQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 22:16:35 -0500
Date: Tue, 19 Nov 2013 11:17:03 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20131030120152.GM2400@suse.de> (from mgorman@suse.de on Wed
	Oct 30 07:01:52 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1384881423.1974.277@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 07:01:52 AM, Mel Gorman wrote:
> We talked about this a
> few months ago but I still suspect that we will have to bite the  
> bullet and
> tune based on "do not dirty more data than it takes N seconds to  
> writeback"
> using per-bdi writeback estimations. It's just not that trivial to  
> implement
> as the writeback speeds can change for a variety of reasons (multiple  
> IO
> sources, random vs sequential etc).

Record "block writes finished this second" into an 8 entry ring buffer,  
with a flag saying "device was partly idle this period" so you can  
ignore those entries. Keep a high water mark, which should converge to  
the device's linear write capacity.

This gives you recent thrashing speed and max capacity, and some  
weighted average of the two lets you avoid queuing up 10 minutes of  
writes all at once like 3.0 would to a terabyte USB2 disk. (And then  
vim calls sync() and hangs...)

The first tricky bit is the high water mark, but it's not too bad. If  
the device reads and writes at the same rate you can populate it from  
that, but even starting it with just one block should converge really  
fast because A) the round trip time should be well under a second, B)  
if you're submitting more than one period's worth of data (you can  
dirty enough to keep disk busy for 2 seconds), then it'll queue up 2  
blocks at a time, then 4, then 8, and increase exponentially until you  
hit the high water mark. (Which is measured so it won't overshoot.)

The second tricky bit is weighting the average, but presumably counting  
the high water mark as one, then adding in all the "device did not  
actually go idle during this period" entries, and dividing by the  
number of entries considered... Reasonable first guess?

Obvious optimizations: instead of recording the "disk went idle" flag  
in the ring buffer, just don't advance the ring buffer at the end of  
that second, but zero out the entry and re-accumulate it. That way the  
ring buffer should always have 7 seconds of measured activity, even if  
it's not necessarily recent. And of course you don't have to wake  
anything up when there was no I/O, so it's nicely quiescent when the  
system is...

Lowering the high water mark in the case of a transient spurious  
reading (maybe clock skew during suspend or virtualization glitch or  
some such) is fun, and could give you a 4 billion block bad reading,  
but if you always decrement the high water mark by 25% (x-=(x>>2)) each  
second the disk didn't go idle (rounding up) and then queue up more  
than one period's worth of data (but no more than say 8 seconds worth),  
such glitches should fix themselves and it'll work its way back up or  
down to a reasonably accurate value. (Keep in mind you're averaging the  
high water mark back down with 7 seconds of measured data from the ring  
buffer. Maybe you can cap the high water mark at the sum of all the  
measured values in the ring buffer as an extra check? You're already  
calculating it to do the average, so...)

This is assuming your hard drive _itself_ doesn't have bufferbloat, but  
http://spritesmods.com/?art=hddhack&f=rss implies they don't, and  
tagged command queueing lets you see through that anyway so your  
"actually committed" numbers could presumably still be accurate if the  
manufacturers aren't totally lying.

Given how far behind I am on my email, I assume somebody's already  
suggested this by now. :)

Rob