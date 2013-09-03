Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab3ICNSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:18:11 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:36823 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab3ICNSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:18:09 -0400
X-ASG-Debug-ID: 1378214287-0421b5021f340920001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Tue, 3 Sep 2013 09:18:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Michel Lespinasse <walken@google.com>, Josef Bacik <jbacik@fusionio.com>,
        <linux-btrfs@vger.kernel.org>, <mingo@elte.hu>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: add rwsem_is_contended
Message-ID: <20130903131805.GA15634@localhost.localdomain>
X-ASG-Orig-Subj: Re: [PATCH] rwsem: add rwsem_is_contended
References: <1377872041-390-1-git-send-email-jbacik@fusionio.com>
 <CANN689Gz-g=_0ErGkB1WZhJUxg+op2=DAPr3GMYwiXFeT9NmGw@mail.gmail.com>
 <5224C850.2060103@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5224C850.2060103@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1378214287
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.12
X-Barracuda-Spam-Status: No, SCORE=0.12 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140220
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 01:18:08PM -0400, Peter Hurley wrote:
> On 09/01/2013 04:32 AM, Michel Lespinasse wrote:
> >Hi Josef,
> >
> >On Fri, Aug 30, 2013 at 7:14 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> >>Btrfs uses an rwsem to control access to its extent tree.  Threads will hold a
> >>read lock on this rwsem while they scan the extent tree, and if need_resched()
> >>they will drop the lock and schedule.  The transaction commit needs to take a
> >>write lock for this rwsem for a very short period to switch out the commit
> >>roots.  If there are a lot of threads doing this caching operation we can starve
> >>out the committers which slows everybody out.  To address this we want to add
> >>this functionality to see if our rwsem has anybody waiting to take a write lock
> >>so we can drop it and schedule for a bit to allow the commit to continue.
> >>Thanks,
> >>
> >>Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> >
> >FYI, I once tried to introduce something like this before, but my use
> >case was pretty weak so it was not accepted at the time. I don't think
> >there were any objections to the API itself though, and I think it's
> >potentially a good idea if you use case justifies it.
> 
> Exactly, I'm concerned about the use case: readers can't starve writers.
> Of course, lots of existing readers can temporarily prevent a writer from
> acquiring, but those readers would already have the lock. Any new readers
> wouldn't be able to prevent a waiting writer from obtaining the lock.
> 
> Josef,
> Could you be more explicit, maybe with some detailed numbers about the
> condition you report?
> 

Sure, this came from a community member

http://article.gmane.org/gmane.comp.file-systems.btrfs/28081

With the old approach we could block between 1-2 seconds waiting for this rwsem,
and with the new approach where we allow many more of these caching threads we
were staving out the writer for 80 seconds.

So what happens is these threads will scan our extent tree to put together the
free space cache, and they'll hold this lock while they are doing the scanning.
The only way they will drop this lock is if we hit need_resched(), but because
these threads are going to do quite a bit of IO I imagine we're not ever being
flagged with need_resched() because we schedule while waiting for IO.  So these
threads will hold onto this lock for bloody ever without giving it up so the
committer can take the write lock.  His patch to "fix" the problem was to have
an atomic that let us know somebody was waiting for a write lock and then we'd
drop the reader lock and schedule.

So really we're just using a rwsem in a really mean way for writers.  I'm open
to other suggestions but I think this probably the cleanest way.  Thanks,

Josef
