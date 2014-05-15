Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaEOWfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbaEOWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:35:03 -0400
Date: Fri, 16 May 2014 00:34:40 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, sandeen@redhat.com,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515223439.GA24089@mguzik.redhat.com>
References: <1400018683-5565-2-git-send-email-mguzik@redhat.com>
 <20140514111449.GB5824@quack.suse.cz>
 <20140514112619.GA10637@mguzik.redhat.com>
 <20140514113945.GC5824@quack.suse.cz>
 <20140514220052.GD5421@dastard>
 <20140514223745.GF5421@dastard>
 <5373F0D6.4090600@redhat.com>
 <alpine.LFD.2.00.1405151213160.2112@localhost.localdomain>
 <20140515104746.GF10637@mguzik.redhat.com>
 <20140515222135.GZ26353@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140515222135.GZ26353@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 08:21:35AM +1000, Dave Chinner wrote:
> On Thu, May 15, 2014 at 12:47:48PM +0200, Mateusz Guzik wrote:
> > On Thu, May 15, 2014 at 12:40:19PM +0200, Lukáš Czerner wrote:
> > > On Wed, 14 May 2014, Eric Sandeen wrote:
> > > 
> > > > Date: Wed, 14 May 2014 17:40:22 -0500
> > > > From: Eric Sandeen <esandeen@redhat.com>
> > > > Reply-To: sandeen@redhat.com
> > > > To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
> > > > Cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
> > > >     linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
> > > >     Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
> > > > Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
> > > >     filesystems
> > > > 
> > > > On 5/14/14, 5:37 PM, Dave Chinner wrote:
> > > > > On Thu, May 15, 2014 at 08:00:52AM +1000, Dave Chinner wrote:
> > > > >> On Wed, May 14, 2014 at 01:39:45PM +0200, Jan Kara wrote:
> > > > >>> On Wed 14-05-14 13:26:21, Mateusz Guzik wrote:
> > > > >>>> On Wed, May 14, 2014 at 01:14:49PM +0200, Jan Kara wrote:
> > > > >>>>> On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
> > > > >>>>>> This helps hang troubleshooting efforts when only dmesg is available.
> > > > >>>>>>
> > > > >>>>>> While here remove code duplication with MS_RDONLY case and fix a
> > > > >>>>>> whitespace nit.
> > > > >>>>>   I'm somewhat undecided here I have to say. On one hand I don't like
> > > > >>>>> printing to kernel log when everything is fine and kernel is operating
> > > > >>>>> normally. On the other hand I've seen quite a few cases where people have
> > > > >>>>> shot themselves in the foot with filesystem freezing so having some trace
> > > > >>>>> of this in the log doesn't seem like a completely bad thing either. What do
> > > > >>>>> other people think?
> > > > >>>>>
> > > > >>>>
> > > > >>>> I would like to note that the kernel already prints messages when e.g.
> > > > >>>> filesystems get mounted.
> > > > >>>   Yeah, that's a fair point.
> > > > >>
> > > > >> But filesystems choose to output that info, not the VFS. When you do
> > > > >> a remount,ro there is no output in syslog, because filesystems don't
> > > > >> need to dump any output - the state change is reflected in
> > > > >> /proc/self/mounts. IMO frozen should state should be communicated
> > > > >> the same way so that it is silent when it just works, and the state
> > > > >> can easily be determined when something goes wrong.
> > > > > 
> > > > > Say, like this:
> > > > > 
> > > > > $ grep /mnt/test /proc/mounts
> > > > > /dev/vda /mnt/test xfs rw,relatime,attr2,inode64,noquota 0 0
> > > > > $ sudo xfs_freeze -f /mnt/test
> > > > > $ grep /mnt/test /proc/mounts
> > > > > /dev/vda /mnt/test xfs rw,frozen,relatime,attr2,inode64,noquota 0 0
> > > > > $ sudo xfs_freeze -u /mnt/test
> > > > > $ grep /mnt/test /proc/mounts
> > > > > /dev/vda /mnt/test xfs rw,relatime,attr2,inode64,noquota 0 0
> > > > > $
> > > > 
> > > > I'm not totally convinced that including a non-mount option in what
> > > > has always (?) been a list of mount options is a great idea.
> > > 
> > > I do not like it either. Mixing this together with other mount
> > > options does not seem like a great idea, however we really need a
> > > way to report this and I guess we can not just change the
> > > /proc/self/mounts, or /proc/self/mountinfo format.
> > > 
> > > So what about crating a new file /proc/self/frozen with the list of
> > > frozen file systems in the same format what mounts, or mountinfo has
> > > ?
> > > 
> > 
> > As the time goes on there will be more data to present about given
> > mountpoint. So either mountinfo should be extendable to support this
> > (can't see why not) or new generic file with that property should be
> > provided. I vote for the former.
> > 
> > IOW, a new column in mountinfo. For frozen filesystems it would contain
> > 'frozen_by=[%s]:[%d]' (escaped comm, pid).
> 
> I really don't see that the process that froze the filesystem is
> particularly useful - it many cases that process is long gone (e.g.
> fsfreeze is being used to allow a HW array to take a snapshot). Just
> the fact it is in the process of freezing (if stuck, stack trace in
> sysrq-w should be present) or frozen (freezing process may be long
> gone, and is mostly irrelevant because you're now tracking down why
> a thaw hasn't happened)...
> 

There are deamons which perform freezing and unfreezing on their own.
Thus storing the name along with pid helps to determine whether someone
went behind such daemon's back, or maybe it's the daemon which "forgot" to
unfreeze after all.

-- 
Mateusz Guzik
