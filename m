Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbbA2CwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:52:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965530AbbA2CiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 112/139] userns: Allow setting gid_maps without privilege when setgroups is disabled
Date: Wed, 28 Jan 2015 14:20:55 -0800
Message-Id: <1422483682-15393-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 66d2f338ee4c449396b6f99f5e75cd18eb6df272 upstream.

Now that setgroups can be disabled and not reenabled, setting gid_map
without privielge can now be enabled when setgroups is disabled.

This restores most of the functionality that was lost when unprivileged
setting of gid_map was removed.  Applications that use this functionality
will need to check to see if they use setgroups or init_groups, and if they
don't they can be fixed by simply disabling setgroups before writing to
gid_map.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/user_namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index d03d490..722bd12 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -818,6 +818,11 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, cred->euid))
 				return true;
+		} else if (cap_setid == CAP_SETGID) {
+			kgid_t gid = make_kgid(ns->parent, id);
+			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
+			    gid_eq(gid, cred->egid))
+				return true;
 		}
 	}
 
-- 
1.9.1

