Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaKEXLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:11:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:39839 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKEXLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:11:37 -0500
Date: Thu, 6 Nov 2014 00:11:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Juerg Haefliger <juergh@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 3.14.23-rt20
In-Reply-To: <20141105174822.491e1eff@gandalf.local.home>
Message-ID: <alpine.DEB.2.11.1411052357110.24960@nanos>
References: <20141031170326.1491a63f@gandalf.local.home> <1414913427.5380.110.camel@marge.simpson.net> <CADLDEKvFvw7Aa98tVtM3z5JV8oocKqAdV4PqOMoZH2mXZ6x2jg@mail.gmail.com> <20141105092707.7c9bb1ae@gandalf.local.home> <alpine.DEB.2.11.1411051703440.4245@nanos>
 <alpine.DEB.2.11.1411052314150.24960@nanos> <20141105174822.491e1eff@gandalf.local.home>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Steven Rostedt wrote:
> On Wed, 5 Nov 2014 23:29:32 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > > When we allow multiple readers, this will be allowed. But even in
> > > > mainline, if a writer were to come in and block between those two
> > > > down_read_trylocks(), the second trylock would fail.
> > > > 
> > > > PREEMPT_RT just has that fail all the time as we only allow an rwsem to
> > > > be held by a single reader.
> > > 
> > > Errm. The reader holds the sem already. So that's a recursive read
> > > lock which should always succeed. And rt_read_trylock() has that
> > > implemented.
> > 
> > Bah. That's the rwlock path. Untested patch below should fix the issue.
> 
> This is basically a revert of my patch that removed rwsems as being
> recursive, because they are not recursive in mainline.

Well, they are. Just not in the presence of a writer.

Which is silly, but due to the fact that we do not track the readers
unavoidable. If the reader holds the sem already there is no real
reason why it should not succeed with the recursive lock.

If anything relies on that behaviour then we have a way bigger
problem at some other place.

> If you have the following:
> 
> 	down_read(&A);
> 
> 				down_write(&A);
> 
> 	down_read(&A);
> 
> in mainline, you will have a deadlock. With this change, it will not
> deadlock on -rt.

And that's fine on RT in the face of a single reader.

> This is probably why that cpu governor code uses down_read_trylock()
> otherwise, it would have suffered from possible deadlock scenarios.

Right.

> But, for a quick solution, just use this patch. I'll start working on
> the multi rwsem readers again, and then I'll have to revert this to do
> that. But when we have multi readers again, we wont need to have this
> hack.

And how exactly are multi reader rwsem solving that problem?

Not at all. You still need to track recursion of an already 'owning'
reader unless you want to add it twice on the 'owner' list.

Thanks,

	tglx






