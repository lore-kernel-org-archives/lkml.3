Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbbAGRjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:39:36 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:57935 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbbAGRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:39:19 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: Combine DEFINE_SRCU() and DEFINE_STATIC_SRCU()
Date: Wed,  7 Jan 2015 09:39:07 -0800
Message-Id: <1420652348-3867-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420652348-3867-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107173842.GA3240@linux.vnet.ibm.com>
 <1420652348-3867-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-8236-0000-0000-0000086A1892
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The DEFINE_SRCU() and DEFINE_STATIC_SRCU() definitions are quite
similar, so this commit combines them, saving a bit of code and removing
redundancy.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/srcu.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index ef923dd96249..9cfd9623fb03 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -102,13 +102,11 @@ void process_srcu(struct work_struct *work);
  * define and init a srcu struct at build time.
  * dont't call init_srcu_struct() nor cleanup_srcu_struct() on it.
  */
-#define DEFINE_SRCU(name)						\
+#define __DEFINE_SRCU(name, is_static)					\
 	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
-	struct srcu_struct name = __SRCU_STRUCT_INIT(name);
-
-#define DEFINE_STATIC_SRCU(name)					\
-	static DEFINE_PER_CPU(struct srcu_struct_array, name##_srcu_array);\
-	static struct srcu_struct name = __SRCU_STRUCT_INIT(name);
+	is_static struct srcu_struct name = __SRCU_STRUCT_INIT(name)
+#define DEFINE_SRCU(name)		__DEFINE_SRCU(name, /* not static */)
+#define DEFINE_STATIC_SRCU(name)	__DEFINE_SRCU(name, static)
 
 /**
  * call_srcu() - Queue a callback for invocation after an SRCU grace period
-- 
1.8.1.5

