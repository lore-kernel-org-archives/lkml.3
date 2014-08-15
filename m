Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaHORVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:21:36 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaHORVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:21:35 -0400
Date: Fri, 15 Aug 2014 19:21:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Message-ID: <20140815172132.GH4120@two.firstfloor.org>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-5-git-send-email-andi@firstfloor.org>
 <CABPqkBTnZ8SF8TPPMxcY+jPvwQhv+3gki86dnNVgBbAJ_RPdkg@mail.gmail.com>
 <20140814143009.GO5803@tassilo.jf.intel.com>
 <CABPqkBQVwGH7GAVXAXjR1inWnWYeWuVG7Aj-aWAzAksdGq8oeg@mail.gmail.com>
 <20140815143121.GJ19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815143121.GJ19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So no need to 'fix' the tools, al we need to do is refuse to create
> INST_RETIRED:ALL events with sample_period < 128.

Like this?

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a0adf58..c592d4d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -443,6 +443,12 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
+	if (event->attr.sample_period && x86_pmu.limit_period) {
+		if (x86_pmu.limit_period(event, event->attr.sample_period) <
+				event->attr.sample_period)
+			return -EINVAL;
+	}
+
 	return x86_setup_perfctr(event);
 }

-Andi
