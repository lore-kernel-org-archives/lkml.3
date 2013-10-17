Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3JQLWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:22:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49702 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3JQLWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:22:02 -0400
Date: Thu, 17 Oct 2013 13:21:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131017112156.GF3364@laptop.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
 <20131016124649.GG227855@redhat.com>
 <20131016133125.GY10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016133125.GY10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 03:31:25PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 16, 2013 at 08:46:49AM -0400, Don Zickus wrote:
> > On Wed, Oct 16, 2013 at 12:57:55PM +0200, Peter Zijlstra wrote:
> > > A prettier patch below. The main difference is on-demand allocation of
> > > the scratch buffer.
> > 
> > I'll see if I can sanity test this in the next couple hours.
> > 
> > Further testing yesterday showed that intel_pmu_drain_pebs_nhm still
> > has long latencies somewhere.  With 15 minute reboots, isolation goes
> > slooow.
> 
> Pick a smaller box? I seem to be able to reproduce on my wsm-ep, which
> boots inside a minute :-)
> 
> root@westmere:~# cd /debug/tracing/
> root@westmere:/debug/tracing# echo function > current_tracer
> root@westmere:/debug/tracing# cat available_filter_functions | grep ^inat > set_ftrace_notrace
> root@westmere:/debug/tracing# cat available_filter_functions | grep ^insn | grep -v get_length >> set_ftrace_notrace
> 
> Run: perf top --stdio -e 'cycles:pp' in another window and when the
> console output shows:
> 
> [  610.319486] perf samples too long (19310 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
> 
> quickly press enter here:

BTW; you can also replace this bit of manual intervention with something
like:

There's 3 changes:
 - changed atomic_t into regular int; there's nothing atomic about
   atomic_set vs atomic_read, so atomic_t is pointless
 - made perf_proc_update_handler() clear the running_sample_length
   state.
 - added if (avg_local_sample_len > 30000) tracing_off().

Of course you should tweak the 30000 to match whatever value you're
interested in. But tracing_off() does the same as that:

  echo 0 > tracing_on

And avoids being too late and having lost the trace buffer content.

---
 kernel/events/core.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c716385f6483..ea787d0d0e78 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -175,8 +175,10 @@ int sysctl_perf_event_sample_rate __read_mostly	= DEFAULT_MAX_SAMPLE_RATE;
 static int max_samples_per_tick __read_mostly	= DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
 static int perf_sample_period_ns __read_mostly	= DEFAULT_SAMPLE_PERIOD_NS;
 
-static atomic_t perf_sample_allowed_ns __read_mostly =
-	ATOMIC_INIT( DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100);
+static int perf_sample_allowed_ns __read_mostly =
+	DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100;
+
+static DEFINE_PER_CPU(u64, running_sample_length);
 
 void update_perf_cpu_limits(void)
 {
@@ -184,7 +186,7 @@ void update_perf_cpu_limits(void)
 
 	tmp *= sysctl_perf_cpu_time_max_percent;
 	do_div(tmp, 100);
-	atomic_set(&perf_sample_allowed_ns, tmp);
+	ACCESS_ONCE(perf_sample_allowed_ns) = tmp;
 }
 
 static int perf_rotate_context(struct perf_cpu_context *cpuctx);
@@ -194,6 +196,7 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 		loff_t *ppos)
 {
 	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	int cpu;
 
 	if (ret || !write)
 		return ret;
@@ -202,6 +205,9 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
 	update_perf_cpu_limits();
 
+	for_each_possible_cpu(cpu)
+		per_cpu(running_sample_length, cpu) = 0;
+
 	return 0;
 }
 
@@ -228,14 +234,13 @@ int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
  * we detect that events are taking too long.
  */
 #define NR_ACCUMULATED_SAMPLES 128
-DEFINE_PER_CPU(u64, running_sample_length);
 
 void perf_sample_event_took(u64 sample_len_ns)
 {
 	u64 avg_local_sample_len;
 	u64 local_samples_len;
 
-	if (atomic_read(&perf_sample_allowed_ns) == 0)
+	if (ACCESS_ONCE(perf_sample_allowed_ns) == 0)
 		return;
 
 	/* decay the counter by 1 average sample */
@@ -251,12 +256,15 @@ void perf_sample_event_took(u64 sample_len_ns)
 	 */
 	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
 
-	if (avg_local_sample_len <= atomic_read(&perf_sample_allowed_ns))
+	if (avg_local_sample_len <= ACCESS_ONCE(perf_sample_allowed_ns))
 		return;
 
 	if (max_samples_per_tick <= 1)
 		return;
 
+	if (avg_local_sample_len > 30000)
+		tracing_off();
+
 	max_samples_per_tick = DIV_ROUND_UP(max_samples_per_tick, 2);
 	sysctl_perf_event_sample_rate = max_samples_per_tick * HZ;
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
@@ -265,7 +273,7 @@ void perf_sample_event_took(u64 sample_len_ns)
 			"perf samples too long (%lld > %d), lowering "
 			"kernel.perf_event_max_sample_rate to %d\n",
 			avg_local_sample_len,
-			atomic_read(&perf_sample_allowed_ns),
+			ACCESS_ONCE(perf_sample_allowed_ns),
 			sysctl_perf_event_sample_rate);
 
 	update_perf_cpu_limits();
