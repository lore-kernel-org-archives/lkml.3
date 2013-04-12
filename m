Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab3DLUPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:15:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44464 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab3DLUPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:15:36 -0400
Date: Fri, 12 Apr 2013 15:15:12 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: zsmalloc zbud hybrid design discussion?
Message-ID: <20130412201512.GB18888@cerebellum>
References: <ef105888-1996-4c78-829a-36b84973ce65@default>
 <20130411193534.GB28296@cerebellum>
 <764b8d66-5456-4bd0-b7a4-5fa3aaf717dd@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764b8d66-5456-4bd0-b7a4-5fa3aaf717dd@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041220-9360-0000-0000-000011B86601
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 04:28:19PM -0700, Dan Magenheimer wrote:
> (Bob Liu added)
> 
> > From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> > Subject: Re: zsmalloc zbud hybrid design discussion?
> > 
> > On Wed, Mar 27, 2013 at 01:04:25PM -0700, Dan Magenheimer wrote:
> > > Seth and all zproject folks --
> > >
> > > I've been giving some deep thought as to how a zpage
> > > allocator might be designed that would incorporate the
> > > best of both zsmalloc and zbud.
> > >
> > > Rather than dive into coding, it occurs to me that the
> > > best chance of success would be if all interested parties
> > > could first discuss (on-list) and converge on a design
> > > that we can all agree on.  If we achieve that, I don't
> > > care who writes the code and/or gets the credit or
> > > chooses the name.  If we can't achieve consensus, at
> > > least it will be much clearer where our differences lie.
> > >
> > > Any thoughts?
> 
> Hi Seth!
>  
> > I'll put some thoughts, keeping in mind that I'm not throwing zsmalloc under
> > the bus here.  Just what I would do starting from scratch given all that has
> > happened.
> 
> Excellent.  Good food for thought.  I'll add some of my thinking
> too and we can talk more next week.
> 
> BTW, I'm not throwing zsmalloc under the bus either.  I'm OK with
> using zsmalloc as a "base" for an improved hybrid, and even calling
> the result "zsmalloc".  I *am* however willing to throw the
> "generic" nature of zsmalloc away... I think the combined requirements
> of the zprojects are complex enough and the likelihood of zsmalloc
> being appropriate for future "users" is low enough, that we should
> accept that zsmalloc is highly tuned for zprojects and modify it
> as required.  I.e. the API to zsmalloc need not be exposed to and
> documented for the rest of the kernel.
>  
> > Simplicity - the simpler the better
> 
> Generally I agree.  But only if the simplicity addresses the
> whole problem.  I'm specifically very concerned that we have
> an allocator that works well across a wide variety of zsize distributions,
> even if it adds complexity to the allocator.
> 
> > High density - LZO best case is ~40 bytes. That's around 1/100th of a page.
> > I'd say it should support up to at least 64 object per page in the best case.
> > (see Reclaim effectiveness before responding here)
> 
> Hmmm... if you pre-check for zero pages, I would guess the percentage
> of pages with zsize less than 64 is actually quite small.  But 64 size
> classes may be a good place to start as long as it doesn't overly
> complicate or restrict other design points.
> 
> > No slab - the slab approach limits LRU and swap slot locality within the pool
> > pages.  Also swap slots have a tendency to be freed in clusters.  If we improve
> > locality within each pool page, it is more likely that page will be freed
> > sooner as the zpages it contains will likely be invalidated all together.
> 
> "Pool page" =?= "pageframe used by zsmalloc"

Yes.

> 
> Isn't it true that that there is no correlation between whether a
> page is in the same cluster and the zsize (and thus size class) of
> the zpage?  So every zpage may end up in a different pool page
> and this theory wouldn't work.  Or am I misunderstanding?

I think so.  I didn't say this outright and should have: I'm thinking along the
lines of a first-fit type method.  So you just stack zpages up in a page until
the page is full then allocate a new one.  Searching for free slots would
ideally be done in reverse LRU so that you put new zpages in the most recently
allocated page that has room.  I'm still thinking how to do that efficiently.

> 
> > Also, take a note out of the zbud playbook at track LRU based on pool pages,
> > not zpages.  One would fill allocation requests from the most recently used
> > pool page.
> 
> Yes, I'm also thinking that should be in any hybrid solution.
> A "global LRU queue" (like in zbud) could also be applicable to entire zspages;
> this is similar to pageframe-reclaim except all the pageframes in a zspage
> would be claimed at the same time.

This brings up another thing that I left out that might be the stickiest part,
eviction and reclaim.  We first have to figure out if eviction is going to be
initiated by the user or by the allocator.

If we do it in the allocator, then I think we are going to muck up the API
because you'll have to register and eviction notification function that the
allocator can call, once for each zpage in the page frame the allocator is
trying to reclaim/free.  The locking might get hairy in that case (user ->
allocator -> user).  Additionally the user would have to maintain a different
lookup system for zpages by address/handle.  Alternatively, you could
add yet another user-provided callback function to extract the users zpage
identifier, like zbuds tmem_handle, from the zpage itself.

The advantage of doing it in the allocator is it has a page-level view of what
is going on and therefore can target zpages for eviction in order to free up
entire page frames.  If the allocator doesn't do this job, then it would have
to have some API for providing information to the user about which zpages
share a page with a given zpage so that the user can initiate the eviction.

Either way, it's challenging to make clean.

> 
> > Reclaim effectiveness - conflicts with density. As the number of zpages per
> > page increases, the odds decrease that all of those objects will be
> > invalidated, which is necessary to free up the underlying page, since moving
> > objects out of sparely used pages would involve compaction (see next).  One
> > solution is to lower the density, but I think that is self-defeating as we lose
> > much the compression benefit though fragmentation. I think the better solution
> > is to improve the likelihood that the zpages in the page are likely to be freed
> > together through increased locality.
> 
> I do think we should seriously reconsider ZS_MAX_ZSPAGE_ORDER==2.
> The value vs ZS_MAX_ZSPAGE_ORDER==0 is enough for most cases and
> 1 is enough for the rest.  If get_pages_per_zspage were "flexible",
> there might be a better tradeoff of density vs reclaim effectiveness.
> 
> I've some ideas along the lines of a hybrid adaptively combining
> buddying and slab which might make it rarely necessary to have
> pages_per_zspage exceed 2.  That also might make it much easier
> to have "variable sized" zspages (size is always one or two).
> 
> > Not a requirement:
> > 
> > Compaction - compaction would basically involve creating a virtual address
> > space of sorts, which zsmalloc is capable of through its API with handles,
> > not pointer.  However, as Dan points out this requires a structure the maintain
> > the mappings and adds to complexity.  Additionally, the need for compaction
> > diminishes as the allocations are short-lived with frontswap backends doing
> > writeback and cleancache backends shrinking.
> 
> I have an idea that might be a step towards compaction but
> it is still forming.  I'll think about it more and, if
> it makes sense by then, we can talk about it next week.
> 
> > So just some thoughts to start some specific discussion.  Any thoughts?
> 
> Thanks for your thoughts and moving the conversation forward!
> It will be nice to talk about this f2f instead of getting sore
> fingers from long typing!

Agreed! Talking has much higher throughput than typing :)

Thanks,
Seth

