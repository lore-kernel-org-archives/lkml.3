Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3JKXSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:18:22 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59088 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3JKXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:17:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 tip/core/rcu 04/14] wireless: Apply ACCESS_ONCE() to avoid sparse false positive
Date: Fri, 11 Oct 2013 16:17:21 -0700
Message-Id: <1381533451-29018-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381533451-29018-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131011231659.GA28062@linux.vnet.ibm.com>
 <1381533451-29018-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101123-9332-0000-0000-000001BD30DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The sparse checking for rcu_assign_pointer() was recently upgraded
to reject non-__kernel address spaces.  This also rejects __rcu,
which is almost always the right thing to do.  However, the uses in
cfg80211_combine_bsses() and cfg80211_bss_update() are legitimate:
They are assigning a pointer to an element from an RCU-protected list,
and all elements of this list are already visible to caller.

This commit therefore silences these false positives by laundering
the pointers using ACCESS_ONCE() as suggested by Eric Dumazet and Josh
Triplett.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
---
 net/wireless/scan.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index eeb71480f1af..ac3a47abf195 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -670,8 +670,8 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
 		list_add(&bss->hidden_list, &new->hidden_list);
 		bss->pub.hidden_beacon_bss = &new->pub;
 		new->refcount += bss->refcount;
-		rcu_assign_pointer(bss->pub.beacon_ies,
-				   new->pub.beacon_ies);
+		/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
+		ACCESS_ONCE(bss->pub.beacon_ies) = new->pub.beacon_ies;
 	}
 
 	return true;
@@ -705,11 +705,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 			old = rcu_access_pointer(found->pub.proberesp_ies);
 
-			rcu_assign_pointer(found->pub.proberesp_ies,
-					   tmp->pub.proberesp_ies);
+			/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
+			ACCESS_ONCE(found->pub.proberesp_ies) =
+					   tmp->pub.proberesp_ies;
 			/* Override possible earlier Beacon frame IEs */
-			rcu_assign_pointer(found->pub.ies,
-					   tmp->pub.proberesp_ies);
+			/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
+			ACCESS_ONCE(found->pub.ies) = tmp->pub.proberesp_ies;
 			if (old)
 				kfree_rcu((struct cfg80211_bss_ies *)old,
 					  rcu_head);
@@ -739,13 +740,14 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 			old = rcu_access_pointer(found->pub.beacon_ies);
 
-			rcu_assign_pointer(found->pub.beacon_ies,
-					   tmp->pub.beacon_ies);
+			/* Both --rcu and visible, so ACCESS_ONCE() is OK. */
+			ACCESS_ONCE(found->pub.beacon_ies) = tmp->pub.beacon_ies;
 
 			/* Override IEs if they were from a beacon before */
 			if (old == rcu_access_pointer(found->pub.ies))
-				rcu_assign_pointer(found->pub.ies,
-						   tmp->pub.beacon_ies);
+				/* Both --rcu & visible, ACCESS_ONCE() is OK. */
+				ACCESS_ONCE(found->pub.ies) =
+						   tmp->pub.beacon_ies;
 
 			/* Assign beacon IEs to all sub entries */
 			list_for_each_entry(bss, &found->hidden_list,
@@ -755,8 +757,9 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				ies = rcu_access_pointer(bss->pub.beacon_ies);
 				WARN_ON(ies != old);
 
-				rcu_assign_pointer(bss->pub.beacon_ies,
-						   tmp->pub.beacon_ies);
+				/* Both --rcu & visible, ACCESS_ONCE() is OK. */
+				ACCESS_ONCE(bss->pub.beacon_ies) =
+						   tmp->pub.beacon_ies;
 			}
 
 			if (old)
@@ -803,8 +806,9 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				list_add(&new->hidden_list,
 					 &hidden->hidden_list);
 				hidden->refcount++;
-				rcu_assign_pointer(new->pub.beacon_ies,
-						   hidden->pub.beacon_ies);
+				/* Both --rcu & visible, ACCESS_ONCE() is OK. */
+				ACCESS_ONCE(new->pub.beacon_ies) =
+						   hidden->pub.beacon_ies;
 			}
 		} else {
 			/*
-- 
1.8.1.5

