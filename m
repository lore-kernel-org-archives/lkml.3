Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3ICPrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:47:14 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:56608 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3ICPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:47:13 -0400
X-ASG-Debug-ID: 1378223231-0421b5021f341c50001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Tue, 3 Sep 2013 11:47:10 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Michel Lespinasse <walken@google.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130903154710.GB15634@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH] rwsem: add rwsem_is_contended
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1378223231
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140229
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 01:32:36AM -0700, Michel Lespinasse wrote:
> Hi Josef,
> 
> On Fri, Aug 30, 2013 at 7:14 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> > Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> > read lock on this rwsem while they scan the extent tree, and if need_resched()
> > they will drop the lock and schedule.  The transaction commit needs to take a
> > write lock for this rwsem for a very short period to switch out the commit
> > roots.  If there are a lot of threads doing this caching operation we can starve
> > out the committers which slows everybody out.  To address this we want to add
> > this functionality to see if our rwsem has anybody waiting to take a write lock
> > so we can drop it and schedule for a bit to allow the commit to continue.
> > Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> FYI, I once tried to introduce something like this before, but my use
> case was pretty weak so it was not accepted at the time. I don't think
> there were any objections to the API itself though, and I think it's
> potentially a good idea if you use case justifies it.
> 
> Two comments:
> 
> - Note that there are two rwsem implementations - if you are going to
> add functionality to rwsem.h you want to add the same functionality in
> rwsem-spinlock.h as well.
> 

Sure thing.

> - I would prefer if you could avoid taking the wait_lock in your
> rwsem.h implementation. In your use case (read lock is known to be
> held), checking for sem->count < 0 would be sufficient to indicate a
> writer is queued (or getting onto the queue). In the general case,
> some architectures have the various values set up so that
> RWSEM_WAITING_BIAS != RWSEM_ACTIVE_WRITE_BIAS - for these
> architectures at least, you can check for waiters by looking if the
> lowest bit of RWSEM_WAITING_BIAS is set in sem->count.

Question about this one, I can't just do

if (sem->count < 0)

since each arch has their own atomic way of looking at count, so I'd have to add
something to do just a normal read of count for each arch and call that wouldn't
I?  If that's what you want me to do then I'm fine with that (though I'll need a
really thorough review), just want to double check before I make a bunch of
extra work for myself.  Thanks,

Josef
