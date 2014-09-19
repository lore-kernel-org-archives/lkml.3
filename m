Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaISFVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:21:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbaISFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:21:35 -0400
Date: Thu, 18 Sep 2014 22:20:18 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-ad96227349901838e1a7f96f1dc22d96a97520c0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1408129739-17368-6-git-send-email-adrian.hunter@intel.com>
References: <1408129739-17368-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Let a user specify a PMU event without any config terms
Git-Commit-ID: ad96227349901838e1a7f96f1dc22d96a97520c0
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

Commit-ID:  ad96227349901838e1a7f96f1dc22d96a97520c0
Gitweb:     http://git.kernel.org/tip/ad96227349901838e1a7f96f1dc22d96a97520c0
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 15 Aug 2014 22:08:40 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:08 -0300

perf tools: Let a user specify a PMU event without any config terms

This enables a PMU event to be specified in the form:

	pmu//

which is effectively the same as:

	pmu/config=0/

This patch is a precursor to defining default config for a PMU.

Further explanation extracted from lkml thread:

Imagine that the 'tsc' term did not exist.

Intel PT trace data would not contain TSC packets, and the decoder would
not know how to decode them.

Then imagine that a new version of the hardware adds 'tsc'.

It is such a useful feature that we want it by default, but older
versions of the tools don't know how to decode it, so the kernel cannot
turn it on by default.

It is similar to why the kernel does not select perf_event_attr.mmap2 by
default.

The kernel doesn't know whether the tool supports it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408129739-17368-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |  6 ++++++
 tools/perf/util/parse-events.y | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e34c81a..e756288 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -645,6 +645,12 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 
 	memset(&attr, 0, sizeof(attr));
 
+	if (!head_config) {
+		attr.type = pmu->type;
+		evsel = __add_event(list, idx, &attr, NULL, pmu->cpus);
+		return evsel ? 0 : -ENOMEM;
+	}
+
 	if (perf_pmu__check_alias(pmu, head_config, &unit, &scale))
 		return -EINVAL;
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 0bc87ba..55fab6a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -210,6 +210,16 @@ PE_NAME '/' event_config '/'
 	parse_events__free_terms($3);
 	$$ = list;
 }
+|
+PE_NAME '/' '/'
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_pmu(list, &data->idx, $1, NULL));
+	$$ = list;
+}
 
 value_sym:
 PE_VALUE_SYM_HW
