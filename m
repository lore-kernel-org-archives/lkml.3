Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaGUPOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:14:24 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:51943 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaGUPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:14:22 -0400
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Alban Crequy <alban.crequy@collabora.co.uk>
Subject: [PATCH] [RFC] cgroup: reject cgroup names with non-printing characters
Date: Mon, 21 Jul 2014 16:11:56 +0100
Message-Id: <1405955516-22016-1-git-send-email-alban.crequy@collabora.co.uk>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

I use < 0x20 as seen in vfat_bad_char; is it safe to use isprint()?

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
---
 kernel/cgroup.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 70776ae..e2df5e7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4378,6 +4378,20 @@ err_free_css:
 	return err;
 }
 
+/* Inspired by vfat_bad_char: do not accept non-printing characters. In
+ * particular, reject '\n' to prevent making /proc/<pid>/cgroup unparsable.
+ */
+static inline int cgroup_is_used_badchars(const char *s)
+{
+	int i;
+
+	for (i = 0; s[i] != '\0'; i++)
+		if (s[i] < 0x20)
+			return -EINVAL;
+
+	return 0;
+}
+
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 			umode_t mode)
 {
@@ -4387,6 +4401,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct kernfs_node *kn;
 	int ssid, ret;
 
+	/* do not create cgroups with bad names */
+	ret = cgroup_is_used_badchars(name);
+	if (ret)
+		return ret;
+
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;
-- 
1.8.5.3

