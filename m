Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaJTQTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:19:00 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46948 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJTQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:18:59 -0400
Date: Mon, 20 Oct 2014 17:18:55 +0100
From: Matt Fleming <matt@console-pimps.org>
To: vikas <vikas.shivappa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "matt.fleming" <matt.fleming@intel.com>,
        "will.auld" <will.auld@intel.com>, tj@kernel.org,
        "vikas.shivappa" <vikas.shivappa@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141020161855.GF12020@console-pimps.org>
References: <1413485050.28564.14.camel@vshiva-Udesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413485050.28564.14.camel@vshiva-Udesk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ing Peter Zijlstra for comments)

On Thu, 16 Oct, at 11:44:10AM, vikas wrote:
> Hi All , We have put together a draft design document for cache 
> allocation technology below. Please review the same and let us know any
> feedback.
> 
> Make sure you cc my email vikas.shivappa@linux.intel.com when replying 
> 
> Thanks,
> Vikas
> 
> What is Cache Allocation Technology ( CAT )
> -------------------------------------------
> 
> Cache Allocation Technology provides a way for the Software (OS/VMM)
> to restrict cache allocation to a defined 'subset' of cache which may 
> be overlapping with other 'subsets'.  This feature is used when
> allocating a line in cache ie when pulling new data into the cache.
> The programming of the h/w is done via programming  MSRs.
> 
> The different cache subsets are identified by CLOS identifier (class 
> of service) and each CLOS has a CBM (cache bit mask).  The CBM is a 
> contiguous set of bits which defines the amount of cache resource that 
> is available for each 'subset'.
> 
> Why is CAT (cache allocation technology)  needed
> ------------------------------------------------
> 
> The CAT  enables more cache resources to be made available for higher
> priority applications based on guidance from the execution
> environment.  
> 
> The architecture also allows dynamically changing these subsets during
> runtime to further optimize the performance of the higher priority
> application with minimal degradation to the low priority app.
> Additionally, resources can be rebalanced for system throughput
> benefit.  (Refer to Section 17.15 in the Intel SDM
> http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf)
> 
> This technique may be useful in managing large computer systems which
> large LLC. Examples may be large servers running  instances of
> webservers or database servers. In such complex systems, these subsets
> can be used for more careful placing of the available cache
> resources.
> 
> The CAT kernel patch would provide a basic kernel framework for users
> to be able to implement such cache subsets. 
> 
> 
> Kernel implementation Overview
> -------------------------------
> 
> Kernel implements a cgroup subsystem to support Cache Allocation.
> 
> Creating a CAT cgroup would create a new CLOS <-> CBM mapping. Each
> cgroup would have one CBM and would just represent one cache 'subset'.
> 
> The user would be allowed to create as many directories as there are
> CLOSs defined by the h/w. If user tries to create more than the
> available CLOSs , -ENOSPC is returned. Currently we support only one
> level of directory, ie directory can be created only under the root. 
> 
> There are 2 modes supported 
> 
> 1. Affinitized mode : Each CAT cgroup is affinitized to a set of CPUs
> specified by the 'cpus' file. The tasks in the CAT cgroup would be
> constrained only on the CPUs in the 'cpus' file. The CPUs in this file 
> are exclusively used for this cgroup. Requests by task
> using the sched_setaffinity() would be filtered through the tasks
> 'cpus'.
> 
> These tasks would get to fill the LLC cache represented by the
> cgroup's 'cbm' file.  'cpus'  is a cpumask and works the same way as
> the existing cpumask datastructure.
> 
> 2. Non Affinitized mode : Each CAT cgroup(inturn 'subset') would be
> for a group of tasks. There is no 'cpus' file and the CPUs that the
> tasks run are not restricted by the CAT cgroup 
> 
> 
> Assignment of CBM,CLOS and modes
> ---------------------------------
> 
> Root directory would have all bits in 'cbm' file by default.
> 
> The cbm_max file in the root defines the maximum number of bits
> describing the available cache units. Say if cbm_max is 16 then the
> 'cbm' cannot have more than 16 bits.
> 
> The 'affinitized' file is either 0 or 1 which represent the two modes.
> System would boot with affinitized mode and all CPUs would have all
> bits in cbm set meaning all CPUs have 100% cache(effectively cache
> allocation is not in effect).
> 
> The 'cbm' file is restricted to having no more than its cbm_max least
> significant bits set. Any contiguous subset of these bits maybe set to
> indication the cache mapping desired.  The 'cbm' between 2 directories
> can overlap. The 'cbm' would represent the cache 'subset' of the CAT
> cgroup. For ex: on a system with 16 bits of max cbm bits , if the
> directory has the least significant 4 bits set in its 'cbm' file, it
> would be allocated the right quarter of the Last level cache which
> means the tasks belonging to this CAT cgroup can use the right quarter
> of the cache to fill. If it has the most significant 8 bits set ,it
> would be allocated the left half of the cache(8 bits  out of 16
> represents 50%).
> 
> The cache subset would be affinitized to a set of cpus in affinitized
> mode. The CPUs to which this allocation is affinitized to is
> represented by the 'cpus' file. The 'cpus' need to be mutually
> exclusive from cpus of  other directories. 
> 
> The cache portion defined in the CBM file is available to all tasks 
> within the CAT group and these task are not allowed to allocate space 
> in other parts of the cache. 
> 
> 'cbm' file is used in both modes where as the 'cpus' file is relevant
> in affinitized mode and would disappear in non-affinitized mode. 
> 
> 
> Scheduling and Context Switch
> ------------------------------
> 
> In affinitized mode , the cache 'subset' and the tasks in a CAT cgroup
> are affinitized to the CPUs represented by the CAT cgroup's 'cpus'
> file i.e when user sets the 'cbm' to 'portion' and 'cpus' to c and 
> 'tasks' to t, the tasks 't' would always be scheduled on cpus 'c' and 
> will get to fill in the allocated 'portion' in  last level cache.
> 
> As noted above ,in the affinitized mode the tasks in a CAT cgroup
> would also be affinitized to the CPUs in the 'cpus' file of the
> directory.  Following hooks in the kernel are required to implement
> this (on the lines of cpuset code)
> - in sched_setaffinity to mask the requested cpu mask with what is
> present in the task's 'cpus' 
> - in migrate_task to migrate the tasks only to those CPUs in the
> 'cpus' file if possible.
> - in select_task_rq 
> 
> In non-affinitized mode the 'affinitized' is 0 , and the 'tasks' file
> indicate the tasks the cache subset is affinitized to.  When user adds
> tasks to the tasks file , the tasks would get to fill the cache subset
> represented by the CAT cgroup's 'cbm' file.  
> 
> During context switch kernel implements this by writing the
> corresponding CLOSid (internally maintained by kernel) of the CAT
> cgroup to the CPU's IA32_PQR_ASSOC MSR. 
> 
> Usage and Example
> -----------------
> 
> 
> Following would mount the cache allocation cgroup subsystem and create
> 2 directories. Please refer to Documentation/cgroups/cgroups.txt on
> details about how to use cgroups.
> 
>   cd /sys/fs/cgroup 
>   mkdir cachealloc 
>   mount -t cgroup -ocachealloc cachealloc /sys/fs/cgroup/cachealloc 
>   cd cachealloc
> 
> Create 2 cat cgroups 
> 
>   mkdir group1 
>   mkdir group2
> 
> Following are some of the Files in the directory
> 
>   ls 
>   cachea.cbm 
>   cachea.cpus . cpus file only appears in the affinitized  mode 
>   cgroup.procs 
>   tasks 
>   cbm_max (root only) 
>   affinitized (root only) . by default itsaffinitized mode
> 
> Say if the cache is 2MB and cbm supports 16 bits, then setting the
> below allocates the 'right 1/4th(512KB)' of the cache to group2 
> 
> Edit the CBM for group2 to set the least significant 4 bits.  This
> allocates 'right quarter' of the cache. 
> 
>   cd group2 
>   /bin/echo 0xf > cachealloc.cbm 
> 
> Change cpus in the directory. 
>  
>   /bin/echo 1-4 > cachealloc.cpus 
> 
> Edit the CBM for group2 to set the least significant 8 bits.This
> allocates the right half of the cache to 'group2'.
> 
>   cd group2 
>   /bin/echo 0xff > cachea.cbm 
> 
> Assign tasks to the group2
>   
>   /bin/echo PID1 > tasks 
>   /bin/echo PID2 > tasks 
>   Meaning now threads
>   PID1 and PID2 runs on CPUs 1-4 , and get to fill the 'right half' of
>   the cache. The tasks PID1 and PID2 can only have a subset of the cpu
>   affinity defined in the 'cpus' file
> 
> Edit the affinitized to 0.mode is changed in root directory cd ..
> 
>   /bin/echo 0 > cachealloc.affinitized
> 
> Now the tasks and the cache allocation is not affinitized to the CPUs
> and the task's cpu affinity is not restricted to being with the subset
> of 'cpus' cpumask. 

-- 
Matt Fleming, Intel Open Source Technology Center
