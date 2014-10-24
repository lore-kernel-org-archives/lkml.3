Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbaJXOpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:45:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:39238 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbaJXOpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:45:09 -0400
Date: Fri, 24 Oct 2014 11:45:00 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/16] perf pmu: Let pmu's with no events show up on perf
 list
Message-ID: <20141024144500.GE14687@kernel.org>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
 <1414061124-26830-3-git-send-email-adrian.hunter@intel.com>
 <87y4s6cak7.fsf@sejong.aot.lge.com>
 <20141024125702.GZ14687@kernel.org>
 <20141024130320.GA14687@kernel.org>
 <20141024132141.GB14687@kernel.org>
 <544A63FE.60902@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544A63FE.60902@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 24, 2014 at 05:36:46PM +0300, Adrian Hunter escreveu:
> On 24/10/2014 4:21 p.m., Arnaldo Carvalho de Melo wrote:
> >Em Fri, Oct 24, 2014 at 10:03:20AM -0300, Arnaldo Carvalho de Melo escreveu:
> >>Em Fri, Oct 24, 2014 at 09:57:02AM -0300, Arnaldo Carvalho de Melo escreveu:
> >>>Em Fri, Oct 24, 2014 at 02:15:52PM +0900, Namhyung Kim escreveu:
> >>>>On Thu, 23 Oct 2014 13:45:10 +0300, Adrian Hunter wrote:
> >>>>>+		if (pmu->selectable) {
> >>>>>+			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
> >>>>>+			aliases[j] = strdup(buf);
> >>>>
> >>>>You need to check the return value here (and above too).
> >>>
> >>>Well spotted, fixing this up.
> >>
> >>Oh well, this print_pmu_events() function needs some care, it starts by
> >>trying to alloc the array, if it fails, it silently returns, does that
> >>mean that there are no pmu events? Or that memory allocation failed?
> >>
> >>Ok, will do the fixes in a separate patch...
> >>
> >>- Arnaldo
> >
> >The patch below should check everything and warn the user, even
> >maintaining that void return...
> >
> >Acked-by tags welcome as always :-)
> >
> >- Arnaldo
> >
> >
> >diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> >index 91dca60..881b754 100644
> >--- a/tools/perf/util/pmu.c
> >+++ b/tools/perf/util/pmu.c
> >@@ -753,9 +753,9 @@ void print_pmu_events(const char *event_glob, bool name_only)
> >  		if (pmu->selectable)
> >  			len++;
> >  	}
> >-	aliases = malloc(sizeof(char *) * len);
> >+	aliases = zalloc(sizeof(char *) * len);
> >  	if (!aliases)
> >-		return;
> >+		goto out_enomem;
> 
> That path tries to free aliases[j] but aliases is null.  You could set len to 0 in that case.


Oops, yeah, my bad, it should not have the !, fixing...
 
> >  	pmu = NULL;
> >  	j = 0;
> >  	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
> >@@ -768,16 +768,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
> >  			      (!is_cpu && strglobmatch(alias->name,
> >  						       event_glob))))
> >  				continue;
> >-			aliases[j] = name;
> >+
> >  			if (is_cpu && !name_only)
> >-				aliases[j] = format_alias_or(buf, sizeof(buf),
> >-							      pmu, alias);
> >-			aliases[j] = strdup(aliases[j]);
> >+				name = format_alias_or(buf, sizeof(buf), pmu, alias);
> >+
> >+			aliases[j] = strdup(name);
> >+			if (aliases[j] == NULL)
> >+				goto out_enomem;
> >  			j++;
> >  		}
> >  		if (pmu->selectable) {
> >-			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
> >-			aliases[j] = strdup(buf);
> >+			char *s;
> >+			if (asprintf(&s, "%s//", pmu->name) < 0)
> >+				goto out_enomem;
> >+			aliases[j] = s;
> >  			j++;
> >  		}
> >  	}
> >@@ -789,12 +793,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
> >  			continue;
> >  		}
> >  		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
> >-		zfree(&aliases[j]);
> >  		printed++;
> >  	}
> >  	if (printed)
> >  		printf("\n");
> >-	free(aliases);
> >+out_free:
> >+	for (j = 0; j < len; j++)
> >+		zfree(&aliases[j]);
> >+	zfree(&aliases);
> >+	return;
> >+
> >+out_enomem:
> >+	printf("FATAL: not enough memory to print PMU events\n");
> >+	if (aliases)
> >+		goto out_free;
> >  }
> >
> >  bool pmu_have_event(const char *pname, const char *name)
> >
