Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3EJRv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:51:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19396 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3EJRvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:51:55 -0400
Date: Fri, 10 May 2013 10:51:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: device-mapper development <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] dmcache: Implement a flush message
Message-ID: <20130510175149.GC5712@blackbox.djwong.org>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204751.GB5712@blackbox.djwong.org>
 <20130510102224.GF20880@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510102224.GF20880@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:22:24AM +0100, Joe Thornber wrote:
> On Thu, May 09, 2013 at 01:47:51PM -0700, Darrick J. Wong wrote:
> > Create a new 'flush' message that causes the dmcache to write all of its
> > metadata out to disk.  This enables us to ensure that the disk reflects
> > whatever's in memory without having to tear down the cache device.  This helps
> > me in the case where I have a cached ro fs that I can't umount and therefore
> > can't tear down the cache device, but want to save the cache metadata anyway.
> > The command syntax is as follows:
> > 
> > # dmsetup message mycache 0 flush now
> 
> Nack.
> 
> [Ignoring the ugly 'now' parameter.]
> 
> I think you're in danger of hiding the real issue.  Which is if the
> target's destructor and post suspend is not being called then, as far
> as dm-cache is concerned this is a crash.  Any open transactions will
> be lost as it automatically rolls back.
> 
> We need to understand more why this is happening.  It's actually
> harmless atm for dm-cache, because we're forced to commit before using
> a new migration.  But for dm-thin you can lose writes.  Why are you
> never tearing down your dm devices?

afaict, there isn't anything in the initscripts that tears down dm devices
prior to invoking reboot(), and the kernel drivers don't have reboot notifiers
to flush things out either.  I've been told that lvm does this, but I don't see
anything in the Ubuntu or RHEL6 that would suggest a teardown script...

# dpkg -L lvm2 dmsetup libdevmapper1.02.1 libdevmapper-event1.02.1 | grep etc
/etc
/etc/lvm
/etc/lvm/lvm.conf
# grep -rn dmsetup /etc
/etc/lvm/lvm.conf:333:    # waiting for udev, run 'dmsetup udevcomplete_all' manually to wake them up.

# rpm -ql lvm2 lvm2-libs device-mapper device-mapper-event device-mapper-event-libs device-mapper-libs | grep /etc
/etc/lvm
/etc/lvm/archive
/etc/lvm/backup
/etc/lvm/cache
/etc/lvm/cache/.cache
/etc/lvm/lvm.conf
/etc/rc.d/init.d/lvm2-monitor
# grep -rn dmsetup /etc/rc* /etc/init*
/etc/rc0.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc0.d/S01halt:22:            if /sbin/dmsetup info "$dst" | grep -q '^Open count: *0$'; then
/etc/rc0.d/S01halt:120:	    && [ "$(dmsetup status "$dst" | cut -d ' ' -f 3)" = crypt ]; then
/etc/rc1.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc2.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc3.d/S25netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc4.d/S25netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc5.d/S25netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc6.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc6.d/S01reboot:22:            if /sbin/dmsetup info "$dst" | grep -q '^Open count: *0$'; then
/etc/rc6.d/S01reboot:120:	    && [ "$(dmsetup status "$dst" | cut -d ' ' -f 3)" = crypt ]; then
/etc/rc.d/rc6.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/rc6.d/S01reboot:22:            if /sbin/dmsetup info "$dst" | grep -q '^Open count: *0$'; then
/etc/rc.d/rc6.d/S01reboot:120:	    && [ "$(dmsetup status "$dst" | cut -d ' ' -f 3)" = crypt ]; then
/etc/rc.d/rc0.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/rc0.d/S01halt:22:            if /sbin/dmsetup info "$dst" | grep -q '^Open count: *0$'; then
/etc/rc.d/rc0.d/S01halt:120:	    && [ "$(dmsetup status "$dst" | cut -d ' ' -f 3)" = crypt ]; then
/etc/rc.d/rc.sysinit:191:		/sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p" >/dev/null
/etc/rc.d/rc5.d/S25netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/rc1.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/rc3.d/S25netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/init.d/netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/init.d/halt:22:            if /sbin/dmsetup info "$dst" | grep -q '^Open count: *0$'; then
/etc/rc.d/init.d/halt:120:	    && [ "$(dmsetup status "$dst" | cut -d ' ' -f 3)" = crypt ]; then
/etc/rc.d/rc4.d/S25netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.d/rc2.d/K75netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/rc.sysinit:191:		/sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p" >/dev/null
/etc/init.d/netfs:53:		       /sbin/dmsetup ls --target multipath --exec "/sbin/kpartx -a -p p"
/etc/init.d/halt:22:            if /sbin/dmsetup info "$dst" | grep -q '^Open count: *0$'; then
/etc/init.d/halt:120:	    && [ "$(dmsetup status "$dst" | cut -d ' ' -f 3)" = crypt ]; then

What am I missing?  My observation of Ubuntu is that at best it shuts down
services, umounts most of the filesystems, syncs, and reboots.  RHEL seems to
shut down multipath and dmcrypt, but that was all I found.  For /most/ users of
dm it seems like the system simply reboots, and nobody's the worse for the
wear.

In the meantime I've added a script to my dmcache test tools to tear things
down at the end, which works unless the umount fails. :/ I guess I could simply
suspend the devices, but the postsuspend flush only seems to get called if I
actually redefine the device to some driver that isn't cache.

(I guess I could suspend the device and replace cache with zero... yuck.)

--D
