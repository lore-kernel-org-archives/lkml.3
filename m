Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398Ab3E2RM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:12:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:3690 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965002Ab3E2RMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:12:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="345207771"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: fix read after read scenario
Date: Wed, 29 May 2013 20:09:30 +0300
Message-Id: <1369847371-31140-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei read always has to be preceded by write but
'write write read read' scenario should work as well.
In this case the offset is not zero but new read should
be initiated

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index b9ad510..5e11b5b 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -214,19 +214,21 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		goto out;
 	}
 
-	if (cl->read_cb && cl->read_cb->buf_idx > *offset) {
-		cb = cl->read_cb;
-		goto copy_buffer;
-	} else if (cl->read_cb && cl->read_cb->buf_idx > 0 &&
-		   cl->read_cb->buf_idx <= *offset) {
+	if (cl->read_cb) {
 		cb = cl->read_cb;
-		rets = 0;
-		goto free;
-	} else if ((!cl->read_cb || !cl->read_cb->buf_idx) && *offset > 0) {
-		/*Offset needs to be cleaned for contiguous reads*/
+		/* read what left */
+		if (cb->buf_idx > *offset)
+			goto copy_buffer;
+		/* offset is beyond buf_idx we have no more data return 0 */
+		if (cb->buf_idx > 0 && cb->buf_idx <= *offset) {
+			rets = 0;
+			goto free;
+		}
+		/* Offset needs to be cleaned for contiguous reads*/
+		if (cb->buf_idx == 0 && *offset > 0)
+			*offset = 0;
+	} else if (*offset > 0) {
 		*offset = 0;
-		rets = 0;
-		goto out;
 	}
 
 	err = mei_cl_read_start(cl, length);
-- 
1.8.1.2

