Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3CRVSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:18:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36717 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3CRVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:18:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        Steven Whitehouse <swhiteho@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/7] rcu: Fix hlist_bl_set_first_rcu() annotation
Date: Mon, 18 Mar 2013 14:16:54 -0700
Message-Id: <1363641416-18642-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130318211615.GA15814@linux.vnet.ibm.com>
 <1363641416-18642-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031821-7282-0000-0000-00001543FEAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Abhi noticed that we were getting a complaint from the RCU subsystem
about access of an RCU protected list under the write side bit lock.
This commit adds additional annotation to check both the RCU read
lock and the write side bit lock before printing a message.

Reported by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Tested-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/list_bl.h    | 5 +++++
 include/linux/rculist_bl.h | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

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
-- 
1.8.1.5

