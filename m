Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaBBVjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:39:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaBBVjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:49 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 06/22] perf tools: Add selected bool into se_snprintf sort entries callback
Date: Sun,  2 Feb 2014 22:38:54 +0100
Message-Id: <1391377150-23920-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding selected bool into se_snprintf sort entries callback,
so we could display selected field differently. This is
going to be used for 'Time' column in following patch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/gtk/hists.c |  2 +-
 tools/perf/ui/hist.c      |  2 +-
 tools/perf/util/sort.c    | 27 ++++++++++++++++++++++++++-
 tools/perf/util/sort.h    |  3 ++-
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 4a3a207..bd9a491 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -322,7 +322,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			if (se->elide)
 				continue;
 
-			se->se_snprintf(se, h, s, ARRAY_SIZE(s),
+			se->se_snprintf(se, false, h, s, ARRAY_SIZE(s),
 					hists__col_len(hists, se->se_width_idx));
 
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 470a1c6..75a8ea6 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -310,7 +310,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			continue;
 
 		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(se, he, s + ret, size - ret,
+		ret += se->se_snprintf(se, false, he, s + ret, size - ret,
 				       hists__col_len(hists, se->se_width_idx));
 	}
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 823a958..b219eaf 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -65,6 +65,7 @@ sort__idx_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__idx_snprintf(struct sort_entry *se __maybe_unused,
+				    bool selected __maybe_unused,
 				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
@@ -100,6 +101,7 @@ static u64 get_time_base(struct hist_entry *he)
 }
 
 static int hist_entry__time_snprintf(struct sort_entry *se __maybe_unused,
+				     bool selected __maybe_unused,
 				     struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
@@ -142,6 +144,7 @@ sort__thread_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__thread_snprintf(struct sort_entry *se __maybe_unused,
+				       bool selected __maybe_unused,
 				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -176,6 +179,7 @@ sort__comm_collapse(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__comm_snprintf(struct sort_entry *se __maybe_unused,
+				     bool selected __maybe_unused,
 				     struct hist_entry *he, char *bf,
 				     size_t size, unsigned int width)
 {
@@ -234,6 +238,7 @@ static int _hist_entry__dso_snprintf(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__dso_snprintf(struct sort_entry *se,
+				    bool selected __maybe_unused,
 				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
@@ -331,6 +336,7 @@ static int _hist_entry__sym_snprintf(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__sym_snprintf(struct sort_entry *se __maybe_unused,
+				    bool selected __maybe_unused,
 				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
@@ -373,6 +379,7 @@ sort__srcline_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__srcline_snprintf(struct sort_entry *se __maybe_unused,
+					bool selected __maybe_unused,
 					struct hist_entry *he, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
@@ -403,6 +410,7 @@ sort__parent_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__parent_snprintf(struct sort_entry *se __maybe_unused,
+				       bool selected __maybe_unused,
 				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -427,6 +435,7 @@ sort__cpu_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__cpu_snprintf(struct sort_entry *se __maybe_unused,
+				    bool selected __maybe_unused,
 				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
@@ -451,8 +460,9 @@ sort__dso_from_cmp(struct sort_entry *se,
 }
 
 static int hist_entry__dso_from_snprintf(struct sort_entry *se,
+					 bool selected __maybe_unused,
 					 struct hist_entry *he, char *bf,
-				    size_t size, unsigned int width)
+					 size_t size, unsigned int width)
 {
 	return _hist_entry__dso_snprintf(se, he->branch_info->from.map,
 					 bf, size, width);
@@ -467,6 +477,7 @@ sort__dso_to_cmp(struct sort_entry *se,
 }
 
 static int hist_entry__dso_to_snprintf(struct sort_entry *se __maybe_unused,
+				       bool selected __maybe_unused,
 				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -501,6 +512,7 @@ sort__sym_to_cmp(struct sort_entry *se,
 }
 
 static int hist_entry__sym_from_snprintf(struct sort_entry *se,
+					 bool selected __maybe_unused,
 					 struct hist_entry *he, char *bf,
 					 size_t size, unsigned int width)
 {
@@ -511,6 +523,7 @@ static int hist_entry__sym_from_snprintf(struct sort_entry *se,
 }
 
 static int hist_entry__sym_to_snprintf(struct sort_entry *se __maybe_unused,
+				       bool selected __maybe_unused,
 				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -561,6 +574,7 @@ sort__mispredict_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__mispredict_snprintf(struct sort_entry *se __maybe_unused,
+					   bool selected __maybe_unused,
 					   struct hist_entry *he, char *bf,
 					   size_t size, unsigned int width){
 	static const char *out = "N/A";
@@ -589,6 +603,7 @@ sort__daddr_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__daddr_snprintf(struct sort_entry *se,
+				      bool selected __maybe_unused,
 				      struct hist_entry *he, char *bf,
 				      size_t size, unsigned int width)
 {
@@ -621,6 +636,7 @@ sort__dso_daddr_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__dso_daddr_snprintf(struct sort_entry *se,
+					  bool selected __maybe_unused,
 					  struct hist_entry *he, char *bf,
 					  size_t size, unsigned int width)
 {
@@ -653,6 +669,7 @@ sort__locked_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__locked_snprintf(struct sort_entry *se __maybe_unused,
+				       bool selected __maybe_unused,
 				       struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -704,6 +721,7 @@ static const char * const tlb_access[] = {
 #define NUM_TLB_ACCESS (sizeof(tlb_access)/sizeof(const char *))
 
 static int hist_entry__tlb_snprintf(struct sort_entry *se __maybe_unused,
+				    bool selected __maybe_unused,
 				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
@@ -783,6 +801,7 @@ static const char * const mem_lvl[] = {
 #define NUM_MEM_LVL (sizeof(mem_lvl)/sizeof(const char *))
 
 static int hist_entry__lvl_snprintf(struct sort_entry *se __maybe_unused,
+				    bool selected __maybe_unused,
 				    struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
@@ -853,6 +872,7 @@ static const char * const snoop_access[] = {
 #define NUM_SNOOP_ACCESS (sizeof(snoop_access)/sizeof(const char *))
 
 static int hist_entry__snoop_snprintf(struct sort_entry *se __maybe_unused,
+				      bool selected __maybe_unused,
 				      struct hist_entry *he, char *bf,
 				      size_t size, unsigned int width)
 {
@@ -904,6 +924,7 @@ sort__local_weight_cmp(struct sort_entry *se __maybe_unused,
 
 static int
 hist_entry__local_weight_snprintf(struct sort_entry *se __maybe_unused,
+				  bool selected __maybe_unused,
 				  struct hist_entry *he, char *bf,
 				  size_t size, unsigned int width)
 {
@@ -926,6 +947,7 @@ sort__global_weight_cmp(struct sort_entry *se __maybe_unused,
 
 static int
 hist_entry__global_weight_snprintf(struct sort_entry *se __maybe_unused,
+				   bool selected __maybe_unused,
 				   struct hist_entry *he, char *bf,
 				   size_t size, unsigned int width)
 {
@@ -990,6 +1012,7 @@ sort__abort_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__abort_snprintf(struct sort_entry *se __maybe_unused,
+				      bool selected __maybe_unused,
 				      struct hist_entry *he, char *bf,
 				      size_t size, unsigned int width)
 {
@@ -1016,6 +1039,7 @@ sort__in_tx_cmp(struct sort_entry *se __maybe_unused,
 }
 
 static int hist_entry__in_tx_snprintf(struct sort_entry *se __maybe_unused,
+				      bool selected __maybe_unused,
 				      struct hist_entry *he, char *bf,
 				      size_t size, unsigned int width)
 {
@@ -1078,6 +1102,7 @@ int hist_entry__transaction_len(void)
 
 static int
 hist_entry__transaction_snprintf(struct sort_entry *se __maybe_unused,
+				 bool selected __maybe_unused,
 				 struct hist_entry *he, char *bf,
 				 size_t size, unsigned int width)
 {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 1dffebc..0b992fd 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -201,7 +201,8 @@ struct sort_entry {
 			  struct hist_entry *);
 	int64_t (*se_collapse)(struct sort_entry *, struct hist_entry *,
 			       struct hist_entry *);
-	int	(*se_snprintf)(struct sort_entry *, struct hist_entry *he,
+	int	(*se_snprintf)(struct sort_entry *, bool selected,
+			       struct hist_entry *he,
 			       char *bf, size_t size, unsigned int width);
 	u8	se_width_idx;
 	bool	elide;
-- 
1.8.3.1

