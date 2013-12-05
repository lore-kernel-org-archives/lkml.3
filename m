Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3LEIMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:12:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40940 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3LEIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:12:18 -0500
Date: Thu, 5 Dec 2013 08:12:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: gfs2 deadlock (was Re: Found it)
Message-ID: <20131205081201.GA17203@ZenIV.linux.org.uk>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
 <20131203042830.GI10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203042830.GI10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:28:30AM +0000, Al Viro wrote:

> These should be safe, but damnit, we really need the lifecycle documented for
> all objects - the above is only a part of it (note that for e.g. superblocks
> we have additional rules re "->s_active can't be incremented for any reason
> once it drops to zero, it can't be incremented until superblock had been
> marked 'born' and it crosses over to zero only with ->s_umount held"; there's
> 6 stages in life cycle of struct super_block and we had interesting bugs due
> to messing the transitions up).  The trouble is, attempt to write those down
> tends to stray into massive grep session, with usual results - some other
> crap gets found (e.g. in some odd driver) and needs to be dealt with ;-/
> Sigh...

... and sure enough, this time is no different - gfs2 sysfs-related code
cheerfully violates lifetime rules for superblocks, which would've
caused a major mess later, if it had not immediately caused a deadlock
on the same superblock ;-/

Watch: gfs2 creates a bunch of files in sysfs (/sys/fs/gfs2/<devname>/*).
Said bunch gets removed from ->put_super().  Which is called under
->s_umount.  Guess what happens if somebody tries to write "1" to
/sys/fs/gfs2/.../freeze just as we enter that ->put_super() (or at any
point starting from the moment when deactivate_locked_super() has dropped
the last active reference)?  This:
static ssize_t freeze_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
{
        int error;
        int n = simple_strtol(buf, NULL, 0);

        if (!capable(CAP_SYS_ADMIN))
                return -EPERM;

        switch (n) {
[snip]
        case 1:
                error = freeze_super(sdp->sd_vfs);

And freeze_super(sb) assumes that caller has an active reference to
sb:
int freeze_super(struct super_block *sb)
{
        int ret;

        atomic_inc(&sb->s_active);

... which is not legitimate when ->s_active has already reached zero.
And right after that we hit this:
        down_write(&sb->s_umount);

Voila - write(2) is waiting for ->s_umount, while umount(2) is holding
->s_umount and waits for write(2) to get past freeze_store().

Hell knows what to do here - atomic_inc_not_zero() in freeze_super()
(and failing if it fails) would've worked, but it doesn't help with
the deadlock - just write "0" instead and we hit thaw_super(), which
starts with grabbing ->s_umount.  atomic_inc_not_zero()/deactivate_super()
around that call of thaw_super() would probably work, but I'll need to
look at that after I get some sleep...

Why bother with sysfs, anyway?  What's wrong with putting those same files
on gfs2meta, seeing that _this_ would have no problems with object lifetimes?
Too late by now, of course, but...
