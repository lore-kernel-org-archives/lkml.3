Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3L0RZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:25:41 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:61989 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3L0RZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:25:35 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 7/8] Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
Date: Fri, 27 Dec 2013 09:25:11 -0800
Message-Id: <1388165112-6545-8-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct shmid64_ds/shminfo64/shm_info for
system calls.  But x32 long is 32-bit. This patch replaces unsigned long
with __kernel_ulong_t in struct shmid64_ds/shminfo64/shm_info if
__BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/asm-generic/shmbuf.h | 36 +++++++++++++++++++++++++++---------
 include/uapi/linux/shm.h          | 14 +++++++++++---
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-generic/shmbuf.h
index 5768fa6..c5d9d34 100644
--- a/include/uapi/asm-generic/shmbuf.h
+++ b/include/uapi/asm-generic/shmbuf.h
@@ -39,21 +39,39 @@ struct shmid64_ds {
 #endif
 	__kernel_pid_t		shm_cpid;	/* pid of creator */
 	__kernel_pid_t		shm_lpid;	/* pid of last operator */
+#if __BITS_PER_LONG != 64
 	unsigned long		shm_nattch;	/* no. of current attaches */
 	unsigned long		__unused4;
 	unsigned long		__unused5;
+#else
+	__kernel_ulong_t	shm_nattch;	/* no. of current attaches */
+	__kernel_ulong_t	__unused4;
+	__kernel_ulong_t	__unused5;
+#endif
 };
 
 struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
+#if __BITS_PER_LONG != 64
+	unsigned long		shmmax;
+	unsigned long		shmmin;
+	unsigned long		shmmni;
+	unsigned long		shmseg;
+	unsigned long		shmall;
+	unsigned long		__unused1;
+	unsigned long		__unused2;
+	unsigned long		__unused3;
+	unsigned long		__unused4;
+#else
+	__kernel_ulong_t	shmmax;
+	__kernel_ulong_t	shmmin;
+	__kernel_ulong_t	shmmni;
+	__kernel_ulong_t	shmseg;
+	__kernel_ulong_t	shmall;
+	__kernel_ulong_t	__unused1;
+	__kernel_ulong_t	__unused2;
+	__kernel_ulong_t	__unused3;
+	__kernel_ulong_t	__unused4;
+#endif
 };
 
 #endif /* __ASM_GENERIC_SHMBUF_H */
diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index ec36fa1..970d255 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -68,11 +68,19 @@ struct	shminfo {
 
 struct shm_info {
 	int used_ids;
-	unsigned long shm_tot;	/* total allocated shm */
-	unsigned long shm_rss;	/* total resident shm */
-	unsigned long shm_swp;	/* total swapped shm */
+#if __BITS_PER_LONG == 64
+	__kernel_ulong_t shm_tot;	/* total allocated shm */
+	__kernel_ulong_t shm_rss;	/* total resident shm */
+	__kernel_ulong_t shm_swp;	/* total swapped shm */
+	__kernel_ulong_t swap_attempts;
+	__kernel_ulong_t swap_successes;
+#else
+	unsigned long shm_tot;		/* total allocated shm */
+	unsigned long shm_rss;		/* total resident shm */
+	unsigned long shm_swp;		/* total swapped shm */
 	unsigned long swap_attempts;
 	unsigned long swap_successes;
+#endif
 };
 
 
-- 
1.8.4.2

