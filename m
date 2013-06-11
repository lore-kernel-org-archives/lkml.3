Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3FKQnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:43:03 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63189 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3FKQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:42:59 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 04/14] MCE: Enable persistent event
Date: Tue, 11 Jun 2013 18:42:30 +0200
Message-Id: <1370968960-22527-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... for MCEs collection.

Changes made by Robert Richter <robert.richter@linaro.org>:

The mce_record tracepoint needs tracepoints to be enabled. Fixing
build error for no-tracepoints configs.

Signed-off-by: Borislav Petkov <bp@suse.de>
[ Fix build error for no-tracepoints configs ]
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..d421937 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1987,6 +1987,24 @@ int __init mcheck_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_TRACEPOINTS
+
+int __init mcheck_init_tp(void)
+{
+	if (perf_add_persistent_event_by_id(event_mce_record.event.type)) {
+		pr_err("Error adding MCE persistent event.\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+/*
+ * We can't run earlier because persistent events uses anon_inode_getfile and
+ * its anon_inode_mnt gets initialized as a fs_initcall.
+ */
+fs_initcall_sync(mcheck_init_tp);
+
+#endif /* CONFIG_TRACEPOINTS */
+
 /*
  * mce_syscore: PM support
  */
-- 
1.8.1.1

