Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbaD3JyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:54:07 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64732 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaD3JyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:54:03 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: will.deacon@arm.com
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v6 4/4] arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h
Date: Wed, 30 Apr 2014 18:51:32 +0900
Message-Id: <1398851492-16345-5-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394861948-28712-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851492-16345-1-git-send-email-takahiro.akashi@linaro.org>
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

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/compat.h   |    5 -----
 arch/arm64/kernel/hw_breakpoint.c |    2 +-
 arch/arm64/kernel/process.c       |    1 +
 arch/arm64/kernel/ptrace.c        |    1 +
 arch/arm64/kernel/signal.c        |    2 +-
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index e71f81f..253e33b 100644
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
index bee7897..df1cf15 100644
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
index 6391485..ccc2a3e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -20,6 +20,7 @@
 
 #include <stdarg.h>
 
+#include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6d666dc..4b58e81 100644
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
1.7.9.5

