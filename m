Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3GHUFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:05:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:10132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3GHUFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1021,1363158000"; 
   d="scan'208";a="342320134"
Message-ID: <51DB1B75.8060303@intel.com>
Date: Mon, 08 Jul 2013 13:05:09 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, dave.hansen@linux.intel.com,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
References: <20130704223010.GA30625@quad> <51DACE08.5030109@intel.com> <CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com>
In-Reply-To: <CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 11:08 AM, Stephane Eranian wrote:
> I admit I have some issues with your patch and what it is trying to avoid.
> There is already interrupt throttling. Your code seems to address latency
> issues on the handler rather than rate issues. Yet to mitigate the latency
> it is modify the throttling.

If we have too many interrupts, we need to drop the rate (existing
throttling).

If the interrupts _consistently_ take too long individually they can
starve out all the other CPU users.  I saw no way to make them finish
faster, so the only recourse is to also drop the rate.

> For some unknown reasons, my HSW interrupt handler goes crazy for
> a while running a very simple:
>    $ perf record -e cycles branchy_loop
> 
> And I do see in the log:
> perf samples too long (2546 > 2500), lowering
> kernel.perf_event_max_sample_rate to 50000
> 
> Which is an enormous latency. I instrumented the code, and under
> normal conditions the latency
> of the handler for this perf run, is about 500ns and it is consistent
> with what I see on SNB.

I was seeing latencies near 1 second from time to time, but
_consistently_ in the hundreds of milliseconds.
