Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbaKSWSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:18:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaKSUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 3.17 084/141] parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls
Date: Wed, 19 Nov 2014 12:51:47 -0800
Message-Id: <20141119205153.420478739@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/uapi/asm/shmbuf.h |   25 +++++++++----------------
 arch/parisc/kernel/syscall_table.S    |    8 ++++----
 2 files changed, 13 insertions(+), 20 deletions(-)

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


