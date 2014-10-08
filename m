Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaJHIH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:07:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaJHIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:07:16 -0400
Date: Wed, 8 Oct 2014 10:07:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net, lizefan@huawei.com,
        anton@samba.org, tj@kernel.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Message-ID: <20141008080706.GC10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 12:37:40PM +0530, Preeti U Murthy wrote:
> There are two masks associated with cpusets. The cpus/mems_allowed
> and effective_cpus/mems. On the legacy hierarchy both these masks
> are consistent with each other. This is the intersection of their
> value and the currently active cpus. This means that we destroy the
> original values set in these masks on each cpu/mem hot unplug operation.
> 	As a consequence when we hot plug back the cpus/mems, the tasks
> no longer run on them and performance degrades, inspite of having
> resources to run on.
> 
> This effect is not seen in the default hierarchy since the
> allowed and effective masks are distinctly maintained.
> allowed masks are never touched once configured and effective masks
> alone are hotplug variant.
> 
> This patch replicates the above design even for the legacy hierarchy,
> so that:
> 
> 1. Tasks always run on the cpus/memory nodes that they are allowed to run on
> as long as they are online. The allowed masks are hotplug invariant.
> 
> 2. When all cpus/memory nodes in a cpuset are hot unplugged out, the tasks
> are moved to their nearest ancestor which has resources to run on.
> 
> There were discussions earlier around this issue:
> https://lkml.org/lkml/2012/5/4/265
> http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133
> 
> The argument against making the allowed masks hotplug invariant was that
> hotplug is destructive and hence cpusets cannot expect to regain resources
> that have gone through a hotplug operation by the user.
> 
> But on powerpc we do smt mode switch to suit the workload running.
> We therefore need to keep track of the original cpuset configuration
> so as to make use of them when they are back online due to a mode switch.
> Moreover there is no real harm in keeping the allowed masks invariant
> on hotplug since the effective masks will anyway keep track of the
> online cpus. In fact there are use cases which need the cpuset's
> original configuration to be retained. The v2 of cgroup design therefore
> does not overwrite this configuration.
> 

I still completely hate all that.. It basically makes cpusets useless,
they no longer guarantee anything, it makes then an optional placement
hint instead.

You also break long standing behaviour.

Also, power is insane if it needs/uses hotplug for operational crap
like that.
