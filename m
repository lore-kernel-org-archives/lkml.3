Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3IKFhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:37:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab3IKE5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:17 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=c5b1vsMxWQ0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9yoJ-Scg7icA:10 a=20KFwNOVAAAA:8 a=SOq6UgPBAAAA:8 a=Z4Rwk6OoAAAA:8 a=AZF5JrWoaULxW49VbHwA:9 a=jEp0ucaQiEUA:10 a=5y_flRe8UpcA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042918.199607552@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>
Subject: [155/251] userns: limit the maximum depth of user_namespace->parent chain
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0155-userns-limit-the-maximum-depth-of-user_namespace-par.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 8742f229b635bf1c1c84a3dfe5e47c814c20b5c8 ]

Ensure that user_namespace->parent chain can't grow too much.
Currently we use the hardroded 32 as limit.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/user_namespace.h |    1 +
 kernel/user_namespace.c        |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 4e72922..4eea4ce 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -22,6 +22,7 @@ struct user_namespace {
 	struct uid_gid_map	gid_map;
 	struct kref		kref;
 	struct user_namespace	*parent;
+	int			level;
 	kuid_t			owner;
 	kgid_t			group;
 };
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a74dc5b..5242e83 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -39,6 +39,9 @@ int create_user_ns(struct cred *new)
 	kuid_t owner = new->euid;
 	kgid_t group = new->egid;
 
+	if (parent_ns->level > 32)
+		return -EUSERS;
+
 	/*
 	 * Verify that we can not violate the policy of which files
 	 * may be accessed that is specified by the root directory,
@@ -62,6 +65,7 @@ int create_user_ns(struct cred *new)
 
 	kref_init(&ns->kref);
 	ns->parent = parent_ns;
+	ns->level = parent_ns->level + 1;
 	ns->owner = owner;
 	ns->group = group;
 
-- 
1.7.10.4


