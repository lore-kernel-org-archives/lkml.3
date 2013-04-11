Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575Ab3DKX2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:28:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DKX2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:28:33 -0400
MIME-Version: 1.0
Message-ID: <764b8d66-5456-4bd0-b7a4-5fa3aaf717dd@default>
Date: Thu, 11 Apr 2013 16:28:19 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <bob.liu@oracle.com>
Subject: RE: zsmalloc zbud hybrid design discussion?
References: <ef105888-1996-4c78-829a-36b84973ce65@default>
 <20130411193534.GB28296@cerebellum>
In-Reply-To: <20130411193534.GB28296@cerebellum>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Bob Liu added)

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: zsmalloc zbud hybrid design discussion?
> 
> On Wed, Mar 27, 2013 at 01:04:25PM -0700, Dan Magenheimer wrote:
> > Seth and all zproject folks --
> >
> > I've been giving some deep thought as to how a zpage
> > allocator might be designed that would incorporate the
> > best of both zsmalloc and zbud.
> >
> > Rather than dive into coding, it occurs to me that the
> > best chance of success would be if all interested parties
> > could first discuss (on-list) and converge on a design
> > that we can all agree on.  If we achieve that, I don't
> > care who writes the code and/or gets the credit or
> > chooses the name.  If we can't achieve consensus, at
> > least it will be much clearer where our differences lie.
> >
> > Any thoughts?

Hi Seth!
 
> I'll put some thoughts, keeping in mind that I'm not throwing zsmalloc under
> the bus here.  Just what I would do starting from scratch given all that has
> happened.

Excellent.  Good food for thought.  I'll add some of my thinking
too and we can talk more next week.

BTW, I'm not throwing zsmalloc under the bus either.  I'm OK with
using zsmalloc as a "base" for an improved hybrid, and even calling
the result "zsmalloc".  I *am* however willing to throw the
"generic" nature of zsmalloc away... I think the combined requirements
of the zprojects are complex enough and the likelihood of zsmalloc
being appropriate for future "users" is low enough, that we should
accept that zsmalloc is highly tuned for zprojects and modify it
as required.  I.e. the API to zsmalloc need not be exposed to and
documented for the rest of the kernel.
 
> Simplicity - the simpler the better

Generally I agree.  But only if the simplicity addresses the
whole problem.  I'm specifically very concerned that we have
an allocator that works well across a wide variety of zsize distributions,
even if it adds complexity to the allocator.

> High density - LZO best case is ~40 bytes. That's around 1/100th of a page.
> I'd say it should support up to at least 64 object per page in the best case.
> (see Reclaim effectiveness before responding here)

Hmmm... if you pre-check for zero pages, I would guess the percentage
of pages with zsize less than 64 is actually quite small.  But 64 size
classes may be a good place to start as long as it doesn't overly
complicate or restrict other design points.

> No slab - the slab approach limits LRU and swap slot locality within the pool
> pages.  Also swap slots have a tendency to be freed in clusters.  If we improve
> locality within each pool page, it is more likely that page will be freed
> sooner as the zpages it contains will likely be invalidated all together.

"Pool page" =?= "pageframe used by zsmalloc"

Isn't it true that that there is no correlation between whether a
page is in the same cluster and the zsize (and thus size class) of
the zpage?  So every zpage may end up in a different pool page
and this theory wouldn't work.  Or am I misunderstanding?

> Also, take a note out of the zbud playbook at track LRU based on pool pages,
> not zpages.  One would fill allocation requests from the most recently used
> pool page.

Yes, I'm also thinking that should be in any hybrid solution.
A "global LRU queue" (like in zbud) could also be applicable to entire zspages;
this is similar to pageframe-reclaim except all the pageframes in a zspage
would be claimed at the same time.

> Reclaim effectiveness - conflicts with density. As the number of zpages per
> page increases, the odds decrease that all of those objects will be
> invalidated, which is necessary to free up the underlying page, since moving
> objects out of sparely used pages would involve compaction (see next).  One
> solution is to lower the density, but I think that is self-defeating as we lose
> much the compression benefit though fragmentation. I think the better solution
> is to improve the likelihood that the zpages in the page are likely to be freed
> together through increased locality.

I do think we should seriously reconsider ZS_MAX_ZSPAGE_ORDER==2.
The value vs ZS_MAX_ZSPAGE_ORDER==0 is enough for most cases and
1 is enough for the rest.  If get_pages_per_zspage were "flexible",
there might be a better tradeoff of density vs reclaim effectiveness.

I've some ideas along the lines of a hybrid adaptively combining
buddying and slab which might make it rarely necessary to have
pages_per_zspage exceed 2.  That also might make it much easier
to have "variable sized" zspages (size is always one or two).

> Not a requirement:
> 
> Compaction - compaction would basically involve creating a virtual address
> space of sorts, which zsmalloc is capable of through its API with handles,
> not pointer.  However, as Dan points out this requires a structure the maintain
> the mappings and adds to complexity.  Additionally, the need for compaction
> diminishes as the allocations are short-lived with frontswap backends doing
> writeback and cleancache backends shrinking.

I have an idea that might be a step towards compaction but
it is still forming.  I'll think about it more and, if
it makes sense by then, we can talk about it next week.

> So just some thoughts to start some specific discussion.  Any thoughts?

Thanks for your thoughts and moving the conversation forward!
It will be nice to talk about this f2f instead of getting sore
fingers from long typing!

Dan
