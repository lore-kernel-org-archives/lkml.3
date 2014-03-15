Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaCOFkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:40:32 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58262 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaCOFkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:40:08 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 4/4] arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h
Date: Sat, 15 Mar 2014 14:39:08 +0900
Message-Id: <1394861948-28712-5-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394705491-12343-1-git-send-email-takahiro.akashi@linaro.org>
 <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kernel files may include both linux/compat.h and asm/compat.h directly
or indirectly. Since both header files contain is_compat_task() under
!CONFIG_COMPAT, compiling them with !CONFIG_COMPAT will eventually fail.
Such files include kernel/auditsc.c, kernel/seccomp.c and init/do_mountfs.c
(do_mountfs.c may read asm/compat.h via asm/ftrace.h once ftrace is
implemented).

So this patch proactively
1) removes is_compat_task() under !CONFIG_COMPAT from asm/compat.h
2) replaces asm/compat.h to linux/compat.h in kernel/*.c,
   but asm/compat.h is still necessary in ptrace.c and process.c because
   they use is_compat_thread().

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/compat.h   | 5 -----
 arch/arm64/kernel/hw_breakpoint.c | 2 +-
 arch/arm64/kernel/process.c       | 1 +
 arch/arm64/kernel/ptrace.c        | 1 +
 arch/arm64/kernel/signal.c        | 2 +-
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..3b334f9 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -305,11 +305,6 @@ static inline int is_compat_thread(struct thread_info *thread)
 
 #else /* !CONFIG_COMPAT */
 
-static inline int is_compat_task(void)
-{
-	return 0;
-}
-
 static inline int is_compat_thread(struct thread_info *thread)
 {
 	return 0;
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index f17f581..a45e2db 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -20,6 +20,7 @@
 
 #define pr_fmt(fmt) "hw-breakpoint: " fmt
 
+#include <linux/compat.h>
 #include <linux/cpu_pm.h>
 #include <linux/errno.h>
 #include <linux/hw_breakpoint.h>
@@ -27,7 +28,6 @@
 #include <linux/ptrace.h>
 #include <linux/smp.h>
 
-#include <asm/compat.h>
 #include <asm/current.h>
 #include <asm/debug-monitors.h>
 #include <asm/hw_breakpoint.h>
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1c0a9be..fc8a387 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -20,6 +20,7 @@
 
 #include <stdarg.h>
 
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index f606276..c47a3ed 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -19,6 +19,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591..4a09989 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -17,6 +17,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/compat.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
@@ -25,7 +26,6 @@
 #include <linux/tracehook.h>
 #include <linux/ratelimit.h>
 
-#include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
-- 
1.8.3.2

