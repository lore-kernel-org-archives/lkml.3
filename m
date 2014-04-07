Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaDGPFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:05:16 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:46420 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDGPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:05:09 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Subject: [PATCH 06/16] mce, x86: Enable persistent events
Date: Mon,  7 Apr 2014 17:04:28 +0200
Message-Id: <1396883078-25320-7-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
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
index 4d5419b..92b0d45 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2018,6 +2018,25 @@ int __init mcheck_init(void)
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
1.7.11.7

