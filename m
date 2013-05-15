Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab3EORMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:12:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38337 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab3EORM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:12:27 -0400
MIME-Version: 1.0
Message-ID: <4d74f5db-11c1-4f58-97f4-8d96bbe601ac@default>
Date: Wed, 15 May 2013 10:09:50 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: RE: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default>
 <20130514163541.GC4024@medulla>
 <f0272a06-141a-4d33-9976-ee99467f3aa2@default>
 <20130514225501.GA11956@cerebellum>
In-Reply-To: <20130514225501.GA11956@cerebellum>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> On Tue, May 14, 2013 at 01:18:48PM -0700, Dan Magenheimer wrote:
> > > From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> > > Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> > >
> > > <snip>
> > >
> > > > > +/* The maximum percentage of memory that the compressed pool can occupy */
> > > > > +static unsigned int zswap_max_pool_percent = 20;
> > > > > +module_param_named(max_pool_percent,
> > > > > +			zswap_max_pool_percent, uint, 0644);
> > >
> > > <snip>
> > >
> > > > This limit, along with the code that enforces it (by calling reclaim
> > > > when the limit is reached), is IMHO questionable.  Is there any
> > > > other kernel memory allocation that is constrained by a percentage
> > > > of total memory rather than dynamically according to current
> > > > system conditions?  As Mel pointed out (approx.), if this limit
> > > > is reached by a zswap-storm and filled with pages of long-running,
> > > > rarely-used processes, 20% of RAM (by default here) becomes forever
> > > > clogged.
> > >
> > > So there are two comments here 1) dynamic pool limit and 2) writeback
> > > of pages in zswap that won't be faulted in or forced out by pressure.
> > >
> > > Comment 1 feeds from the point of view that compressed pages should just be
> > > another type of memory managed by the core MM.  While ideal, very hard to
> > > implement in practice.  We are starting to realize that even the policy
> > > governing to active vs inactive list is very hard to get right. Then shrinkers
> > > add more complexity to the policy problem.  Throwing another type in the mix
> > > would just that much more complex and hard to get right (assuming there even
> > > _is_ a "right" policy for everyone in such a complex system).
> > >
> > > This max_pool_percent policy is simple, works well, and provides a
> > > deterministic policy that users can understand. Users can be assured that a
> > > dynamic policy heuristic won't go nuts and allow the compressed pool to grow
> > > unbounded or be so aggressively reclaimed that it offers no value.
> >
> > Hi Seth --
> >
> > Hmmm... I'm not sure how to politely say "bullshit". :-)
> >
> > The default 20% was randomly pulled out of the air long ago for zcache
> > experiments.  If you can explain why 20% is better than 19% or 21%, or
> > better than 10% or 30% or even 50%, that would be a start.  Then please try
> > to explain -- in terms an average sysadmin can understand -- under
> > what circumstances this number should be higher or lower, that would
> > be even better.  In fact if you can explain it in even very broadbrush
> > terms like "higher for embedded" and "lower for server" that would be
> > useful.  If the top Linux experts in compression can't answer these
> > questions (and the default is a random number, which it is), I don't
> > know how we can expect users to be "assured".
> 
> 20% is a default maximum.  There really isn't a particular reason for the
> selection other than to supply reasonable default to a tunable.  20% is enough
> to show the benefit while assuring the user zswap won't eat more than that
> amount of memory under any circumstance.  The point is to make it a tunable,
> not to launch an incredibly in-depth study on what the default should be.

My point is that a tunable is worthless -- and essentially the same as
a fixed value -- unless you can clearly instruct target users how to
change it to match their needs.
 
> As guidance on how to tune it, switching to zbud actually made the math simpler
> by bounding the best case to 2 and the expected density to very near 2.  I have
> two methods, one based on calculation and another based on experimentation.
>
> Yes, I understand that there are many things to consider, but for the sake of
> those that honestly care about the answer to the question, I'll answer it.
> 
> Method 1:
> 
> If you have a workload running on a machine with x GB of RAM and an anonymous
> working set of y GB of pages where x < y, a good starting point for
> max_pool_percent is ((y/x)-1)*100.
> 
> For example, if you have 10GB of RAM and 12GB anon working set, (12/10-1)*100 =
> 20.  During operation there would be 8GB in uncompressed memory, and 4GB worth
> of compressed memory occupying 2GB (i.e. 20%) of RAM.  This will reduce swap I/O
> to near zero assuming the pages compress <50% on average.
> 
> Bear in mind that this formula provides a lower bound on max_pool_percent if
> you want to avoid swap I/0.  Setting max_pool_percent to >20 would produce
> the same situation.

OK, let's try to apply your method.  You personally have undoubtedly
compiled the kernel hundreds, maybe thousands of times in the last year.
In the restricted environment where you and I have run benchmarks, this
is a fairly stable and reproducible workload == stable and reproducible
are somewhat rare in the real world.

Can you tell me what the "anon working set" is of compiling the kernel?
Have you, one of the top experts in Linux compression technology, ever
even once changed the max_pool_percent in your benchmark runs even as
an experiment?

This method also makes the assumption that the users that are
going to enable zswap are doing so because their system is currently
swapping its poor brains out (and for some reason can't increase the
RAM in their system).  I sure hope that's not the only reason users
will enable it.
 
> Method 2:
> 
> Experimentally, one can just watch swap I/O rates while the workload is running
> and increase max_pool_percent until no (or acceptable level of) swap I/O is
> occurring.
> 
> As max_pool_percent increases, however, there is less and less room for
> uncompressed memory, the only kind of memory on which the kernel can actually
> operate. Compression/decompression activity might start dominating over useful
> work.  Going over 80 is probably not advised.  If swap I/O is still observed
> for high values of max_pool_percent, then the memory load should be reduced,
> memory capacity should be increased, or performance degradation should be accepted.

Method 2 assumes workloads are reproducible/idempotent.

So, I don't think either of these methods are answers to my question,
just handwaving.

> > What you mean is "works well"... on the two benchmarks you've tried it
> > on.  You say it's too hard to do dynamically... even though every other
> > significant RAM user in the kernel has to do it dynamically.
> > Workloads are dynamic and heavy users of RAM needs to deal with that.
> > You don't see a limit on the number of anonymous pages in the MM subsystem,
> > and you don't see a limit on the number of inodes in btrfs.  Linus
> > would rightfully barf all over those limits and (if he was paying attention
> > to this discussion) he would barf on this limit too.
> 
> Putting a user-tunable hard limit on the size of the compressed pool is in _no
> way_ analogous to putting an fixed upper bound on system-wide anonymous memory
> or number of inodes.  In fact, they are so dissimilar, I don't know what else to
> say about the attempted comparison.

I'm not sure why we disagree here, but I see them as very similar.
 
> zswap is not like other caches in the kernel. Most caches make use of
> unused/less recently used memory in an effort to improve performance by
> avoiding rereads from persistent media.  In the case of zswap, its size is near
> 0 until memory pressure hits a threshold; a point at which traditional caches
> start shrinking.  zswap _grows_ under memory pressure while all other caches
> shrink.  This is why traditional cache sizing policies and techniques don't
> work with zswap. In the absence of any precedent policy for this kind of
> caching, zswap goes with a simple, but understandable one: user-tunable cap
> on the maximum size and shrink through pressure and (soon) age driven writeback.

Zswap is not like other caches in the kernel because it is not a cache
at all.  It is simply a mechanism whereby the MM subsystem can increase
the total number of anonymous pages stored in RAM by identifying (via
frontswap) and compressing (via LZO) the lowest priority anonymous pages,
then decompressing them when a page fault occurs.  The swap subsystem
is just a convenient place to put the hooks because it clearly identifies
the lowest priority anonymous pages -- and also provides a convenient
key (type+offset) to identify the compressed page (which obviously can't
be addressed using normal CPU direct addressing mechanisms)

The precedent policy is the MM subsystem itself, which is responsible
for managing the quantity of pages used for a wide variety of uses and
the priority of these classes against each other.  It must do this
dynamically, not just because it must handle different kinds of
workloads, but also because each one of those workloads vary
dramatically across time.  Compressed anonymous pages are still
a form of anonymous pages and, to the extent possible, need to be
counted and managed/prioritized as anonymous pages when the
MM subsystem is making policy decisions.

So any artificial limit in the MM subsystem (even as a percentage of
total RAM) is very suspicious and deserves scrutiny.  As I said,
your max_pages solution is simple only because you are ignoring the
harder part of the problem and and now also pretending that users/distros
will ever have any clue at all as to how to solve that harder part of
the problem.

Sorry, but I don't think that's appropriate for a patch in the MM subsystem.

Thanks,
Dan
