Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaEPAMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:12:38 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33239 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbaEPAMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:12:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkHAOhWdVN5LL1s/2dsb2JhbABZgwaDPqgjAQEBAQEBBpodAYERF3SCJQEBBAE6HCMFCwgDDgQGCSUPBSUDDRQTiDkH0UkXFoU+iHoHhEAEmVCTFYNIKw
Date: Fri, 16 May 2014 10:11:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, sandeen@redhat.com,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140516001156.GI5421@dastard>
References: <20140514113945.GC5824@quack.suse.cz>
 <20140514220052.GD5421@dastard>
 <20140514223745.GF5421@dastard>
 <5373F0D6.4090600@redhat.com>
 <alpine.LFD.2.00.1405151213160.2112@localhost.localdomain>
 <20140515104746.GF10637@mguzik.redhat.com>
 <20140515222135.GZ26353@dastard>
 <20140515223439.GA24089@mguzik.redhat.com>
 <20140515225141.GA26353@dastard>
 <20140515231908.GB24089@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515231908.GB24089@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 01:19:09AM +0200, Mateusz Guzik wrote:
> On Fri, May 16, 2014 at 08:51:41AM +1000, Dave Chinner wrote:
> > On Fri, May 16, 2014 at 12:34:40AM +0200, Mateusz Guzik wrote:
> > > On Fri, May 16, 2014 at 08:21:35AM +1000, Dave Chinner wrote:
> > > > > IOW, a new column in mountinfo. For frozen filesystems it would contain
> > > > > 'frozen_by=[%s]:[%d]' (escaped comm, pid).
> > > > 
> > > > I really don't see that the process that froze the filesystem is
> > > > particularly useful - it many cases that process is long gone (e.g.
> > > > fsfreeze is being used to allow a HW array to take a snapshot). Just
> > > > the fact it is in the process of freezing (if stuck, stack trace in
> > > > sysrq-w should be present) or frozen (freezing process may be long
> > > > gone, and is mostly irrelevant because you're now tracking down why
> > > > a thaw hasn't happened)...
> > > 
> > > There are deamons which perform freezing and unfreezing on their own.
> > > Thus storing the name along with pid helps to determine whether someone
> > > went behind such daemon's back, or maybe it's the daemon which "forgot" to
> > > unfreeze after all.
> > 
> > Such a daemon should be logging the fact that it's freezing and
> > thawing the filesystem. The kernel is not the place to track what
> > buggy userspace applications are doing wrong.
> > 
> 
> Except there is no log entry if /var got frozen (and this is not an
> imaginary example).

Freezing the filesystem that the freezing daemon logs to is, well, a
major application architecture fail. Sorry, catering for the lowest
common denominator (i.e. stupidity) is not an valid argument for
adding stuff to the kernel....

> Grabbig a debugger to inspect daemon's state is not
> exactly what your typical support associate can or should do.

No, but they can read /proc/self/mountinfo, and grab sysrq-w output.
And they should be able to read that and tell that there is a freeze
hang from that info. This "filesystem hang triage 101" stuff....

> But this was a side request, I'm not going to argue about including
> this since turns out there is a better way.
> 
> Somewhere in the thread an idea to log long-standing freezes was
> mentioned which would provide sufficient information as far as

You've already got the hung task timer firing when a fs is frozen
for too long. You'll see processes hung in sb_write_wait(), and that
tells you the filesystem is frozen. Then look at
/proc/self/mountinfo to find which fs is frozen....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
