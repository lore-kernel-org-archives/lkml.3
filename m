Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017Ab3DKRs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:48:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43203 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868Ab3DKRs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:48:58 -0400
MIME-Version: 1.0
Message-ID: <f3841afd-d5af-49d2-b1a1-7a93160c2d77@default>
Date: Thu, 11 Apr 2013 10:46:53 -0700 (PDT)
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
 <c3d40e0f-68b3-45a4-9251-a97c59a50b2e@default>
 <20130410005004.GF6836@blaptop>
In-Reply-To: <20130410005004.GF6836@blaptop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from zram in-memory)
> 
> On Tue, Apr 09, 2013 at 01:25:45PM -0700, Dan Magenheimer wrote:
> > > From: Minchan Kim [mailto:minchan@kernel.org]
> > > Subject: Re: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from zram in-memory)
> > >
> > > Hi Dan,
> > >
> > > On Mon, Apr 08, 2013 at 09:32:38AM -0700, Dan Magenheimer wrote:
> > > > > From: Minchan Kim [mailto:minchan@kernel.org]
> > > > > Sent: Monday, April 08, 2013 12:01 AM
> > > > > Subject: [PATCH] mm: remove compressed copy from zram in-memory
> > > >
> > > > (patch removed)
> > > >
> > > > > Fragment ratio is almost same but memory consumption and compile time
> > > > > is better. I am working to add defragment function of zsmalloc.
> > > >
> > > > Hi Minchan --
> > > >
> > > > I would be very interested in your design thoughts on
> > > > how you plan to add defragmentation for zsmalloc.  In
> > >
> > > What I can say now about is only just a word "Compaction".
> > > As you know, zsmalloc has a transparent handle so we can do whatever
> > > under user. Of course, there is a tradeoff between performance
> > > and memory efficiency. I'm biased to latter for embedded usecase.
> >
> > Have you designed or implemented this yet?  I have a couple
> > of concerns:
> 
> Not yet implemented but just had a time to think about it, simply.
> So surely, there are some obstacle so I want to uncase the code and
> number after I make a prototype/test the performance.
> Of course, if it has a severe problem, will drop it without wasting
> many guys's time.

OK.  I have some ideas that may similar or may be very different
than yours.  Likely different, since I am coming at it from the
angle of zcache which has some different requirements.  So
I'm hoping that by discussing design we can incorporate some
of the zcache requirements before coding.

> > 1) The handle is transparent to the "user", but it is still a form
> >    of a "pointer" to a zpage.  Are you planning on walking zram's
> >    tables and changing those pointers?  That may be OK for zram
> >    but for more complex data structures than tables (as in zswap
> >    and zcache) it may not be as easy, due to races, or as efficient
> >    because you will have to walk potentially very large trees.
> 
> Rough concept is following as.
> 
> I'm considering for zsmalloc to return transparent fake handle
> but we have to maintain it with real one.
> It could be done in zsmalloc internal so there isn't any race we should consider.

That sounds very difficult because I think you will need
an extra level of indirection to translate every fake handle
to every real handle/pointer (like virtual-to-physical page tables).
Or do you have some more clever idea?

> > 2) Compaction in the kernel is heavily dependent on page migration
> >    and page migration is dependent on using flags in the struct page.
> >    There's a lot of code in those two code modules and there
> >    are going to be a lot of implementation differences between
> >    compacting pages vs compacting zpages.
> 
> Compaction of kernel is never related to zsmalloc's one.

OK.  Compaction has certain meaning in the kernel.  Defrag
is usually used I think for what we are discussing here.
So I thought you might be planning on doing exactly what
the kernel does that it calls compaction.

> > I'm also wondering if you will be implementing "variable length
> > zspages".  Without that, I'm not sure compaction will help
> > enough.  (And that is a good example of the difference between
> 
> Why do you think so?
> variable lengh zspage could be further step to improve but it's not
> only a solution to solve fragmentation.

In my partial-design-in-my-head, they are related, but I
think I understand what you mean.  You are planning to
move zpages across zspage boundaries, and I am not.  So
I think your solution will result in better density but
may be harder to implement.

> > > > particular, I am wondering if your design will also
> > > > handle the requirements for zcache (especially for
> > > > cleancache pages) and perhaps also for ramster.
> > >
> > > I don't know requirements for cleancache pages but compaction is
> > > general as you know well so I expect you can get a benefit from it
> > > if you are concern on memory efficiency but not sure it's valuable
> > > to compact cleancache pages for getting more slot in RAM.
> > > Sometime, just discarding would be much better, IMHO.
> >
> > Zcache has page reclaim.  Zswap has zpage reclaim.  I am
> > concerned that these continue to work in the presence of
> > compaction.   With no reclaim at all, zram is a simpler use
> > case but if you implement compaction in a way that can't be
> > used by either zcache or zswap, then zsmalloc is essentially
> > forking.
> 
> Don't go too far. If it's really problem for zswap and zcache,
> maybe, we could add it optionally.

Good, I think it should be possible to do it optionally too.

> > > > In https://lkml.org/lkml/2013/3/27/501 I suggested it
> > > > would be good to work together on a common design, but
> > > > you didn't reply.  Are you thinking that zsmalloc
> > >
> > > I saw the thread but explicit agreement is really matter?
> > > I believe everybody want it although they didn't reply. :)
> > >
> > > You can make the design/post it or prototyping/post it.
> > > If there are some conflit with something in my brain,
> > > I will be happy to feedback. :)
> > >
> > > Anyway, I think my above statement "COMPACTION" would be enough to
> > > express my current thought to avoid duplicated work and you can catch up.
> > >
> > > I will get around to it after LSF/MM.
> > >
> > > > improvements should focus only on zram, in which case
> > >
> > > Just focusing zsmalloc.
> >
> > Right.  Again, I am asking if you are changing zsmalloc in
> > a way that helps zram but hurts zswap and makes it impossible
> > for zcache to ever use the improvements to zsmalloc.
> 
> As I said, I'm biased to memory efficiency rather than performace.
> Of course, severe performance drop is disaster but small drop will
> be acceptable for memory-efficiency concerning systems.
> >
> > If so, that's fine, but please make it clear that is your goal.
> 
> Simple, help memory hungry system. :)

One major difference I think is that you are focused on systems
where processes often get destroyed by OOMs (e.g. Android-like),
where I am focused on server systems where everything possible
must be done to avoid killed processes.  So IMHO writeback and
better integration with the MM system are a requirement.  I
think that's a key difference between zram and zcache that
is driving different design decisions.

Dan
