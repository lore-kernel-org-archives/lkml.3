Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030287Ab3GSHyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:54:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030211Ab3GSHyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:54:09 -0400
Date: Fri, 19 Jul 2013 00:53:51 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-5698d2c99ec11006b4c241ebad5252289902b358@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, ykh815.yoo@lge.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, ykh815.yoo@lge.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1374048495-3643-1-git-send-email-namhyung@kernel.org>
References: <1374048495-3643-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Do not apply symfs for an absolute vmlinux path
Git-Commit-ID: 5698d2c99ec11006b4c241ebad5252289902b358
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:53:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5698d2c99ec11006b4c241ebad5252289902b358
Gitweb:     http://git.kernel.org/tip/5698d2c99ec11006b4c241ebad5252289902b358
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 17 Jul 2013 17:08:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 12:23:57 -0300

perf symbols: Do not apply symfs for an absolute vmlinux path

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
