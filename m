Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3GCEtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:49:16 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63470 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787Ab3GCEtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:49:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQMANms01F5LCeA/2dsb2JhbABagwm7bYUlBAGBAhd0giMBAQQBJxMcIwULCAMYCSUPBSUDIROICQW7VBaOMoEdB4NtA5dJkUaDIyo
Date: Wed, 3 Jul 2013 14:49:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130703044901.GI14996@dastard>
References: <20130701120037.GA6196@quack.suse.cz>
 <20130702062954.GA14996@dastard>
 <20130702081937.GA31770@quack.suse.cz>
 <20130702123835.GF14996@dastard>
 <20130702140508.GB31770@quack.suse.cz>
 <CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
 <20130702165752.GA12179@quack.suse.cz>
 <CA+55aFxSY76aWEC04yREjFObPF3ZJFMHdczoT=yGmSpsg5hhyg@mail.gmail.com>
 <20130703030759.GG14996@dastard>
 <CA+55aFxN2-qZwBywE3b+RYyPLg1-ru5ZwJLHLohy0KJ0fD0vqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxN2-qZwBywE3b+RYyPLg1-ru5ZwJLHLohy0KJ0fD0vqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 08:28:42PM -0700, Linus Torvalds wrote:
> On Tue, Jul 2, 2013 at 8:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>
> >> Then that test would become
> >>
> >>         if (wbc->sync_mode == WB_SYNC_SINGLE) {
> >>
> >> instead, and now "sync_mode" would actually describe what mode of
> >> syncing the caller wants, without that hacky special "we know what the
> >> caller _really_ meant by looking at *which* caller it is".
> >
> > The problem is that all the code that currently looks for
> > WB_SYNC_ALL for it's behavioural cue during writeback now has
> > multiple different modes they have to handle.  IOWs, it's not a
> > straight forward conversion process. WB_SYNC_ALL reaches right down
> > into filesystem ->writepages implementations and they all need to be
> > changed if we make up a new sync_mode behaviour.
> 
> I have to admit that I absolutely detest our current "sync_mode" to
> begin with, so I'd personally be happy to see some major surgery in
> this area.
> 
> For example, maybe we'd be much better off with something that has
> various behavioral flags rather than distinct "mode values".  So
> instead of being an enum of different reasons for syncing, it would be
> a set of bitmasks for specific sync behavior. We have a much better
> sync model in our sync_file_range() model, where we have flags like
> SYNC_FILE_RANGE_WAIT_xxx (where xxx is BEFORE, WRITE, AFTER to
> describe whether you should wait for old writes, start new writes, or
> wait after the newly started writes).

I agree that the flag model for writeback behaviour that it uses is
a good example to follow.

> That's a very powerful model, and it's also much more easy to think
> about. So the above test could become
> 
>         if (wbc->sync_mode & WB_SYNC_AFTER) {
>                 int err = filemap_fdatawait(mapping);
>                 ....
> 
> in that kind of model, and the code actually looks sensible. It reads
> like "if the caller asked us to synchronize after writing, then we do
> an fdatawait on the mapping".

*nod*

> So I think something like that might make sense. And there aren't
> _that_ many users of WB_SYNC_xxx, and the patch should be pretty
> straightforward.

Patching might be straight forward, but the testing isn't - it's
spread across 30 different filesystems...

> WB_SYNC_NONE semantics would presumably be "just
> start writeout" (so it would become WB_SYNC_WRITE), while WB_SYNC_ALL
> would become (WB_SYNC_BEFORE | WB_SYNC_WRITE | WB_SYNC_AFTER), but
> then the "for_sync" case would remove WB_SYNC_AFTER, because it does
> its own waiting after.

Not exactly. WB_SYNC_NONE currently means "best effort writeback"
which means if we are going to block on a lock, it's ok to abort
writeback as we can try again later. For writeback, WB_SYNC_ALL
means "write everything that is dirty" and means we must block
waiting for locks to do the required writeback.  So there's WB_WRITE
and WB_WRITE_SYNC behaviours at minimum.

Also, we don't currently have a WB_SYNC_BEFORE use case, so I'm not
sure we want to add code for something nobody currently uses. We can
add that later if anyone ever needs it to be implemented....

> Sounds fairly sensible and straightforward to me. Much more
> self-explanatory than the current "WB_SYNC_NONE/ALL" distinction,
> methinks (well, you'd still have to explain what the point of
> BEFORE/AFTER is, and how it interacts with starting writeout, but
> especially since we already have that concept for file_sync_range(), I
> think that's not too bad).

Yeah, it makes sense from a a high level perspective, but we've also
got to handle inode metadata writeback as well (which can be done
separately to data writeback via sync_inode_metadata()) and that
means we probably need WB_WRITE_META flags as well.

I suspect that we will also need to have filesystems set their
default behaviour flags on the superblock as well so that we can
make things like filemap_fdatawrite() and friends do exactly the
right thing for each filesystem without having callers need to pass
in flags. e.g. XFS doesn't require any data waiting or inode
metadata writeback, while ext2 requires inode metadata writeback
after data writeback dispatch and NFS needs WB_SYNC_AFTER behaviour
before inode metadata writeback....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
