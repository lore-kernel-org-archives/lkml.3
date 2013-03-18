Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3CRChm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:37:42 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60745
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3CRChk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:37:40 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: Notify the host of permanent hot-add failures
Date: Sun, 17 Mar 2013 20:07:47 -0700
Message-Id: <1363576067-30758-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory hot-add fails with the error -EEXIST, then this is a permanent
failure. Notify the host this information, so the host will not attempt
hot-add again. If the failure were a transient failure, host will attempt
a hot-add after some delay.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 71655b4..d2ed673 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -583,6 +583,16 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 
 		if (ret) {
 			pr_info("hot_add memory failed error is %d\n", ret);
+			if (ret == -EEXIST) {
+				/*
+				 * This error indicates that the error
+				 * is not a transient failure. This is the
+				 * case where the guest's physical address map
+				 * precludes hot adding memory. Stop all further
+				 * memory hot-add.
+				 */
+				do_hot_add = false;
+			}
 			has->ha_end_pfn -= HA_CHUNK;
 			has->covered_end_pfn -=  processed_pfn;
 			break;
@@ -842,11 +852,14 @@ static void hot_add_req(struct work_struct *dummy)
 		rg_sz = region_size;
 	}
 
-	resp.page_count = process_hot_add(pg_start, pfn_cnt,
-					rg_start, rg_sz);
+	if (do_hot_add)
+		resp.page_count = process_hot_add(pg_start, pfn_cnt,
+						rg_start, rg_sz);
 #endif
 	if (resp.page_count > 0)
 		resp.result = 1;
+	else if (!do_hot_add)
+		resp.result = 1;
 	else
 		resp.result = 0;
 
-- 
1.7.4.1

