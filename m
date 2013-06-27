Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3F0DS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:18:59 -0400
Received: from ozlabs.org ([203.10.76.45]:34579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3F0DS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:18:57 -0400
Date: Thu, 27 Jun 2013 13:18:54 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, mlpesant@us.ibm.com
Subject: Re: [PATCH 15/15] perf, tools: Add perf stat --transaction v3
Message-ID: <20130627031854.GA9793@concordia>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
 <1366485563-16209-16-git-send-email-andi@firstfloor.org>
 <20130619085159.GA25177@concordia>
 <20130619144621.GW6123@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619144621.GW6123@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 04:46:21PM +0200, Andi Kleen wrote:
> > This hard coded list isn't going to work for us on powerpc.
> > 
> > We don't have HLE, so we won't ever have an event for el-start.
> > 
> > I don't quite grok what the cycles-ct is about, checkpointed cycles?
> 
> The counter is check pointed on a transaction start, and set back to
> the checkpoint when an abort happens. This allows to count the cycles
> wasted in aborts, when you subtract from cycles-t.

OK. I'm still confused by that one sorry. In the patch you do:

+       else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_IN_TX_CP)))
+               update_stats(&runtime_cycles_in_txcp_stats[0], count[0]);

But then I don't see where you use runtime_cycles_in_txcp_stats ?

> > But I don't think we have anything equivalent.
> 
> But you have cycles-t and tx-start?

We have:
 - cycles
 - cycles in transactional state
 - cycles spent in successful transactions

So your cycles-t is "cycles in transactional state".

We would calculate cycles wasted in aborts with:

 "cycles in transactional" - "cycles in successful transactions"

Which I think is what you're describing above with cycles-ct.


Does "tx-start" just count the number of transactions begun? Does it
count nested transactions?

We have one counter for non-nested transactions and one for nested, but
I think we could just count the non-nested as "tx-start", that's
probably of most interest.

> > I guess the simplest option is to make it a per-arch list inside the
> > perf tool?
> 
> I'm not sure that would be acceptable to the perf maintainers.
> Although I'm just guessing, I haven't heard any comments on
> this patch recently.

Yeah sure. Although I agree with the desire to make the perf tool work
similarly across architectures, I think as we add more of these detailed
analysis tools we are eventually going to come across something that
can't be handled generically. But I guess we'll see.

cheers
