Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaJXKxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:53:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaJXKxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:53:11 -0400
Date: Fri, 24 Oct 2014 12:53:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: vikas <vikas.shivappa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "matt.fleming" <matt.fleming@intel.com>,
        "will.auld" <will.auld@intel.com>, tj@kernel.org,
        "vikas.shivappa" <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141024105306.GI12706@worktop.programming.kicks-ass.net>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020161855.GF12020@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 05:18:55PM +0100, Matt Fleming wrote:
> > What is Cache Allocation Technology ( CAT )
> > -------------------------------------------

Its a horrible name is what it is, please consider using the old name,
that at least was clear in purpose.

> > Kernel implementation Overview
> > -------------------------------
> > 
> > Kernel implements a cgroup subsystem to support Cache Allocation.
> > 
> > Creating a CAT cgroup would create a new CLOS <-> CBM mapping. Each
> > cgroup would have one CBM and would just represent one cache 'subset'.
> > 
> > The user would be allowed to create as many directories as there are
> > CLOSs defined by the h/w. If user tries to create more than the
> > available CLOSs , -ENOSPC is returned. Currently we support only one
> > level of directory, ie directory can be created only under the root. 

NAK, cgroups must support full hierarchies, simply enforce that the
child cgroup's mask is a subset of the parent's.

> > There are 2 modes supported 
> > 
> > 1. Affinitized mode : Each CAT cgroup is affinitized to a set of CPUs
> > specified by the 'cpus' file. The tasks in the CAT cgroup would be
> > constrained only on the CPUs in the 'cpus' file. The CPUs in this file 
> > are exclusively used for this cgroup. Requests by task
> > using the sched_setaffinity() would be filtered through the tasks
> > 'cpus'.

NAK, we will not have yet another cgroup mucking about with task
affinities.

> > These tasks would get to fill the LLC cache represented by the
> > cgroup's 'cbm' file.  'cpus'  is a cpumask and works the same way as
> > the existing cpumask datastructure.
> > 
> > 2. Non Affinitized mode : Each CAT cgroup(inturn 'subset') would be
> > for a group of tasks. There is no 'cpus' file and the CPUs that the
> > tasks run are not restricted by the CAT cgroup 

It appears to me this 'mode' thing is entirely superfluous and can be
constructed by voluntary operation of this and cpusets or manual
affinity calls.

> > Assignment of CBM,CLOS and modes
> > ---------------------------------
> > 
> > Root directory would have all bits in 'cbm' file by default.
> > 
> > The cbm_max file in the root defines the maximum number of bits
> > describing the available cache units. Say if cbm_max is 16 then the
> > 'cbm' cannot have more than 16 bits.

This seems redundant, if you've already stated that the root cbm is the
full set, there is no need to further provide this.

> > The 'cbm' file is restricted to having no more than its cbm_max least
> > significant bits set. Any contiguous subset of these bits maybe set to
> > indication the cache mapping desired.  The 'cbm' between 2 directories
> > can overlap. The 'cbm' would represent the cache 'subset' of the CAT
> > cgroup. 

This would follow from the hierarchy requirement/conditions.

> > Scheduling and Context Switch
> > ------------------------------

> > In non-affinitized mode the 'affinitized' is 0 , and the 'tasks' file
> > indicate the tasks the cache subset is affinitized to.  When user adds
> > tasks to the tasks file , the tasks would get to fill the cache subset
> > represented by the CAT cgroup's 'cbm' file.  
> > 
> > During context switch kernel implements this by writing the
> > corresponding CLOSid (internally maintained by kernel) of the CAT
> > cgroup to the CPU's IA32_PQR_ASSOC MSR. 

Right.
