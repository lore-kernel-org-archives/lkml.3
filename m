Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaAOBrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:47:04 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaAOBpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:47 -0500
X-AuditID: 9c930197-b7b7cae000000e34-67-52d5e847e3ec
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/17] tools lib traceevent: Unregister handler when kvm plugin unloaded
Date: Wed, 15 Jan 2014 10:45:34 +0900
Message-Id: <1389750340-15965-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm handlers should be unregistered when the plugin unloaded
otherwise they'll try to access invalid memory.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/plugin_kvm.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index a0e282c6b967..6a1eeadbf7a1 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -434,3 +434,33 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
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
+	pevent_unregister_print_function(pevent,
+					 process_is_writable_pte,
+					 "is_writable_pte");
+}
-- 
1.7.11.7

