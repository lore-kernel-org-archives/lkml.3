Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaESXhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:37:52 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:29268 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbaESXht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:37:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgHAO2UelN5LL1s/2dsb2JhbABZgwaDQac7AQEBAQEBBpopAYEXF3SCJQEBBTocIxAIAw4EBgklDwUlAw0UE4hA0lIXFoU/iHoHgyuBFQSZWZMbg0kr
Date: Tue, 20 May 2014 09:37:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        sandeen@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140519233733.GD18954@dastard>
References: <20140514223745.GF5421@dastard>
 <5373F0D6.4090600@redhat.com>
 <alpine.LFD.2.00.1405151213160.2112@localhost.localdomain>
 <20140515104746.GF10637@mguzik.redhat.com>
 <20140515222135.GZ26353@dastard>
 <20140515223439.GA24089@mguzik.redhat.com>
 <20140515225141.GA26353@dastard>
 <20140515231908.GB24089@mguzik.redhat.com>
 <20140516001156.GI5421@dastard>
 <20140519094313.GA3427@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519094313.GA3427@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:43:13AM +0200, Jan Kara wrote:
> On Fri 16-05-14 10:11:56, Dave Chinner wrote:
> > On Fri, May 16, 2014 at 01:19:09AM +0200, Mateusz Guzik wrote:
> > > On Fri, May 16, 2014 at 08:51:41AM +1000, Dave Chinner wrote:
> > > > On Fri, May 16, 2014 at 12:34:40AM +0200, Mateusz Guzik wrote:
> > > > > On Fri, May 16, 2014 at 08:21:35AM +1000, Dave Chinner wrote:
> > > > > > > IOW, a new column in mountinfo. For frozen filesystems it would contain
> > > > > > > 'frozen_by=[%s]:[%d]' (escaped comm, pid).
> > > > > > 
> > > > > > I really don't see that the process that froze the filesystem is
> > > > > > particularly useful - it many cases that process is long gone (e.g.
> > > > > > fsfreeze is being used to allow a HW array to take a snapshot). Just
> > > > > > the fact it is in the process of freezing (if stuck, stack trace in
> > > > > > sysrq-w should be present) or frozen (freezing process may be long
> > > > > > gone, and is mostly irrelevant because you're now tracking down why
> > > > > > a thaw hasn't happened)...
> > > > > 
> > > > > There are deamons which perform freezing and unfreezing on their own.
> > > > > Thus storing the name along with pid helps to determine whether someone
> > > > > went behind such daemon's back, or maybe it's the daemon which "forgot" to
> > > > > unfreeze after all.
> > > > 
> > > > Such a daemon should be logging the fact that it's freezing and
> > > > thawing the filesystem. The kernel is not the place to track what
> > > > buggy userspace applications are doing wrong.
> > > > 
> > > 
> > > Except there is no log entry if /var got frozen (and this is not an
> > > imaginary example).
> > 
> > Freezing the filesystem that the freezing daemon logs to is, well, a
> > major application architecture fail. Sorry, catering for the lowest
> > common denominator (i.e. stupidity) is not an valid argument for
> > adding stuff to the kernel....
>   Sure it's not a good architecture but it happens either because of a bug
> or a wrong architecture. So you need to debug it and traces from sysrq-w
> don't tell you who froze the filesystem. Currently you have to use
> tracepoints or similar stuff to find that out (e.g. in one case I was
> debugging it was rpm running a post-install script that froze the fs,
> believe me that was really unexpected :)). But tracepoints aren't useful
> after the fact so sometimes it would be useful to be able to find out
> after the fact who froze the fs (PID and command name to help with
> situations when the process isn't running anymore). Since this is mostly
> debug stuff I'd be OK with dumping this information on sysrq request or as
> Ted suggested from some fs-freeze hang check timer... Hmm?

Sure, along with all the memory allocation, copying and freeing
stuff that isn't guaranteed to be around if a hang occurs. And it
has to be per-sb, because you can indepenently freeze multiple
filesystems at the same time, and so on. I just don't see the
complexity as being worthwhile given how rare freeze problems are...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
