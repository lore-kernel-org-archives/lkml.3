Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3GXUvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:51:44 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51809
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3GXUvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:51:43 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com, dave@sr71.net
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
Date: Wed, 24 Jul 2013 14:29:59 -0700
Message-Id: <1374701399-30842-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1374701399-30842-1-git-send-email-kys@microsoft.com>
References: <1374701355-30799-1-git-send-email-kys@microsoft.com>
 <1374701399-30842-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverage the newly exported functionality to bring memory online
without involving user level code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2d094cf..c2eec17 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -515,11 +515,6 @@ struct hv_dynmem_device {
 	bool host_specified_ha_region;
 
 	/*
-	 * State to synchronize hot-add.
-	 */
-	struct completion  ol_waitevent;
-	bool ha_waiting;
-	/*
 	 * This thread handles hot-add
 	 * requests from the host as well as notifying
 	 * the host with regards to memory pressure in
@@ -581,9 +576,6 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 
 		has->covered_end_pfn +=  processed_pfn;
 
-		init_completion(&dm_device.ol_waitevent);
-		dm_device.ha_waiting = true;
-
 		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
 				(HA_CHUNK << PAGE_SHIFT));
@@ -606,12 +598,10 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 		}
 
 		/*
-		 * Wait for the memory block to be onlined.
-		 * Since the hot add has succeeded, it is ok to
-		 * proceed even if the pages in the hot added region
-		 * have not been "onlined" within the allowed time.
+		 * Before proceeding to hot add the next segment,
+		 * online the segment that has been hot added.
 		 */
-		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
+		online_memory_block(start_pfn);
 
 	}
 
@@ -625,10 +615,6 @@ static void hv_online_page(struct page *pg)
 	unsigned long cur_start_pgp;
 	unsigned long cur_end_pgp;
 
-	if (dm_device.ha_waiting) {
-		dm_device.ha_waiting = false;
-		complete(&dm_device.ol_waitevent);
-	}
 
 	list_for_each(cur, &dm_device.ha_region_list) {
 		has = list_entry(cur, struct hv_hotadd_state, list);
-- 
1.7.4.1

