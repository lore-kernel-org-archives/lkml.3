Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732AbaE3V7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:59:17 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52326 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934587AbaE3V64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:58:56 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] audit: Syscall auditing lite
Date: Fri, 30 May 2014 14:58:48 -0700
Message-Id: <555d2e442a00a5e40713fa03b01a8a54ea9164b8.1401486790.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401486790.git.luto@amacapital.net>
References: <cover.1401486790.git.luto@amacapital.net>
In-Reply-To: <cover.1401486790.git.luto@amacapital.net>
References: <cover.1401486790.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAICS the main use of syscall auditing is to get syscall
information for syscalls that are already causing another audit
message.

We don't need any of the fancy syscall auditing machinery for that,
though: we can just log this information directly.  This should have
essentially no overhead and it could end up being much easier to use
than auditsc.

This produces messages like this:

audit: type=1123 audit(1401485315.370:2): pid=125 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='blah blah blah' arch=c000003e syscall=44 a0=3 a1=7fff383feb60 a2=5c a3=0 a4=7fff383feb50 a5=c

The new fields (arch, syscall, and a0..a5) will only be logged if we
are in a syscall but we aren't otherwise building an auditsc context.

This is only supported on x86 for now.  Other architectures can get
this if they implement syscall_in_syscall.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/audit.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 47845c5..8509d00 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -67,6 +67,10 @@
 #include <linux/pid_namespace.h>
 #include <net/netns/generic.h>
 
+#ifdef CONFIG_HAVE_SYSCALL_IN_SYSCALL
+#include <asm/syscall.h>
+#endif
+
 #include "audit.h"
 
 /* No auditing will take place until audit_initialized == AUDIT_INITIALIZED.
@@ -1897,6 +1901,40 @@ out:
 	kfree(name);
 }
 
+#ifdef CONFIG_HAVE_SYSCALL_IN_SYSCALL
+/**
+ * audit_log_missing_context - append otherwise-missing context
+ * @ab: the audit_buffer
+ *
+ * If syscall auditing is unavailable, try to log syscall context
+ * information anyway.
+ */
+static void audit_log_missing_context(struct audit_buffer *ab)
+{
+	struct task_struct *tsk = current;
+	struct pt_regs *regs = current_pt_regs();
+	unsigned long args[6];
+
+	if (!syscall_in_syscall(tsk, regs))
+		return;
+
+	if (ab->ctx && ab->ctx->in_syscall)
+		return;  /* Let audit_log_exit log the context. */
+
+	syscall_get_arguments(tsk, regs, 0, 6, args);
+
+	audit_log_format(ab, " arch=%x syscall=%d a0=%lx a1=%lx a2=%lx a3=%lx a4=%lx a5=%lx",
+			 (unsigned int)syscall_get_arch(),
+			 syscall_get_nr(tsk, regs),
+			 args[0], args[1], args[2], args[3], args[4], args[5]);
+}
+#else
+static void audit_log_missing_context(struct audit_buffer *ab)
+{
+	/* We need arch support to do this reliably, so don't even try. */
+}
+#endif
+
 /**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
@@ -1913,7 +1951,11 @@ void audit_log_end(struct audit_buffer *ab)
 	if (!audit_rate_check()) {
 		audit_log_lost("rate limit exceeded");
 	} else {
-		struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
+		struct nlmsghdr *nlh;
+
+		audit_log_missing_context(ab);
+
+		nlh = nlmsg_hdr(ab->skb);
 		nlh->nlmsg_len = ab->skb->len - NLMSG_HDRLEN;
 
 		if (audit_pid) {
-- 
1.9.3

