Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab3A3TJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:09:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab3A3TJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:09:14 -0500
Subject: rcu: fix hlist_bl_set_first_rcu annotation
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, adas@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 30 Jan 2013 19:07:57 +0000
Message-ID: <1359572877.2719.50.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Abhi noticed that we were getting a complaint from the RCU subsystem
about access of an RCU protected list under the write side bit lock.
This patch adds additional annotation to check both the RCU read
lock and the write side bit lock before printing a message.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Abhijith Das <adas@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 31f9d75..2eb8855 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -125,6 +125,11 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 	__bit_spin_unlock(0, (unsigned long *)b);
 }
 
+static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
+{
+	return bit_spin_is_locked(0, (unsigned long *)b);
+}
+
 /**
  * hlist_bl_for_each_entry	- iterate over list of given type
  * @tpos:	the type * to use as a loop cursor.
diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
index cf1244f..4f216c5 100644
--- a/include/linux/rculist_bl.h
+++ b/include/linux/rculist_bl.h
@@ -20,7 +20,7 @@ static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
 static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
 {
 	return (struct hlist_bl_node *)
-		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
+		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
 }
 
 /**


