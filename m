Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaD0RVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:21:25 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48025 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaD0RID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:03 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bobi Jam <bobijam.xu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 20/47] staging/lustre/llite: issue OST_SYNC for fsync()
Date: Sun, 27 Apr 2014 13:06:44 -0400
Message-Id: <1398618431-29757-21-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bobi Jam <bobijam.xu@intel.com>

The last parameter @datasync of fsync() has following indication:
* if datasync=0, we'd always flush data and metadata
* if datasync=1, we'd always flush data while does not flush modifed
  metadata unless that metadata is needed in order to allow a
  subsequent data retrieval to be correctly handled. For example, a
  change to the file size would require a metadata flush.

Lustre client can not tell the difference easily, and would issue
MDS_SYNC and OST_SYNC in all cases.

Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-on: http://review.whamcloud.com/8684
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4388
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index c991ea5..872c878 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2653,7 +2653,7 @@ int ll_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (!err)
 		ptlrpc_req_finished(req);
 
-	if (datasync && S_ISREG(inode->i_mode)) {
+	if (S_ISREG(inode->i_mode)) {
 		struct ll_file_data *fd = LUSTRE_FPRIVATE(file);
 
 		err = cl_sync_file_range(inode, 0, OBD_OBJECT_EOF,
-- 
1.8.5.3

