Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab3HGVRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:17:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410Ab3HGVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 46/47] perf machine: Do not require /lib/modules/* on a guest
Date: Wed,  7 Aug 2013 18:11:13 -0300
Message-Id: <1375909874-22073-47-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

For some types of work loads and special guest environments, you might
have a kernel that has no kernel modules.  The perf kvm record tool
fails instantiate vmlinux maps when the kernel modules directory cannot
be opened, even though the kallsyms has been properly processed.  This
leads to a perf kvm report that has no guest symbols resolved.

This patch changes the failure to locate kernel modules to be non-fatal.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1373920073-4874-1-git-send-email-jason.wessel@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ef3b49c..6fcc358 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -806,7 +806,10 @@ static int machine__create_modules(struct machine *machine)
 	free(line);
 	fclose(file);
 
-	return machine__set_modules_path(machine);
+	if (machine__set_modules_path(machine) < 0) {
+		pr_debug("Problems setting modules path maps, continuing anyway...\n");
+	}
+	return 0;
 
 out_delete_line:
 	free(line);
-- 
1.8.1.4

