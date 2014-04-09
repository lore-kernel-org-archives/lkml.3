Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbaDIM6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:58:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781AbaDIM6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:58:21 -0400
Date: Wed, 9 Apr 2014 14:58:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf list: Fix --raw-dump argument
Message-ID: <20140409125817.GB2556@krava.brq.redhat.com>
References: <1395955661-10056-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395955661-10056-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 05:27:41PM -0400, Ramkumar Ramachandra wrote:
> While adding usage information, 44d742e (perf list: Add usage,
> 2013-10-30) broke
> 
>   $ perf list --raw-dump
> 
> Fix this by making raw-dump a proper argument.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  I sent this patch earlier, but it didn't get picked up due to some
>  confusion.
> 
>  tools/perf/builtin-list.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..2629c24 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -19,7 +19,9 @@
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
> +	bool raw_dump = false;
>  	const struct option list_options[] = {
> +		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> @@ -32,6 +34,10 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	setup_pager();
>  
> +	if (raw_dump) {
> +		print_events(NULL, true);
> +		return 0;
> +	}
>  	if (argc == 0) {
>  		print_events(NULL, false);
>  		return 0;
> @@ -53,8 +59,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  			print_hwcache_events(NULL, false);
>  		else if (strcmp(argv[i], "pmu") == 0)
>  			print_pmu_events(NULL, false);
> -		else if (strcmp(argv[i], "--raw-dump") == 0)
> -			print_events(NULL, true);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
>  			int sep_idx;
> -- 
> 1.9.0.431.g014438b
> 

hi,
I understand you're just fixing a bug, but if it's an --raw-dump
option (not command) shoudn't we use it for all commands? like:

  $ perf list --raw-dump      # all events via raw dump
  $ perf list --raw-dump pmu  # pmu event via raw dump
  ...

Please check attached change to your patch below (not completely working/tested).

Also.. the option is not mentioned in the man page (please do ;-)),
but looks like the usage is for bash completion only, so we probably
need only the first example functionality above.

If this is the case I think it should not be an option but another
command like 'raw-dump'.

thanks,
jirka


---
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 2629c24..a3b2da8 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -34,12 +34,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_pager();
 
-	if (raw_dump) {
-		print_events(NULL, true);
-		return 0;
-	}
 	if (argc == 0) {
-		print_events(NULL, false);
+		print_events(NULL, raw_dump);
 		return 0;
 	}
 
@@ -47,7 +43,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		if (i)
 			putchar('\n');
 		if (strncmp(argv[i], "tracepoint", 10) == 0)
-			print_tracepoint_events(NULL, NULL, false);
+			print_tracepoint_events(NULL, NULL, raw_dump);
 		else if (strcmp(argv[i], "hw") == 0 ||
 			 strcmp(argv[i], "hardware") == 0)
 			print_events_type(PERF_TYPE_HARDWARE);
@@ -56,15 +52,15 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_events_type(PERF_TYPE_SOFTWARE);
 		else if (strcmp(argv[i], "cache") == 0 ||
 			 strcmp(argv[i], "hwcache") == 0)
-			print_hwcache_events(NULL, false);
+			print_hwcache_events(NULL, raw_dump);
 		else if (strcmp(argv[i], "pmu") == 0)
-			print_pmu_events(NULL, false);
+			print_pmu_events(NULL, raw_dump);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
 
 			if (sep == NULL) {
-				print_events(argv[i], false);
+				print_events(argv[i], raw_dump);
 				continue;
 			}
 			sep_idx = sep - argv[i];
@@ -73,7 +69,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 				return -1;
 
 			s[sep_idx] = '\0';
-			print_tracepoint_events(s, s + sep_idx + 1, false);
+			print_tracepoint_events(s, s + sep_idx + 1, raw_dump);
 			free(s);
 		}
 	}
