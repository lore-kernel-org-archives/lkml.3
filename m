Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaBSSJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaBSSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:16 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 1/5] audit: move kaudit thread start from auditd registration to kaudit init
Date: Wed, 19 Feb 2014 13:08:19 -0500
Message-Id: <051b7435793f18b45194360662ff2cb17ee5928c.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kauditd_thread() task was started only after the auditd userspace daemon
registers itself with kaudit.  This was fine when only auditd consumed messages
from the kaudit netlink unicast socket.  With the addition of a multicast group
to that socket it is more convenient to have the thread start on init of the
kaudit kernel subsystem.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 34c5a23..b5b2f72 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -768,16 +768,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (err)
 		return err;
 
-	/* As soon as there's any sign of userspace auditd,
-	 * start kauditd to talk to it */
-	if (!kauditd_task) {
-		kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
-		if (IS_ERR(kauditd_task)) {
-			err = PTR_ERR(kauditd_task);
-			kauditd_task = NULL;
-			return err;
-		}
-	}
 	seq  = nlh->nlmsg_seq;
 	data = nlmsg_data(nlh);
 
@@ -1116,6 +1106,11 @@ static int __init audit_init(void)
 	audit_enabled = audit_default;
 	audit_ever_enabled |= !!audit_default;
 
+	kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
+	if (IS_ERR(kauditd_task))
+		printk(KERN_ERR "audit: error starting kauditd_thread (%ld)\n",
+			PTR_ERR(kauditd_task));
+
 	audit_log(NULL, GFP_KERNEL, AUDIT_KERNEL, "initialized");
 
 	for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
-- 
1.7.1

