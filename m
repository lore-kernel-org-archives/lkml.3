Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3GQIIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:08:22 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54221 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3GQIIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:08:19 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-d3-51e650f13c1e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf symbol: Do not apply symfs for an absolute vmlinux path
Date: Wed, 17 Jul 2013 17:08:15 +0900
Message-Id: <1374048495-3643-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If an user gives both of --symfs and --vmlinux option, the vmlinux
will be searched under the symfs directory.  This is somewhat
confusing since vmlinux often lives in kernel build directory or
somewhere other than user space binaries.

So it'd be better not adding symfs prefix for a vmlinux if it has an
absolute pathname.

Reported-by: Kwanghyun Yoo <ykh815.yoo@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d5528e1cc03a..02718e728d59 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -888,8 +888,11 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	char symfs_vmlinux[PATH_MAX];
 	enum dso_binary_type symtab_type;
 
-	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
-		 symbol_conf.symfs, vmlinux);
+	if (vmlinux[0] == '/')
+		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s", vmlinux);
+	else
+		snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
+			 symbol_conf.symfs, vmlinux);
 
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 		symtab_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
-- 
1.7.11.7

