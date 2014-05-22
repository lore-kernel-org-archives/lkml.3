Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaEVMX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:23:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964790AbaEVMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:23:57 -0400
Date: Thu, 22 May 2014 05:23:47 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-1c89fe9b0447f0ce393325e51911f8073432b7b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-19-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-19-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce reset_output_field()
Git-Commit-ID: 1c89fe9b0447f0ce393325e51911f8073432b7b4
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

Commit-ID:  1c89fe9b0447f0ce393325e51911f8073432b7b4
Gitweb:     http://git.kernel.org/tip/1c89fe9b0447f0ce393325e51911f8073432b7b4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 7 May 2014 18:42:24 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:37 +0200

perf tools: Introduce reset_output_field()

The reset_output_field() function is for clearing output field
settings and will be used for test code in later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-19-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/hist.c   | 17 +++++++++++++++++
 tools/perf/util/hist.h |  7 +++++++
 tools/perf/util/sort.c | 11 +++++++++++
 tools/perf/util/sort.h |  1 +
 4 files changed, 36 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 61cf31e..4484f5b 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -459,6 +459,23 @@ next:
 	}
 }
 
+void perf_hpp__reset_output_field(void)
+{
+	struct perf_hpp_fmt *fmt, *tmp;
+
+	/* reset output fields */
+	perf_hpp__for_each_format_safe(fmt, tmp) {
+		list_del_init(&fmt->list);
+		list_del_init(&fmt->sort_list);
+	}
+
+	/* reset sort keys */
+	perf_hpp__for_each_sort_list_safe(fmt, tmp) {
+		list_del_init(&fmt->list);
+		list_del_init(&fmt->sort_list);
+	}
+}
+
 /*
  * See hists__fprintf to match the column widths
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 034db76..a8418d1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -174,9 +174,15 @@ extern struct list_head perf_hpp__sort_list;
 #define perf_hpp__for_each_format(format) \
 	list_for_each_entry(format, &perf_hpp__list, list)
 
+#define perf_hpp__for_each_format_safe(format, tmp)	\
+	list_for_each_entry_safe(format, tmp, &perf_hpp__list, list)
+
 #define perf_hpp__for_each_sort_list(format) \
 	list_for_each_entry(format, &perf_hpp__sort_list, sort_list)
 
+#define perf_hpp__for_each_sort_list_safe(format, tmp)	\
+	list_for_each_entry_safe(format, tmp, &perf_hpp__sort_list, sort_list)
+
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
@@ -197,6 +203,7 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
 void perf_hpp__setup_output_field(void);
+void perf_hpp__reset_output_field(void);
 void perf_hpp__append_sort_keys(void);
 
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d913206..901b9be 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1573,3 +1573,14 @@ int setup_sorting(void)
 
 	return 0;
 }
+
+void reset_output_field(void)
+{
+	sort__need_collapse = 0;
+	sort__has_parent = 0;
+	sort__has_sym = 0;
+	sort__has_dso = 0;
+
+	reset_dimensions();
+	perf_hpp__reset_output_field();
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f5a831c..5f38d92 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -194,6 +194,7 @@ extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
 int setup_output_field(void);
+void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
 
