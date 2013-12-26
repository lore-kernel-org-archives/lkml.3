Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3LZPxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:53:38 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:53415 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3LZPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:53:37 -0500
Date: Thu, 26 Dec 2013 07:53:34 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info
Message-ID: <20131226155334.GG23355@gmail.com>
References: <20131225165359.GA29550@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <20131225165359.GA29550@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 08:53:59AM -0800, H.J. Lu wrote:
> Both x32 and x86-64 use the same struct shmid64_ds/shminfo64/shm_info for
> system calls.  But x32 long is 32-bit. This patch replaces unsigned long
> with __kernel_ulong_t in struct shmid64_ds/shminfo64/shm_info.
> 

Here is the updated patch which uses __kernel_ulong_t only if
__BITS_PER_LONG == 64. 
 
H.J.

--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0007-Use-__kernel_ulong_t-in-shmid64_ds-shminfo64-shm_inf.patch"

>From 36c74f04735cbb62a33a1c9e8e75350c1b183f1a Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 25 Dec 2013 08:51:50 -0800
Subject: [PATCH] Use __kernel_ulong_t in shmid64_ds/shminfo64/shm_info

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


--JSkcQAAxhB1h8DcT--
