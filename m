Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbbAGCCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:02:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294AbbAGCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:01:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.10 27/38] userns: Rename id_map_mutex to userns_state_mutex
Date: Tue,  6 Jan 2015 17:50:39 -0800
Message-Id: <20150107014956.766477878@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit f0d62aec931e4ae3333c797d346dc4f188f454ba upstream.

Generalize id_map_mutex so it can be used for more state of a user namespace.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/fs_struct.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
+static DEFINE_MUTEX(userns_state_mutex);
 
 static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
@@ -577,9 +578,6 @@ static bool mappings_overlap(struct uid_
 	return false;
 }
 
-
-static DEFINE_MUTEX(id_map_mutex);
-
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -596,7 +594,7 @@ static ssize_t map_write(struct file *fi
 	ssize_t ret = -EINVAL;
 
 	/*
-	 * The id_map_mutex serializes all writes to any given map.
+	 * The userns_state_mutex serializes all writes to any given map.
 	 *
 	 * Any map is only ever written once.
 	 *
@@ -614,7 +612,7 @@ static ssize_t map_write(struct file *fi
 	 * order and smp_rmb() is guaranteed that we don't have crazy
 	 * architectures returning stale data.
 	 */
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
@@ -741,7 +739,7 @@ static ssize_t map_write(struct file *fi
 	*ppos = count;
 	ret = count;
 out:
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 	if (page)
 		free_page(page);
 	return ret;
@@ -833,12 +831,12 @@ bool userns_may_setgroups(const struct u
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


