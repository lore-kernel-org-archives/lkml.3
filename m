Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbaAFVZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:25:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:42392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbaAFVZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:25:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="434703667"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
References: <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com>
	<20131218141125.GT21999@twins.programming.kicks-ass.net>
	<87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
	<20131218150900.GU21999@twins.programming.kicks-ass.net>
	<87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
	<20131219103134.GD30183@twins.programming.kicks-ass.net>
	<87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
	<20131219112812.GY21999@twins.programming.kicks-ass.net>
	<20131219123955.GA18186@gmail.com>
	<87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
	<20131219151024.GI16438@laptop.programming.kicks-ass.net>
Date: Mon, 06 Jan 2014 13:25:02 -0800
In-Reply-To: <20131219151024.GI16438@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 19 Dec 2013 16:10:24 +0100")
Message-ID: <87iotw6bwx.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, Dec 19, 2013 at 04:30:53PM +0200, Alexander Shishkin wrote:
>> So I'd like to steer away from the ways in which hardware can be broken
>> and talk about a usable interface, to begin with.
>
> Just dump it into the regular one buffer like I outlined.

Just getting back to this. 

Do you realize that PT buffers have to be page aligned. 

So to mix it with a regular perf buffer would need padding every PT
message by 4K, which wastes a lot of memory. The side band messages
are usually only a few bytes (e.g. context switch).

If the sideband is mfrequent it could even take up >half of the buffer,
but mostly only with padding.

Is that what you intended?

perf doesn't support gaps today, so your proposal wouldn't even
seem to fit into the current perf design.

Also of course it requires disabling/enabling PT explicitly for 
every perf message, which is slow. So you add at least 2*WRMSR cost
(thousands of cycles).

> That said; we very much need to have at least two architectures
> implemented for any of this code to move.
>
> But we cannot ignore the hardware trainwreck; we cannot shape our
> interface around something that's utterly broken.
>
> Some hardware is just too broken to support.

I don't think the PT design is broken in any way, it's straight 
forward and simple.

Trying to mix hardware tracing and software tracing in the same buffer
on the other hand ...

Anyways if perf is not flexible enough to support this I suppose
it could switch to a simple device driver, and only run perf with
separate fds for side band purposes. 

Would you prefer that?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
