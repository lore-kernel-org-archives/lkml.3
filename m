Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaICKaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:30:22 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11925 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755808AbaICK3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:29:39 -0400
X-IronPort-AV: E=Sophos;i="5.04,456,1406563200"; 
   d="scan'208";a="35453954"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: [RFC PATCH 1/3] procfs: check uniq proc_dir_entry subdir name
Date: Wed, 3 Sep 2014 18:29:58 +0800
Message-ID: <1409740200-26461-2-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether a proc dir has a subdir
with a specific name.
Will be used in a later patch.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 fs/proc/generic.c       | 15 +++++++++++++++
 include/linux/proc_fs.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b7f268e..4d576c2 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -173,6 +173,21 @@ static const struct inode_operations proc_link_inode_operations = {
 	.follow_link	= proc_follow_link,
 };
 
+/* check whether dir has @name member */
+struct proc_dir_entry *proc_uniq_dir(struct proc_dir_entry *de, char *name)
+{
+	spin_lock(&proc_subdir_lock);
+	for (de = de->subdir; de ; de = de->next) {
+		if (!strcmp(de->name, name)) {
+			spin_unlock(&proc_subdir_lock);
+			return de;
+		}
+	}
+	spin_unlock(&proc_subdir_lock);
+	return NULL;
+}
+EXPORT_SYMBOL(proc_uniq_dir);
+
 /*
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 9d117f6..38e87aa 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -41,6 +41,7 @@ extern void *proc_get_parent_data(const struct inode *);
 extern void proc_remove(struct proc_dir_entry *);
 extern void remove_proc_entry(const char *, struct proc_dir_entry *);
 extern int remove_proc_subtree(const char *, struct proc_dir_entry *);
+extern struct proc_dir_entry *proc_uniq_dir(struct proc_dir_entry *, char *);
 
 #else /* CONFIG_PROC_FS */
 
@@ -71,6 +72,8 @@ static inline void *proc_get_parent_data(const struct inode *inode) { BUG(); ret
 static inline void proc_remove(struct proc_dir_entry *de) {}
 #define remove_proc_entry(name, parent) do {} while (0)
 static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
+static inline struct proc_dir_entry *proc_uniq_dir(struct proc_dir_entry *,
+	char *) {return 0; }
 
 #endif /* CONFIG_PROC_FS */
 
-- 
1.9.0

