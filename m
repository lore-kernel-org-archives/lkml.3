Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3CGQmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:42:53 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:38011 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3CGQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:42:51 -0500
X-ASG-Debug-ID: 1362674569-03d6a56648105890001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 7 Mar 2013 11:42:48 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: Chris Mason <clmason@fusionio.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "aquini@redhat.com" <aquini@redhat.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
Message-ID: <20130307164248.GC5784@shiny.masoncoding.com>
X-ASG-Orig-Subj: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Chris Mason <clmason@fusionio.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Rik van Riel <riel@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <Waiman.Long@hp.com>,
	Davidlohr Bueso <davidlohr.bueso@hp.com>,
	Emmanuel Benisty <benisty.e@gmail.com>,
	"Vinod, Chegu" <chegu_vinod@hp.com>,
	"Low, Jason" <jason.low2@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"aquini@redhat.com" <aquini@redhat.com>,
	Michel Lespinasse <walken@google.com>,
	Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
 <513626E9.2040509@redhat.com>
 <51364AB9.80206@hp.com>
 <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com>
 <51365B66.5010905@redhat.com>
 <1362645933.2606.14.camel@laptop>
 <20130307125546.GD13323@shiny.masoncoding.com>
 <5138B84F.1060807@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5138B84F.1060807@oracle.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362674569
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.3823 1.0000 -0.0481
X-Barracuda-Spam-Score: -0.05
X-Barracuda-Spam-Status: No, SCORE=-0.05 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.124526
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:54:55AM -0700, Dave Kleikamp wrote:
> On 03/07/2013 06:55 AM, Chris Mason wrote:
> > On Thu, Mar 07, 2013 at 01:45:33AM -0700, Peter Zijlstra wrote:
> >> On Tue, 2013-03-05 at 15:53 -0500, Rik van Riel wrote:
> >>
> >>> Indeed.  Though how well my patches will work with Oracle will
> >>> depend a lot on what kind of semctl syscalls they are doing.
> >>>
> >>> Does Oracle typically do one semop per semctl syscall, or does
> >>> it pass in a whole bunch at once?
> >>
> >> https://oss.oracle.com/~mason/sembench.c
> >>
> >> I think Chris wrote that to match a particular pattern of semaphore
> >> operations the database engine in question does. I haven't checked to
> >> see if it triggers the case in point though.
> >>
> >> Also, Chris since left Oracle but maybe he knows who to poke.
> >>
> > 
> > Dave Kleikamp (cc'd) took over my patches and did the most recent
> > benchmarking.  Ported against 3.0:
> > 
> > https://oss.oracle.com/git/?p=linux-uek-2.6.39.git;a=commit;h=c7fa322dd72b08450a440ef800124705a1fa148c
> > 
> > The current versions are still in the 2.6.32 oracle kernel, but it looks
> > like they reverted this 3.0 commit.  I think with Manfred's upstream
> > work my more complex approach wasn't required anymore, but hopefully
> > Dave can fill in details.
> 
> From what I recall, I could never get better performance from your
> patches that we saw with Manfred's work alone. I can't remember the
> reasons for including and then reverting the patches from the 3.0
> (2.6.39) Oracle kernel, but in the end we weren't able to justify their
> inclusion.

Ok, so after this commit, oracle was happy:

commit fd5db42254518fbf241dc454e918598fbe494fa2
Author: Manfred Spraul <manfred@colorfullife.com>
Date:   Wed May 26 14:43:40 2010 -0700

    ipc/sem.c: optimize update_queue() for bulk wakeup calls

But that doesn't explain why Davidlohr saw semtimedop at the top of the
oracle profiles in his runs.

Looking through the patches in this thread, I don't see anything that
I'd expect to slow down oracle TPC numbers.

I dealt with the ipc_perm lock a little differently:

https://oss.oracle.com/git/?p=linux-uek-2.6.39.git;a=commitdiff;h=78fe45325c8e2e3f4b6ebb1ee15b6c2e8af5ddb1;hp=8102e1ff9d667661b581209323faaf7a84f0f528

My code switched the ipc_rcu_hdr refcount to an atomic, which changed
where I needed the spinlock.  It may make things easier in patches 3/4
and 4/4.

(some of this code was Jens, but at the time he made me promise to
pretend he never touched it)

-chris

