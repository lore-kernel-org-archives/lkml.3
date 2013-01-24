Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab3AXP3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3AXP3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:29:03 -0500
Date: Thu, 24 Jan 2013 10:28:59 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] userns: improve uid/gid map collision detection
Message-ID: <20130124152859.GP17632@redhat.com>
References: <20130123160221.GG17632@redhat.com>
 <20130124044438.GA13354@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124044438.GA13354@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

userns: improve uid/gid map collision detection

Initial implementation of the uid/gid maps (/proc/<pid>/{u,g}id_map) will
enforce that the UID and GID maps be written in strict order as a simple
way to check for range collision:
	local id	mapped to	count/range
	0		1000		50
	(ids 0-50 get mapped to 1000-1050)
	100		2120		10
	500		5000		200
so for each new entry, local id must be bigger than last local id (plus
count) and the ids it maps to also needs to be bigger than the last
entry (plus count).

This makes impossible to have a use case like this:
	local id	mapped to	count/range
	0		1000		1
	48		500		20

because while 48+20 > 0+1, 500+20 < 1000+1.

This patch implements a more elaborate collision detection allowing any
order to be used.

v2: improved the patch description as requested by Andrew

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 2b042c4..fb0e492 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -521,6 +521,28 @@ struct seq_operations proc_projid_seq_operations = {
 
 static DEFINE_MUTEX(id_map_mutex);
 
+#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))
+static inline int extent_collision(struct uid_gid_map *new_map,
+				   struct uid_gid_extent *extent)
+{
+	int i;
+	struct uid_gid_extent *cur;
+
+	for (i = 0; i < new_map->nr_extents; i++) {
+		cur = &new_map->extent[i];
+		if (in_range(extent->first, cur->first, cur->count) ||
+		    in_range(extent->first + extent->count, cur->first,
+			     cur->count))
+			return 1;
+		if (in_range(extent->lower_first, cur->lower_first,
+			     cur->count) ||
+		    in_range(extent->lower_first + extent->count,
+			     cur->lower_first, cur->count))
+			return 1;
+	}
+	return 0;
+}
+
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -634,10 +656,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 		if ((extent->lower_first + extent->count) <= extent->lower_first)
 			goto out;
 
-		/* For now only accept extents that are strictly in order */
-		if (last &&
-		    (((last->first + last->count) > extent->first) ||
-		     ((last->lower_first + last->count) > extent->lower_first)))
+		if (extent_collision(&new_map, extent))
 			goto out;
 
 		new_map.nr_extents++;
