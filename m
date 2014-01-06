Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaAFSG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:06:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37413 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaAFSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:06:54 -0500
Date: Mon, 6 Jan 2014 19:06:36 +0100
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
Message-ID: <20140106180636.GG30183@twins.programming.kicks-ass.net>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
 <20140104161050.GA24306@htj.dyndns.org>
 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140104225058.GC24306@htj.dyndns.org>
 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106111624.GB5623@twins.programming.kicks-ass.net>
 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 04:47:57PM +0000, Waskiewicz Jr, Peter P wrote:
> > As is I don't really see a good use for RMIDs and I would simply not use
> > them.
> 
> If you want to use CQM in the hardware, then the RMID is how you get the
> cache usage data from the CPU.  If you don't want to use CQM, then you
> can ignore RMIDs.

I think you can make do with a single RMID (per cpu). When you program
the counter (be it for a task, cpu or cgroup context) you set the 1 RMID
and EVSEL and read the CTR.

What I'm not entirely clear on is if the EVSEL and CTR MSR are per
logical CPU or per L3 (package); /me prays they're per logical CPU.

> One of the best use cases for using RMIDs is in virtualization.

*groan*.. /me plugs wax in ears and goes la-la-la-la

> A VM
> may be a heavy cache user, or a light cache user.  Tracing different VMs
> on different RMIDs can allow an admin to identify which VM may be
> causing high levels of eviction, and either migrate it to another host,
> or move other tasks/VMs to other hosts.  Without CQM, it's much harder
> to find which process is eating the cache up.

Not necessarily VMs, there's plenty large processes that exhibit similar
problems.. why must people always do VMs :-(

That said, even with a single RMID you can get that information by
simply running it against all competing processes one at a time. Since
there's limited RMID space you need to rotate at some point anyway.

The cgroup interface you propose wouldn't allow for rotation; other than
manual by creating different cgroups one after another.


