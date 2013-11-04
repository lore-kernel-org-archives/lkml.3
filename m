Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3KDUeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:34:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3KDUeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:34:14 -0500
Date: Mon, 4 Nov 2013 22:36:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] srcu: API for barrier after srcu read unlock
Message-ID: <1383592884-2535-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

srcu read lock/unlock include a full memory barrier
but that's an implementation detail.
Add an API for make memory fencing explicit for
users that need this barrier, to make sure we
can change it as needed without breaking all users.

Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/srcu.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index c114614..9b058ee 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -237,4 +237,18 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__srcu_read_unlock(sp, idx);
 }
 
+/**
+ * smp_mb__after_srcu_read_unlock - ensure full ordering after srcu_read_unlock
+ *
+ * Converts the preceding srcu_read_unlock into a two-way memory barrier.
+ *
+ * Call this after srcu_read_unlock, to guarantee that all memory operations
+ * that occur after smp_mb__after_srcu_read_unlock will appear to happen after
+ * the preceding srcu_read_unlock.
+ */
+static inline void smp_mb__after_srcu_read_unlock(void)
+{
+	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
+}
+
 #endif
-- 
MST

