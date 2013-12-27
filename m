Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3L0RZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:25:38 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:53223 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3L0RZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:25:34 -0500
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 5/8] Use __kernel_ulong_t in struct msqid64_ds
Date: Fri, 27 Dec 2013 09:25:09 -0800
Message-Id: <1388165112-6545-6-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
References: <1388165112-6545-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x32 and x86-64 use the same struct msqid64_ds for system calls.
But x32 long is 32-bit. This patch replaces unsigned long with
__kernel_ulong_t in struct msqid64_ds if __BITS_PER_LONG == 64.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/asm-generic/msgbuf.h | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/uapi/asm-generic/msgbuf.h b/include/uapi/asm-generic/msgbuf.h
index aec850d..e73766a 100644
--- a/include/uapi/asm-generic/msgbuf.h
+++ b/include/uapi/asm-generic/msgbuf.h
@@ -34,14 +34,23 @@ struct msqid64_ds {
 	__kernel_time_t msg_ctime;	/* last change time */
 #if __BITS_PER_LONG != 64
 	unsigned long	__unused3;
+	unsigned long	msg_cbytes;	/* current number of bytes on queue */
+	unsigned long	msg_qnum;	/* number of messages in queue */
+	unsigned long	msg_qbytes;	/* max number of bytes on queue */
+#else
+	__kernel_ulong_t msg_cbytes;	/* current number of bytes on queue */
+	__kernel_ulong_t msg_qnum;	/* number of messages in queue */
+	__kernel_ulong_t msg_qbytes;	/* max number of bytes on queue */
 #endif
-	unsigned long  msg_cbytes;	/* current number of bytes on queue */
-	unsigned long  msg_qnum;	/* number of messages in queue */
-	unsigned long  msg_qbytes;	/* max number of bytes on queue */
 	__kernel_pid_t msg_lspid;	/* pid of last msgsnd */
 	__kernel_pid_t msg_lrpid;	/* last receive pid */
-	unsigned long  __unused4;
-	unsigned long  __unused5;
+#if __BITS_PER_LONG != 64
+	unsigned long	__unused4;
+	unsigned long	__unused5;
+#else
+	__kernel_ulong_t __unused4;
+	__kernel_ulong_t __unused5;
+#endif
 };
 
 #endif /* __ASM_GENERIC_MSGBUF_H */
-- 
1.8.4.2

