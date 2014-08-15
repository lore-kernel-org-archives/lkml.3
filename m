Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaHOQsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:40 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41223 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaHOQsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:37 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Nathaniel Clark <nathaniel.l.clark@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 01/10] staging/lustre/llite: check for integer overflow in hsm user request
Date: Fri, 15 Aug 2014 12:48:06 -0400
Message-Id: <1408121295-29115-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Clark <nathaniel.l.clark@intel.com>

Check to make sure total size of request does not overflow when
calculated.  Return -1 from hur_len() if it does overflow.

Signed-off-by: Nathaniel Clark <nathaniel.l.clark@intel.com>
Reviewed-on: http://review.whamcloud.com/10615
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4984
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_user.h     | 23 +++++++++++++++++-----
 drivers/staging/lustre/lustre/llite/dir.c          |  4 +++-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
index a69b27a..4c1b3cb 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_user.h
@@ -997,12 +997,25 @@ static inline void *hur_data(struct hsm_user_request *hur)
 	return &(hur->hur_user_item[hur->hur_request.hr_itemcount]);
 }
 
-/** Compute the current length of the provided hsm_user_request. */
-static inline int hur_len(struct hsm_user_request *hur)
+/**
+ * Compute the current length of the provided hsm_user_request.  This returns -1
+ * instead of an errno because ssize_t is defined to be only [ -1, SSIZE_MAX ]
+ *
+ * return -1 on bounds check error.
+ */
+static inline ssize_t hur_len(struct hsm_user_request *hur)
 {
-	return offsetof(struct hsm_user_request,
-			hur_user_item[hur->hur_request.hr_itemcount]) +
-		hur->hur_request.hr_data_len;
+	__u64	size;
+
+	/* can't overflow a __u64 since hr_itemcount is only __u32 */
+	size = offsetof(struct hsm_user_request, hur_user_item[0]) +
+		(__u64)hur->hur_request.hr_itemcount *
+		sizeof(hur->hur_user_item[0]) + hur->hur_request.hr_data_len;
+
+	if (size != (ssize_t)size)
+		return -1;
+
+	return size;
 }
 
 /****** HSM RPCs to copytool *****/
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index efa2faf..de5892c 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1787,7 +1787,7 @@ out_quotactl:
 		return ll_fid2path(inode, (void *)arg);
 	case LL_IOC_HSM_REQUEST: {
 		struct hsm_user_request	*hur;
-		int			 totalsize;
+		ssize_t			 totalsize;
 
 		OBD_ALLOC_PTR(hur);
 		if (hur == NULL)
@@ -1802,6 +1802,8 @@ out_quotactl:
 		/* Compute the whole struct size */
 		totalsize = hur_len(hur);
 		OBD_FREE_PTR(hur);
+		if (totalsize < 0)
+			return -E2BIG;
 
 		/* Final size will be more than double totalsize */
 		if (totalsize >= MDS_MAXREQSIZE / 3)
-- 
1.9.3

