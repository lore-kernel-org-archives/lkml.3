Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3JUX4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:56:07 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39593 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab3JUX4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:56:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEGALi9ZVJ5LAy1/2dsb2JhbABZgwe6CoU+gTAXdIIlAQEFJxMcIxAIAw4KCSUPBSUDIROIBbpeFo9FB4QpA5gIkgiDOCg
Date: Tue, 22 Oct 2013 10:56:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>, "Geyslan G. Bem" <geyslan@gmail.com>,
        kernel-br@googlegroups.com
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131021235601.GG4446@dastard>
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
 <5265956F.4010700@sandeen.net>
 <20131021224459.GE16161@dastard>
 <5265B4D2.3000907@sandeen.net>
 <20131021231849.GL10553@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021231849.GL10553@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 06:18:49PM -0500, Ben Myers wrote:
> Hey,
> 
> On Mon, Oct 21, 2013 at 06:12:18PM -0500, Eric Sandeen wrote:
> > On 10/21/13 5:44 PM, Dave Chinner wrote:
> > > On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
> > >> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
> > >>> This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
> > >>> dereferencing.
> > >>
> > >> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > > 
> > > Actually, NACK.
> > 
> > I felt that one coming ;)
> > 
> > >> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
> > >> xfs_emerg() doesn't.
> > >>
> > >> Dave, was that intentional?
> > > 
> > > Of course it was. ;) xfs_emerg() is only called from the debug code
> > > in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().
> > > 
> > > In the case of assfail(), it has it's own BUG() call, so it does
> > > everything just fine.
> > > 
> > > In the case of xlog_verify_iclog() when icptr is NULL, it will
> > > panic immediately after the message is printed, just like the old
> > > code. i.e. this patch isn't fixing anything we need fixed. 
> > 
> > A BUG() is probably warranted, then.
> 
> I tend to agree with Eric on this point.  If we want to crash, I'd rather our
> intent be very clear, rather than just see a null ptr deref.  ;)

Sure. ASSERT() would be better and more consistent with the rest of
the code. i.e:

        for (i = 0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
		ASSERT(icptr);

<Devil's Advocate>

However, I keep coming back to the fact that what we are checking is
that the list is correctly circular and that and adding an
ASSERT(icptr) to panic if a pointer chase finds a null pointer is
kinda redundant, especially as:

	- there's already 2 comments for the function indicating
	  that it is checking the validity of the pointers and that
	  they are circular....
	- we have repeatedly, over many years, justified the removal
	  of ASSERT(ptr) from code like:

		ASSERT(ptr);
		foo = ptr->foo;

	  as it is redundant because production code will always
	  panic the machine in that situation via the dereference.
	  ASSERT() is for documenting assumptions and constraints
	  that are not obvious from the code context.

IOWs, in this case the presence or absence of the ASSERT inside
*debug-only code* doesn't add any addition value to debugging such
problems, nor does it add any value in terms of documentation
because it's clear from the comments in the debug code that it
should not be NULL to begin with.

</Devil's Advocate>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
