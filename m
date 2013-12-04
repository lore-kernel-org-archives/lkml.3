Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3LDUNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:13:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240Ab3LDUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/38] perf tools: Remove condition in machine__get_kernel_start_addr.
Date: Wed,  4 Dec 2013 17:06:30 -0300
Message-Id: <1386187622-2928-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

In machine__get_kernel_start_addr, the code, which is using
machine->root_dir to build filename, works for both host and guests
initialized from guestmount, as root_dir is set to "" for the host
machine in the machine__init() function.

So this patch remove the branch for machine__is_host.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/0a81645dd0b384a12cb4f962cf193ef8c3ce2010.1386197481.git.yangds.fnst@cn.fujitsu.com
[ Clarified changeset mentioning root_dir setup in machine__init() ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 84cdb072ac83..bac817ab2068 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -502,15 +502,11 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 	char path[PATH_MAX];
 	struct process_args args;
 
-	if (machine__is_host(machine)) {
-		filename = "/proc/kallsyms";
-	} else {
-		if (machine__is_default_guest(machine))
-			filename = (char *)symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
+	if (machine__is_default_guest(machine))
+		filename = (char *)symbol_conf.default_guest_kallsyms;
+	else {
+		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		filename = path;
 	}
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
-- 
1.8.1.4

