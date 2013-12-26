Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3LZPwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:52:08 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:37693 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3LZPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:52:07 -0500
Date: Thu, 26 Dec 2013 07:52:03 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_ulong_t in struct msqid64_ds
Message-ID: <20131226155203.GF23355@gmail.com>
References: <20131225160807.GA32441@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
In-Reply-To: <20131225160807.GA32441@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 08:08:07AM -0800, H.J. Lu wrote:
> Both x32 and x86-64 use the same struct msqid64_ds for system calls.
> But x32 long is 32-bit. This patch replaces unsigned long with
> __kernel_ulong_t in struct msqid64_ds.
> 

Here is the updated patch which uses __kernel_ulong_t only if
__BITS_PER_LONG == 64. 
 
H.J.

--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0005-Use-__kernel_ulong_t-in-struct-msqid64_ds.patch"

>From 018f0c350f4a38bb238deb632b79dc909b9490a7 Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 25 Dec 2013 08:05:12 -0800
Subject: [PATCH] Use __kernel_ulong_t in struct msqid64_ds

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


--G6nVm6DDWH/FONJq--
