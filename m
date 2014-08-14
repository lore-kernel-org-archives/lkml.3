Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaHNRr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:47:58 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45216 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaHNRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140814143009.GO5803@tassilo.jf.intel.com>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
	<1407979069-7121-5-git-send-email-andi@firstfloor.org>
	<CABPqkBTnZ8SF8TPPMxcY+jPvwQhv+3gki86dnNVgBbAJ_RPdkg@mail.gmail.com>
	<20140814143009.GO5803@tassilo.jf.intel.com>
Date: Thu, 14 Aug 2014 19:47:56 +0200
Message-ID: <CABPqkBQVwGH7GAVXAXjR1inWnWYeWuVG7Aj-aWAzAksdGq8oeg@mail.gmail.com>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+perf tool maintainers]

On Thu, Aug 14, 2014 at 4:30 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> I understand all your points, but there's no alternative.
> The only other way would be to disable INST_RETIRED.ALL.
>
You cannot do that either. INST_RETIRED:ALL is important.
I assume the bug applies whether or not the event is used
with a filter.

I think we need to ensure that by looking at the perf.data file,
one can reconstruct the total number of inst_Retired:all
occurrences for the run. With a fixed period, one would do
num_samples * fixed_period. I know the Gooda tool does
that. It is used to estimate the number of events captured
vs. the number of events occurring.

So what I am saying is that on BDW, we need to have
perf force PERF_SAMPLE_PERIOD even with a fixed
period is passed. The kernel cannot simply add
PERF_SAMPLE_PERIOD to the event sample_format
because the tool would get confused by the sample
record size otherwise.

I understand this is not pretty. We'd need to have
a on the evsel just before making the syscall. That
callback would be for x86 and it would check the
CPUID to force PERF_SAMPLE_PERIOD. That's
my thinking but there may be a better way of doing
this.
