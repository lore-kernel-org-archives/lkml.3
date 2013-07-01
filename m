Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3GAFqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:46:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49916 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3GAFqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:46:21 -0400
X-AuditID: 9c93016f-b7b0aae0000032af-14-51d117abaadc
Date: Mon, 1 Jul 2013 14:46:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/3] perf record: support duration option to run during
 specified time
Message-ID: <20130701054619.GA730@lge.com>
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130629002724.GB5117@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629002724.GB5117@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 05:27:24PM -0700, Sukadev Bhattiprolu wrote:
> Joonsoo Kim [iamjoonsoo.kim@lge.com] wrote:
> | Currently, there is no method to quit at specified time later.
> | We are used to using 'sleep N' as command argument if we need it,
> | but explicitly supporting this feature maybe makes sense.
> | 
> | Cc: Namhyung Kim <namhyung@kernel.org>
> | Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> | 
> | diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> | index cdf58ec..19c65b5 100644
> | --- a/tools/perf/builtin-record.c
> | +++ b/tools/perf/builtin-record.c
> | @@ -29,6 +29,7 @@
> |  #include <sched.h>
> |  #include <sys/mman.h>
> | 
> | +static unsigned int duration;
> |  #ifndef HAVE_ON_EXIT
> |  #ifndef ATEXIT_MAX
> |  #define ATEXIT_MAX 32
> | @@ -194,7 +195,7 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
> |  			psignal(WTERMSIG(status), rec->progname);
> |  	}
> | 
> | -	if (signr == -1 || signr == SIGUSR1)
> | +	if (signr == -1 || signr == SIGUSR1 || signr == SIGALRM)
> |  		return;
> | 
> |  	signal(signr, SIG_DFL);
> | @@ -404,6 +405,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
> |  	signal(SIGCHLD, sig_handler);
> |  	signal(SIGINT, sig_handler);
> |  	signal(SIGUSR1, sig_handler);
> | +	signal(SIGALRM, sig_handler);
> | 
> |  	if (!output_name) {
> |  		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
> | @@ -471,6 +473,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
> |  			goto out_delete_session;
> |  	}
> | 
> | +	alarm(duration);
> |  	if (forks) {
> |  		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
> |  						    argv, opts->pipe_output,
> | @@ -955,6 +958,7 @@ const struct option record_options[] = {
> |  		     parse_branch_stack),
> |  	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
> |  		    "sample by weight (on special events only)"),
> | +	OPT_UINTEGER(0, "duration", &duration, "run during specified seconds"),
> 
> nit: A slight ambiguity in the help text. Would you mind changing it to:
> 
> 	"run for specified duration (seconds)" ?
> 
> Sukadev

Hello, Sukadev.
Okay.

Here goes v2 with your suggestion.
---------------->8------------------------------
>From b65e29b33cb250d4a4be103ce5afae29f6bdc11a Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Thu, 13 Jun 2013 18:06:21 +0900
Subject: [PATCH v2] perf, tools: support duration option to run during specified
 time

Currently, there is no method to quit at specified time later.
We are used to using 'sleep N' as command argument if we need it,
but explicitly supporting this feature maybe makes sense.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..1384118 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -29,6 +29,7 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+static unsigned int duration;
 #ifndef HAVE_ON_EXIT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
@@ -194,7 +195,7 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 			psignal(WTERMSIG(status), rec->progname);
 	}
 
-	if (signr == -1 || signr == SIGUSR1)
+	if (signr == -1 || signr == SIGUSR1 || signr == SIGALRM)
 		return;
 
 	signal(signr, SIG_DFL);
@@ -404,6 +405,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
+	signal(SIGALRM, sig_handler);
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
@@ -471,6 +473,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			goto out_delete_session;
 	}
 
+	alarm(duration);
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
 						    argv, opts->pipe_output,
@@ -955,6 +958,8 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_UINTEGER(0, "duration", &duration,
+		    "run for specified duration (seconds)"),
 	OPT_END()
 };
 
-- 
1.7.9.5

