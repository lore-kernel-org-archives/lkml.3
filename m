Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3J1Pxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:53:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53367 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1Pxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:53:35 -0400
Date: Mon, 28 Oct 2013 16:53:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/3] sched: Aggressive balance in domains whose groups
 share package resources
Message-ID: <20131028155316.GQ19466@laptop.lan>
References: <20131021114002.13291.31478.stgit@drishya>
 <20131021114502.13291.60794.stgit@drishya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021114502.13291.60794.stgit@drishya>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:15:02PM +0530, Vaidyanathan Srinivasan wrote:
> From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
> The current logic in load balance is such that after picking the
> busiest group, the load is attempted to be moved from the busiest cpu
> in that group to the dst_cpu. If the load cannot be moved from the
> busiest cpu to dst_cpu due to either tsk_cpus_allowed mask or cache
> hot tasks, then the dst_cpu is changed to be another idle cpu within
> the dst->grpmask. If even then, the load cannot be moved from the
> busiest cpu, then the source group is changed. The next busiest group
> is found and the above steps are repeated.
> 
> However if the cpus in the group share package resources, then when
> a load movement from the busiest cpu in this group fails as above,
> instead of finding the next busiest group to move load from, find the
> next busiest cpu *within the same group* from which to move load away.
> By doing so, a conscious effort is made during load balancing to keep
> just one cpu busy as much as possible within domains that have
> SHARED_PKG_RESOURCES flag set unless under scenarios of high load.
> Having multiple cpus busy within a domain which share package resource
> could lead to a performance hit.
> 
> A similar scenario arises in active load balancing as well. When the
> current task on the busiest cpu cannot be moved away due to task
> pinning, currently no more attempts at load balancing is made.

> This
> patch checks if the balancing is being done on a group whose cpus
> share package resources. If so, then check if the load balancing can
> be done for other cpus in the same group.

So I absolutely hate this patch... Also I'm not convinced I actually
understand the explanation above.

Furthermore; there is nothing special about spreading tasks for
SHARED_PKG_RESOURCES and special casing that one case is just wrong.

If anything it should be keyed off of SD_PREFER_SIBLING and or
cpu_power.
