Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaGKISe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:18:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:54122 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaGKISc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:18:32 -0400
Subject: [PATCH] mm/page-writeback.c: fix divide by zero in bdi_dirty_limits
To: akpm@linux-foundation.org
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, mhocko@suse.cz,
        linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, jweiner@redhat.com
Date: Fri, 11 Jul 2014 12:18:27 +0400
Message-ID: <20140711081656.15654.19946.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under memory pressure, it is possible for dirty_thresh, calculated by
global_dirty_limits() in balance_dirty_pages(), to equal zero. Then, if
strictlimit is true, bdi_dirty_limits() tries to resolve the proportion:

  bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh

by dividing by zero.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 518e2c3..e0c9430 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1306,9 +1306,9 @@ static inline void bdi_dirty_limits(struct backing_dev_info *bdi,
 	*bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
 
 	if (bdi_bg_thresh)
-		*bdi_bg_thresh = div_u64((u64)*bdi_thresh *
-					 background_thresh,
-					 dirty_thresh);
+		*bdi_bg_thresh = dirty_thresh ? div_u64((u64)*bdi_thresh *
+							background_thresh,
+							dirty_thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need

