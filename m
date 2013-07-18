Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab3GRTuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:50:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759494Ab3GRTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 70/76] perf symbols: Do not apply symfs for an absolute vmlinux path
Date: Thu, 18 Jul 2013 16:49:57 -0300
Message-Id: <1374177003-3706-71-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If an user gives both of --symfs and --vmlinux option, the vmlinux will
be searched under the symfs directory.  This is somewhat confusing since
vmlinux often lives in kernel build directory or somewhere other than
user space binaries.

So it'd be better not adding symfs prefix for a vmlinux if it has an
absolute pathname.

Reported-by: Kwanghyun Yoo <ykh815.yoo@lge.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374048495-3643-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d5528e1..02718e7 100644
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
1.8.1.4

