Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3GWSTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:19:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55674 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab3GWSTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:19:06 -0400
Date: Tue, 23 Jul 2013 13:18:53 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: ebiederm@xmission.com
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] capabilities: allow nice if we are privileged
Message-ID: <20130723181853.GA7005@sergelap>
References: <20130723181606.GA6342@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723181606.GA6342@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allow task A to change B's nice level if it has a supserset of
B's privileges, or of it has CAP_SYS_NICE.  Also allow it if A has
CAP_SYS_NICE with respect to B - meaning it is root in the same
namespace, or it created B's namespace.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 security/commoncap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index d78b003..ef98b56 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -768,16 +768,16 @@ int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
  */
 static int cap_safe_nice(struct task_struct *p)
 {
-	int is_subset;
+	int is_subset, ret = 0;
 
 	rcu_read_lock();
 	is_subset = cap_issubset(__task_cred(p)->cap_permitted,
 				 current_cred()->cap_permitted);
+	if (!is_subset && !ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE))
+		ret = -EPERM;
 	rcu_read_unlock();
 
-	if (!is_subset && !capable(CAP_SYS_NICE))
-		return -EPERM;
-	return 0;
+	return ret;
 }
 
 /**
-- 
1.7.9.5

