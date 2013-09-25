Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3IYAsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:48:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab3IYAT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 010/117] SCSI: sd: Fix potential out-of-bounds access
Date: Tue, 24 Sep 2013 17:17:56 -0700
Message-Id: <20130925001741.988849176@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2419,14 +2419,9 @@ sd_read_cache_type(struct scsi_disk *sdk
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


