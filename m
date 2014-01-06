Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388AbaAFXKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:10:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:28149 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaAFXK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 18:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,615,1384329600"; 
   d="scan'208";a="462559361"
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
References: <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com>
	<20131218150900.GU21999@twins.programming.kicks-ass.net>
	<87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com>
	<20131219103134.GD30183@twins.programming.kicks-ass.net>
	<87ob4drsww.fsf@ashishki-desk.ger.corp.intel.com>
	<20131219112812.GY21999@twins.programming.kicks-ass.net>
	<20131219123955.GA18186@gmail.com>
	<87haa4kj4y.fsf@ashishki-desk.ger.corp.intel.com>
	<20131219151024.GI16438@laptop.programming.kicks-ass.net>
	<87iotw6bwx.fsf@tassilo.jf.intel.com>
	<20140106221528.GK30183@twins.programming.kicks-ass.net>
Date: Mon, 06 Jan 2014 15:10:28 -0800
In-Reply-To: <20140106221528.GK30183@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Mon, 6 Jan 2014 23:15:28 +0100")
Message-ID: <8761pw6717.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

Can you please clarify your position on the interleaved buffer?

I still can't see how it is a efficient design.

It's generally true in scather-gather (be it software or hardware) 
that each additional SG entry increases the cost. So to make things
efficient you always want to minimize entries as much as possible.

>> I don't think the PT design is broken in any way, it's straight 
>> forward and simple.
>
> Also, do clarify the other points I asked about. Esp. the non
> FREEZE_ON_PMI behaviour of the PT PMI is worrying me immensely.

The only reason for hardware freeze is when you have a few entries (like
with LBRs) so the interrupt entry code could overwhelm it.

But PT is not small, it's gigantic: even with the smallest buffer you
have many thousands of entries.

So you will get a few branches in the interrupt entry, but it's not a problem
because everything you really wanted to trace is still there.

Eventually the handler disables PT, so there's no risk of racing with
the update or anything like that.

Did I miss anything?

> To me it seems very weird that PT is hooked to the same PMI as the
> normal PMU, it really should have been a different interrupt.

It's in the same STATUS register, so it's cheap to check both.

It shouldn't add any new spurious problems (or at least nothing
worse than what we already have)

I understand that it would be nice to separate other NMI users
from all of PMI, but that would be an orthogonal problem.

Any other issues?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
