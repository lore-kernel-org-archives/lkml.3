Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3LLQy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:54:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45677 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3LLQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:48 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 8/9] userns: Known exploit detection for CVE-2013-1959
Date: Thu, 12 Dec 2013 17:52:31 +0100
Message-Id: <1386867152-24072-8-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See 6708075f104c3c9b04b23336bb0366ca30c3931b and
e3211c120a85b792978bcb4be7b2886df18d27f0.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 kernel/user_namespace.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 13fb113..df7a51a 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -22,6 +22,7 @@
 #include <linux/ctype.h>
 #include <linux/projid.h>
 #include <linux/fs_struct.h>
+#include <linux/exploit.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 
@@ -806,11 +807,15 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
+
+			exploit_on(uid_eq(uid, current_fsuid()), "CVE-2013-1959");
 		}
 		else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
 			if (gid_eq(gid, file->f_cred->fsgid))
 				return true;
+
+			exploit_on(gid_eq(gid, current_fsgid()), "CVE-2013-1959");
 		}
 	}
 
@@ -822,9 +827,12 @@ static bool new_idmap_permitted(const struct file *file,
 	 * (CAP_SETUID or CAP_SETGID) over the parent user namespace.
 	 * And the opener of the id file also had the approprpiate capability.
 	 */
-	if (ns_capable(ns->parent, cap_setid) &&
-	    file_ns_capable(file, ns->parent, cap_setid))
-		return true;
+	if (ns_capable(ns->parent, cap_setid)) {
+		if (file_ns_capable(file, ns->parent, cap_setid))
+			return true;
+
+		exploit("CVE-2013-1959");
+	}
 
 	return false;
 }
-- 
1.7.10.4

