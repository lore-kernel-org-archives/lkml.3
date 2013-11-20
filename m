Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3KTSDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:03:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:21104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3KTSDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:03:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,738,1378882800"; 
   d="scan'208";a="436784833"
Message-ID: <528CF94E.8020300@linux.intel.com>
Date: Wed, 20 Nov 2013 20:02:54 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
References: <20131120160450.072555619@infradead.org> <20131120162736.691879744@infradead.org>
In-Reply-To: <20131120162736.691879744@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/2013 18:04, Peter Zijlstra wrote:
> The only valid use of preempt_enable_no_resched() is if the very next
> line is schedule() or if we know preemption cannot actually be enabled
> by that statement due to known more preempt_count 'refs'.

The reason I used the no resched version is that busy_poll_end_time()
is almost always called with rcu read lock held, so it seemed the more
correct option.

I have no issue with you changing this.

> As to the busy_poll mess; that looks to be completely and utterly
> broken, sched_clock() can return utter garbage with interrupts enabled
> (rare but still), it can drift unbounded between CPUs, so if you get
> preempted/migrated and your new CPU is years behind on the previous
> CPU we get to busy spin for a _very_ long time. There is a _REASON_
> sched_clock() warns about preemptability - papering over it with a
> preempt_disable()/preempt_enable_no_resched() is just terminal brain
> damage on so many levels.

IMHO This has been reviewed thoroughly.

When Ben Hutchings voiced concerns I rewrote the code to use time_after,
so even if you do get switched over to a CPU where the time is random
you will at most poll another full interval.

Linus asked me to remove this since it makes us use two time values
instead of one. see https://lkml.org/lkml/2013/7/8/345.

Cheers,
Eliezer
