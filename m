Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879Ab3DCJsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:48:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab3DCJsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:48:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,400,1363104000"; 
   d="scan'208";a="6995581"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] audit: don't check if kauditd is valid everytime
Date: Wed, 3 Apr 2013 17:38:15 +0800
Message-Id: <1364981895-3125-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/03 17:40:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/03 17:47:10,
	Serialize complete at 2013/04/03 17:47:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need to check if kauditd is valid after we start
it, if kauditd is invalid, we will set kauditd_task to NULL.
So next time, we will start kauditd again.

It means if kauditd_task is not NULL,it must be valid.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d596e53..9816a1b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -660,14 +660,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	/* As soon as there's any sign of userspace auditd,
 	 * start kauditd to talk to it */
-	if (!kauditd_task)
+	if (!kauditd_task) {
 		kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
-	if (IS_ERR(kauditd_task)) {
-		err = PTR_ERR(kauditd_task);
-		kauditd_task = NULL;
-		return err;
+		if (IS_ERR(kauditd_task)) {
+			err = PTR_ERR(kauditd_task);
+			kauditd_task = NULL;
+			return err;
+		}
 	}
-
 	loginuid = audit_get_loginuid(current);
 	sessionid = audit_get_sessionid(current);
 	security_task_getsecid(current, &sid);
-- 
1.7.11.7

