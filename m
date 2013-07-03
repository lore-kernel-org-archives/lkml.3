Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab3GCDIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 23:08:22 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:63204 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691Ab3GCDIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 23:08:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqQMADOV01F5LCeA/2dsb2JhbABagwm7ZoUlBAGBAhd0giMBAQQBJxMcIwULCAMYCSUPBSUDIRMbh24Fu0wWjjKBHQeDbQOXSZFGgyMq
Date: Wed, 3 Jul 2013 13:07:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130703030759.GG14996@dastard>
References: <20130628102819.GA4725@quack.suse.cz>
 <20130629033924.GK32195@dastard>
 <20130701120037.GA6196@quack.suse.cz>
 <20130702062954.GA14996@dastard>
 <20130702081937.GA31770@quack.suse.cz>
 <20130702123835.GF14996@dastard>
 <20130702140508.GB31770@quack.suse.cz>
 <CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
 <20130702165752.GA12179@quack.suse.cz>
 <CA+55aFxSY76aWEC04yREjFObPF3ZJFMHdczoT=yGmSpsg5hhyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxSY76aWEC04yREjFObPF3ZJFMHdczoT=yGmSpsg5hhyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 10:38:20AM -0700, Linus Torvalds wrote:
> On Tue, Jul 2, 2013 at 9:57 AM, Jan Kara <jack@suse.cz> wrote:
> >
> >   sync(2) was always slow in presence of heavy concurrent IO so I don't
> > think this is a stable material.
> 
> It's not the "sync being slow" part I personally react to. I don't
> care that much about that.
> 
> It's the "sync slows down other things" part that makes me go "Hmm,
> this may be due to interactions with the flushing changes". A slow
> sync is fine - a sync that causes the global disk throughput to go
> down by also stopping *other* writeback is not.

Agreed, but none of this is stable stuff at this point. sync(2)
modifications need a fair bit of testing, and I haven't really done
any failure testing to determine whether it is completely safe or
not yet. That's why I haven't posted my entire patch series yet.

As it is, I suspect this patch has a negative effect on NFS client
behaviour on sync, because NFS relies on ->write_inode to send a
commit to the server to transition pages from unstable to clean.
The NFS client has no ->sync_fs method, and hence it appears to be
completely relying on __writeback_single_inode() always waiting for
IO completion before calling ->write_inode for this to work
correctly.

> So it's the effect on the normal background writeback that makes me go
> "hmm - have we really always had that, or is this an effect of the old
> sync logic _mixed_ with all the bdflush -> worker changes"

We've always had it, but I've never really cared that much about
sync(2) performance. What is different right now is that I've been
running new tests that cause sync(2) to behave in nasty ways that
I've never run before, and so I'm noticing certain behaviours for
the first time...

> The thing is, it used to be that bdflush didn't much care what a sync
> by another user was doing. But bdflush doesn't exist any more, it's
> all worker threads..

The flusher threads don't care what users are doing, either. All
they are supposed to do is dispatch IO efficiently. We've broken
that by adding a blocking path into the IO dispatch...

> >   The trouble is with callers like write_inode_now() from iput_final().
> > For write_inode_now() to work correctly in that place, you must make sure
> > page writeback is finished before calling ->write_inode() because
> > filesystems may (and do) dirty the inode in their ->end_io callbacks. If
> > you don't wait you risk calling ->evict_inode() on a dirty inode and thus
> > loosing some updates.
> 
> My point was - why don't we move that sync thing into the caller (so
> write_inode_now() in this case)?

We could, but it's a mess of twisty passages. The problem is that
we've got several paths that end up in __writeback_single_inode(),
and some require blocking and some don't. And write_inode_now()
needs the I_SYNC synchronisation that writeback_single_inode()
provides. That's why it all funnels in to a single path that tries
to do everything for everyone.

> IOW, I'm not disputing the need for filemap_fdatawait() in the data
> paths. I'm just saying that maybe we could split things up - including
> that whole "write_inode()" call. Some users clearly want to do this in
> different orders.

Yes, we need to do that, but it's pretty major surgery because
it implies a separation of data and metadata writeback.

> 
> That said, we might also just want to change the "sync_mode" thing.
> The thing that I dislike about this patch (even though I applied it)
> is that odd
> 
>         if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
> 
> test. It doesn't make sense to me. It's a hack saying "I know that
> 'sync' does something special and doesn't actually want this
> particular WB_SYNC_ALL behavior at all". That's hacky. Moving that
> kind of "I know what the caller *really* meant" logic into the callers
> - by splitting up the logic - would get rid of the hacky part.

Yes, that would be nice, and something I'd like to do. But it's
pretty major surgery, and not something that I want to under time
pressure.

> But another approach of getting rid of the hacky part might be to
> simple split - and rename - that "WB_SYNC_ALL" thing, and simply say
> "clearly 'sync()' and individual callers of 'write_inode_now()' have
> totally different expectations of the semantics of WB_SYNC_ALL". Which
> means that they really shouldn't share the same "sync_mode" at all.

*nod* 

That's the fundamental problem - WB_SYNC_ALL means one thing
for filemap_fdatawrite() callers, and something different sync(2)
callers, and something different again for al other callers...

> So maybe we could just extend that "sync_mode", and have the ones that
> want to do _one_ inode synchronously use "WB_SYNC_SINGLE" to make it
> clear that they are syncing a single inode. Vs "WB_SYNC_ALL" that
> would be used for "I'm syncing all inodes, and I'll do a separate
> second pass for syncing".
> 
> Then that test would become
> 
>         if (wbc->sync_mode == WB_SYNC_SINGLE) {
> 
> instead, and now "sync_mode" would actually describe what mode of
> syncing the caller wants, without that hacky special "we know what the
> caller _really_ meant by looking at *which* caller it is".

The problem is that all the code that currently looks for
WB_SYNC_ALL for it's behavioural cue during writeback now has
multiple different modes they have to handle.  IOWs, it's not a
straight forward conversion process. WB_SYNC_ALL reaches right down
into filesystem ->writepages implementations and they all need to be
changed if we make up a new sync_mode behaviour.

> See what my objection to the code is? And maybe there is yet another
> solution to the oddity, I've just outlined two possible ones..

They are two possibilities that I've been considering over the past few
days - I just haven't vocalised them because I haven't thought them
through completely yet.

I agree with you that this patch is a quick hack that works around
the underlying problem. But I don't have a months of spare time
right now to do a complete overhaul of the inode writeback code to
fix the underlying problem. I've basically resigned myself to
spending a day a week over the next few months cleaning this cruft
up. We're not going to fix the problem in a single patchset for
3.11...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
