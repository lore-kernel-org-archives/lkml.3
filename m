Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbaAXFcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:32:16 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44284 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaAXFbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:55 -0500
X-Greylist: delayed 2738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 00:31:40 EST
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>,
        "Christopher J. Morrone" <morrone2@llnl.gov>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 4/5] lustre: Correct KUC code max changelog msg size
Date: Thu, 23 Jan 2014 23:45:07 -0500
Message-Id: <1390538708-4120-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel to userspace communication routines (KUC) allocate
and limit the maximum cs_buf size to CR_MAXSIZE.  However this
fails to account for the fact that the buffer is assumed to begin
with a struct kuc_hdr.  To allocate and account for that space,
we introduce a new define, KUC_CHANGELOG_MSG_MAXSIZE.

Signed-off-by: Christopher J. Morrone <morrone2@llnl.gov>
Reviewed-on: http://review.whamcloud.com/7406
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3587
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h | 2 ++
 drivers/staging/lustre/lustre/mdc/mdc_request.c                 | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
index 596a15f..037ae8a 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
@@ -61,6 +61,8 @@ struct kuc_hdr {
 	__u16 kuc_msglen;     /* Including header */
 } __attribute__((aligned(sizeof(__u64))));
 
+#define KUC_CHANGELOG_MSG_MAXSIZE (sizeof(struct kuc_hdr)+CR_MAXSIZE)
+
 #define KUC_MAGIC  0x191C /*Lustre9etLinC */
 #define KUC_FL_BLOCK 0x01   /* Wait for send */
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
index d1ad91c3..8301392 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
@@ -1430,7 +1430,7 @@ static struct kuc_hdr *changelog_kuc_hdr(char *buf, int len, int flags)
 {
 	struct kuc_hdr *lh = (struct kuc_hdr *)buf;
 
-	LASSERT(len <= CR_MAXSIZE);
+	LASSERT(len <= KUC_CHANGELOG_MSG_MAXSIZE);
 
 	lh->kuc_magic = KUC_MAGIC;
 	lh->kuc_transport = KUC_TRANSPORT_CHANGELOG;
@@ -1503,7 +1503,7 @@ static int mdc_changelog_send_thread(void *csdata)
 	CDEBUG(D_CHANGELOG, "changelog to fp=%p start "LPU64"\n",
 	       cs->cs_fp, cs->cs_startrec);
 
-	OBD_ALLOC(cs->cs_buf, CR_MAXSIZE);
+	OBD_ALLOC(cs->cs_buf, KUC_CHANGELOG_MSG_MAXSIZE);
 	if (cs->cs_buf == NULL)
 		GOTO(out, rc = -ENOMEM);
 
@@ -1540,7 +1540,7 @@ out:
 	if (ctxt)
 		llog_ctxt_put(ctxt);
 	if (cs->cs_buf)
-		OBD_FREE(cs->cs_buf, CR_MAXSIZE);
+		OBD_FREE(cs->cs_buf, KUC_CHANGELOG_MSG_MAXSIZE);
 	OBD_FREE_PTR(cs);
 	return rc;
 }
-- 
1.8.5.3

