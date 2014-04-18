Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaDRAYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:24:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48658 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaDRAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:24:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v3 2/5] seccomp: create locked helper for setting mode
Date: Thu, 17 Apr 2014 17:24:17 -0700
Message-Id: <1397780660-24750-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397780660-24750-1-git-send-email-keescook@chromium.org>
References: <1397780660-24750-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For multiple mode-setting callers, we will need a helper to perform the
sanity-checking and finalization logic while the seccomp lock is held.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 6d61a0b5080c..440dc2c213ac 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -462,26 +462,11 @@ long prctl_get_seccomp(void)
 	return current->seccomp.mode;
 }
 
-/**
- * prctl_set_seccomp: configures current->seccomp.mode
- * @seccomp_mode: requested mode to use
- * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
- *
- * This function may be called repeatedly with a @seccomp_mode of
- * SECCOMP_MODE_FILTER to install additional filters.  Every filter
- * successfully installed will be evaluated (in reverse order) for each system
- * call the task makes.
- *
- * Once current->seccomp.mode is non-zero, it may not be changed.
- *
- * Returns 0 on success or -EINVAL on failure.
- */
-long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+/* Expects to be called under seccomp lock. */
+static long _seccomp_set_mode(unsigned long seccomp_mode, char * __user filter)
 {
 	long ret = -EINVAL;
 
-	seccomp_lock(current);
-
 	if (current->seccomp.mode &&
 	    current->seccomp.mode != seccomp_mode)
 		goto out;
@@ -507,6 +492,29 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 	current->seccomp.mode = seccomp_mode;
 	set_thread_flag(TIF_SECCOMP);
 out:
+	return ret;
+}
+
+/**
+ * prctl_set_seccomp: configures current->seccomp.mode
+ * @seccomp_mode: requested mode to use
+ * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
+ *
+ * This function may be called repeatedly with a @seccomp_mode of
+ * SECCOMP_MODE_FILTER to install additional filters.  Every filter
+ * successfully installed will be evaluated (in reverse order) for each system
+ * call the task makes.
+ *
+ * Once current->seccomp.mode is non-zero, it may not be changed.
+ *
+ * Returns 0 on success or -EINVAL on failure.
+ */
+long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
+{
+	long ret;
+
+	seccomp_lock(current);
+	ret = _seccomp_set_mode(seccomp_mode, filter);
 	seccomp_unlock(current);
 	return ret;
 }
-- 
1.7.9.5

