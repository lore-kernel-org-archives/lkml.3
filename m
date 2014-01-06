Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaAFLQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:16:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56205 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaAFLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:16:44 -0500
Date: Mon, 6 Jan 2014 12:16:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140106111624.GB5623@twins.programming.kicks-ass.net>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
 <20140104161050.GA24306@htj.dyndns.org>
 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140104225058.GC24306@htj.dyndns.org>
 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 05:23:07AM +0000, Waskiewicz Jr, Peter P wrote:
> The processor doesn't need to understand the grouping at all, but it
> also isn't tracking things per-process that are rolled up later.
> They're tracked via the RMID resource in the hardware, which could
> correspond to a single process, or 500 processes.  It really comes down
> to the ease of management of grouping tasks in groups for two consumers,
> 1) the end user, and 2) the process scheduler.
> 
> I think I still may not be explaining how the CPU side works well
> enough, in order to better understand what I'm trying to do with the
> cgroup.  Let me try to be a bit more clear, and if I'm still sounding
> vague or not making sense, please tell me what isn't clear and I'll try
> to be more specific.  The new Documentation addition in patch 4 also has
> a good overview, but let's try this:
> 
> A CPU may have 32 RMID's in hardware.  This is for the platform, not per
> core.  I may want to have a single process assigned to an RMID for
> tracking, say qemu to monitor cache usage of a specific VM.  But I also
> may want to monitor cache usage of all MySQL database processes with
> another RMID, or even split specific processes of that database between
> different RMID's.  It all comes down to how the end-user wants to
> monitor their specific workloads, and how those workloads are impacting
> cache usage and occupancy.
> 
> With this implementation I've sent, all tasks are in RMID 0 by default.
> Then one can create a subdirectory, just like the cpuacct cgroup, and
> then add tasks to that subdirectory's task list.  Once that
> subdirectory's task list is enabled (through the cacheqos.monitor_cache
> handle), then a free RMID is assigned from the CPU, and when the
> scheduler switches to any of the tasks in that cgroup under that RMID,
> the RMID begins monitoring the usage.
> 
> The CPU side is easy and clean.  When something in the software wants to
> monitor when a particular task is scheduled and started, write whatever
> RMID that task is assigned to (through some mechanism) to the proper MSR
> in the CPU.  When that task is swapped out, clear the MSR to stop
> monitoring of that RMID.  When that RMID's statistics are requested by
> the software (through some mechanism), then the CPU's MSRs are written
> with the RMID in question, and the value is read of what has been
> collected so far.  In my case, I decided to use a cgroup for this
> "mechanism" since so much of the grouping and task/group association
> already exists and doesn't need to be rebuilt or re-invented.

This still doesn't explain why you can't use perf-cgroup for this.

> > In general, I'm quite strongly opposed against using cgroup as
> > arbitrary grouping mechanism for anything other than resource control,
> > especially given that we're moving away from multiple hierarchies.
> 
> Just to clarify then, would the mechanism in the cpuacct cgroup to
> create a group off the root subsystem be considered multi-hierarchical?
> If not, then the intent for this new cacheqos subsystem is to be
> identical in that regard to cpuacct in the behavior.
> 
> This is a resource controller, it just happens to be tied to a hardware
> resource instead of an OS resource.

No, cpuacct and perf-cgroup aren't actually controllers at all. They're
resource monitors at best. Same with your Cache QoS Monitor, it doesn't
control anything.
