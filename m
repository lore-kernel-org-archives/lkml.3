Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3DWWMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:12:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3DWVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 32/42] userns: Dont let unprivileged users trick privileged users into setting the id_map
Date: Tue, 23 Apr 2013 14:52:30 -0700
Message-Id: <20130423215208.750031063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 6708075f104c3c9b04b23336bb0366ca30c3931b upstream.

When we require privilege for setting /proc/<pid>/uid_map or
/proc/<pid>/gid_map no longer allow an unprivileged user to
open the file and pass it to a privileged program to write
to the file.

Instead when privilege is required require both the opener and the
writer to have the necessary capabilities.

I have tested this code and verified that setting /proc/<pid>/uid_map
fails when an unprivileged user opens the file and a privielged user
attempts to set the mapping, that unprivileged users can still map
their own id, and that a privileged users can still setup an arbitrary
mapping.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -25,7 +25,8 @@
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 
-static bool new_idmap_permitted(struct user_namespace *ns, int cap_setid,
+static bool new_idmap_permitted(const struct file *file,
+				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *map);
 
 static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
@@ -666,7 +667,7 @@ static ssize_t map_write(struct file *fi
 
 	ret = -EPERM;
 	/* Validate the user is allowed to use user id's mapped to. */
-	if (!new_idmap_permitted(ns, cap_setid, &new_map))
+	if (!new_idmap_permitted(file, ns, cap_setid, &new_map))
 		goto out;
 
 	/* Map the lower ids from the parent user namespace to the
@@ -753,7 +754,8 @@ ssize_t proc_projid_map_write(struct fil
 			 &ns->projid_map, &ns->parent->projid_map);
 }
 
-static bool new_idmap_permitted(struct user_namespace *ns, int cap_setid,
+static bool new_idmap_permitted(const struct file *file,
+				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
 	/* Allow mapping to your own filesystem ids */
@@ -777,8 +779,10 @@ static bool new_idmap_permitted(struct u
 
 	/* Allow the specified ids if we have the appropriate capability
 	 * (CAP_SETUID or CAP_SETGID) over the parent user namespace.
+	 * And the opener of the id file also had the approprpiate capability.
 	 */
-	if (ns_capable(ns->parent, cap_setid))
+	if (ns_capable(ns->parent, cap_setid) &&
+	    file_ns_capable(file, ns->parent, cap_setid))
 		return true;
 
 	return false;


