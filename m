Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbbAIKkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44570 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757466AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 62/78] userns: Only allow the creator of the userns unprivileged mappings
Date: Fri,  9 Jan 2015 11:32:11 +0100
Message-Id: <42eec84f58cde5309a5dd770c42f3e364f05f3e0.1420799385.git.jslaby@suse.cz>
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

commit f95d7918bd1e724675de4940039f2865e5eec5fe upstream.

If you did not create the user namespace and are allowed
to write to uid_map or gid_map you should already have the necessary
privilege in the parent user namespace to establish any mapping
you want so this will not affect userspace in practice.

Limiting unprivileged uid mapping establishment to the creator of the
user namespace makes it easier to verify all credentials obtained with
the uid mapping can be obtained without the uid mapping without
privilege.

Limiting unprivileged gid mapping establishment (which is temporarily
absent) to the creator of the user namespace also ensures that the
combination of uid and gid can already be obtained without privilege.

This is part of the fix for CVE-2014-8989.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 6e495bd672a7..c2ca6c01e575 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -798,14 +798,16 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
+	const struct cred *cred = file->f_cred;
 	/* Don't allow mappings that would allow anything that wouldn't
 	 * be allowed without the establishment of unprivileged mappings.
 	 */
-	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
+	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
+	    uid_eq(ns->owner, cred->euid)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->euid))
+			if (uid_eq(uid, cred->euid))
 				return true;
 		}
 	}
-- 
2.2.1

