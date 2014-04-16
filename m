Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174AbaDPNet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161002AbaDPNer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:34:47 -0400
Date: Wed, 16 Apr 2014 15:34:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf record: Propagate exit status of a command line
 workload
Message-ID: <20140416133432.GA7040@krava.brq.redhat.com>
References: <CABPqkBQeAqRUW8LLMsHhHBR8gJcE4VPZa++ji8i=RKUCd2jSvQ@mail.gmail.com>
 <1397608244-15496-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397608244-15496-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:30:43AM +0900, Namhyung Kim wrote:

SNIP

>  
> @@ -356,6 +331,7 @@ static void workload_exec_failed_signal(int signo, siginfo_t *info,
>  static int __cmd_record(struct record *rec, int argc, const char **argv)
>  {
>  	int err;
> +	int status = 0;
>  	unsigned long waking = 0;
>  	const bool forks = argc > 0;
>  	struct machine *machine;
> @@ -367,7 +343,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
>  
>  	rec->progname = argv[0];
>  
> -	on_exit(record__sig_exit, rec);

so record__sig_exit took care of waiting the child even
in case the record fails before running the workload

after your change all error cases just delete session
and go away, ending up with parent dead and go_pipe
released executing the workload

with attached patch, current perf code:

[jolsa@krava perf]$ ./perf.old record -e cycles -m 10G true
rounding mmap pages size to 17179869184 bytes (4194304 pages)
Permission error mapping pages.
Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
or try again with a smaller value of -m/--mmap_pages.
(current value: 4194304)
true: Terminated

with attached patch, your change:

[jolsa@krava perf]$ ./perf record -e cycles -m 10G true
rounding mmap pages size to 17179869184 bytes (4194304 pages)
Permission error mapping pages.
Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
or try again with a smaller value of -m/--mmap_pages.
(current value: 4194304)
unable to read pipe: No such file or directory


I think that after creating the workload, all error paths
need to release(wait) the child if there's any

thanks,
jirka

---
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 59ef280..185f30a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1072,7 +1072,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 		/*
 		 * Wait until the parent tells us to go.
 		 */
-		if (read(go_pipe[0], &bf, 1) == -1)
+		if (read(go_pipe[0], &bf, 1) != 1)
 			perror("unable to read pipe");
 
 		execvp(argv[0], (char **)argv);
