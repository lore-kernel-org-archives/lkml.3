Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaAFQsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:48:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:47727 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbaAFQr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:47:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="454332619"
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Topic: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMAgAH1FwCAAFi3gIAAAjYAgAABqYA=
Date: Mon, 6 Jan 2014 16:47:57 +0000
Message-ID: <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
	 <20140104161050.GA24306@htj.dyndns.org>
	 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140104225058.GC24306@htj.dyndns.org>
	 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106111624.GB5623@twins.programming.kicks-ass.net>
	 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140106164150.GQ31570@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.231]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E3A1884C0FEAD4E9927FF129C94CA01@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s06Gm8nE008031

On Mon, 2014-01-06 at 17:41 +0100, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 04:34:04PM +0000, Waskiewicz Jr, Peter P wrote:
> > On Mon, 2014-01-06 at 12:16 +0100, Peter Zijlstra wrote:
> > > On Sun, Jan 05, 2014 at 05:23:07AM +0000, Waskiewicz Jr, Peter P wrote:
> > > > The CPU side is easy and clean.  When something in the software wants to
> > > > monitor when a particular task is scheduled and started, write whatever
> > > > RMID that task is assigned to (through some mechanism) to the proper MSR
> > > > in the CPU.  When that task is swapped out, clear the MSR to stop
> > > > monitoring of that RMID.  When that RMID's statistics are requested by
> > > > the software (through some mechanism), then the CPU's MSRs are written
> > > > with the RMID in question, and the value is read of what has been
> > > > collected so far.  In my case, I decided to use a cgroup for this
> > > > "mechanism" since so much of the grouping and task/group association
> > > > already exists and doesn't need to be rebuilt or re-invented.
> > > 
> > > This still doesn't explain why you can't use perf-cgroup for this.
> > 
> > I'm not completely familiar with perf-cgroup, so I looked for some
> > documentation for it to better understand it.  Are you referring to perf
> > -G to monitor an existing cgroup/all cgroups?  Or something else?  If
> > it's the former, I'm not following you how this would fit.
> 
> All the bits under CONFIG_CGROUP_PERF, I've no idea how userspace looks.

Ah ok.  Yes, the userspace side of perf really doesn't fit controlling
the CQM bits at all from what I see.

> > > > > In general, I'm quite strongly opposed against using cgroup as
> > > > > arbitrary grouping mechanism for anything other than resource control,
> > > > > especially given that we're moving away from multiple hierarchies.
> > > > 
> > > > Just to clarify then, would the mechanism in the cpuacct cgroup to
> > > > create a group off the root subsystem be considered multi-hierarchical?
> > > > If not, then the intent for this new cacheqos subsystem is to be
> > > > identical in that regard to cpuacct in the behavior.
> > > > 
> > > > This is a resource controller, it just happens to be tied to a hardware
> > > > resource instead of an OS resource.
> > > 
> > > No, cpuacct and perf-cgroup aren't actually controllers at all. They're
> > > resource monitors at best. Same with your Cache QoS Monitor, it doesn't
> > > control anything.
> > 
> > I may be using controller in a different way than you are.  Yes, the
> > Cache QoS Monitor is monitoring cache data.  But it is also controlling
> > the allocation and deallocation of RMIDs to tasks/task groups as
> > monitoring is enabled and disabled for those groups.  That's why I
> > called it a controller.  If that's not accurate, I apologize.
> 
> Yeah that's not accurate, nor desired I think, because you get into
> horrible problems with hierarchies, do child groups belong to your RMID
> or not?

I'd rather not support a child group of a child group.  Only groups off
the root, and each group would be assigned an RMID when it's activated
for monitoring.

> As is I don't really see a good use for RMIDs and I would simply not use
> them.

If you want to use CQM in the hardware, then the RMID is how you get the
cache usage data from the CPU.  If you don't want to use CQM, then you
can ignore RMIDs.

One of the best use cases for using RMIDs is in virtualization.  A VM
may be a heavy cache user, or a light cache user.  Tracing different VMs
on different RMIDs can allow an admin to identify which VM may be
causing high levels of eviction, and either migrate it to another host,
or move other tasks/VMs to other hosts.  Without CQM, it's much harder
to find which process is eating the cache up.

Cheers,
-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
