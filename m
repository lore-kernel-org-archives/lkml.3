Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3KNQqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:46:55 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49844 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab3KNQo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:44:57 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 23/26] staging/lustre/seq: make seq_proc_write_common() safer
Date: Fri, 15 Nov 2013 00:43:10 +0800
Message-Id: <1384447393-13838-24-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

Don't allow seq_proc_write_common() to specify arbitrary ranges,
since this can permanently corrupt the sequence controller and/or
sequnece server.  That would allow duplicate FID allocation, or
possibly prevent any new files to be created or servers to be added
to the filesystem.

Instead, limit the sequence range that can be written via /proc to
a subset of the sequence range currently allocated to that node.
Add the "clear" keyword to allow dropping the entire local sequence
and force a new one to be fetched from the sequence server.

Lustre-change: http://review.whamcloud.com/7123
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3642
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |   14 ++++++++++----
 .../lustre/lustre/include/lustre/lustre_idl.h      |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index 294070d..befa12f 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -56,22 +56,28 @@
 
 #ifdef LPROCFS
 /*
- * Note: this function is only used for testing, it is no safe for production
- * use.
+ * Reduce the SEQ range allocated to a node to a strict subset of the range
+ * currently-allocated SEQ range.  If the specified range is "clear", then
+ * drop all allocated sequences and request a new one from the master.
+ *
+ * Note: this function should only be used for testing, it is not necessarily
+ * safe for production use.
  */
 static int
 lprocfs_fid_write_common(const char *buffer, unsigned long count,
 			 struct lu_seq_range *range)
 {
-	struct lu_seq_range tmp;
+	struct lu_seq_range tmp = { 0, };
 	int rc;
 
 	LASSERT(range != NULL);
 
+	/* of the form "[0x0000000240000400 - 0x000000028000400]" */
 	rc = sscanf(buffer, "[%llx - %llx]\n",
 		    (long long unsigned *)&tmp.lsr_start,
 		    (long long unsigned *)&tmp.lsr_end);
-	if (rc != 2 || !range_is_sane(&tmp) || range_is_zero(&tmp))
+	if (!range_is_sane(&tmp) || range_is_zero(&tmp) ||
+	    tmp.lsr_start < range->lsr_start || tmp.lsr_end > range->lsr_end)
 		return -EINVAL;
 	*range = tmp;
 	return 0;
diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 15ae8e8..f7dcfe8 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -264,7 +264,7 @@ static inline __u64 range_space(const struct lu_seq_range *range)
 
 static inline void range_init(struct lu_seq_range *range)
 {
-	range->lsr_start = range->lsr_end = range->lsr_index = 0;
+	memset(range, 0, sizeof(*range));
 }
 
 /**
-- 
1.7.9.5

