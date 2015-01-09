Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbbAIKkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:33 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44578 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757479AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 63/78] userns: Rename id_map_mutex to userns_state_mutex
Date: Fri,  9 Jan 2015 11:32:12 +0100
Message-Id: <8af7f1447f86763c7c7d8bff54f58030723d9abb.1420799385.git.jslaby@suse.cz>
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

commit f0d62aec931e4ae3333c797d346dc4f188f454ba upstream.

Generalize id_map_mutex so it can be used for more state of a user namespace.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index c2ca6c01e575..a607b24bec0b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/fs_struct.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
+static DEFINE_MUTEX(userns_state_mutex);
 
 static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
@@ -575,9 +576,6 @@ static bool mappings_overlap(struct uid_gid_map *new_map, struct uid_gid_extent
 	return false;
 }
 
-
-static DEFINE_MUTEX(id_map_mutex);
-
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -594,7 +592,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	ssize_t ret = -EINVAL;
 
 	/*
-	 * The id_map_mutex serializes all writes to any given map.
+	 * The userns_state_mutex serializes all writes to any given map.
 	 *
 	 * Any map is only ever written once.
 	 *
@@ -612,7 +610,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 * order and smp_rmb() is guaranteed that we don't have crazy
 	 * architectures returning stale data.
 	 */
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
@@ -739,7 +737,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	*ppos = count;
 	ret = count;
 out:
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 	if (page)
 		free_page(page);
 	return ret;
@@ -831,12 +829,12 @@ bool userns_may_setgroups(const struct user_namespace *ns)
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
2.2.1

