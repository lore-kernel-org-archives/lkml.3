Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaJHJN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:13:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:34535 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754434AbaJHJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:13:30 -0400
X-IronPort-AV: E=Sophos;i="5.04,676,1406563200"; 
   d="scan'208";a="36951470"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [PATCH RFC] setns: return 0 directly if try to reassociate with current namespace
Date: Wed, 8 Oct 2014 17:13:07 +0800
Message-ID: <1412759587-21320-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could use setns to join the current ns,
which did a lot of unnecessary work.
This patch will check this senario and
return 0 directly.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 kernel/nsproxy.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index ef42d0a..66eea63 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -236,6 +236,34 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	ops = ei->ns_ops;
 	if (nstype && (ops->type != nstype))
 		goto out;
+	switch (ops->type) {
+	case CLONE_NEWIPC:
+		if (ei->ns == tsk->nsproxy->ipc_ns)
+			return 0;
+		break;
+	case CLONE_NEWNET:
+		if (ei->ns == tsk->nsproxy->net_ns)
+			return 0;
+		break;
+	case CLONE_NEWNS:
+		if (ei->ns == tsk->nsproxy->mnt_ns)
+			return 0;
+		break;
+	case CLONE_NEWPID:
+		if (ei->ns == tsk->nsproxy->pid_ns_for_children)
+			return 0;
+		break;
+	case CLONE_NEWUSER:
+		if (ei->ns == current_user_ns())
+			return 0;
+		break;
+	case CLONE_NEWUTS:
+		if (ei->ns == tsk->nsproxy->uts_ns)
+			return 0;
+		break;
+	default:
+		goto out;
+	}
 
 	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
 	if (IS_ERR(new_nsproxy)) {
-- 
1.9.0

