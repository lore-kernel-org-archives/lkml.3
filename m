Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbbALSGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbbALSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 108/216] userns: Don't allow unprivileged creation of gid mappings
Date: Mon, 12 Jan 2015 18:03:45 +0000
Message-Id: <1421085933-32536-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/user_namespace.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 397d7b1e5f40..b96763a25a68 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -821,10 +821,6 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
-		} else if (cap_setid == CAP_SETGID) {
-			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, file->f_cred->fsgid))
-				return true;
 		}
 	}
 
-- 
2.1.4

