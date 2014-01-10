Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaAJSzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:55:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:36240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaAJSzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:55:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,639,1384329600"; 
   d="scan'208";a="464833403"
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
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMAgAH1FwCAAFi3gIAAAjYAgAABqYCAABYGAIAAIqSAgAAVLYCAAAYhgIAABtuAgAAJDYCAAKSvAIAAcA2AgABjroCABJCVAA==
Date: Fri, 10 Jan 2014 18:55:11 +0000
Message-ID: <1389380100.32504.172.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <20140106164150.GQ31570@twins.programming.kicks-ass.net>
	 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106180636.GG30183@twins.programming.kicks-ass.net>
	 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106212623.GH30183@twins.programming.kicks-ass.net>
	 <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106221251.GJ30183@twins.programming.kicks-ass.net>
	 <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140107083440.GL30183@twins.programming.kicks-ass.net>
	 <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140107211229.GF2480@laptop.programming.kicks-ass.net>
In-Reply-To: <20140107211229.GF2480@laptop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.99]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6599ADE8EA605A4E803C0E87B01CC9B9@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0AItUWt011235

On Tue, 2014-01-07 at 22:12 +0100, Peter Zijlstra wrote:
> Maybe its me (its late) but I can't follow.
> 
> So if every cacheline is tagged with both CR3 and RMID (on all levels --
> I get that it needs to propagate etc..) then you can, upon observing a
> new CR3,RMID pair, iterate the entire cache for the matching CR3 and
> update its RMID.
> 
> This, while expensive, would fairly quickly propagate changes.
> 
> Now I'm not at all sure cachelines are CR3 tagged.
> 
> The above has downsides in that you cannot use RMIDs to slice into
> processes, where a pure RMID (without CR3 relation, even if cachelines
> are CR3 tagged) can slice processes -- note that process is an
> address-space/CR3 collection of threads.
> 
> A pure RMID tagging solution would not allow the immediate update and
> would require on demand updates on new cacheline usage.
> 
> This makes switching RMIDs effects slower to propagate.

> > > The other possible interpretation is that it updates on-demand whenever
> > > it touches a cacheline. But in that case, how do you deal with the
> > > non-exclusive states? Does the last RMID to touch a non-exclusive
> > > cacheline simply claim the entire line?
> > 
> > I don't believe it claims the whole line; I had that exact discussion
> > awhile ago with the CPU architect, and this didn't appear broken before.
> > I will ask him again though since that discussion was over a year ago.
> > 
> > > But that doesn't avoid the problem; because as soon as you change the
> > > PQR_ASSOC RMID you still need to go run for a while to touch 'all' your
> > > lines.
> > > 
> > > This duration is indeterminate; which again brings us back to needing to
> > > first wipe the entire cache.
> > 
> > I asked hpa if there is a clean way to do that outside of a WBINVD, and
> > the answer is no.
> > 
> > I've sent the two outstanding questions off to the CPU architect, I'll
> > let you know what he says once I hear.
> 
> Much appreciated; so I'd like a complete description of how this thing
> works, with in particular when exactly lines are tagged.

I've spoken with the CPU architect, and he's set me straight.  I was
getting some simulation data and reality mixed up, so apologies.

The cacheline is tagged with the RMID being tracked when it's brought
into the cache.  That is the only time it's tagged, it does not get
updated (I was looking at data showing impacts if it was updated).

If there are frequent RMID updates for a particular process, then there
is the possibility that any remaining old data for that process can be
accounted for on a different RMID.  This really is workload dependent,
and my architect provided their data showing that this occurrence is
pretty much in the noise.

Also, I did ask about the granularity of the RMID, and it is
per-cacheline.  So if there is a non-exclusive cacheline, then the
occupancy data in the other part of the cacheline will count against the
RMID.

> So my current mental model would tag a line with the current (ASSOC)
> RMID on:
>  - load from DRAM -> L*, even for non-exclusive
>  - any to exclusive transition
> 
> The result of such rules is that when the effective RMID of a task
> changes it takes an indeterminate amount of time before the residency
> stats reflect reality again.
> 
> Furthermore; the IA32_QM_CTR is a misnomer as its a VALUE not a COUNTER.
> Not to mention the entire SDM 17.14.2 section is a mess; it purports to
> describe how to detect the thing using CPUID but then also maybe
> describes how to program it.

I've given this feedback to the section owner in the SDM.  There is an
update due this month, and there will be some updates to this section
(along with some additions).

I should have my alternate implementation sent out shortly, just working
a few kinks out of it.  This is the proc-based and sysfs-based interface
that will rely on a userspace program to handle the logic of grouping
and assigning stuff together.

Cheers,
-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
