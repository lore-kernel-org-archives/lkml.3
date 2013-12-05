Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3LEKVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:21:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab3LEKVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:21:16 -0500
Subject: Re: gfs2 deadlock (was Re: Found it)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>, cluster-devel@redhat.com
In-Reply-To: <20131205081201.GA17203@ZenIV.linux.org.uk>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
	 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
	 <20131203042830.GI10323@ZenIV.linux.org.uk>
	 <20131205081201.GA17203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 05 Dec 2013 10:19:41 +0000
Message-ID: <1386238781.2722.14.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-12-05 at 08:12 +0000, Al Viro wrote:
> On Tue, Dec 03, 2013 at 04:28:30AM +0000, Al Viro wrote:
> 
> > These should be safe, but damnit, we really need the lifecycle documented for
> > all objects - the above is only a part of it (note that for e.g. superblocks
> > we have additional rules re "->s_active can't be incremented for any reason
> > once it drops to zero, it can't be incremented until superblock had been
> > marked 'born' and it crosses over to zero only with ->s_umount held"; there's
> > 6 stages in life cycle of struct super_block and we had interesting bugs due
> > to messing the transitions up).  The trouble is, attempt to write those down
> > tends to stray into massive grep session, with usual results - some other
> > crap gets found (e.g. in some odd driver) and needs to be dealt with ;-/
> > Sigh...
> 
> ... and sure enough, this time is no different - gfs2 sysfs-related code
> cheerfully violates lifetime rules for superblocks, which would've
> caused a major mess later, if it had not immediately caused a deadlock
> on the same superblock ;-/
> 
> Watch: gfs2 creates a bunch of files in sysfs (/sys/fs/gfs2/<devname>/*).
> Said bunch gets removed from ->put_super().  Which is called under
> ->s_umount.  Guess what happens if somebody tries to write "1" to
> /sys/fs/gfs2/.../freeze just as we enter that ->put_super() (or at any
> point starting from the moment when deactivate_locked_super() has dropped
> the last active reference)?  This:
> static ssize_t freeze_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
> {
>         int error;
>         int n = simple_strtol(buf, NULL, 0);
> 
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
> 
>         switch (n) {
> [snip]
>         case 1:
>                 error = freeze_super(sdp->sd_vfs);
> 
> And freeze_super(sb) assumes that caller has an active reference to
> sb:
> int freeze_super(struct super_block *sb)
> {
>         int ret;
> 
>         atomic_inc(&sb->s_active);
> 
> ... which is not legitimate when ->s_active has already reached zero.
> And right after that we hit this:
>         down_write(&sb->s_umount);
> 
> Voila - write(2) is waiting for ->s_umount, while umount(2) is holding
> ->s_umount and waits for write(2) to get past freeze_store().
> 
> Hell knows what to do here - atomic_inc_not_zero() in freeze_super()
> (and failing if it fails) would've worked, but it doesn't help with
> the deadlock - just write "0" instead and we hit thaw_super(), which
> starts with grabbing ->s_umount.  atomic_inc_not_zero()/deactivate_super()
> around that call of thaw_super() would probably work, but I'll need to
> look at that after I get some sleep...
> 
> Why bother with sysfs, anyway?  What's wrong with putting those same files
> on gfs2meta, seeing that _this_ would have no problems with object lifetimes?
> Too late by now, of course, but...

Well now. Thats is a bit of a can of worms :(

Short answer is that the sysfs stuff was largely inherited from GFS
unchanged. The metafs was added in GFS2 as a way to access files which
are otherwise hidden from the user (e.g. the journals). In retrospect,
both were probably a mistake, for different reasons.

Quite a large number of the interfaces in sysfs were added to do what
should really have been the job of mount options. Over time we've now
got to the point that anything that can be done with sysfs that makes
sense as a mount option, is now a mount option and thats the recommended
way to do things.

Freeze can be done via dmsetup suspend, and thats what we've recommended
that people use for a long time now. The only thing in userspace that
used the sysfs interface was gfs2_tool (an obsolete and no longer
shipping userspace tool). So the chances are that nothing uses that
interface any more, but it has been left for backward compatibility
purposes. Maybe we could remove it now?

In any case freeze in GFS2 is due for an overhaul and Ben Marzinski has
patches which he is currently working on as we speak, that are a big
step forward in this area, even though they won't (I think) solve the
issue that you've identified here.

What we do need to preserve are the uevents which are generated though,
since those are used by the older cluster suite programs, and are also
useful for debugging mount/umount/recovery issues, even with the latest
pcs based cluster suite.

Returning briefly to the metafs, the locking there has also been a pain
to deal with. Over time I hope to transition to using "proper"
interfaces rather than trying to directly touch the internal files.
We've already done that with quota - that means that extending the fs
and adding journals are the only two operations left which still use the
metafs as an interface. Eventually I'd like those to have fs independent
(if possible!) interfaces too and then userspace will no longer require
direct access to the metafs. Extending the fs is fairly easy to fix I
think, adding journals will be more tricky to do.

So although it probably doesn't help a lot - thats the background behind
where we are today,

Steve.



