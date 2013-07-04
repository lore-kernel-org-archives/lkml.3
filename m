Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3GDJOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:14:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35126 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab3GDJOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:14:20 -0400
Date: Thu, 4 Jul 2013 11:13:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
Message-ID: <20130704091339.GK18898@dyad.programming.kicks-ass.net>
References: <51A43B16.9080801@linux.vnet.ibm.com>
 <51D25A80.8090406@linux.vnet.ibm.com>
 <20130702085202.GA23916@twins.programming.kicks-ass.net>
 <51D29EE5.8080307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D29EE5.8080307@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:35:33PM +0800, Michael Wang wrote:
> >> +	if (jiffies > current->last_switch_decay + HZ) {
> >> +		current->nr_wakee_switch = 0;
> >> +		current->last_switch_decay = jiffies;
> >> +	}
> > 
> > This isn't so much a decay as it is wiping state. Did you try an actual
> > decay -- something like: current->nr_wakee_switch >>= 1; ?
> > 
> > I suppose you wanted to avoid something like:
> > 
> >   now = jiffies;
> >   while (now > current->last_switch_decay + HZ) {
> >   	current->nr_wakee_switch >>= 1;
> > 	current->last_switch_decay += HZ;
> >   }
> 
> Right, actually I have though about the decay problem with some testing,
> including some similar implementations like this, but one issue I could
> not solve is:
> 
> 	the task waken up after dequeue 10secs and the task waken up
> 	after dequeue 1sec will suffer the same decay.
>
> Thus, in order to keep fair, we have to do some calculation here to make
> the decay correct, but that means cost...

Right, but something like the below is limited in cost to at most 32/64 (I
forgot the type) shifts. Now its probably not worth doing, but it shows
things like that can be done in 'constant' time.

  now = jiffies;
  if (now - p->last_switch_decay > 8*sizeof(p->nr_wakee_switch)*HZ) {
	p->nr_wakee_switch = 0;
	p->last_switch_decay = now;
  } else while (now > p->last_switch_decay + HZ) {
	p->nr_wakee_switch >>= 1;
	p->last_switch_decay += HZ;
  }


