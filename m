Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbbAPMnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:43:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:10437 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbbAPMnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:43:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,410,1418112000"; 
   d="scan'208";a="662925517"
Message-ID: <54B90713.1090503@intel.com>
Date: Fri, 16 Jan 2015 14:41:55 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for timestamps
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com> <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 18:51, Pawel Moll wrote:
> Until now, perf framework never defined the meaning of the timestamps
> captured as PERF_SAMPLE_TIME sample type. The values were obtaining
> from local (sched) clock, which is unavailable in userspace. This made
> it impossible to correlate perf data with any other events. Other
> tracing solutions have the source configurable (ftrace) or just share
> a common time domain between kernel and userspace (LTTng).
> 
> Follow the trend by using monotonic clock, which is readily available
> as POSIX CLOCK_MONOTONIC.
> 
> Also add a sysctl "perf_sample_time_clk_id" attribute which can be used
> by the user to obtain the clk_id to be used with POSIX clock API (eg.
> clock_gettime()) to obtain a time value comparable with perf samples.
> 
> Old behaviour can be restored by using "perf_use_local_clock" kernel
> parameter.
> 

Don't forget this breaks the relationship to TSC. So you will need something
like below. Also patch 3 needs to be done first and extended to cover TSC so
there is no gap when we cannot get TSC.

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 143e5f5..b6e833d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1922,21 +1922,6 @@ void arch_perf_update_userpage(struct
perf_event_mmap_page *userpg, u64 now)
        userpg->cap_user_time_zero = 0;
        userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
        userpg->pmc_width = x86_pmu.cntval_bits;
-
-       if (!sched_clock_stable())
-               return;
-
-       data = cyc2ns_read_begin();
-
-       userpg->cap_user_time = 1;
-       userpg->time_mult = data->cyc2ns_mul;
-       userpg->time_shift = data->cyc2ns_shift;
-       userpg->time_offset = data->cyc2ns_offset - now;
-
-       userpg->cap_user_time_zero = 1;
-       userpg->time_zero = data->cyc2ns_offset;
-
-       cyc2ns_read_end(data);
 }

 /*


