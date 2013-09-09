Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3IINWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:22:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35870 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3IINWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:22:33 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] perf tools: remove short name compare in dsos__find()
Date: Mon,  9 Sep 2013 21:21:56 +0800
Message-Id: <1378732916-3537-2-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378732916-3537-1-git-send-email-chenggang.qin@gmail.com>
References: <1378732916-3537-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

If the list traversal is avoided by the last patch, the short name compare in
dsos__find() is unnecessary. The purpose of short name compare is only to find
the dso of vdso. If the vdso can be found by a pointor, the short name compare
can be removed.
Thanks

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/util/dso.c |   10 ++--------
 tools/perf/util/dso.h |    3 +--
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index c4374f0..6f7d5a9 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -513,16 +513,10 @@ void dsos__add(struct list_head *head, struct dso *dso)
 	list_add_tail(&dso->node, head);
 }
 
-struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
+struct dso *dsos__find(struct list_head *head, const char *name)
 {
 	struct dso *pos;
 
-	if (cmp_short) {
-		list_for_each_entry(pos, head, node)
-			if (strcmp(pos->short_name, name) == 0)
-				return pos;
-		return NULL;
-	}
 	list_for_each_entry(pos, head, node)
 		if (strcmp(pos->long_name, name) == 0)
 			return pos;
@@ -531,7 +525,7 @@ struct dso *dsos__find(struct list_head *head, const char *name, bool cmp_short)
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name)
 {
-	struct dso *dso = dsos__find(head, name, false);
+	struct dso *dso = dsos__find(head, name);
 
 	if (!dso) {
 		dso = dso__new(name);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d51aaf2..450199a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -133,8 +133,7 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 				const char *short_name, int dso_type);
 
 void dsos__add(struct list_head *head, struct dso *dso);
-struct dso *dsos__find(struct list_head *head, const char *name,
-		       bool cmp_short);
+struct dso *dsos__find(struct list_head *head, const char *name);
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
 
-- 
1.7.8.rc2.5.g815b

