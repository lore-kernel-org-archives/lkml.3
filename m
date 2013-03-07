Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab3CGMzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:55:51 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:43302 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323Ab3CGMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:55:49 -0500
X-ASG-Debug-ID: 1362660947-0421b5549403120001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 7 Mar 2013 07:55:46 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Rik van Riel <riel@redhat.com>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clmason@fusionio.com>, <dave.kleikamp@oracle.com>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
Message-ID: <20130307125546.GD13323@shiny.masoncoding.com>
X-ASG-Orig-Subj: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
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
	Thomas Gleixner <tglx@linutronix.de>,
	Chris Mason <clmason@fusionio.com>, dave.kleikamp@oracle.com
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
 <513626E9.2040509@redhat.com>
 <51364AB9.80206@hp.com>
 <CA+55aFwYOUyG_DQUqVPrQNi_a=AUwS53U-Yi6jbvJTGRxQ_aEQ@mail.gmail.com>
 <51365B66.5010905@redhat.com>
 <1362645933.2606.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1362645933.2606.14.camel@laptop>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362660947
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.124512
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:45:33AM -0700, Peter Zijlstra wrote:
> On Tue, 2013-03-05 at 15:53 -0500, Rik van Riel wrote:
> 
> > Indeed.  Though how well my patches will work with Oracle will
> > depend a lot on what kind of semctl syscalls they are doing.
> > 
> > Does Oracle typically do one semop per semctl syscall, or does
> > it pass in a whole bunch at once?
> 
> https://oss.oracle.com/~mason/sembench.c
> 
> I think Chris wrote that to match a particular pattern of semaphore
> operations the database engine in question does. I haven't checked to
> see if it triggers the case in point though.
> 
> Also, Chris since left Oracle but maybe he knows who to poke.
> 

Dave Kleikamp (cc'd) took over my patches and did the most recent
benchmarking.  Ported against 3.0:

https://oss.oracle.com/git/?p=linux-uek-2.6.39.git;a=commit;h=c7fa322dd72b08450a440ef800124705a1fa148c

The current versions are still in the 2.6.32 oracle kernel, but it looks
like they reverted this 3.0 commit.  I think with Manfred's upstream
work my more complex approach wasn't required anymore, but hopefully
Dave can fill in details.

Here is some of the original discussion around the patch:

https://lkml.org/lkml/2010/4/12/257

In terms of how oracle uses IPC, the part that shows up in profiles is
using semtimedop for bulk wakeups.  They can configure things to use
either a bunch of small arrays or a huge single array (and anything in
between). 

There is one IPC semaphore per process and they use this to wait for
some event (like a log commit).  When the event comes in, everyone
waiting is woken in bulk via a semtimedop call.

So, single proc waking many waiters at once.

-chris

