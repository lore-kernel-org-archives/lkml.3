Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbbAOWKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:10:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 17/19] userns: Don't allow unprivileged creation of gid mappings
Date: Thu, 15 Jan 2015 14:09:53 -0800
Message-Id: <1421359795-11155-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit be7c6dba2332cef0677fbabb606e279ae76652c3 upstream.

As any gid mapping will allow and must allow for backwards
compatibility dropping groups don't allow any gid mappings to be
established without CAP_SETGID in the parent user namespace.

For a small class of applications this change breaks userspace
and removes useful functionality.  This small class of applications
includes tools/testing/selftests/mount/unprivilged-remount-test.c

Most of the removed functionality will be added back with the addition
of a one way knob to disable setgroups.  Once setgroups is disabled
setting the gid_map becomes as safe as setting the uid_map.

For more common applications that set the uid_map and the gid_map
with privilege this change will have no affect.

This is part of a fix for CVE-2014-8989.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/user_namespace.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a12b44f..8ee5170 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -816,11 +816,6 @@ static bool new_idmap_permitted(const struct file *file,
 			if (uid_eq(uid, cred->euid))
 				return true;
 		}
-		else if (cap_setid == CAP_SETGID) {
-			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, file->f_cred->fsgid))
-				return true;
-		}
 	}
 
 	/* Allow anyone to set a mapping that doesn't require privilege */
-- 
1.9.1

