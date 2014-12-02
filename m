Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbaLBTVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:21:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaLBTVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:21:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 071/121] parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls
Date: Tue,  2 Dec 2014 11:19:10 -0800
Message-Id: <1417548000-1794-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 2fe749f50b0bec07650ef135b29b1f55bf543869 upstream.

Switch over the msgctl, shmat, shmctl and semtimedop syscalls to use the compat
layer. The problem was found with the debian procenv package, which called
	shmctl(0, SHM_INFO, &info);
in which the shmctl syscall then overwrote parts of the surrounding areas on
the stack on which the info variable was stored and thus lead to a segfault
later on.

Additionally fix the definition of struct shminfo64 to use unsigned longs like
the other architectures. This has no impact on userspace since we only have a
32bit userspace up to now.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/parisc/include/uapi/asm/shmbuf.h | 25 +++++++++----------------
 arch/parisc/kernel/syscall_table.S    |  8 ++++----
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/parisc/include/uapi/asm/shmbuf.h b/arch/parisc/include/uapi/asm/shmbuf.h
index 0a3eada..f395cde 100644
--- a/arch/parisc/include/uapi/asm/shmbuf.h
+++ b/arch/parisc/include/uapi/asm/shmbuf.h
@@ -36,23 +36,16 @@ struct shmid64_ds {
 	unsigned int		__unused2;
 };
 
-#ifdef CONFIG_64BIT
-/* The 'unsigned int' (formerly 'unsigned long') data types below will
- * ensure that a 32-bit app calling shmctl(*,IPC_INFO,*) will work on
- * a wide kernel, but if some of these values are meant to contain pointers
- * they may need to be 'long long' instead. -PB XXX FIXME
- */
-#endif
 struct shminfo64 {
-	unsigned int	shmmax;
-	unsigned int	shmmin;
-	unsigned int	shmmni;
-	unsigned int	shmseg;
-	unsigned int	shmall;
-	unsigned int	__unused1;
-	unsigned int	__unused2;
-	unsigned int	__unused3;
-	unsigned int	__unused4;
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
 };
 
 #endif /* _PARISC_SHMBUF_H */
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index 486a600..ddc0597 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -286,11 +286,11 @@
 	ENTRY_COMP(msgsnd)
 	ENTRY_COMP(msgrcv)
 	ENTRY_SAME(msgget)		/* 190 */
-	ENTRY_SAME(msgctl)
-	ENTRY_SAME(shmat)
+	ENTRY_COMP(msgctl)
+	ENTRY_COMP(shmat)
 	ENTRY_SAME(shmdt)
 	ENTRY_SAME(shmget)
-	ENTRY_SAME(shmctl)		/* 195 */
+	ENTRY_COMP(shmctl)		/* 195 */
 	ENTRY_SAME(ni_syscall)		/* streams1 */
 	ENTRY_SAME(ni_syscall)		/* streams2 */
 	ENTRY_SAME(lstat64)
@@ -323,7 +323,7 @@
 	ENTRY_SAME(epoll_ctl)		/* 225 */
 	ENTRY_SAME(epoll_wait)
  	ENTRY_SAME(remap_file_pages)
-	ENTRY_SAME(semtimedop)
+	ENTRY_COMP(semtimedop)
 	ENTRY_COMP(mq_open)
 	ENTRY_SAME(mq_unlink)		/* 230 */
 	ENTRY_COMP(mq_timedsend)
-- 
1.9.1

