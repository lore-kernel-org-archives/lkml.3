Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947370Ab3BHX3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:29:31 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51129
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760373Ab3BHX3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:29:30 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: hv: balloon: Prevent the host from ballooning the guest too low
Date: Fri,  8 Feb 2013 15:57:16 -0800
Message-Id: <1360367836-3495-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360367836-3495-1-git-send-email-kys@microsoft.com>
References: <1360367805-3451-1-git-send-email-kys@microsoft.com>
 <1360367836-3495-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the amount of memory being managed set a floor on how low the
guest can be ballooned.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index f8fc996..3787321 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -523,6 +523,34 @@ static void process_info(struct hv_dynmem_device *dm, struct dm_info_msg *msg)
 	}
 }
 
+unsigned long compute_balloon_floor(void)
+{
+	unsigned long min_pages;
+#define MB2PAGES(mb) ((mb) << (20 - PAGE_SHIFT))
+	/* Simple continuous piecewiese linear function:
+	 *  max MiB -> min MiB  gradient
+	 *       0         0
+	 *      16        16
+	 *      32        24
+	 *     128        72    (1/2)
+	 *     512       168    (1/4)
+	 *    2048       360    (1/8)
+	 *    8192       552    (1/32)
+	 *   32768      1320
+	 *  131072      4392
+	 */
+	if (totalram_pages < MB2PAGES(128))
+		min_pages = MB2PAGES(8) + (totalram_pages >> 1);
+	else if (totalram_pages < MB2PAGES(512))
+		min_pages = MB2PAGES(40) + (totalram_pages >> 2);
+	else if (totalram_pages < MB2PAGES(2048))
+		min_pages = MB2PAGES(104) + (totalram_pages >> 3);
+	else
+		min_pages = MB2PAGES(296) + (totalram_pages >> 5);
+#undef MB2PAGES
+	return min_pages;
+}
+
 /*
  * Post our status as it relates memory pressure to the
  * host. Host expects the guests to post this status
@@ -552,9 +580,14 @@ static void post_status(struct hv_dynmem_device *dm)
 	 * The host expects the guest to report free memory.
 	 * Further, the host expects the pressure information to
 	 * include the ballooned out pages.
+	 * For a given amount of memory that we are managing, we
+	 * need to compute a floor below which we should not balloon.
+	 * Compute this and add it to the pressure report.
 	 */
 	status.num_avail = val.freeram;
-	status.num_committed = vm_memory_committed() + dm->num_pages_ballooned;
+	status.num_committed = vm_memory_committed() +
+				dm->num_pages_ballooned +
+				compute_balloon_floor();
 
 	vmbus_sendpacket(dm->dev->channel, &status,
 				sizeof(struct dm_status),
-- 
1.7.4.1

