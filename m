Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3IINWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:22:23 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61844 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3IINWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:22:22 -0400
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
Subject: [PATCH 1/2] perf tools: avoid traverse dsos list while find vdso
Date: Mon,  9 Sep 2013 21:21:55 +0800
Message-Id: <1378732916-3537-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

Vdso is only one in a system. It is not necessory to traverse the
macine->user_dsos list when looking for the dso of vdso.
The flag vdso_found should be replaced by a pointor that point to the dso of
vdso. If the pointer is NULL, dso of vdso have not been created. Else, the
pointor can be returned directly in function vdso__dso_findnew().
The list traversing can be avoided by this method.
Thanks.

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
 tools/perf/util/vdso.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 3915982..8022ef0 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -13,7 +13,7 @@
 #include "symbol.h"
 #include "linux/string.h"
 
-static bool vdso_found;
+static struct dso *vdso_dso = NULL;
 static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
 
 static int find_vdso_map(void **start, void **end)
@@ -55,9 +55,6 @@ static char *get_file(void)
 	size_t size;
 	int fd;
 
-	if (vdso_found)
-		return vdso_file;
-
 	if (find_vdso_map(&start, &end))
 		return NULL;
 
@@ -79,33 +76,30 @@ static char *get_file(void)
  out:
 	free(buf);
 
-	vdso_found = (vdso != NULL);
 	return vdso;
 }
 
 void vdso__exit(void)
 {
-	if (vdso_found)
+	if (vdso_dso)
 		unlink(vdso_file);
 }
 
 struct dso *vdso__dso_findnew(struct list_head *head)
 {
-	struct dso *dso = dsos__find(head, VDSO__MAP_NAME, true);
-
-	if (!dso) {
+	if (!vdso_dso) {
 		char *file;
 
 		file = get_file();
 		if (!file)
 			return NULL;
 
-		dso = dso__new(VDSO__MAP_NAME);
-		if (dso != NULL) {
-			dsos__add(head, dso);
-			dso__set_long_name(dso, file);
+		vdso_dso = dso__new(VDSO__MAP_NAME);
+		if (vdso_dso != NULL) {
+			dsos__add(head, vdso_dso);
+			dso__set_long_name(vdso_dso, file);
 		}
 	}
 
-	return dso;
+	return vdso_dso;
 }
-- 
1.7.8.rc2.5.g815b

