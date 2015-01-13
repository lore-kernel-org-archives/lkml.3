Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbbAMXc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:32:59 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46907 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbbAMXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:32:57 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Tue, 13 Jan 2015 18:32:54 -0500
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236
 locks_free_lock_context+0x10d/0x240()
Message-ID: <20150113183254.58469edf@tlielax.poochiereds.net>
In-Reply-To: <54B5A145.6060108@oracle.com>
References: <54B4A909.9060206@oracle.com>
	<20150113164441.5b210f48@tlielax.poochiereds.net>
	<54B5A145.6060108@oracle.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 17:50:45 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> On 01/13/2015 04:44 PM, Jeff Layton wrote:
> > On Tue, 13 Jan 2015 00:11:37 -0500
> > Sasha Levin <sasha.levin@oracle.com> wrote:
> > 
> >> Hey Jeff,
> >>
> >> While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> kernel, I've stumbled on the following spew:
> >>
> >> [  887.078606] WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
> >> [  887.079703] Modules linked in:
> >> [  887.080288] CPU: 16 PID: 4296 Comm: trinity-c273 Not tainted 3.19.0-rc4-next-20150112-sasha-00053-g23c147e02e-dirty #1710
> >> [  887.082229]  0000000000000000 0000000000000000 0000000000000000 ffff8804c9f4f8e8
> >> [  887.083773]  ffffffff9154e0a6 0000000000000000 ffff8804cad98000 ffff8804c9f4f938
> >> [  887.085280]  ffffffff8140a4d0 0000000000000001 ffffffff81bf0d2d ffff8804c9f4f988
> >> [  887.086792] Call Trace:
> >> [  887.087320] dump_stack (lib/dump_stack.c:52)
> >> [  887.088247] warn_slowpath_common (kernel/panic.c:447)
> >> [  887.089342] ? locks_free_lock_context (fs/locks.c:236 (discriminator 3))
> >> [  887.090514] warn_slowpath_null (kernel/panic.c:481)
> >> [  887.091629] locks_free_lock_context (fs/locks.c:236 (discriminator 3))
> >> [  887.092782] __destroy_inode (fs/inode.c:243)
> >> [  887.093817] destroy_inode (fs/inode.c:268)
> >> [  887.094833] evict (fs/inode.c:574)
> >> [  887.095808] iput (fs/inode.c:1503)
> >> [  887.096687] __dentry_kill (fs/dcache.c:323 fs/dcache.c:508)
> >> [  887.097683] ? _raw_spin_trylock (kernel/locking/spinlock.c:136)
> >> [  887.098733] ? dput (fs/dcache.c:545 fs/dcache.c:648)
> >> [  887.099672] dput (fs/dcache.c:649)
> >> [  887.100552] __fput (fs/file_table.c:227)
> > 
> > So, looking at this a bit more...
> > 
> > It's clear that we're at the dput in __fput at this point. Much earlier
> > in __fput, we call locks_remove_file to remove all of the locks that
> > are associated with the file description.
> > 
> > Evidently though, something didn't go right there. The two most likely
> > scenarios to my mind are:
> > 
> > A) a lock raced onto the list somehow after that point. That seems
> > unlikely since presumably the fcheck should have failed at that point.
> > 
> > ...or...
> > 
> > B) the CPU that called locks_remove_file mistakenly thought that
> > inode->i_flctx was NULL when it really wasn't (stale cache, perhaps?).
> > That would make it skip trying to remove any flock locks.
> > 
> > B seems more likely to me, and if it's the case then that would seem to
> > imply that we need some memory barriers (or maybe some ACCESS_ONCE
> > calls) in these codepaths. I'll have to sit down and work through it to
> > see what makes the most sense.
> > 
> > If your debugging seems to jive with this, then one thing that might be
> > interesting would be to comment out these two lines in
> > locks_remove_flock:
> > 
> >         if (!file_inode(filp)->i_flctx)
> >                 return;
> > 
> > ...and see if it's still reproducible. That's obviously not a real fix
> > for this problem, but it might help prove whether the above suspicion
> > is correct.
> 
> Removing those two lines makes the issue go away.
> 

Wow, that was quick! Thanks!

I'll need to ponder how best to fix this. I wonder if we need something
like an ACCESS_ONCE there, or maybe a smp_rmb() prior to that might be
sufficient? The pointer is assigned with cmpxchg(), so that should have
an implicit mb already.

Guess I need to set up a trinity test rig of my own and see if I can
reproduce this myself.

> I'm guessing that figuring out which filesystem we were abusing isn't
> interesting anymore...
> 

Yeah, probably not. If you've already figured it out, then please do
share, but there's no need to put forth further effort if not. I'll let
you know once I've got something that I think will work.

Thanks for the help so far!
-- 
Jeff Layton <jlayton@primarydata.com>
