Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaASMXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:23:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55763 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaASMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:23:43 -0500
Date: Sun, 19 Jan 2014 04:23:20 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-354a2bd0318e0758f93b8b24553f3376fa9dfa21@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1389839478-5887-7-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Unregister handler when kvm plugin is unloaded
Git-Commit-ID: 354a2bd0318e0758f93b8b24553f3376fa9dfa21
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:23:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  354a2bd0318e0758f93b8b24553f3376fa9dfa21
Gitweb:     http://git.kernel.org/tip/354a2bd0318e0758f93b8b24553f3376fa9dfa21
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Jan 2014 11:31:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 16 Jan 2014 16:26:24 -0300

tools lib traceevent: Unregister handler when kvm plugin is unloaded

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
index a0e282c..9e0e8c6 100644
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
