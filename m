Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaG1VDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:03:17 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54679 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaG1VDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:03:12 -0400
Date: Mon, 28 Jul 2014 23:03:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        Oleg Nesterov <oleg@redhat.com>, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH RFC tip/core/rcu] Fix attempt to avoid offloading
 callbacks unless requested
Message-ID: <20140728210303.GB26017@localhost.localdomain>
References: <20140725233623.GA18537@linux.vnet.ibm.com>
 <53D2F211.4090509@gmail.com>
 <20140726023013.GG16182@localhost.localdomain>
 <CAJhHMCCkS9_bO3PHc+cWSMw-eEZfnYVKdXyk6E5P5p7RbU7oLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCCkS9_bO3PHc+cWSMw-eEZfnYVKdXyk6E5P5p7RbU7oLQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 09:51:52PM -0400, Pranith Kumar wrote:
> On Fri, Jul 25, 2014 at 10:30 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> 
> >> I understand that if CONFIG_NO_HZ_FULL_ALL is set then CONFIG_NOCB_CPU_ALL
> >> will also be set and there is no need for this cpumask_or().
> >>
> >> Is there any reason for the coupling between CONFIG_NO_HZ_FULL_ALL
> >> and CONFIG_NOCB_CPU_ALL?
> >
> > Yeah, for any nohz full CPU, we need the corresponding CPU to be rcu_nocb.
> > So if all CPUs are full dynticks, all CPUs must be rcunocb.
> >
> > That said with this patch, the dependency is perhaps not needed anymore.
> >
> >>
> >> I ask because a user can override CONFIG_NO_HZ_FULL_ALL=y at boot time
> >> using the nohz_full= boot time parameter.
> >
> > No, the content of nohz_full= is ignored with CONFIG_NO_HZ_FULL_ALL=y.
> >
> 
> Please correct me if I am wrong but that does not seem to be the case.
> If a boot parameter is passed, we are setting up tick_nohz_full_mask
> from tick_nohz_full_setup() and marking tick_nohz_full_running as true.
> Later on we check this flag and skip the CONFIG_NO_HZ_FULL_ALL
> initialization.

You're right, I missed the tick_nohz_full_running check :)

So if nohz_full is passed, we ignore CONFIG_NO_HZ_FULL_ALL. That looks like
the right behaviour though.

Paul what do you think? If we keep that behaviour, Maybe you could blindly do
rcu_nocb_mask |= tick_nohz_full and remove the CONFIG_NO_HZ_FULL_ALL dependency
on RCU_NOCB_ALL?
