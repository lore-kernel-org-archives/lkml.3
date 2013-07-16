Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3GPMt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab3GPMtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:49:25 -0400
Date: Tue, 16 Jul 2013 14:48:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V5 12/12] perf tools: add a sample parsing test
Message-ID: <20130716124846.GE9964@krava.brq.redhat.com>
References: <1373548341-24119-1-git-send-email-adrian.hunter@intel.com>
 <1373548341-24119-13-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373548341-24119-13-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 04:12:21PM +0300, Adrian Hunter wrote:
> Add a test that checks that sample parsing is correctly
> implemented.

nice!!! :)

> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

SNIP

> +static int do_test(u64 sample_type, u64 sample_regs_user)
> +{
> +	struct perf_evsel evsel = {
> +		.needs_swap = false,
> +		.attr = {
> +			.sample_type = sample_type,
> +			.sample_regs_user = sample_regs_user,
> +		},
> +	};
> +	union perf_event event = {
> +		.header = {
> +			.type = PERF_RECORD_SAMPLE,
> +			.size = sizeof(union perf_event),
> +		},
> +	};

maybe I'm missing something but how does event.sample.array get
allocated? It's used in perf_event__synthesize_sample func.

do we need to use something like in the patch below..

thanks,
jirka

---
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index c6e6813..dcbd40d 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -111,12 +111,8 @@ static int do_test(u64 sample_type, u64 sample_regs_user)
 			.sample_regs_user = sample_regs_user,
 		},
 	};
-	union perf_event event = {
-		.header = {
-			.type = PERF_RECORD_SAMPLE,
-			.size = sizeof(union perf_event),
-		},
-	};
+	u64 buf[100];
+	union perf_event *event = (union perf_event *) buf;
 	union {
 		struct ip_callchain callchain;
 		u64 data[64];
@@ -162,10 +158,15 @@ static int do_test(u64 sample_type, u64 sample_regs_user)
 	size_t i;
 	int err;
 
+	event->sample.header = (struct perf_event_header) {
+		.type = PERF_RECORD_SAMPLE,
+		.size = sizeof(union perf_event),
+	};
+
 	for (i = 0; i < sizeof(user_regs); i++)
 		*(u8 *)user_regs = i;
 
-	err = perf_event__synthesize_sample(&event, sample_type,
+	err = perf_event__synthesize_sample(event, sample_type,
 					    sample_regs_user, &sample, false);
 	if (err) {
 		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
@@ -175,7 +176,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user)
 
 	evsel.sample_size = __perf_evsel__sample_size(sample_type);
 
-	err = perf_evsel__parse_sample(&evsel, &event, &sample_out);
+	err = perf_evsel__parse_sample(&evsel, event, &sample_out);
 	if (err) {
 		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
 			 "perf_evsel__parse_sample", sample_type, err);
