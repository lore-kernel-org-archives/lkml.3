Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3KPAYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:24:22 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43716 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3KPAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Michael S. Tsirkin" <mst@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/16] srcu: Add API for barrier after srcu_read_unlock()
Date: Fri, 15 Nov 2013 16:23:34 -0800
Message-Id: <1384561418-30575-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-8236-0000-0000-000003D80E55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

The srcu_read_unlock() implementation currently contains a full memory
barrier, but that has not always been the case and it someday again might
not be the case.  However, given that the memory barrier is there, it is
useful to be able to rely on it.  This commit therefore adds a new
smp_mb__after_srcu_read_unlock() API that, together with a preceding
srcu_read_unlock(), is guaranteed to provide a full barrier.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index c114614ed172..9b058eecd403 100644
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
1.8.1.5

