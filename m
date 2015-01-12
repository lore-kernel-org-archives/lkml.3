Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbbALSJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:09:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbbALSGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 111/216] userns: Rename id_map_mutex to userns_state_mutex
Date: Mon, 12 Jan 2015 18:03:48 +0000
Message-Id: <1421085933-32536-112-git-send-email-luis.henriques@canonical.com>
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

commit f0d62aec931e4ae3333c797d346dc4f188f454ba upstream.

Generalize id_map_mutex so it can be used for more state of a user namespace.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/user_namespace.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 48ba6d8af564..d3981e7fabab 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/fs_struct.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
+static DEFINE_MUTEX(userns_state_mutex);
 
 static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
@@ -583,9 +584,6 @@ static bool mappings_overlap(struct uid_gid_map *new_map,
 	return false;
 }
 
-
-static DEFINE_MUTEX(id_map_mutex);
-
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -602,7 +600,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	ssize_t ret = -EINVAL;
 
 	/*
-	 * The id_map_mutex serializes all writes to any given map.
+	 * The userns_state_mutex serializes all writes to any given map.
 	 *
 	 * Any map is only ever written once.
 	 *
@@ -620,7 +618,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 * order and smp_rmb() is guaranteed that we don't have crazy
 	 * architectures returning stale data.
 	 */
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
@@ -750,7 +748,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	*ppos = count;
 	ret = count;
 out:
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 	if (page)
 		free_page(page);
 	return ret;
@@ -845,12 +843,12 @@ bool userns_may_setgroups(const struct user_namespace *ns)
 {
 	bool allowed;
 
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 	/* It is not safe to use setgroups until a gid mapping in
 	 * the user namespace has been established.
 	 */
 	allowed = ns->gid_map.nr_extents != 0;
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 
 	return allowed;
 }
-- 
2.1.4

