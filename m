Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3HOEsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 00:48:45 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58408 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3HOEsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 00:48:43 -0400
Date: Thu, 15 Aug 2013 13:48:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, k.kozlowski@samsung.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, guz.fnst@cn.fujitsu.com,
        Benjamin LaHaise <bcrl@kvack.org>, Dave Hansen <dave.hansen@intel.com>,
        lliubbo@gmail.com, aquini@redhat.com, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC 0/3] Pin page control subsystem
Message-ID: <20130815044834.GB3139@gmail.com>
References: <1376377502-28207-1-git-send-email-minchan@kernel.org>
 <00000140787b6191-ae3f2eb1-515e-48a1-8e64-502772af4700-000000@email.amazonses.com>
 <20130814001236.GC2271@bbox>
 <000001407dafbe92-7b2b4006-2225-4f0b-b23b-d66101a995aa-000000@email.amazonses.com>
 <20130814164705.GD2706@gmail.com>
 <000001407dc3c33b-4139d615-aecc-4745-a9b4-c84949f6a8f4-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001407dc3c33b-4139d615-aecc-4745-a9b4-c84949f6a8f4-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Christoph,

On Wed, Aug 14, 2013 at 04:58:36PM +0000, Christoph Lameter wrote:
> On Thu, 15 Aug 2013, Minchan Kim wrote:
> 
> > When I look API of mmu_notifier, it has mm_struct so I guess it works
> > for only user process. Right?
> 
> Correct. A process must have mapped the pages. If you can get a
> kernel "process" to work then that process could map the pages.
> 
> > If so, I need to register it without user conext because zram, zswap
> > and zcache works for only kernel side.
> 
> Hmmm... Ok but that now gets the complexity of page pinnning up to a very
> weird level. Is there some way we can have a common way to deal with the
> various ways that pinning is needed? Just off the top of my head (I may
> miss some use cases) we have
> 
> 1. mlock from user space

Now mlock pages could be migrated in case of CMA so I think it's not a
big problem to migrate it for other cases.
I remember You and Peter argued what's the mlock semainc of pin POV
and as I remember correctly, Peter said mlock doesn't mean pin so
we could migrate it but you didn't agree. Right?
Anyway, it's off-topic but technically, it's not a problem.

> 2. page pinning for reclaim

Reclaiming pin a page for a while. Of course, "for a while" means
rather vague so it could mean it's really long for someone but really
short for others. But at least, reclaim pin should be short and
we should try it if it's not ture.

> 3. Page pinning for I/O from device drivers (like f.e. the RDMA subsystem)

It's one of big concerns for me. Even several drviers might be able to pin
a page same time. But normally most of drvier can know he will pin a page
long time or short time so if it want to pin a page long time like aio or
some GPU driver for zero-coyp, it should use pinpage control subsystem to
release pin pages when VM ask.

> 4. Page pinning for low latency operations

I have no idea but I guess most of them pin a page during short time?
Otherwise, they should use pinpage control subsystem, too.

> 5. Page pinning for migration

It's like 2. migration pin should be short.

> 6. Page pinning for the perf buffers.

I'm not familiar with that but my gut feeling is it will pin pages
for a long time so it should use pinpage control subsystem.

> 7. Page pinning for cross system access (XPMEM, GRU SGI)

If it's really long pin, it should use pinpage control subsystem.

> 
> Now we have another subsystem wanting different semantics of pinning. Is
> there any way we can come up with a pinning mechanism that fits all use
> cases, that is easyly understandable and maintainable?

I agree it's not easy but we should go that way rather than adding ad-hoc
subsystem specific implementaion. If we allow subsystem specific way,
maybe, everybody want to touch migrate.c so it would be very complicated
and bloated, even not maintainable in future. If it goes another way
like a_ops->migratepages, it couldn't handle complex nesting pin pages
case so it couldn't gaurantee pinpage migraions.

Most hard part is what is "for a while". It depends on system workloads
so some system means it is 3ms while other system means it is 3s. :(
Sigh, now I have no idea how can handle it with general.

Thanks for the comment, Christoph!

> 

-- 
Kind regards,
Minchan Kim
