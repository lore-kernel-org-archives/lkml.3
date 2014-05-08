Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaEHQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbaEHQeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:34:23 -0400
Date: Thu, 8 May 2014 12:33:33 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, andi@firstfloor.org
Subject: Re: [PATCH 1/5] x86, nmi:  Add new nmi type 'external'
Message-ID: <20140508163333.GZ39568@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-2-git-send-email-dzickus@redhat.com>
 <20140507153854.GA14926@gmail.com>
 <20140507160251.GQ39568@redhat.com>
 <20140507162746.GA15779@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507162746.GA15779@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 06:27:46PM +0200, Ingo Molnar wrote:
> > [...]  But I guess in theory, if a PMI NMI comes in and before the 
> > cpu can accept it and GHES NMI comes in, then it would suffice to 
> > say it may get dropped.  That would be not be good.  Though the race 
> > would be very small.
> > 
> > I don't have a good idea how to handle that.
> 
> Well, are GHES NMIs reasserted if they are not handled? I don't know 
> but there's a definite answer to that hardware behavior question.

I can't find anything that explicitly says the NMI will be re-asserted, so
I will it does not.  Andi, do you know?  (I am not sure who maintains GHES
any more).

> 
> > On the flip side, we have the same exact problem, today, with the 
> > other common external NMIs (SERR, IO).  If a PCI SERR comes in at 
> > the same time as a PMI, then it gets dropped.  Worse, it doesn't get 
> > re-enabled and blocks future SERRs (just found this out two weeks 
> > ago because of a dirty perf status register on boot).
> > 
> > Again, I don't have a solution to juggle between PMI performance and 
> > reliable delivery.  We could do away with the spinlocks and go back 
> > to single cpu delivery (like it used to be).  Then devise a 
> > mechanism to switch delivery to another cpu upon hotplug.
> > 
> > Thoughts?
> 
> I'd say we should do a delayed timer that makes sure that all possible 
> handlers are polled after an NMI is triggered, but never at a high 
> rate.

Hmm, I was thinking about it and wanted to avoid a poll as I hear
complaints here and there about the nmi_watchdog constantly wasting power
cycles with its polling.

I was wondering if I could do a status read outside the spinlock, then if
a bit is set, just grab the spin_lock and re-read the status.  But then
looking at the GHES code, I am not sure if it is as easy to read the
status bit as it is for a PCI_SERR/IO_CHK NMI.

Andi thoughts here?  Should I poke Tony Luck?

Otherwise I can set up the polling if that doesn't work.

Cheers,
Don
