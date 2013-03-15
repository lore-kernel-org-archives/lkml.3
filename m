Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3CONGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:06:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52631 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab3CONGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:06:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>
Subject: [RFC PATCH 3/3] MCE: Enable persistent event
Date: Fri, 15 Mar 2013 14:06:29 +0100
Message-Id: <1363352789-17991-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363352789-17991-1-git-send-email-bp@alien8.de>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... for MCEs collection.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7bc126346ace..4f44991b38b5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1987,6 +1987,31 @@ int __init mcheck_init(void)
 	return 0;
 }
 
+static struct perf_event_attr pattr = {
+	.type		= PERF_TYPE_TRACEPOINT,
+	.size		= sizeof(pattr),
+	.sample_type	= PERF_SAMPLE_RAW,
+	.persistent	= 1,
+};
+
+int __init mcheck_init_tp(void)
+{
+
+	pattr.config = event_mce_record.event.type;
+	pattr.sample_period = 1;
+	pattr.wakeup_events = 1;
+
+	if (perf_add_persistent_event(&pattr, 4))
+		pr_err("Error adding MCE persistent event.\n");
+
+	return 0;
+}
+/*
+ * We can't run earlier because persistent events uses anon_inode_getfile and
+ * its anon_inode_mnt gets initialized as a fs_initcall.
+ */
+fs_initcall_sync(mcheck_init_tp);
+
 /*
  * mce_syscore: PM support
  */
-- 
1.8.1.3.535.ga923c31

