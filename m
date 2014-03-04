Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaCDCoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:44:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56470 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaCDCmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:42:20 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 08/10] perf tools: Allow hpp fields to be sort keys
Date: Tue,  4 Mar 2014 11:42:14 +0900
Message-Id: <1393900936-22977-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add overhead{,_sys,_us,_guest_sys,_guest_us}, sample and period sort
keys so that they can be selected with --sort/-s option.

  $ perf report -s period,comm --stdio
  ...
  # Overhead        Period          Command
  # ........  ............  ...............
  #
      47.06%           152          swapper
      13.93%            45  qemu-system-arm
      12.38%            40         synergys
       3.72%            12          firefox
       2.48%             8            xchat

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   |  9 +++++++--
 tools/perf/util/sort.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 59abcb4e40c7..8b7eb052a432 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -347,8 +347,13 @@ void perf_hpp__init(void)
 	int i;
 
 	for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
-		INIT_LIST_HEAD(&perf_hpp__format[i].list);
-		INIT_LIST_HEAD(&perf_hpp__format[i].sort_list);
+		struct perf_hpp_fmt *fmt = &perf_hpp__format[i];
+
+		INIT_LIST_HEAD(&fmt->list);
+
+		/* sort_list may be linked by setup_sorting() */
+		if (fmt->sort_list.next == NULL)
+			INIT_LIST_HEAD(&fmt->sort_list);
 	}
 
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b2829f947053..916652af8304 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1028,6 +1028,26 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
 #undef DIM
 
+struct hpp_dimension {
+	const char		*name;
+	struct perf_hpp_fmt	*fmt;
+	int			taken;
+};
+
+#define DIM(d, n) { .name = n, .fmt = &perf_hpp__format[d], }
+
+static struct hpp_dimension hpp_sort_dimensions[] = {
+	DIM(PERF_HPP__OVERHEAD, "overhead"),
+	DIM(PERF_HPP__OVERHEAD_SYS, "overhead_sys"),
+	DIM(PERF_HPP__OVERHEAD_US, "overhead_us"),
+	DIM(PERF_HPP__OVERHEAD_GUEST_SYS, "overhead_guest_sys"),
+	DIM(PERF_HPP__OVERHEAD_GUEST_US, "overhead_guest_us"),
+	DIM(PERF_HPP__SAMPLES, "sample"),
+	DIM(PERF_HPP__PERIOD, "period"),
+};
+
+#undef DIM
+
 struct hpp_sort_entry {
 	struct perf_hpp_fmt hpp;
 	struct sort_entry *se;
@@ -1115,6 +1135,16 @@ static int __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 	return 0;
 }
 
+static int __hpp_dimension__add(struct hpp_dimension *hd)
+{
+	if (!hd->taken) {
+		hd->taken = 1;
+
+		perf_hpp__register_sort_field(hd->fmt);
+	}
+	return 0;
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -1144,6 +1174,15 @@ int sort_dimension__add(const char *tok)
 		return __sort_dimension__add(sd, i);
 	}
 
+	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
+		struct hpp_dimension *hd = &hpp_sort_dimensions[i];
+
+		if (strncasecmp(tok, hd->name, strlen(tok)))
+			continue;
+
+		return __hpp_dimension__add(hd);
+	}
+
 	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
 		struct sort_dimension *sd = &bstack_sort_dimensions[i];
 
-- 
1.7.11.7

