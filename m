Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3LXNfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:35:33 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:65429 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LXNfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:35:30 -0500
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Dec 2013 08:35:29 EST
Date: Tue, 24 Dec 2013 10:30:03 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20131224133003.GA23382@ghostprotocols.net>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
 <20131220075759.GA12937@gmail.com>
 <20131223193757.GA1396@ghostprotocols.net>
 <52B8D582.9090009@gmail.com>
 <20131224125342.GC17780@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131224125342.GC17780@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 24, 2013 at 09:53:42AM -0300, Arnaldo Carvalho de Melo escreveu:
> The thing to check is perf_evlist__{prepare,start}_workload notification
> errors using SIGUSR1, that we need to check for in the caller, and emit
> the message, no?

Something like this:

1. We tell perf_evlist__prepare_workload that we want a signal if execvp
fails, it will be a SIGUSR1

2. We catch that signal in 'stat' and check that we got a signal, only
problem so far with this signal maze is that we're getting a SIGCHLD
while I was expecting a SIGUSR1... I.e. the "if (signr != -1) test
really should be if (signr == SIGUSR1), but I'm getting a SIGCHLD there
and the elves are tugging me away...

- Arnaldo

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dab98b50c9fe..d2350fef8cde 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -144,6 +144,7 @@ static struct timespec		ref_time;
 static struct cpu_map		*aggr_map;
 static int			(*aggr_get_id)(struct cpu_map *m, int cpu);
 
+static volatile int signr = -1;
 static volatile int done = 0;
 
 struct perf_stat {
@@ -531,7 +532,7 @@ static int __run_perf_stat(int argc, const char **argv)
 
 	if (forks) {
 		if (perf_evlist__prepare_workload(evsel_list, &target, argv,
-						  false, false) < 0) {
+						  false, true) < 0) {
 			perror("failed to prepare workload");
 			return -1;
 		}
@@ -598,6 +599,8 @@ static int __run_perf_stat(int argc, const char **argv)
 		wait(&status);
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
+		else if (signr != -1)
+			return -1;
 	} else {
 		handle_initial_delay();
 		while (!done) {
@@ -1335,8 +1338,6 @@ static void print_stat(int argc, const char **argv)
 	}
 }
 
-static volatile int signr = -1;
-
 static void skip_signal(int signo)
 {
 	if ((child_pid == -1) || interval)
@@ -1785,6 +1786,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	signal(SIGCHLD, skip_signal);
 	signal(SIGALRM, skip_signal);
 	signal(SIGABRT, skip_signal);
+	signal(SIGUSR1, skip_signal);
 
 	status = 0;
 	for (run_idx = 0; forever || run_idx < run_count; run_idx++) {
