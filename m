Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbaFIE5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 00:57:55 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55057 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaFIE5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 00:57:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/9] perf, tools: Add support for text descriptions of events and alias add
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
	<1401486615-21374-3-git-send-email-andi@firstfloor.org>
Date: Mon, 09 Jun 2014 13:57:47 +0900
In-Reply-To: <1401486615-21374-3-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 30 May 2014 14:50:08 -0700")
Message-ID: <87ha3ud6ic.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 30 May 2014 14:50:08 -0700, Andi Kleen wrote:
> @@ -756,22 +816,31 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  			      (!is_cpu && strglobmatch(alias->name,
>  						       event_glob))))
>  				continue;
> -			aliases[j] = name;
> -			if (is_cpu && !name_only)
> -				aliases[j] = format_alias_or(buf, sizeof(buf),
> -							      pmu, alias);
> -			aliases[j] = strdup(aliases[j]);
> +			aliases[j].name = name;
> +			if (is_cpu && !name_only && !alias->desc)
> +				aliases[j].name = format_alias_or(buf,
> +								  sizeof(buf),
> +								  pmu, alias);
> +			aliases[j].name = strdup(aliases[j].name);
> +			aliases[j].desc = alias->desc;
>  			j++;
>  		}
>  	len = j;
> -	qsort(aliases, len, sizeof(char *), cmp_string);
> +	qsort(aliases, len, sizeof(struct pair), cmp_pair);
>  	for (j = 0; j < len; j++) {
>  		if (name_only) {
> -			printf("%s ", aliases[j]);
> +			printf("%s ", aliases[j].name);
>  			continue;
>  		}
> -		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
> -		zfree(&aliases[j]);
> +		if (aliases[j].desc) {
> +			if (numdesc++ == 0 && printed)
> +				printf("\n");
> +			printf("  %-50s [", aliases[j].name);
> +			wordwrap(aliases[j].desc, 53, columns, 1);
> +			printf("]\n");
> +		} else
> +			printf("  %-50s [Kernel PMU event]\n", aliases[j].name);
> +		zfree(&aliases[j].name);

Hmm.. this will print the description at right side and I think it'd be
better if it prints in another line(s) like below:


  agu_bypass_cancel.count                            [Kernel PMU event]
        This event counts executed load operations with all the following
         traits: 1. addressing of the format [base + offset], 2. the offset
         is between 1 and 2047, 3. the address specified in the base register
         is in one page and the address [base+offset] is in an
  arith.fpu_div                                      [Kernel PMU event]
        Divide operations executed
  arith.fpu_div_active                               [Kernel PMU event]
        Cycles when divider is busy executing divide operations
  ...


I just tweaked it using -v option for perf list.  Below is the change I
made on top of your series.  What do you think?

Thanks,
Namhyung


diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 086c96fa959b..e65a3b428a44 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -13,6 +13,7 @@
 
 #include "util/parse-events.h"
 #include "util/cache.h"
+#include "util/debug.h"
 #include "util/pmu.h"
 #include "util/parse-options.h"
 
@@ -22,6 +23,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 	const struct option list_options[] = {
 		OPT_STRING(0, "events-file", &json_file, "json file",
 			   "Read event json file"),
+		OPT_INCR('v', "verbose", &verbose,
+			 "be more verbose (show event description if exist)"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index b87f52058bb4..99a2156e6c54 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -838,14 +838,16 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			printf("%s ", aliases[j].name);
 			continue;
 		}
-		if (aliases[j].desc) {
-			if (numdesc++ == 0 && printed)
-				printf("\n");
-			printf("  %-50s [", aliases[j].name);
-			wordwrap(aliases[j].desc, 53, columns, 1);
-			printf("]\n");
-		} else
-			printf("  %-50s [Kernel PMU event]\n", aliases[j].name);
+
+		if (aliases[j].desc && numdesc++ == 0 && printed)
+			printf("\n");
+		printf("  %-50s [Kernel PMU event]\n", aliases[j].name);
+
+		if (aliases[j].desc && verbose) {
+			printf("%8s", "");
+			wordwrap(aliases[j].desc, 8, columns, 1);
+			printf("\n");
+		}
 		zfree(&aliases[j].name);
 		printed++;
 	}


