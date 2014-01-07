Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaAGPQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:16:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:41036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaAGPPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:15:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,619,1384329600"; 
   d="scan'208";a="454886637"
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
Thread-Index: AQHPCMNUDB9LRbk7GE+jzVKI+L/oYZp1Q6cAgABthYCAAAJHAIAAbYMAgAH1FwCAAFi3gIAAAjYAgAABqYCAABYGAIAAIqSAgAAVLYCAAAYhgIAABtuAgAAJDYCAAKSvAIAAcA2A
Date: Tue, 7 Jan 2014 15:15:52 +0000
Message-ID: <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
References: <20140106111624.GB5623@twins.programming.kicks-ass.net>
	 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
	 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106180636.GG30183@twins.programming.kicks-ass.net>
	 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106212623.GH30183@twins.programming.kicks-ass.net>
	 <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140106221251.GJ30183@twins.programming.kicks-ass.net>
	 <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com>
	 <20140107083440.GL30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140107083440.GL30183@twins.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.89]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C20E0748E03CDE42930C14F18DC98A00@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s07FG9Er019263

On Tue, 2014-01-07 at 09:34 +0100, Peter Zijlstra wrote:
> On Mon, Jan 06, 2014 at 10:45:24PM +0000, Waskiewicz Jr, Peter P wrote:
> > > Since its a very limited resource that seems like a weird assumption to
> > > me; there's plenty scenarios in which you'd want to re-use RMIDs that
> > > belong to a still running context.
> > 
> > I think I see what you're really asking, let me rephrase to see if I'm
> > now understanding you:  What happens to a running process' cache
> > assigned to one RMID when it's reassigned to a different RMID?  Does the
> > RMID get updated internally or does it appear as still belonging to the
> > old RMID?
> > 
> > If that's your question, then the CPU will update the cache entry with
> > the correct RMID.  It knows to do this because the when the process is
> > scheduled, the OS will write the IA32_PQR_ASSOC MSR with the RMID map to
> > start monitoring.  That's when the RMID will be updated in the cache.
> > However, any cacheline for a process that is moved to a different RMID,
> > but doesn't have an opportunity to be scheduled, will still show up on
> > the old RMID until it gets to run with the new RMID.
> > 
> > Let me know if that better explains what I think you're asking.
> 
> Still confused here. So what you're saying is that cachelines get tagged
> with {CR3,RMID} and when they observe the same CR3 with a different RMID
> the hardware will iterate the entire cache and update all tuples?
> 
> That seems both very expensive and undesirable. It would mean you could
> never use the RMID to creates slices of a process since you're stuck to
> the CR3.
> 
> It also makes me wonder why we have the RMID at all; because if you're
> already tagging every line with the CR3, why not build the cache monitor
> on that. Just query the occupancy for all CR3s in your group and add.

The reason is the RMID needs to be retained on the cache entry when it
is promoted to another layer of cache, and (possibly) returns to the LLC
later.  And the mechanism to return the occupancy is how you hope it is,
query the occupancy for all CR3s and add.  If you didn't have the RMID
tagged on the cache entry, then you couldn't do that.

> The other possible interpretation is that it updates on-demand whenever
> it touches a cacheline. But in that case, how do you deal with the
> non-exclusive states? Does the last RMID to touch a non-exclusive
> cacheline simply claim the entire line?

I don't believe it claims the whole line; I had that exact discussion
awhile ago with the CPU architect, and this didn't appear broken before.
I will ask him again though since that discussion was over a year ago.

> But that doesn't avoid the problem; because as soon as you change the
> PQR_ASSOC RMID you still need to go run for a while to touch 'all' your
> lines.
> 
> This duration is indeterminate; which again brings us back to needing to
> first wipe the entire cache.

I asked hpa if there is a clean way to do that outside of a WBINVD, and
the answer is no.

I've sent the two outstanding questions off to the CPU architect, I'll
let you know what he says once I hear.

Cheers,
-PJ

-- 
PJ Waskiewicz				Open Source Technology Center
peter.p.waskiewicz.jr@intel.com		Intel Corp.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
