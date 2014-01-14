Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaANUq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:46:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:59252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaANUqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:46:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="466658211"
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
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMAgAH1FwCAAFi3gIAAAjYAgAABqYCAABYGAIAAIqSAgAAVLYCAAAYhgIAABtuAgAAJDYCAAKSvAIAAcA2AgABjroCABJCVAIAD/rkAgAJp04A=
Date: Tue, 14 Jan 2014 20:46:53 +0000
Message-ID: <1389732405.32504.193.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <20140106180636.GG30183@twins.programming.kicks-ass.net>
	 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106212623.GH30183@twins.programming.kicks-ass.net>
	 <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106221251.GJ30183@twins.programming.kicks-ass.net>
	 <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140107083440.GL30183@twins.programming.kicks-ass.net>
	 <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140107211229.GF2480@laptop.programming.kicks-ass.net>
	 <1389380100.32504.172.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140113075528.GR7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140113075528.GR7572@laptop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.206]
Content-Type: text/plain; charset="utf-8"
Content-ID: <313BB4370657944FA44FFA5E5277A95F@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0EKl2qC003429

On Mon, 2014-01-13 at 08:55 +0100, Peter Zijlstra wrote:
> On Fri, Jan 10, 2014 at 06:55:11PM +0000, Waskiewicz Jr, Peter P wrote:
> > I've spoken with the CPU architect, and he's set me straight.  I was
> > getting some simulation data and reality mixed up, so apologies.
> > 
> > The cacheline is tagged with the RMID being tracked when it's brought
> > into the cache.  That is the only time it's tagged, it does not get
> > updated (I was looking at data showing impacts if it was updated).
> > 
> > If there are frequent RMID updates for a particular process, then there
> > is the possibility that any remaining old data for that process can be
> > accounted for on a different RMID.  This really is workload dependent,
> > and my architect provided their data showing that this occurrence is
> > pretty much in the noise.
> 
> What change frequency and what sided workloads did they test?

I will see what data I can share, as much of this is internal testing
with open access to hardware implementation details.

> I can make it significant; take a multi-threaded workload that mostly
> fits in cache, then assign all theads but one RMDI 0, then fairly
> quickly rotate RMID 1 between the threads.
> 
> The problem is, since there's a limited number of RMIDs we have to
> rotate at some point, but since changing RMIDs is nondeterministic we
> can't.
> 
> > Also, I did ask about the granularity of the RMID, and it is
> > per-cacheline.  So if there is a non-exclusive cacheline, then the
> > occupancy data in the other part of the cacheline will count against the
> > RMID.
> 
> One more question:
> 
>   u64 i;
>   u64 rmid_val[];
> 
>   for (i = 0; i < rmid_max; i++) {
>     wrmsr(IA32_QM_EVTSEL, 1 | (i << 32));
>     rdmsr(IA32_QM_CTR, rmid_val[i]);
>   }
> 
> Is this the right way of reading these values? I couldn't find anything
> that says the event must 'run' to accumulate a value at all, so all it
> seems it a direct value read with a multiplexer to the RMID.

Yes, this is correct.  In the SDM, the layout of the IA32_QM_CTR MSR has
bits 61:0 contain the data, then bits 62 and 63 are error bits.  In
order to select the RMID to read, the IA32_QM_EVTSEL must be programmed
to get the data out; that's the only way to tell the CPU what RMID needs
to be inspected.

[...]

> I've not figured out how to deal with this stuff yet; exposing RMIDs to
> userspace is a guaranteed fail though. Any interface that disallows the
> kernel to manage the RMIDs is broken.

Hence the first implementation in this patch series using cgroups.  The
backend would assign an RMID to the task group when monitoring was
enabled.  The RMID itself had no exposure to userspace.  It's quite a
nice association that works well.  I still think it's a viable way to do
it, and am trying to convince myself otherwise (but keep coming back to
it).

The implementation I'm talking about is to assign an arbitrary group
number to the tasks, then have the kernel assign an RMID to that group
number when the group's monitoring is enabled.  So basically the same
functionality that the current patchset uses, but minus the cgroup.  I
don't like the approach because it will reinvent some of the cgroup's
functionality, but it does separate it from cgroups.

Cheers,
-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
