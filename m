Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaAPCbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:31:33 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58256 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaAPCbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:31:23 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-d2-52d7447837b4
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/12] tools lib traceevent: Unregister handler when kvm plugin unloaded
Date: Thu, 16 Jan 2014 11:31:12 +0900
Message-Id: <1389839478-5887-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm handlers should be unregistered when the plugin unloaded
otherwise they'll try to access invalid memory.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
1.7.11.7

