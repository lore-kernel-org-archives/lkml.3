Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3KSCMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:12:16 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45149 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KSCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:12:13 -0500
X-AuditID: 9c930197-b7caaae000001cef-47-528ac8fb22af
Date: Tue, 19 Nov 2013 11:12:36 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 3/6] Squashfs: add multi-threaded decompression using
 percpu variables
Message-ID: <20131119021235.GP4407@bbox>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
 <1383855865-4683-4-git-send-email-phillip@squashfs.org.uk>
 <20131108024210.GB21064@bbox>
 <528502A4.3030505@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528502A4.3030505@lougher.demon.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Phillip,

Sorry for late response.

On Thu, Nov 14, 2013 at 05:04:36PM +0000, Phillip Lougher wrote:
> CCing Junjiro Okijima and Stephen Hemminger
> 
> On 08/11/13 02:42, Minchan Kim wrote:
> >
> >Hello Phillip,
> >
> >On Thu, Nov 07, 2013 at 08:24:22PM +0000, Phillip Lougher wrote:
> >>Add a multi-threaded decompression implementation which uses
> >>percpu variables.
> >>
> >>Using percpu variables has advantages and disadvantages over
> >>implementations which do not use percpu variables.
> >>
> >>Advantages: the nature of percpu variables ensures decompression is
> >>load-balanced across the multiple cores.
> >>
> >>Disadvantages: it limits decompression to one thread per core.
> >
> >At a glance, I understand your concern but I don't see benefit to
> >make this feature as separate new config because we can modify the
> >number of decompressor per core in the future.
> >I don't want to create new config SQUASHFS_DECOMP_MULTI_3,
> >SQUASHFS_DECOMP_MULTI_4 and so on. :)
> 
> You misunderstand
> 
> I have been sent two multi-threaded implementations in the
> past which use percpu variables:
> 
> 1.  First patch set:
> 
>    http://www.spinics.net/lists/linux-fsdevel/msg34365.html
> 
>    Later in early 2011, I explained why I'd not merged the
>    patches, and promised to do so when I got time
> 
>    http://www.spinics.net/lists/linux-fsdevel/msg42392.html
> 
> 
> 2.  Second patch set sent in 2011
> 
>    http://www.spinics.net/lists/linux-fsdevel/msg44111.html
> 
> So, these patches have been in my inbox, waiting until I got
> time to refactor Squashfs so that they could be merged... and
> I finally got to do this last month, which is why I'm merging
> a combined version of both patches now.
> 
> As to why have *two* implementations, I previously explained these
> two approaches are complementary, and merging both allows the
> user to decide which method of parallelising Squashfs they want
> to do.

What I see for benefit decompressor_multi_percpu is only limit
memory overhead but it could be solved by dynamic shrinking as
I mentioned earlier.

About CPU usage, I'm not sure how decompressor_multi is horrible.
If it's really concern, we can fix it to limit number of decomp
stream by admin via sysfs or something.

Decompression load balance? Acutally, I don't understand your claim.
Could you elaborate it a bit?
I couldn't understand why decompressor_multi_percpu is better than
decompressor_multi.

> 
> The percpu implementation is a good approach to parallelising
> Squashfs.  It is extremely simple, both in code and overhead.

I agree about code but not sure about overhead.
I admit decompressor_multi is bigger but it consists of simple opeartions.
Sometime, kmalloc's cost could be higher if system memory pressure is
severe so that file system's performance would fluctuate. If it's
your concern, we could make threshold min/high so that it could guarantee
some speed at least.


> The decompression hotpath simply consists of taking a percpu
> variable, doing the decompression, and then a release.

When decomp buffer is created dynamically, it could be rather overhead
compared to percpu approach but once it did, the overhead of decompress
would be marginal.

> Looking at code sizes:
> 
> fs/squashfs/decompressor_multi.c        |  199 +++++++++++++++++++++++++++++++
> fs/squashfs/decompressor_multi_percpu.c |  104 ++++++++++++++++
> fs/squashfs/decompressor_single.c       |   85 +++++++++++++
> 
> The simplicity of the percpu approach is readily apparent, at 104
> lines it is only slightly larger than the single threaded
> implementation.
> 
> Personally I like both approaches, and I have no reason not to
> merge both implementations I have been sent.

Okay. I'm not a maintainer so I'm not strong against your thougt.
I just wanted to unify them if either of them isn't sigificantly win
because I thought it makes maintainer and contributors happy due to
avoid more CONFIG options which should be considered when some feature
is added.

> 
> But what does the community think here?  Do you want the percpu
> implementation?  Do you see value in having two implementations?
> Feedback is appreciated.

As I mentioned, my opinion is that let's unify them if either of them
is significantly win. It would be better to see some benchmark result.

> 
> >
> >How about this?
> >
> >1. Let's make CONFIG_DECOMPRESSOR_MAX which could be tuned by admin
> >  in Kconfig. default is CPU *2 or CPU, Otherwise, we can put it
> >  to sysfs so user can tune it in rumtime.
> >
> >2. put decompressor shrink logic by slab shrinker so if system has
> >  memory pressure, we could catch the event and free some of decompressor
> >  but memory pressure is not severe again in the future, we can create
> >  new decompressor until reaching threadhold user define.
> >  We could know system memory is enough by GFP_NOWAIT, not GFP_KERNEL
> >  in get_decomp_stream's allocation indirectly.
> 
> This adds extra complexity to an implementation already 199 lines long
> (as opposed to 104 for the percpu implementation).   The whole point of
> the percpu implementation is to add a simple implementation that
> may suit many systems.

Okay. finally I agree because I guess decompressor_multi's code complexity
might be large in future to control decomp_stream's size dynamically
in many core system and some system might hate it by memory overhead
In that case, per-cpu approach could works well by small amount of code.

>From now on, I don't object.

Thanks.

> 
> Phillip
> 
> >

-- 
Kind regards,
Minchan Kim
