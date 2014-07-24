Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640AbaGXVe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 17:34:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:57526 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaGXVe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 17:34:57 -0400
Date: Thu, 24 Jul 2014 18:34:51 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 17/19] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
Message-ID: <20140724213451.GH7831@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <1405893363-21967-18-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405893363-21967-18-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jul 20, 2014 at 11:56:01PM +0200, Jiri Olsa escreveu:
> The PERF_RECORD_FINISHED_ROUND governs queue flushing in
> reporting, so it needs to be stored for any kind of event.
> 
> Forcing the PERF_RECORD_FINISHED_ROUND event to be stored any
> time we finish the round and wrote at least one event.

This is not just one change, it does two things and it is not clearly
detailed here.

The existing code would write a PERF_RECORD_FINISHED_ROUND per call to
record__mmap_read() for tracepoints were present.

I.e. if tracepoints and any other type of event type was present, then
this syntetic PERF_RECORD_FINISHED_ROUND thing is inserted which will be
handled at report time.

Now you changed it to not check if tracepoints are present, i.e. it will
always insert that after processing N events in
PERF_RECORD_FINISHED_ROUND. (change #1)

The thing is, before it didn't checked if N was zero, needlessly
inserting PERF_RECORD_FINISHED_ROUND events in some corner cases.

Now you, in addition to change #1 you also check that the number of
bytes written before that event processing loop in record__mmap_read()
is the same after the loop, i.e. if some events were written to the
output perf.data file, only inserting the PERF_RECORD_FINISHED_ROUND
events if so. (change #2)

I think both changes are OK, but should be split in different patches,
and while testing comparing having the patch applied versus patch
applied + ignore the PERF_RECORD_FINISHED_ROUND events in the resulting
perf.data file, I get:

[root@zoo /]# perf stat -r 5 perf report --no-ordered-samples > /dev/null
<SNIP symbol stuff>
 Performance counter stats for 'perf report --no-ordered-samples' (5 runs):

      30263.033852      task-clock (msec)         #    1.000 CPUs utilized            ( +-  0.48% )
               346      context-switches          #    0.011 K/sec                    ( +- 54.65% )
               182      cpu-migrations            #    0.006 K/sec                    ( +- 29.94% )
            89,951      page-faults               #    0.003 M/sec                    ( +-  0.05% )
    92,342,939,311      cycles                    #    3.051 GHz                      ( +-  0.46% )
    50,605,250,178      stalled-cycles-frontend   #   54.80% frontend cycles idle     ( +-  0.88% )
   <not supported>      stalled-cycles-backend   
   101,171,572,553      instructions              #    1.10  insns per cycle        
                                                  #    0.50  stalled cycles per insn  ( +-  0.01% )
    22,643,469,804      branches                  #  748.222 M/sec                    ( +-  0.01% )
       284,395,273      branch-misses             #    1.26% of all branches          ( +-  0.45% )

      30.249514999 seconds time elapsed                                          ( +-  0.48% )

[root@zoo /]# perf stat -r 5 perf report --ordered-samples > /dev/null
<SNIP symbol stuff>
 Performance counter stats for 'perf report --ordered-samples' (5 runs):

      32665.828429      task-clock (msec)         #    1.001 CPUs utilized            ( +-  0.41% )
               304      context-switches          #    0.009 K/sec                    ( +- 23.32% )
               102      cpu-migrations            #    0.003 K/sec                    ( +- 21.70% )
            79,405      page-faults               #    0.002 M/sec                    ( +-  0.02% )
   101,761,091,322      cycles                    #    3.115 GHz                      ( +-  0.40% )
    57,627,138,326      stalled-cycles-frontend   #   56.63% frontend cycles idle     ( +-  0.65% )
   <not supported>      stalled-cycles-backend   
   105,982,144,263      instructions              #    1.04  insns per cycle        
                                                  #    0.54  stalled cycles per insn  ( +-  0.01% )
    23,493,670,235      branches                  #  719.212 M/sec                    ( +-  0.01% )
       319,060,575      branch-misses             #    1.36% of all branches          ( +-  0.19% )

      32.636483981 seconds time elapsed                                          ( +-  0.41% )

[root@zoo /]#

The patch used to enable/disable processing of PERF_RECORD_FINISHED_ROUND is this one:

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 21d830bafff3..8b5410313005 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -675,6 +675,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
+	OPT_BOOLEAN(0, "ordered-samples", &report.tool.ordered_samples,
+		    "Make sure samples are ordered by time"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",

---

The workload:

[root@zoo /]# perf report --header-only
# ========
# captured on: Thu Jul 24 17:10:16 2014
# hostname : zoo.ghostprotocols.net
# os release : 3.15.4-200.fc20.x86_64
# perf version : 3.16.rc2.g2b5b8b
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM) i7-3667U CPU @ 2.00GHz
# cpuid : GenuineIntel,6,58,9
# total memory : 8081004 kB
# cmdline : /home/acme/bin/perf record -F 7000 -a -e cache-misses,instructions,cycles sleep 5m 
# event : name = cache-misses, type = 0, config = 0x3, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, attr_mmap2 = 0, attr_mmap  = 1, attr_mmap_data = 0
# event : name = instructions, type = 0, config = 0x1, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, attr_mmap2 = 0, attr_mmap  = 0, attr_mmap_data = 0
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, attr_mmap2 = 0, attr_mmap  = 0, attr_mmap_data = 0, id =
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, power = 9, uncore_imc = 8, tracepoint = 2, uncore_cbox_0 = 6, uncore_cbox_1 = 7, breakpoint = 5
# ========
#

[root@zoo /]# perf evlist -v
cache-misses: sample_freq=7000, config: 3, size: 96, sample_type: IP|TID|TIME|ID|CPU|PERIOD, read_format: ID, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, sample_id_all: 1, exclude_guest: 1
instructions: sample_freq=7000, config: 1, size: 96, sample_type: IP|TID|TIME|ID|CPU|PERIOD, read_format: ID, disabled: 1, inherit: 1, freq: 1, sample_id_all: 1, exclude_guest: 1
cycles: sample_freq=7000, size: 96, sample_type: IP|TID|TIME|ID|CPU|PERIOD, read_format: ID, disabled: 1, inherit: 1, freq: 1, sample_id_all: 1, exclude_guest: 1
[root@zoo /]#

- Arnaldo

> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/builtin-record.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 378b85b731a7..4869050e7194 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -238,6 +238,7 @@ static struct perf_event_header finished_round_event = {
>  
>  static int record__mmap_read_all(struct record *rec)
>  {
> +	u64 bytes_written = rec->bytes_written;
>  	int i;
>  	int rc = 0;
>  
> @@ -250,7 +251,11 @@ static int record__mmap_read_all(struct record *rec)
>  		}
>  	}
>  
> -	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
> +	/*
> +	 * Mark the round finished in case we wrote
> +	 * at least one event.
> +	 */
> +	if (bytes_written != rec->bytes_written)
>  		rc = record__write(rec, &finished_round_event, sizeof(finished_round_event));
>  
>  out:
> -- 
> 1.8.3.1
