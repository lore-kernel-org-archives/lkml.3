Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3I3KOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:14:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3I3KNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 102/104] [SCSI] sd: Fix potential out-of-bounds access
Date: Mon, 30 Sep 2013 11:11:19 +0100
Message-Id: <1380535881-9239-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/sd.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8e18431..68eb46e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2226,14 +2226,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
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
1.8.3.2

