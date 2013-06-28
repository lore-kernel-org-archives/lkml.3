Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3F1Dyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:54:46 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31686 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754210Ab3F1Dyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:54:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtANAHYIzVF5LB/8/2dsb2JhbABbgwm6ZIUhBAGBBhd0giMBAQU6HCMQCAMYCSUPBSUDIROIDbtJFo4XC4EdB4MCYwOXRJFGgyMq
Date: Fri, 28 Jun 2013 13:54:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628035437.GB29338@dastard>
References: <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:54:53PM -1000, Linus Torvalds wrote:
> On Thu, Jun 27, 2013 at 3:18 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Right, that will be what is happening - the entire system will go
> > unresponsive when a sync call happens, so it's entirely possible
> > to see the soft lockups on inode_sb_list_add()/inode_sb_list_del()
> > trying to get the lock because of the way ticket spinlocks work...
> 
> So what made it all start happening now? I don't recall us having had
> these kinds of issues before..

Not sure - it's a sudden surprise for me, too. Then again, I haven't
been looking at sync from a performance or lock contention point of
view any time recently.  The algorithm that wait_sb_inodes() is
effectively unchanged since at least 2009, so it's probably a case
of it having been protected from contention by some external factor
we've fixed/removed recently.  Perhaps the bdi-flusher thread
replacement in -rc1 has changed the timing sufficiently that it no
longer serialises concurrent sync calls as much....

However, the inode_sb_list_lock is known to be a badly contended
lock from a create/unlink fastpath for XFS, so it's not like this sort
of thing is completely unexpected. It sits behind only the dentry
cache LRU lock on my most contended VFS lock list, so it's been on
my radar for a while. With the work to remove the global dentry LRU
lock currently in -mm, this was always going to be the next lock I
looked at....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
