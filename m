Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3K0OB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:01:57 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:64688 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3K0OBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:01:55 -0500
Date: Wed, 27 Nov 2013 15:01:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface. (new ABI)
Message-ID: <20131127140143.GB24403@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
 <20131127132354.GA18422@gmail.com>
 <20131127133027.GE10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127133027.GE10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 27, 2013 at 02:23:54PM +0100, Ingo Molnar wrote:
> > There are 3 main compatibility cases:
> > 
> >  - the kernel's 'sizeof sched_attr' is equal to sched_attr:size: the 
> >    kernel version and user-space version matches, it's a straight ABI 
> >    in this case with full functionality.
> > 
> >  - the kernel's 'sizeof sched_attr' is larger than sched_attr::size 
> >    [the kernel is newer than what user-space was built for], in this 
> >    case the kernel assumes that all remaining values are zero and acts
> >    accordingly.
> 
> It also needs to fail sched_getparam() when any of the fields that do
> not fit in the smaller struct provided are !0.
>
> >  - the kernel's 'sizeof sched_attr' is smaller than sched_attr::size 
> >    [the kernel is older than what user-space was built for]. In 
> >    this case the kernel should return -ENOSYS if any of the 
> >    additional fields are nonzero. If those are all zero then it 
> >    will work as if a smaller structure was passed in.
> 
> So the problem I see with this one is that because you're allowed to 
> call sched_setparam() or whatever it will be called next on another 
> task; a task can very easily fail its sched_getparam() call.
> 
> Suppose the application is 'old' and only supports a subset of the 
> fields; but its wants to get, modify and set its params. This will 
> work as long nothing will set anything it doesn't know about.
> 
> As soon as some external entity -- say a sysad using schedtool -- 
> sets a param field it doesn't support the get, modify, set routing 
> completely fails.

There are two approaches to this that I can see:

1)

allow partial information to be returned to user-space, for existing 
input parameters. The new fields won't be displayed, but the tool 
doesn't know about them anyway so it's OK. The tool can still display 
all the other existing parameters.

2)

Return -ENOSYS if the 'extra' fields are nonzero. In this case the 
usual case of old tooling + new kernel will still work just fine, 
because old tooling won't set the new fields to any non-default 
(nonzero) values. In the 'mixed' case old tooling will not be able to 
change/display those fields.

I tend to lean towards #1. What do you think?

Thanks,

	Ingo
