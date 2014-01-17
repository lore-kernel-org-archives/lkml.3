Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaAQO5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:57:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36290 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaAQO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/19] tools lib traceevent: Unregister handler when kvm plugin is unloaded
Date: Fri, 17 Jan 2014 11:57:12 -0300
Message-Id: <1389970645-12075-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The kvm handlers should be unregistered when the plugin is unloaded
otherwise they'll try to access invalid memory.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389839478-5887-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/plugin_kvm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index a0e282c6b967..9e0e8c61b43b 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -434,3 +434,32 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 				       PEVENT_FUNC_ARG_VOID);
 	return 0;
 }
+
+void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+{
+	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+					kvm_exit_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+					kvm_emulate_insn_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+					kvm_mmu_get_page_handler, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+					kvm_mmu_print_role, NULL);
+
+	pevent_unregister_event_handler(pevent, -1,
+					"kvmmmu", "kvm_mmu_unsync_page",
+					kvm_mmu_print_role, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+					kvm_mmu_print_role, NULL);
+
+	pevent_unregister_event_handler(pevent, -1, "kvmmmu",
+			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
+			NULL);
+
+	pevent_unregister_print_function(pevent, process_is_writable_pte,
+					 "is_writable_pte");
+}
-- 
1.8.1.4

