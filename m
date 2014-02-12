Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaBMKxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:53:06 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36273 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBMKxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:53:03 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 1/3] staging/lustre/libcfs: remove user space code from kernel_user_comm.c
Date: Wed, 12 Feb 2014 19:21:38 +0800
Message-Id: <1392204100-968-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/libcfs/kernel_user_comm.c        |  102 --------------------
 1 files changed, 0 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c b/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
index 7b2c315..b6ddc99 100644
--- a/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
+++ b/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
@@ -44,106 +44,6 @@
 
 #include <linux/libcfs/libcfs.h>
 
-#ifdef LUSTRE_UTILS
-/* This is the userspace side. */
-
-/** Start the userspace side of a KUC pipe.
- * @param link Private descriptor for pipe/socket.
- * @param groups KUC broadcast group to listen to
- *	  (can be null for unicast to this pid)
- */
-int libcfs_ukuc_start(lustre_kernelcomm *link, int group)
-{
-	int pfd[2];
-
-	if (pipe(pfd) < 0)
-		return -errno;
-
-	memset(link, 0, sizeof(*link));
-	link->lk_rfd = pfd[0];
-	link->lk_wfd = pfd[1];
-	link->lk_group = group;
-	link->lk_uid = getpid();
-	return 0;
-}
-
-int libcfs_ukuc_stop(lustre_kernelcomm *link)
-{
-	if (link->lk_wfd > 0)
-		close(link->lk_wfd);
-	return close(link->lk_rfd);
-}
-
-#define lhsz sizeof(*kuch)
-
-/** Read a message from the link.
- * Allocates memory, returns handle
- *
- * @param link Private descriptor for pipe/socket.
- * @param buf Buffer to read into, must include size for kuc_hdr
- * @param maxsize Maximum message size allowed
- * @param transport Only listen to messages on this transport
- *      (and the generic transport)
- */
-int libcfs_ukuc_msg_get(lustre_kernelcomm *link, char *buf, int maxsize,
-			int transport)
-{
-	struct kuc_hdr *kuch;
-	int rc = 0;
-
-	memset(buf, 0, maxsize);
-
-	CDEBUG(D_KUC, "Waiting for message from kernel on fd %d\n",
-	       link->lk_rfd);
-
-	while (1) {
-		/* Read header first to get message size */
-		rc = read(link->lk_rfd, buf, lhsz);
-		if (rc <= 0) {
-			rc = -errno;
-			break;
-		}
-		kuch = (struct kuc_hdr *)buf;
-
-		CDEBUG(D_KUC, "Received message mg=%x t=%d m=%d l=%d\n",
-		       kuch->kuc_magic, kuch->kuc_transport, kuch->kuc_msgtype,
-		       kuch->kuc_msglen);
-
-		if (kuch->kuc_magic != KUC_MAGIC) {
-			CERROR("bad message magic %x != %x\n",
-			       kuch->kuc_magic, KUC_MAGIC);
-			rc = -EPROTO;
-			break;
-		}
-
-		if (kuch->kuc_msglen > maxsize) {
-			rc = -EMSGSIZE;
-			break;
-		}
-
-		/* Read payload */
-		rc = read(link->lk_rfd, buf + lhsz, kuch->kuc_msglen - lhsz);
-		if (rc < 0) {
-			rc = -errno;
-			break;
-		}
-		if (rc < (kuch->kuc_msglen - lhsz)) {
-			CERROR("short read: got %d of %d bytes\n",
-			       rc, kuch->kuc_msglen);
-			rc = -EPROTO;
-			break;
-		}
-
-		if (kuch->kuc_transport == transport ||
-		    kuch->kuc_transport == KUC_TRANSPORT_GENERIC) {
-			return 0;
-		}
-		/* Drop messages for other transports */
-	}
-	return rc;
-}
-
-#else /* LUSTRE_UTILS */
 /* This is the kernel side (liblustre as well). */
 
 /**
@@ -338,5 +238,3 @@ int libcfs_kkuc_group_foreach(int group, libcfs_kkuc_cb_t cb_func,
 	return rc;
 }
 EXPORT_SYMBOL(libcfs_kkuc_group_foreach);
-
-#endif /* LUSTRE_UTILS */
-- 
1.7.7.6

