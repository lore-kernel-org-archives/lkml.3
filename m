Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaAPBSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:18:01 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45971 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaAPBR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:17:57 -0500
X-AuditID: 9c930197-b7b7cae000000e34-43-52d733414a23
From: Namhyung Kim <namhyung@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf tools: Spare double comparison of callchain first entry
References: <1389713836-13375-1-git-send-email-fweisbec@gmail.com>
	<1389713836-13375-3-git-send-email-fweisbec@gmail.com>
	<87y52h930t.fsf@sejong.aot.lge.com>
	<20140115165927.GA21574@localhost.localdomain>
Date: Thu, 16 Jan 2014 10:17:53 +0900
In-Reply-To: <20140115165927.GA21574@localhost.localdomain> (Frederic
	Weisbecker's message of "Wed, 15 Jan 2014 17:59:30 +0100")
Message-ID: <87d2js9132.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Wed, 15 Jan 2014 17:59:30 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 15, 2014 at 03:23:46PM +0900, Namhyung Kim wrote:
>> On Tue, 14 Jan 2014 16:37:15 +0100, Frederic Weisbecker wrote:
>> > When a new callchain child branch matches an existing one in the rbtree,
>> > the comparison of its first entry is performed twice:
>> >
>> > 1) From append_chain_children() on branch lookup
>> >
>> > 2) If 1) reports a match, append_chain() then compares all entries of
>> > the new branch against the matching node in the rbtree, and this
>> > comparison includes the first entry of the new branch again.
>> 
>> Right.
>> 
>> >
>> > Lets shortcut this by performing the whole comparison only from
>> > append_chain() which then returns the result of the comparison between
>> > the first entry of the new branch and the iterating node in the rbtree.
>> > If the first entry matches, the lookup on the current level of siblings
>> > stops and propagates to the children of the matching nodes.
>> 
>> Hmm..  it looks like that I thought directly calling append_chain() has
>> some overhead - but it's not.
>
> No that's a right concern. I worried as well because I wasn't sure if there
> is more match than unmatch on the first entry. I'd tend to think that the first
> entry endures unmatches most often, in which case calling match_chain() first
> may be more efficient as a fast path (ie: calling append_chain() involves
> one more function call and a few other details).
>
> But eventually measurement hasn't shown significant difference before and
> after the patch.

I think if the sort key doesn't contain "symbol", unmatch case would be
increased as more various callchains would go into a same entry.

>
>> 
>> >
>> > This results in less comparisons performed by the CPU.
>> 
>> Do you have any numbers?  I suspect it'd not be a big change, but just
>> curious.
>
> So I compared before/after the patchset (which include the cursor restore removal)
> with:
>
> 	1) Some big hackbench-like load that generates > 200 MB perf.data
>
> 	perf record -g -- perf bench sched messaging -l $SOME_BIG_NUMBER
>
> 	2) Compare before/after with the following reports:
>
> 	perf stat perf report --stdio > /dev/null
> 	perf stat perf report --stdio -s sym > /dev/null
> 	perf stat perf report --stdio -G > /dev/null
> 	perf stat perf report --stdio -g fractal,0.5,caller,address > /dev/null 
>
> And most of the time I had < 0.01% difference on time completion in favour of the patchset
> (which may be due to the removed cursor restore patch eventually).
>
> So, all in one, there was no real interesting difference. If you want the true results I can definetly relaunch the tests.

So as an extreme case, could you please also test "-s cpu" case and
share the numbers?

Thanks,
Namhyung
