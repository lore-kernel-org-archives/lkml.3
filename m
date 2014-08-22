Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaHVNPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:15:00 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57846 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaHVNO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:14:59 -0400
Date: Fri, 22 Aug 2014 16:14:49 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] mac80211: scan: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822131449.GA19959@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f40661e..6c69d09 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1058,7 +1058,7 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 	if (rcu_access_pointer(local->sched_scan_sdata)) {
 		ret = drv_sched_scan_stop(local, sdata);
 		if (!ret)
-			rcu_assign_pointer(local->sched_scan_sdata, NULL);
+			RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
 	}
 out:
 	mutex_unlock(&local->mtx);
-- 
1.9.1

