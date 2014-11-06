Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaKFKIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:08:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKFKIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:08:34 -0500
Date: Thu, 6 Nov 2014 11:08:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Wanpeng Li <kernellwp@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
Message-ID: <20141106100823.GR10501@worktop.programming.kicks-ass.net>
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com>
 <20141105105058.GQ3337@twins.programming.kicks-ass.net>
 <545A0317.4090406@gmail.com>
 <20141105125254.GT3337@twins.programming.kicks-ass.net>
 <20141106014634.GA25640@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106014634.GA25640@kernel>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 09:46:34AM +0800, Wanpeng Li wrote:

> >Ah, it could be that for offline cpus we have a singleton rd. Lemme try
> 
> I still cannot find where build the singleton rd in the codes, could you
> point out?

So this is all quite horrible code, but what I think happens is that:

	sched_cpu_inactive() -> set_cpu_active(cpu, false);
	cpuset_cpu_inactive() -> cpuset_update_active_cpus(false)
	                      -> partition_sched_domains(1, NULL, NULL)
			      -> build_sched_domains(cpu_active_mask)
			      -> for_each_cpu()
			           cpu_attach_domain() -> rq_attach_root()

Now, that will detach all active cpus from the current root domain and
attach them to the new root domain. Which leaves behind the old root
domain attached to only the one 'dead' cpu.
