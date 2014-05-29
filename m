Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbaE2FIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:08:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaE2Efu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cwang@twopensource.com>
Subject: [PATCH 3.14 128/140] rtnetlink: wait for unregistering devices in rtnl_link_unregister()
Date: Wed, 28 May 2014 21:34:27 -0700
Message-Id: <20140529043105.830777770@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cwang@twopensource.com>

[ Upstream commit 200b916f3575bdf11609cb447661b8d5957b0bbf ]

From: Cong Wang <cwang@twopensource.com>

commit 50624c934db18ab90 (net: Delay default_device_exit_batch until no
devices are unregistering) introduced rtnl_lock_unregistering() for
default_device_exit_batch(). Same race could happen we when rmmod a driver
which calls rtnl_link_unregister() as we call dev->destructor without rtnl
lock.

For long term, I think we should clean up the mess of netdev_run_todo()
and net namespce exit code.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rtnetlink.h |    5 +++++
 net/core/dev.c            |    2 +-
 net/core/net_namespace.c  |    2 +-
 net/core/rtnetlink.c      |   33 ++++++++++++++++++++++++++++++++-
 4 files changed, 39 insertions(+), 3 deletions(-)

--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -4,6 +4,7 @@
 
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/wait.h>
 #include <uapi/linux/rtnetlink.h>
 
 extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
@@ -22,6 +23,10 @@ extern void rtnl_lock(void);
 extern void rtnl_unlock(void);
 extern int rtnl_trylock(void);
 extern int rtnl_is_locked(void);
+
+extern wait_queue_head_t netdev_unregistering_wq;
+extern struct mutex net_mutex;
+
 #ifdef CONFIG_PROVE_LOCKING
 extern int lockdep_rtnl_is_held(void);
 #else
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5573,7 +5573,7 @@ static int dev_new_index(struct net *net
 
 /* Delayed registration/unregisteration */
 static LIST_HEAD(net_todo_list);
-static DECLARE_WAIT_QUEUE_HEAD(netdev_unregistering_wq);
+DECLARE_WAIT_QUEUE_HEAD(netdev_unregistering_wq);
 
 static void net_set_todo(struct net_device *dev)
 {
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -24,7 +24,7 @@
 
 static LIST_HEAD(pernet_list);
 static struct list_head *first_device = &pernet_list;
-static DEFINE_MUTEX(net_mutex);
+DEFINE_MUTEX(net_mutex);
 
 LIST_HEAD(net_namespace_list);
 EXPORT_SYMBOL_GPL(net_namespace_list);
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -353,15 +353,46 @@ void __rtnl_link_unregister(struct rtnl_
 }
 EXPORT_SYMBOL_GPL(__rtnl_link_unregister);
 
+/* Return with the rtnl_lock held when there are no network
+ * devices unregistering in any network namespace.
+ */
+static void rtnl_lock_unregistering_all(void)
+{
+	struct net *net;
+	bool unregistering;
+	DEFINE_WAIT(wait);
+
+	for (;;) {
+		prepare_to_wait(&netdev_unregistering_wq, &wait,
+				TASK_UNINTERRUPTIBLE);
+		unregistering = false;
+		rtnl_lock();
+		for_each_net(net) {
+			if (net->dev_unreg_count > 0) {
+				unregistering = true;
+				break;
+			}
+		}
+		if (!unregistering)
+			break;
+		__rtnl_unlock();
+		schedule();
+	}
+	finish_wait(&netdev_unregistering_wq, &wait);
+}
+
 /**
  * rtnl_link_unregister - Unregister rtnl_link_ops from rtnetlink.
  * @ops: struct rtnl_link_ops * to unregister
  */
 void rtnl_link_unregister(struct rtnl_link_ops *ops)
 {
-	rtnl_lock();
+	/* Close the race with cleanup_net() */
+	mutex_lock(&net_mutex);
+	rtnl_lock_unregistering_all();
 	__rtnl_link_unregister(ops);
 	rtnl_unlock();
+	mutex_unlock(&net_mutex);
 }
 EXPORT_SYMBOL_GPL(rtnl_link_unregister);
 


