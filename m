Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbaJ2OIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:08:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:41358 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933703AbaJ2OIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:08:25 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/25] perf pmu: Add proper error handling to print_pmu_events()
Date: Wed, 29 Oct 2014 12:06:30 -0200
Message-Id: <1414591597-2763-19-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414591597-2763-1-git-send-email-acme@kernel.org>
References: <1414591597-2763-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was silently returning or printing "(null)" when no memory was
available at various points. Fix it by checking and warning the user
when that happens.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-835udmf66x9nza504cu6irz9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 91dca604c422..881b75490533 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -753,9 +753,9 @@ void print_pmu_events(const char *event_glob, bool name_only)
 		if (pmu->selectable)
 			len++;
 	}
-	aliases = malloc(sizeof(char *) * len);
+	aliases = zalloc(sizeof(char *) * len);
 	if (!aliases)
-		return;
+		goto out_enomem;
 	pmu = NULL;
 	j = 0;
 	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
@@ -768,16 +768,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			      (!is_cpu && strglobmatch(alias->name,
 						       event_glob))))
 				continue;
-			aliases[j] = name;
+
 			if (is_cpu && !name_only)
-				aliases[j] = format_alias_or(buf, sizeof(buf),
-							      pmu, alias);
-			aliases[j] = strdup(aliases[j]);
+				name = format_alias_or(buf, sizeof(buf), pmu, alias);
+
+			aliases[j] = strdup(name);
+			if (aliases[j] == NULL)
+				goto out_enomem;
 			j++;
 		}
 		if (pmu->selectable) {
-			scnprintf(buf, sizeof(buf), "%s//", pmu->name);
-			aliases[j] = strdup(buf);
+			char *s;
+			if (asprintf(&s, "%s//", pmu->name) < 0)
+				goto out_enomem;
+			aliases[j] = s;
 			j++;
 		}
 	}
@@ -789,12 +793,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			continue;
 		}
 		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
-		zfree(&aliases[j]);
 		printed++;
 	}
 	if (printed)
 		printf("\n");
-	free(aliases);
+out_free:
+	for (j = 0; j < len; j++)
+		zfree(&aliases[j]);
+	zfree(&aliases);
+	return;
+
+out_enomem:
+	printf("FATAL: not enough memory to print PMU events\n");
+	if (aliases)
+		goto out_free;
 }
 
 bool pmu_have_event(const char *pname, const char *name)
-- 
1.9.3

