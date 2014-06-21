Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaFUT3G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 15:29:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59556 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbaFUT3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 15:29:03 -0400
Message-ID: <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Tux3 for review
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Czerner <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 21 Jun 2014 12:29:01 -0700
In-Reply-To: <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
References: <5376B273.7000800@partner.samsung.com>
	 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
	 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
	 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
	 <20140613202039.GA23872@amd.pavel.ucw.cz>
	 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
	 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
	 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
	 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
	 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 14:58 -0700, Daniel Phillips wrote:
> On Thursday, June 19, 2014 2:26:48 AM PDT, Luká¨ Czerner wrote:
> > Let me remind you some more important problems Dave brought up,
> > including page forking:
> >
> > "
> >  The hacks around VFS and MM functionality need to have demonstrated
> >  methods for being removed.
> 
> We already removed 450 lines of core kernel workarounds from Tux3 with an 
> approach that was literally cut and pasted from one of Dave's emails. Then 
> Dave changed his mind. Now the Tux3 team has been assigned a research 
> project to improve core kernel writeback instead of simply adapting the 
> approach that is already proven to work well enough. That is a rather 
> blatant example of "perfect is the enemy of good enough". Please read the 
> thread.

That's a bit disingenuous: the concern has always been how page forking
interacted with writeback.  It's not new, it was one of the major things
brought up at LSF 14 months ago, so you weren't just assigned this.

> > We're not going to merge that page
> >  forking stuff (like you were told at LSF 2013 more than a year ago:
> >  http://lwn.net/Articles/548091/) without rigorous design review and
> >  a demonstration of the solutions to all the hard corner cases it
> >  has. The current code doesn't solve them (e.g. direct IO doesn't
> >  work in tux3), and there's no clear patch set we can review that
> >  demonstrates how it is all supposed to work. i.e. you need to
> >  separate out all the page forking code into a separate patchset for
> >  review, independent of the tux3 code and applies to the core mm/
> >  code.
> > "
> 
> Direct IO is a spurious issue. To recap: direct IO does not introduce any 
> new page forking issues. All of the page forking issues already exist with 
> normal buffered IO and mmap. We have little interest and scant available 
> time for heading off on a tangent to implement direct IO at this point just 
> as a precondition for merging.

The specific concern is that page forking cannot be made to work with
direct io.  Asserting that it doesn't cause any additional problems
isn't an answer to that concern.  Direct IO isn't actually a huge issue
for most filesystems (I mean even vfat has it).  The fact that you think
it is such a huge deal to implement for tux3 tends to lend credence to
this viewpoint.

The point is that if page forking won't work with direct IO at all, then
it's a broken design and there's no point merging it.

> On the other hand, page forking itself has a number of interesting issues. 
> Hirofumi is currently preparing a set of core kernel patches for review. 
> These patches explicitly do not attempt to package page forking up into a 
> nice and easy API that other filesystems could patch in tomorrow. That 
> would be an unreasonable research burden on our small development team. 
> Instead, we show how it works in Tux3, and if other filesystems want to get 
> those benefits, they can make similar changes. If we (the kernel community) 
> are lucky enough to find a pattern in it such that substantial parts of the 
> code can be abstracted into a library, then good. But requiring such a 
> library to be developed as a precondition to merging Tux3 is unreasonable.

OK, can we take a step back and ask why you're so keen to push this into
the tree?  The usual reason is ease of maintenance because in-tree
filesystems get updated as the vfs and mm APIs change.  However, the
reciprocal side of that is using standard VFS and MM APIs to make this
update and maintenance easy.  The reason no-one wants an in-tree
filesystem that implements its own writeback by hacking into the current
writeback system is that it's a huge maintenance burden.  Every time
writeback gets tweaked, tux3 will break meaning either we double the
burden on people updating writeback (to try to figure out how to
replicate the change in tux3) or we just accept that tux3 gets broken.
The former is unacceptable to the filesystem and mm people and the
latter would mean there's not really much point merging tux3 if we just
keep breaking it ... it's better to keep it out of tree where the
breakages can be fixed by people who understand them on their own
timescales.

The object of the exercise is *not* for you to convert every filesystem
to tux3, it's to see if there's a way of integrating enough of page
forking into the current writeback code that tux3 uses standard APIs and
doesn't multiply the burden on the people who maintain and update the
writeback code.

> > "
> >  Then there's all the writeback hacks. You've simply copy-n-pasted
> >  most of fs-writeback.c, including duplicating structures like struct
> >  wb_writeback_work and then hacked in crap (kallsyms lookups!) to be
> >  able to access core structures from kernel module context
> >  (tux3_setup_writeback(), I'm looking at you). This is completely
> >  unacceptible for a merge. Again, you need to separate out all the
> >  writeback changes you need into an independent patchset so that they
> >  can be reviewed independently of the tux3 code that uses it.
> > "
> 
> That was already fixed as noted above, and all the relevant changes were 
> already posted as an independent patch set. After that, some developers 
> weighed in with half formed ideas about how the same thing could be done 
> better, but without concrete suggestions. There is nothing wrong with half 
> formed ideas, except when they turn into a way of blocking forward 
> progress. See "perfect is the enemy of good enough" above.

Could you post the url to the new series, please, I must have missed it;
seeing the patches that implement the API for insertion into the
writeback code would certainly help frame this discussion.

> It is worth noting that we (the kernel community) have been thrashing away 
> at the writeback problem for more than twenty years, and the current 
> solution still leaves much to be desired. It is unfair to expect us, the 
> Tux3 team, to fix that mess in a week or two, just to merge our filesystem. 
> We prefer to adapt the existing infrastructure for now, as expressed in the 
> currently proposed patch set. With that, we allow core to mark our inodes 
> dirty just as it has always done, and we continue to use the usual inode 
> writeback lists for writeback sheduling, which work just fine.

So that's a misunderstanding of expectations; the actual expectation is
that you won't make the writeback problem more difficult to tackle.
Reimplementing writeback within your code in a way that's hacked into
the system is fragile and burdensome: as I said above, it becomes double
the code to maintain and tux3 breaks if its not updated.

James


