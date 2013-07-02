Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3GBRiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:38:22 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:46897 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3GBRiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130702165752.GA12179@quack.suse.cz>
References: <20130628011301.GC32195@dastard>
	<20130628035825.GC29338@dastard>
	<20130628102819.GA4725@quack.suse.cz>
	<20130629033924.GK32195@dastard>
	<20130701120037.GA6196@quack.suse.cz>
	<20130702062954.GA14996@dastard>
	<20130702081937.GA31770@quack.suse.cz>
	<20130702123835.GF14996@dastard>
	<20130702140508.GB31770@quack.suse.cz>
	<CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
	<20130702165752.GA12179@quack.suse.cz>
Date: Tue, 2 Jul 2013 10:38:20 -0700
X-Google-Sender-Auth: ltgLePlKn_He0D94PYrFaq1G4MA
Message-ID: <CA+55aFxSY76aWEC04yREjFObPF3ZJFMHdczoT=yGmSpsg5hhyg@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 9:57 AM, Jan Kara <jack@suse.cz> wrote:
>
>   sync(2) was always slow in presence of heavy concurrent IO so I don't
> think this is a stable material.

It's not the "sync being slow" part I personally react to. I don't
care that much about that.

It's the "sync slows down other things" part that makes me go "Hmm,
this may be due to interactions with the flushing changes". A slow
sync is fine - a sync that causes the global disk throughput to go
down by also stopping *other* writeback is not.

So it's the effect on the normal background writeback that makes me go
"hmm - have we really always had that, or is this an effect of the old
sync logic _mixed_ with all the bdflush -> worker changes"

The thing is, it used to be that bdflush didn't much care what a sync
by another user was doing. But bdflush doesn't exist any more, it's
all worker threads..

>   The trouble is with callers like write_inode_now() from iput_final().
> For write_inode_now() to work correctly in that place, you must make sure
> page writeback is finished before calling ->write_inode() because
> filesystems may (and do) dirty the inode in their ->end_io callbacks. If
> you don't wait you risk calling ->evict_inode() on a dirty inode and thus
> loosing some updates.

My point was - why don't we move that sync thing into the caller (so
write_inode_now() in this case)?

IOW, I'm not disputing the need for filemap_fdatawait() in the data
paths. I'm just saying that maybe we could split things up - including
that whole "write_inode()" call. Some users clearly want to do this in
different orders.

That said, we might also just want to change the "sync_mode" thing.
The thing that I dislike about this patch (even though I applied it)
is that odd

        if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {

test. It doesn't make sense to me. It's a hack saying "I know that
'sync' does something special and doesn't actually want this
particular WB_SYNC_ALL behavior at all". That's hacky. Moving that
kind of "I know what the caller *really* meant" logic into the callers
- by splitting up the logic - would get rid of the hacky part.

But another approach of getting rid of the hacky part might be to
simple split - and rename - that "WB_SYNC_ALL" thing, and simply say
"clearly 'sync()' and individual callers of 'write_inode_now()' have
totally different expectations of the semantics of WB_SYNC_ALL". Which
means that they really shouldn't share the same "sync_mode" at all.

So maybe we could just extend that "sync_mode", and have the ones that
want to do _one_ inode synchronously use "WB_SYNC_SINGLE" to make it
clear that they are syncing a single inode. Vs "WB_SYNC_ALL" that
would be used for "I'm syncing all inodes, and I'll do a separate
second pass for syncing".

Then that test would become

        if (wbc->sync_mode == WB_SYNC_SINGLE) {

instead, and now "sync_mode" would actually describe what mode of
syncing the caller wants, without that hacky special "we know what the
caller _really_ meant by looking at *which* caller it is".

See what my objection to the code is? And maybe there is yet another
solution to the oddity, I've just outlined two possible ones..

                   Linus
