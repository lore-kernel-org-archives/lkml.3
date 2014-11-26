Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaKZHbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:31:05 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65140 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaKZHbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:31:04 -0500
From: Zahari Doychev <zahari.doychev@linux.com>
To: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, joe@perches.com
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com
Subject: [PATCH v2] staging: lustre: fix pointer declarations
Date: Wed, 26 Nov 2014 08:30:55 +0100
Message-Id: <65e982457eeb4763d791b08287b311f94417ec6e.1416986684.git.zahari.doychev@linux.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes pointer declarations from void * to void __user * in order
to remove some sparse warnings. The patch also enables again commented named
initializers for the iovec structures. The corrected pointers are used in
these structures as field member values.

lib-lnet.h:798:48: warning: incorrect type in initializer (different address spaces)
lib-lnet.h:798:48:    expected void [noderef] <asn:1>*iov_base
lib-lnet.h:798:48:    got void *dest
lib-lnet.h:787:47: warning: incorrect type in initializer (different address spaces)
lib-lnet.h:787:47:    expected void [noderef] <asn:1>*iov_base
lib-lnet.h:787:47:    got void *dest
lib-lnet.h:819:48: warning: incorrect type in initializer (different address spaces)
lib-lnet.h:819:48:    expected void [noderef] <asn:1>*iov_base
lib-lnet.h:819:48:    got void *src
lib-lnet.h:808:47: warning: incorrect type in initializer (different address spaces)
lib-lnet.h:808:47:    expected void [noderef] <asn:1>*iov_base
lib-lnet.h:808:47:    got void *src

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 drivers/staging/lustre/include/linux/lnet/lib-lnet.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
index 7e89b3b..c07fb04 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
@@ -780,22 +780,22 @@ void lnet_copy_kiov2kiov(unsigned int ndkiov, lnet_kiov_t *dkiov,
 			  unsigned int soffset, unsigned int nob);
 
 static inline void
-lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
+lnet_copy_iov2flat(int dlen, void __user *dest, unsigned int doffset,
 		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
 		   unsigned int nob)
 {
-	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
+	struct iovec diov = {.iov_base = dest, .iov_len = dlen};
 
 	lnet_copy_iov2iov(1, &diov, doffset,
 			  nsiov, siov, soffset, nob);
 }
 
 static inline void
-lnet_copy_kiov2flat(int dlen, void *dest, unsigned int doffset,
+lnet_copy_kiov2flat(int dlen, void __user *dest, unsigned int doffset,
 		    unsigned int nsiov, lnet_kiov_t *skiov,
 		    unsigned int soffset, unsigned int nob)
 {
-	struct iovec diov = {/* .iov_base = */ dest, /* .iov_len = */ dlen};
+	struct iovec diov = {.iov_base = dest, .iov_len = dlen};
 
 	lnet_copy_kiov2iov(1, &diov, doffset,
 			   nsiov, skiov, soffset, nob);
@@ -803,9 +803,10 @@ lnet_copy_kiov2flat(int dlen, void *dest, unsigned int doffset,
 
 static inline void
 lnet_copy_flat2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
-		   int slen, void *src, unsigned int soffset, unsigned int nob)
+		   int slen, void __user *src, unsigned int soffset,
+		   unsigned int nob)
 {
-	struct iovec siov = {/*.iov_base = */ src, /*.iov_len = */slen};
+	struct iovec siov = {.iov_base = src, .iov_len = slen};
 
 	lnet_copy_iov2iov(ndiov, diov, doffset,
 			  1, &siov, soffset, nob);
@@ -813,10 +814,10 @@ lnet_copy_flat2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
 
 static inline void
 lnet_copy_flat2kiov(unsigned int ndiov, lnet_kiov_t *dkiov,
-		    unsigned int doffset, int slen, void *src,
+		    unsigned int doffset, int slen, void __user *src,
 		    unsigned int soffset, unsigned int nob)
 {
-	struct iovec siov = {/* .iov_base = */ src, /* .iov_len = */ slen};
+	struct iovec siov = {.iov_base = src, .iov_len = slen};
 
 	lnet_copy_iov2kiov(ndiov, dkiov, doffset,
 			   1, &siov, soffset, nob);
-- 
2.1.0

