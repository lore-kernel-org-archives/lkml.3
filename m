Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3KFUgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:36:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46590 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3KFUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:36:14 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH] xen/balloon: Set balloon's initial state to number of existing RAM pages
Date: Wed,  6 Nov 2013 15:37:40 -0500
Message-Id: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently balloon's initial value is set to max_pfn which includes
non-RAM ranges such as MMIO hole. As result, initial memory target
(specified by guest's configuration file) will appear smaller than
what balloon driver perceives to be the current number of available
pages. Thus it will balloon down "extra" pages, decreasing amount of
available memory for no good reason.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 drivers/xen/balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index b232908..1b62304 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -641,7 +641,7 @@ static int __init balloon_init(void)
 
 	balloon_stats.current_pages = xen_pv_domain()
 		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
-		: max_pfn;
+		: get_num_physpages();
 	balloon_stats.target_pages  = balloon_stats.current_pages;
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
-- 
1.8.1.4

