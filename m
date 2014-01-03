Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaACDMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:12:07 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:52771 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaACDLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:11:47 -0500
Message-ID: <52C62A55.4070901@huawei.com>
Date: Fri, 3 Jan 2014 11:11:17 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <jhs@mojatatu.com>, David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [RFC PATCH net-next 4/4] cls_cgroup: restore classid from skb->sk_classid
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if skb->sk is NULL, we can try to restore from skb->bk_classid,
because we may have saved it.

Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 net/sched/cls_cgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index d228a5d..6ab0e69 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -141,9 +141,10 @@ static int cls_cgroup_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	 */
 	if (in_serving_softirq()) {
 		/* If there is an sk_classid we'll use that. */
-		if (!skb->sk)
-			return -1;
-		classid = skb->sk->sk_classid;
+		if (skb->sk)
+			classid = skb->sk->sk_classid;
+		else
+			classid = skb->backup_classid;
 	}

 	if (!classid)
-- 
1.8.2.2


