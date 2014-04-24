Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaDXHrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:47:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaDXHrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:47:45 -0400
Date: Thu, 24 Apr 2014 09:47:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by CPU
 hot-addition
Message-ID: <20140424074741.GA26782@laptop.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
 <20140422081515.GF11182@twins.programming.kicks-ass.net>
 <53572939.7020509@linux.intel.com>
 <20140423053213.GV26782@laptop.programming.kicks-ass.net>
 <20140423055107.GB1429@laptop.programming.kicks-ass.net>
 <3908561D78D1C84285E8C5FCA982C28F327EB605@ORSMSX114.amr.corp.intel.com>
 <53587E21.5070507@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53587E21.5070507@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:59:45AM +0800, Jiang Liu wrote:
> On 2014/4/24 1:46, Luck, Tony wrote:
> >>>> 1) Handle CPU hot-addition event
> >>>> 1.a) gather platform specific information
> >>>> 1.b) associate hot-added CPU with a node
> >>>> 1.c) create CPU device
> >>>> 2) User online hot-added CPUs through sysfs:
> >>>> 2.a)	cpu_up()
> >>>> 2.b)		->try_online_node()
> >>>> 2.c)			->hotadd_new_pgdat()
> >>>> 2.d)			->node_set_online()
> >>>>
> >>>> So between 1.b and 2.c, kmalloc_node(nid) may cause invalid
> >>>> memory access without the node_online(nid) check.
> >>>
> >>> Any why was all this not in the Changelog?
> >>
> >> Also, do explain what kind of hardware you needed to trigger this. This
> >> code has been like this for a good while.
> > 
> > With your proposed fix in place the allocations will succeed - but they
> > will be done from other nodes ... and this cpu will have to do a remote
> > NUMA access for the rest of time.
> > 
> > It would be better to switch the order above - add the memory first,
> > then add the cpus.  Is that possible?
> Hi Tony,
> 	The BIOS always sends CPU hot-addition events before memory
> hot-addition events, so it's hard to change the order.
> 	And we couldn't completely solve this performance penalty because the
> affected code tries to allocate memory for all possible
> CPUs instead of onlined CPUs.

So the BIOS is fucked, news at 11, one would have hoped Intel would have
_some_ say in it, but alas. So how about instead you force memory online
when you online the first CPU, screw whatever the BIOS does or does not?
