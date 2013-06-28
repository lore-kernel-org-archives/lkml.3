Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3F1Icb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:32:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54886 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3F1Ic3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:32:29 -0400
Date: Fri, 28 Jun 2013 09:32:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130628083223.GF4165@ZenIV.linux.org.uk>
References: <20130626191853.GA29049@redhat.com>
 <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627143055.GA1000@redhat.com>
 <20130628011843.GD32195@dastard>
 <CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
 <20130628035437.GB29338@dastard>
 <CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
 <20130628072141.GB9047@dastard>
 <CA+55aFzQ6bwPt4PUDsxB7c7N3xwOaXSqL5U9=w5odm-vWMyTKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzQ6bwPt4PUDsxB7c7N3xwOaXSqL5U9=w5odm-vWMyTKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 10:22:45PM -1000, Linus Torvalds wrote:

> > It looks ok, but I still think it is solving the wrong problem.
> > FWIW, your optimisation has much wider application that just this
> > one place. I'll have a look to see how we can apply this approach
> > across all the inode lookup+validate code we currently have that
> > unconditionally takes the inode->i_lock....
> 
> Yes, I was looking at all the other cases that also seemed to be
> testing i_state for those "about to go away" cases.

FWIW, there's a subtle issue here - something like ext2_new_inode()
starts with allocating an inode and putting it into list (no I_NEW
yet), then decides what inumber will it have and calls insert_inode_locked(),
which sets I_NEW.  Then we proceed with initializing the inode (and
eventually do unlock_new_inode(), which removes I_NEW).  We depend on having
no pages in the pagecache of that sucker prior to insert_inode_locked() call;
you really don't want to start playing with writeback on this half-initialized
in-core inode.
