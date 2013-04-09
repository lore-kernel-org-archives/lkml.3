Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936220Ab3DIU2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:28:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41962 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936020Ab3DIU2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:28:07 -0400
MIME-Version: 1.0
Message-ID: <c3d40e0f-68b3-45a4-9251-a97c59a50b2e@default>
Date: Tue, 9 Apr 2013 13:25:45 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        Shuah Khan <shuah@gonehiking.org>
Subject: RE: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from
 zram in-memory)
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
 <f3c8ef05-a880-47db-86dd-156038fc7d0f@default>
 <20130409012719.GB3467@blaptop>
In-Reply-To: <20130409012719.GB3467@blaptop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from zram in-memory)
> 
> Hi Dan,
> 
> On Mon, Apr 08, 2013 at 09:32:38AM -0700, Dan Magenheimer wrote:
> > > From: Minchan Kim [mailto:minchan@kernel.org]
> > > Sent: Monday, April 08, 2013 12:01 AM
> > > Subject: [PATCH] mm: remove compressed copy from zram in-memory
> >
> > (patch removed)
> >
> > > Fragment ratio is almost same but memory consumption and compile time
> > > is better. I am working to add defragment function of zsmalloc.
> >
> > Hi Minchan --
> >
> > I would be very interested in your design thoughts on
> > how you plan to add defragmentation for zsmalloc.  In
> 
> What I can say now about is only just a word "Compaction".
> As you know, zsmalloc has a transparent handle so we can do whatever
> under user. Of course, there is a tradeoff between performance
> and memory efficiency. I'm biased to latter for embedded usecase.

Have you designed or implemented this yet?  I have a couple
of concerns:

1) The handle is transparent to the "user", but it is still a form
   of a "pointer" to a zpage.  Are you planning on walking zram's
   tables and changing those pointers?  That may be OK for zram
   but for more complex data structures than tables (as in zswap
   and zcache) it may not be as easy, due to races, or as efficient
   because you will have to walk potentially very large trees.
2) Compaction in the kernel is heavily dependent on page migration
   and page migration is dependent on using flags in the struct page.
   There's a lot of code in those two code modules and there
   are going to be a lot of implementation differences between
   compacting pages vs compacting zpages.

I'm also wondering if you will be implementing "variable length
zspages".  Without that, I'm not sure compaction will help
enough.  (And that is a good example of the difference between
the kernel page compaction design/code and zspage compaction.)

> > particular, I am wondering if your design will also
> > handle the requirements for zcache (especially for
> > cleancache pages) and perhaps also for ramster.
> 
> I don't know requirements for cleancache pages but compaction is
> general as you know well so I expect you can get a benefit from it
> if you are concern on memory efficiency but not sure it's valuable
> to compact cleancache pages for getting more slot in RAM.
> Sometime, just discarding would be much better, IMHO.

Zcache has page reclaim.  Zswap has zpage reclaim.  I am
concerned that these continue to work in the presence of
compaction.   With no reclaim at all, zram is a simpler use
case but if you implement compaction in a way that can't be
used by either zcache or zswap, then zsmalloc is essentially
forking.

> > In https://lkml.org/lkml/2013/3/27/501 I suggested it
> > would be good to work together on a common design, but
> > you didn't reply.  Are you thinking that zsmalloc
> 
> I saw the thread but explicit agreement is really matter?
> I believe everybody want it although they didn't reply. :)
> 
> You can make the design/post it or prototyping/post it.
> If there are some conflit with something in my brain,
> I will be happy to feedback. :)
> 
> Anyway, I think my above statement "COMPACTION" would be enough to
> express my current thought to avoid duplicated work and you can catch up.
> 
> I will get around to it after LSF/MM.
> 
> > improvements should focus only on zram, in which case
> 
> Just focusing zsmalloc.

Right.  Again, I am asking if you are changing zsmalloc in
a way that helps zram but hurts zswap and makes it impossible
for zcache to ever use the improvements to zsmalloc.

If so, that's fine, but please make it clear that is your goal.

> > we may -- and possibly should -- end up with a different
> > allocator for frontswap-based/cleancache-based compression
> > in zcache (and possibly zswap)?
> 
> > I'm just trying to determine if I should proceed separately
> > with my design (with Bob Liu, who expressed interest) or if
> > it would be beneficial to work together.
> 
> Just posting and if it affects zsmalloc/zram/zswap and goes the way
> I don't want, I will involve the discussion because our product uses
> zram heavily and consider zswap, too.
> 
> I really appreciate your enthusiastic collaboration model to find
> optimal solution!

My goal is to have compression be an integral part of Linux
memory management.  It may be tied to a config option, but
the goal is that distros turn it on by default.  I don't think
zsmalloc meets that objective yet, but it may be fine for
your needs.  If so it would be good to understand exactly why
it doesn't meet the other zproject needs.
