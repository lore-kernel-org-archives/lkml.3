Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbbAOWNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:13:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 08/19] userns: Only allow the creator of the userns unprivileged mappings
Date: Thu, 15 Jan 2015 14:09:44 -0800
Message-Id: <1421359795-11155-9-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/user_namespace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 1ae8d2c..30a5362 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -804,14 +804,16 @@ static bool new_idmap_permitted(const struct file *file,
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
 		else if (cap_setid == CAP_SETGID) {
-- 
1.9.1

