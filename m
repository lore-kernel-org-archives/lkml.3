Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaF0XZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:25:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52539 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbaF0XXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:23:55 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v9 03/11] seccomp: split mode setting routines
Date: Fri, 27 Jun 2014 16:22:52 -0700
Message-Id: <1403911380-27787-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403911380-27787-1-git-send-email-keescook@chromium.org>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separates the two mode setting paths to make things more readable with
fewer #ifdefs within function bodies.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |   71 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 03a5959b7930..812cea2e7ffb 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -489,48 +489,66 @@ long prctl_get_seccomp(void)
 }
 
 /**
- * seccomp_set_mode: internal function for setting seccomp mode
- * @seccomp_mode: requested mode to use
- * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
- *
- * This function may be called repeatedly with a @seccomp_mode of
- * SECCOMP_MODE_FILTER to install additional filters.  Every filter
- * successfully installed will be evaluated (in reverse order) for each system
- * call the task makes.
+ * seccomp_set_mode_strict: internal function for setting strict seccomp
  *
  * Once current->seccomp.mode is non-zero, it may not be changed.
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
+static long seccomp_set_mode_strict(void)
 {
+	const unsigned long seccomp_mode = SECCOMP_MODE_STRICT;
 	long ret = -EINVAL;
 
 	if (!seccomp_check_mode(seccomp_mode))
 		goto out;
 
-	switch (seccomp_mode) {
-	case SECCOMP_MODE_STRICT:
-		ret = 0;
 #ifdef TIF_NOTSC
-		disable_TSC();
+	disable_TSC();
 #endif
-		break;
+	seccomp_assign_mode(seccomp_mode);
+	ret = 0;
+
+out:
+
+	return ret;
+}
+
 #ifdef CONFIG_SECCOMP_FILTER
-	case SECCOMP_MODE_FILTER:
-		ret = seccomp_attach_user_filter(filter);
-		if (ret)
-			goto out;
-		break;
-#endif
-	default:
+/**
+ * seccomp_set_mode_filter: internal function for setting seccomp filter
+ * @filter: struct sock_fprog containing filter
+ *
+ * This function may be called repeatedly to install additional filters.
+ * Every filter successfully installed will be evaluated (in reverse order)
+ * for each system call the task makes.
+ *
+ * Once current->seccomp.mode is non-zero, it may not be changed.
+ *
+ * Returns 0 on success or -EINVAL on failure.
+ */
+static long seccomp_set_mode_filter(char __user *filter)
+{
+	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
+	long ret = -EINVAL;
+
+	if (!seccomp_check_mode(seccomp_mode))
+		goto out;
+
+	ret = seccomp_attach_user_filter(filter);
+	if (ret)
 		goto out;
-	}
 
 	seccomp_assign_mode(seccomp_mode);
 out:
 	return ret;
 }
+#else
+static inline long seccomp_set_mode_filter(char __user *filter)
+{
+	return -EINVAL;
+}
+#endif
 
 /**
  * prctl_set_seccomp: configures current->seccomp.mode
@@ -541,5 +559,12 @@ out:
  */
 long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 {
-	return seccomp_set_mode(seccomp_mode, filter);
+	switch (seccomp_mode) {
+	case SECCOMP_MODE_STRICT:
+		return seccomp_set_mode_strict();
+	case SECCOMP_MODE_FILTER:
+		return seccomp_set_mode_filter(filter);
+	default:
+		return -EINVAL;
+	}
 }
-- 
1.7.9.5

