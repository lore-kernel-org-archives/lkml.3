Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3GBRWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:22:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab3GBRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:22:08 -0400
Date: Tue, 2 Jul 2013 18:57:52 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130702165752.GA12179@quack.suse.cz>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwZHOUCYvojbP9q3D5MDgCH7GttkUGiJerra9uyduFLKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-07-13 09:13:43, Linus Torvalds wrote:
> On Tue, Jul 2, 2013 at 7:05 AM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 02-07-13 22:38:35, Dave Chinner wrote:
> >>
> >> IOWs, sync is 7-8x faster on a busy filesystem and does not have an
> >> adverse impact on ongoing async data write operations.
> >   The patch looks good. You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Ok, I'm going to take this patch asap. Should we also mark it for
> stable? It doesn't look like a regression in that particular code, but
> it sounds like it might be a regression when paired with the way the
> flusher threads interact. Or is this really some long-time performance
> problem?
  sync(2) was always slow in presence of heavy concurrent IO so I don't
think this is a stable material.

> I'm also wondering if we should just change all callers - remove that
> "wait for writeback to complete" from writeback_one_inode()
> completely, and just make sure that *all* callers that use WB_SYNC_ALL
> do the "wait for writeback" in a separate stage, the way "sync()"
> already does?
  The trouble is with callers like write_inode_now() from iput_final().
For write_inode_now() to work correctly in that place, you must make sure
page writeback is finished before calling ->write_inode() because
filesystems may (and do) dirty the inode in their ->end_io callbacks. If
you don't wait you risk calling ->evict_inode() on a dirty inode and thus
loosing some updates.

> That whole
> 
>         if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
> 
> test doesn't really look all that sane (..so thanks Dave for adding a
> comment above it)
  I agree the condition looks a bit fishy so it definitely deserves that
comment. The only way I see to avoid this strange condition is to move
do_writepages() from __writeback_single_inode() into the callers
(writeback_single_inode() and writeback_sb_inodes()) and the condition with
the wait would then be only in writeback_single_inode(). But we would also
have to duplicate the trace points so current solution looked a tad bit
better to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
