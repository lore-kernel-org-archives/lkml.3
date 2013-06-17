Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3FQMdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:33:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42372 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab3FQMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:33:47 -0400
Date: Mon, 17 Jun 2013 14:33:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130617123315.GU3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-4-git-send-email-alex.shi@intel.com>
 <CALZhoSS=xMgW8sgjL4qS+LkqAucFptJnOa2Yt53rNwJPEpA0Hg@mail.gmail.com>
 <20130617092033.GL3204@twins.programming.kicks-ass.net>
 <CALZhoSTNg+QWY4VMH97oF8ReJx_nVY7Ux7iEM=66XvNmdbdH6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSTNg+QWY4VMH97oF8ReJx_nVY7Ux7iEM=66XvNmdbdH6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 08:26:55PM +0800, Lei Wen wrote:
> Hi Peter,
> 
> > So the 'problem' is that our running avg is a 'floating' average; ie. it
> > decays with time. Now we have to guess about the future of our newly
> > spawned task -- something that is nigh impossible seeing these CPU
> > vendors keep refusing to implement the crystal ball instruction.
> 
> I am curious at this "crystal ball instruction" saying. :)
> Could it be real? I mean what kind of hw mechanism could achieve such
> magic power? What I see, for silicon vendor they could provide more
> monitor unit, but to precise predict the sw's behavior, I don't think hw
> also this kind of power...

There's indeed no known mechanism for this crystal ball instruction to
really work with. Its just something I often wish for ;-) It would make
life so much easier - although I have no experience with handling the
resulting paradoxes, so who knows :-)

> > So there's two asymptotic cases we want to deal well with; 1) the case
> > where the newly spawned program will be 'nearly' idle for its lifetime;
> > and 2) the case where its cpu-bound.
> >
> > Since we have to guess, we'll go for worst case and assume its
> > cpu-bound; now we don't want to make the avg so heavy adjusting to the
> > near-idle case takes forever. We want to be able to quickly adjust and
> > lower our running avg.
> >
> > Now we also don't want to make our avg too light, such that it gets
> > decremented just for the new task not having had a chance to run yet --
> > even if when it would run, it would be more cpu-bound than not.
> >
> > So what we do is we make the initial avg of the same duration as that we
> > guess it takes to run each task on the system at least once -- aka
> > sched_slice().
> >
> > Of course we can defeat this with wakeup/fork bombs, but in the 'normal'
> > case it should be good enough.
> >
> >
> > Does that make sense?
> 
> Thanks for your detailed explanation. Very useful indeed! :)
> 
> BTW, I have no question for the patch itself, but just confuse at the
> patch's comment
> "some tasks were not launched at once after created".

Right, I might edit that on applying to clarify things.
