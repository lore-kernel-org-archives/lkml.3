Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3EKPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 11:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3EKPZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 11:25:26 -0400
Date: Sat, 11 May 2013 11:25:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Joe Thornber <thornber@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 2/2] dmcache: Implement a flush message
Message-ID: <20130511152523.GA18988@redhat.com>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204751.GB5712@blackbox.djwong.org>
 <20130510102224.GF20880@debian>
 <20130510175149.GC5712@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510175149.GC5712@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[in the future please refrain from posting to LKML for such a narrow
topic like dm-cache... not seeing the point in adding to the LKML noise
-- dm-devel should suffice]

On Fri, May 10 2013 at  1:51pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Fri, May 10, 2013 at 11:22:24AM +0100, Joe Thornber wrote:
> > On Thu, May 09, 2013 at 01:47:51PM -0700, Darrick J. Wong wrote:
> > > Create a new 'flush' message that causes the dmcache to write all of its
> > > metadata out to disk.  This enables us to ensure that the disk reflects
> > > whatever's in memory without having to tear down the cache device.  This helps
> > > me in the case where I have a cached ro fs that I can't umount and therefore
> > > can't tear down the cache device, but want to save the cache metadata anyway.
> > > The command syntax is as follows:
> > > 
> > > # dmsetup message mycache 0 flush now
> > 
> > Nack.
> > 
> > [Ignoring the ugly 'now' parameter.]
> > 
> > I think you're in danger of hiding the real issue.  Which is if the
> > target's destructor and post suspend is not being called then, as far
> > as dm-cache is concerned this is a crash.  Any open transactions will
> > be lost as it automatically rolls back.
> > 
> > We need to understand more why this is happening.  It's actually
> > harmless atm for dm-cache, because we're forced to commit before using
> > a new migration.  But for dm-thin you can lose writes.  Why are you
> > never tearing down your dm devices?
> 
> afaict, there isn't anything in the initscripts that tears down dm devices
> prior to invoking reboot(), and the kernel drivers don't have reboot notifiers
> to flush things out either.  I've been told that lvm does this, but I don't see
> anything in the Ubuntu or RHEL6 that would suggest a teardown script...

See: https://git.fedorahosted.org/cgit/lvm2.git/commit/?id=c698ee14bbb1310cf2383c8977d14a8e29139f8c

But I'm not sure which distros have hooked blkdeactivate in (cc'ing
prajnoha for his insight).

> What am I missing?  My observation of Ubuntu is that at best it shuts down
> services, umounts most of the filesystems, syncs, and reboots.  RHEL seems to
> shut down multipath and dmcrypt, but that was all I found.  For /most/ users of
> dm it seems like the system simply reboots, and nobody's the worse for the
> wear.

DM devices should be properly torn down; as Joe said this is
particularly important for dm-thinp (otherwise it looks like a crash and
the open transaction is rolled back).

> In the meantime I've added a script to my dmcache test tools to tear things
> down at the end, which works unless the umount fails. :/ 

You should switch to using blkdeactivate.

> I guess I could simply suspend the devices, but the postsuspend flush
> only seems to get called if I actually redefine the device to some
> driver that isn't cache.
> 
> (I guess I could suspend the device and replace cache with zero... yuck.)

You _really_ shouldn't need to play these games.

postsuspend will get called regardless of whether you're changing the
table in any way.

See: do_suspend -> dm_suspend -> dm_table_postsuspend_targets -> suspend_targets

(the only way I'm seeing that the postsuspend could not get called is if
the freeze_bdev/thaw_bdev were to fail, via {lock,unlock}_fs())
