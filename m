Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaHTMLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:11:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58886 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Maxim Patlasov <MPatlasov@parallels.com>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/104] mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()
Date: Wed, 20 Aug 2014 13:42:31 +0200
Message-Id: <c5fec566bef6a027e75c84c35ec970482eb88cea.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Patlasov <MPatlasov@parallels.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f6789593d5cea42a4ecb1cbeab6a23ade5ebbba7 upstream.

Under memory pressure, it is possible for dirty_thresh, calculated by
global_dirty_limits() in balance_dirty_pages(), to equal zero.  Then, if
strictlimit is true, bdi_dirty_limits() tries to resolve the proportion:

  bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh

by dividing by zero.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/page-writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d013dba21429..9f45f87a5859 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1324,9 +1324,9 @@ static inline void bdi_dirty_limits(struct backing_dev_info *bdi,
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
-- 
2.0.4

