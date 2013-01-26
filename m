Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3AZUEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab3AZUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:04:35 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf tools: Add pmu interface to parse single file of aliases
Date: Sat, 26 Jan 2013 21:04:06 +0100
Message-Id: <1359230650-10415-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding pmu_aliases_parse_multi function to parse and add
aliases from single file. The file format follows the
alias format, each line for single alias. Each line
must contains 'name' term, like:

  name=BR_MISP_EXEC.ALL_BRANCHES,event=0x89,umask=0xff
  name=BR_MISP_EXEC.COND,event=0x89,umask=0x1

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/pmu.c | 23 +++++++++++++++++++++++
 tools/perf/util/pmu.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 0d45ccd..68d6c86 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -146,11 +146,34 @@ static int perf_pmu__new_alias(struct list_head *list, char *name, char *data)
 		}
 	}
 
+	pr_debug3("adding alias '%s' => '%s'\n", name, data);
+
 	alias->name = strdup(name);
 	list_add_tail(&alias->list, list);
 	return 0;
 }
 
+int pmu_aliases_parse_multi(char *path, struct list_head *head)
+{
+	FILE *file;
+	char *data = NULL;
+	size_t len;
+	int ret = -EINVAL;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -EINVAL;
+
+	while ((getline(&data, &len, file)) != -1) {
+		ret = perf_pmu__new_alias(head, NULL, data);
+		free(data);
+		data = NULL;
+	}
+
+	fclose(file);
+	return ret;
+}
+
 /*
  * Process all the sysfs attributes located under the directory
  * specified in 'dir' parameter.
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 54cd809..add249b 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -43,5 +43,7 @@ struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
 
 char *perf_pmu__event_name(struct list_head *head_terms, bool remove);
 
+int pmu_aliases_parse_multi(char *path, struct list_head *head);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.7.11.7

