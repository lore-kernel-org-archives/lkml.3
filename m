Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaHOQsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:48:45 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41235 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaHOQsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:43 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: "John L. Hammond" <john.hammond@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 06/10] staging/lustre/llite: hold inode mutex around ll_setattr_raw()
Date: Fri, 15 Aug 2014 12:48:11 -0400
Message-Id: <1408121295-29115-7-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

ll_setattr_raw() expects to be called with the inode mutex held so do
when calling it from ll_hsm_import().

Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-on: http://review.whamcloud.com/11349
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5456
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Faccini Bruno <bruno.faccini@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index fd1b75a3..084fb92 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2116,10 +2116,14 @@ static int ll_hsm_import(struct inode *inode, struct file *file,
 			 ATTR_MTIME | ATTR_MTIME_SET |
 			 ATTR_ATIME | ATTR_ATIME_SET;
 
+	mutex_lock(&inode->i_mutex);
+
 	rc = ll_setattr_raw(file->f_dentry, attr, true);
 	if (rc == -ENODATA)
 		rc = 0;
 
+	mutex_unlock(&inode->i_mutex);
+
 out:
 	if (hss != NULL)
 		OBD_FREE_PTR(hss);
-- 
1.9.3

