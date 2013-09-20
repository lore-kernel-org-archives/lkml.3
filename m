Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3ITUMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:12:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3ITUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:12:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 88/93] [SCSI] sd: Fix potential out-of-bounds access
Date: Fri, 20 Sep 2013 13:09:23 -0700
Message-Id: <1379707768-1804-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 984f1733fcee3fbc78d47e26c5096921c5d9946a upstream.

This patch fixes an out-of-bounds error in sd_read_cache_type(), found
by Google's AddressSanitizer tool.  When the loop ends, we know that
"offset" lies beyond the end of the data in the buffer, so no Caching
mode page was found.  In theory it may be present, but the buffer size
is limited to 512 bytes.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/sd.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1dcdc3..bc108d2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2421,14 +2421,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			}
 		}
 
-		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
-				  "present\n");
-			goto defaults;
-		} else if ((buffer[offset] & 0x3f) != modepage) {
-			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
-			goto defaults;
-		}
+		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		goto defaults;
+
 	Page_found:
 		if (modepage == 8) {
 			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
-- 
1.8.1.2

