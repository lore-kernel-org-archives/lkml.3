Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab3EFVOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:14:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab3EFUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Copeland <bob@cozybit.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 020/115] mac80211: use synchronize_rcu() with rcu_barrier()
Date: Mon,  6 May 2013 13:44:16 -0700
Message-Id: <20130506203057.643359431@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 8ceb59557bdc373e532b87d4142ce27e04218f0e upstream.

The RCU docs used to state that rcu_barrier() included a wait
for an RCU grace period; however the comments for rcu_barrier()
as of commit f0a0e6f... "rcu: Clarify memory-ordering properties
of grace-period primitives" contradict this.

So add back synchronize_{rcu,net}() to where they once were,
but keep the rcu_barrier()s for the call_rcu() callbacks.

Signed-off-by: Bob Copeland <bob@cozybit.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c   |    1 +
 net/mac80211/iface.c |    5 +++--
 net/mac80211/pm.c    |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1034,6 +1034,7 @@ static int ieee80211_stop_ap(struct wiph
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		sta_info_flush_defer(vlan);
 	sta_info_flush_defer(sdata);
+	synchronize_net();
 	rcu_barrier();
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		sta_info_flush_cleanup(vlan);
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -844,11 +844,12 @@ static void ieee80211_do_stop(struct iee
 		 *
 		 * sta_info_flush_cleanup() requires rcu_barrier()
 		 * first to wait for the station call_rcu() calls
-		 * to complete, here we need at least sychronize_rcu()
-		 * it to wait for the RX path in case it is using the
+		 * to complete, and we also need synchronize_rcu()
+		 * to wait for the RX path in case it is using the
 		 * interface and enqueuing frames at this very time on
 		 * another CPU.
 		 */
+		synchronize_rcu();
 		rcu_barrier();
 		sta_info_flush_cleanup(sdata);
 
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -54,6 +54,7 @@ int __ieee80211_suspend(struct ieee80211
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
 	/* flush out all packets and station cleanup call_rcu()s */
+	synchronize_net();
 	rcu_barrier();
 
 	drv_flush(local, false);


