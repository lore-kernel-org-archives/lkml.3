Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbaACDLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:11:45 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:52651 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaACDLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:11:44 -0500
Message-ID: <52C62A4D.5010000@huawei.com>
Date: Fri, 3 Jan 2014 11:11:09 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <jhs@mojatatu.com>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <ebiederm@xmission.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [RFC PATCH net-next 2/4] cls_cgroup: introduce a helper: bk_cls_classid()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it can save classid from skb->sk->sk_classid
to skb->bk_classid

Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 include/net/cls_cgroup.h | 11 +++++++++++
 net/sched/cls_cgroup.c   |  1 -
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index 33d03b6..4249ea3 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -16,6 +16,7 @@
 #include <linux/cgroup.h>
 #include <linux/hardirq.h>
 #include <linux/rcupdate.h>
+#include <net/sock.h>

 #if IS_ENABLED(CONFIG_NET_CLS_CGROUP)
 struct cgroup_cls_state
@@ -26,6 +27,12 @@ struct cgroup_cls_state

 void sock_update_classid(struct sock *sk);

+static inline void bk_cls_classid(struct sk_buff *skb)
+{
+	if (skb->sk && skb->sk->sk_classid)
+		skb->backup_classid = skb->sk->sk_classid;
+}
+
 #if IS_BUILTIN(CONFIG_NET_CLS_CGROUP)
 static inline u32 task_cls_classid(struct task_struct *p)
 {
@@ -61,6 +68,10 @@ static inline u32 task_cls_classid(struct task_struct *p)
 }
 #endif
 #else /* !CGROUP_NET_CLS_CGROUP */
+static inline void bk_cls_classid(struct sk_buff *skb)
+{
+}
+
 static inline void sock_update_classid(struct sock *sk)
 {
 }
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index f9d21258..d228a5d 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -20,7 +20,6 @@
 #include <linux/fdtable.h>
 #include <net/rtnetlink.h>
 #include <net/pkt_cls.h>
-#include <net/sock.h>
 #include <net/cls_cgroup.h>

 static inline struct cgroup_cls_state *css_cls_state(struct cgroup_subsys_state *css)
-- 
1.8.2.2


