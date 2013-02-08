Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947380Ab3BHX3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:29:42 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40475
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947333Ab3BHX3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:29:30 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: hv: balloon: Add a parameter to delay pressure reporting
Date: Fri,  8 Feb 2013 15:57:15 -0800
Message-Id: <1360367836-3495-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360367805-3451-1-git-send-email-kys@microsoft.com>
References: <1360367805-3451-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delay reporting memory pressure by a specified amount of time.
This addresses the problem where the host may take memory balancing
decisions based on incorrect memory pressure data that will be posted
as soon as the balloon driver is loaded.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 32a96f1..f8fc996 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -414,10 +414,17 @@ struct dm_info_msg {
 
 static bool hot_add;
 static bool do_hot_add;
+/*
+ * Delay reporting memory pressure by
+ * the specified number of seconds.
+ */
+static uint pressure_report_delay = 30;
 
 module_param(hot_add, bool, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");
 
+module_param(pressure_report_delay, uint, (S_IRUGO | S_IWUSR));
+MODULE_PARM_DESC(pressure_report_delay, "Delay in secs in reporting pressure");
 static atomic_t trans_id = ATOMIC_INIT(0);
 
 static int dm_ring_size = (5 * PAGE_SIZE);
@@ -531,6 +538,10 @@ static void post_status(struct hv_dynmem_device *dm)
 	struct dm_status status;
 	struct sysinfo val;
 
+	if (pressure_report_delay > 0) {
+		--pressure_report_delay;
+		return;
+	}
 	si_meminfo(&val);
 	memset(&status, 0, sizeof(struct dm_status));
 	status.hdr.type = DM_STATUS_REPORT;
@@ -552,8 +563,6 @@ static void post_status(struct hv_dynmem_device *dm)
 
 }
 
-
-
 static void free_balloon_pages(struct hv_dynmem_device *dm,
 			 union dm_mem_page_range *range_array)
 {
-- 
1.7.4.1

