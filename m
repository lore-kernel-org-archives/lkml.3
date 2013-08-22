Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3HVOQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:16:53 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61882 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3HVOOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:45 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 06/12] mce, x86: Enable persistent events
Date: Thu, 22 Aug 2013 16:13:21 +0200
Message-Id: <1377180807-12758-7-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... for MCEs collection.

Signed-off-by: Borislav Petkov <bp@suse.de>
[ rric: Fix build error for no-tracepoints configs ]
[ rric: Return proper error code. ]
[ rric: No error message if perf is disabled. ]
Signed-off-by: Robert Richter <rric@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 87a65c9..ffa227b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1990,6 +1990,25 @@ int __init mcheck_init(void)
 	return 0;
 }
 
+#ifdef CONFIG_EVENT_TRACING
+
+int __init mcheck_init_tp(void)
+{
+	int ret = perf_add_persistent_tp(&event_mce_record);
+
+	if (ret && ret != -ENOENT)
+		pr_err("Error adding MCE persistent event: %d\n", ret);
+
+	return ret;
+}
+/*
+ * We can't run earlier because persistent events uses anon_inode_getfile and
+ * its anon_inode_mnt gets initialized as a fs_initcall.
+ */
+fs_initcall_sync(mcheck_init_tp);
+
+#endif /* CONFIG_EVENT_TRACING */
+
 /*
  * mce_syscore: PM support
  */
-- 
1.8.3.2

