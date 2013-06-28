Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3F1IWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:22:49 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61696 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3F1IWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130628072141.GB9047@dastard>
References: <20130624173510.GA1321@redhat.com>
	<20130625153520.GA7784@redhat.com>
	<20130626191853.GA29049@redhat.com>
	<20130627002255.GA16553@redhat.com>
	<20130627075543.GA32195@dastard>
	<20130627143055.GA1000@redhat.com>
	<20130628011843.GD32195@dastard>
	<CA+55aFze-=6e_P1syCs=3b6-xj-itVyZKvpejqBR83gA5tV+4w@mail.gmail.com>
	<20130628035437.GB29338@dastard>
	<CA+55aFyZYsbMpP+6dkdkhdDn9gpTx0dkv25MUtcnswer_a2x9w@mail.gmail.com>
	<20130628072141.GB9047@dastard>
Date: Thu, 27 Jun 2013 22:22:45 -1000
X-Google-Sender-Auth: 3OgM2IruIPpKN96etfbcMFPl9-g
Message-ID: <CA+55aFzQ6bwPt4PUDsxB7c7N3xwOaXSqL5U9=w5odm-vWMyTKA@mail.gmail.com>
Subject: Re: frequent softlockups with 3.10rc6.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 9:21 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Besides, making the inode_sb_list_lock per sb won't help solve this
> problem, anyway. The case that I'm testing involves a filesystem
> that contains 99.97% of all inodes cached by the system. This is a
> pretty common situation....

Yeah..

> The problem is not the inode->i_lock. lockstat is pretty clear on
> that...

So the problem is that we're at -rc7, and apparently this has
magically gotten much worse. I'd *really* prefer to polish some turds
here over being fancy.

> Right, we could check some of it optimisitcally, but we'd still be
> walking millions of inodes under the inode_sb_list_lock on each
> sync() call just to find the one inode that is dirty. It's like
> polishing a turd - no matter how shiny you make it, it's still just
> a pile of shit.

Agreed. But it's not a _new_ pile of shit, and so I'm looking for
something less scary than a whole new list with totally new locking.
If we could make the cost of walking the (many) inodes sufficiently
lower so that we can paper over things for now, that would be lovely.

And with the inode i_lock we might well get into some kind of lockstep
worst-case behavior wrt the sb_lock too. I was hoping that making the
inner loop more optimized would possibly improve the contention case -
or at least push it out a bit (which is presumably what the situation
*used* to be).

> It looks ok, but I still think it is solving the wrong problem.
> FWIW, your optimisation has much wider application that just this
> one place. I'll have a look to see how we can apply this approach
> across all the inode lookup+validate code we currently have that
> unconditionally takes the inode->i_lock....

Yes, I was looking at all the other cases that also seemed to be
testing i_state for those "about to go away" cases.

                 Linus
