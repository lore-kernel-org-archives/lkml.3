Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3AXDbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:31:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3AXDbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:13 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 56/74] audit: create explicit AUDIT_SECCOMP event type
Date: Thu, 24 Jan 2013 01:27:08 -0200
Message-Id: <1358998046-613-57-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 7b9205bd775afc4439ed86d617f9042ee9e76a71 upstream.

The seccomp path was using AUDIT_ANOM_ABEND from when seccomp mode 1
could only kill a process.  While we still want to make sure an audit
record is forced on a kill, this should use a separate record type since
seccomp mode 2 introduces other behaviors.

In the case of "handled" behaviors (process wasn't killed), only emit a
record if the process is under inspection.  This change also fixes
userspace examination of seccomp audit events, since it was considered
malformed due to missing fields of the AUDIT_ANOM_ABEND event type.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Julien Tinnes <jln@google.com>
Acked-by: Will Drewry <wad@chromium.org>
Acked-by: Steve Grubb <sgrubb@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ herton: adjust context, include/uapi/linux/audit.h -> include/linux/audit.h ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/audit.h |    4 +++-
 kernel/auditsc.c      |   14 +++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22f292a..eaa7c9f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -106,6 +106,7 @@
 #define AUDIT_MMAP		1323	/* Record showing descriptor and flags in mmap */
 #define AUDIT_NETFILTER_PKT	1324	/* Packets traversing netfilter chains */
 #define AUDIT_NETFILTER_CFG	1325	/* Netfilter chain modifications */
+#define AUDIT_SECCOMP		1326	/* Secure Computing event */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -510,7 +511,8 @@ void audit_core_dumps(long signr);
 
 static inline void audit_seccomp(unsigned long syscall, long signr, int code)
 {
-	if (unlikely(!audit_dummy_context()))
+	/* Force a record to be reported if a signal was delivered. */
+	if (signr || unlikely(!audit_dummy_context()))
 		__audit_seccomp(syscall, signr, code);
 }
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4b96415..a0ecca4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2670,7 +2670,7 @@ void __audit_mmap_fd(int fd, int flags)
 	context->type = AUDIT_MMAP;
 }
 
-static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
+static void audit_log_task(struct audit_buffer *ab)
 {
 	uid_t auid, uid;
 	gid_t gid;
@@ -2685,6 +2685,11 @@ static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);
+}
+
+static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
+{
+	audit_log_task(ab);
 	audit_log_format(ab, " reason=");
 	audit_log_string(ab, reason);
 	audit_log_format(ab, " sig=%ld", signr);
@@ -2715,8 +2720,11 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 {
 	struct audit_buffer *ab;
 
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
-	audit_log_abend(ab, "seccomp", signr);
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
+	if (unlikely(!ab))
+		return;
+	audit_log_task(ab);
+	audit_log_format(ab, " sig=%ld", signr);
 	audit_log_format(ab, " syscall=%ld", syscall);
 	audit_log_format(ab, " compat=%d", is_compat_task());
 	audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
-- 
1.7.9.5

