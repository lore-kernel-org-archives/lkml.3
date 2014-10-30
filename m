Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbaJ3Gr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:47:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659AbaJ3GrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:47:12 -0400
Date: Wed, 29 Oct 2014 23:46:30 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-835udmf66x9nza504cu6irz9@git.kernel.org>
Cc: bp@suse.de, paulus@samba.org, jean.pihet@linaro.org, efault@gmx.de,
        tglx@linutronix.de, dsahern@gmail.com, adrian.hunter@intel.com,
        acme@redhat.com, peterz@infradead.org, hpa@zytor.com,
        dzickus@redhat.com, jolsa@redhat.com, mingo@kernel.org,
        namhyung@kernel.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        eranian@google.com
Reply-To: tglx@linutronix.de, acme@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, peterz@infradead.org, bp@suse.de, paulus@samba.org,
        efault@gmx.de, jean.pihet@linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, eranian@google.com, dzickus@redhat.com,
        hpa@zytor.com, jolsa@redhat.com, mingo@kernel.org, namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf pmu:
  Add proper error handling to print_pmu_events()
Git-Commit-ID: 7e4772dc99a3ebfc53708eff262f7a8155485e85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e4772dc99a3ebfc53708eff262f7a8155485e85
Gitweb:     http://git.kernel.org/tip/7e4772dc99a3ebfc53708eff262f7a8155485e85
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 24 Oct 2014 10:25:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:48 -0200

perf pmu: Add proper error handling to print_pmu_events()

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
index 91dca60..881b754 100644
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
