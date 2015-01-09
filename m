Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbbAIKkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:19 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44569 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757475AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 60/78] userns: Don't allow unprivileged creation of gid mappings
Date: Fri,  9 Jan 2015 11:32:09 +0100
Message-Id: <c75f0d0b9621f9654fcfb7cab7d7c13ed3898f3d.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 048bb7b641a9..a5809c42a1b3 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -808,11 +808,6 @@ static bool new_idmap_permitted(const struct file *file,
 			if (uid_eq(uid, file->f_cred->fsuid))
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
2.2.1

