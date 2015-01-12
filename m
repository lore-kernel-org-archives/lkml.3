Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbbALSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:09:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbALSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 110/216] userns: Only allow the creator of the userns unprivileged mappings
Date: Mon, 12 Jan 2015 18:03:47 +0000
Message-Id: <1421085933-32536-111-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/user_namespace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 16b716e8184c..48ba6d8af564 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,14 +812,16 @@ static bool new_idmap_permitted(const struct file *file,
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
2.1.4

