Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3L3NqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:46:09 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:38336 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab3L3NqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:46:04 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 2/3] Add shrink_pagecache_parent
Date: Mon, 30 Dec 2013 21:45:17 +0800
Message-Id: <249cbd3edaa84dd58a0626780fb546ddf7c1dc11.1388409687.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpOVU5OS0tLS0pCS0xIT0NNSFdZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNS
	QzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1
	VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISy
	Q2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9OjY0LigkPzQ2OjI1JCgrPSQ9OjI3QUpLVUtAKC45JD
	5BSlVOTlkG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	T0pKSk5OQkxKVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUhIS0g3V1kSC1lBWUpKQlVIQlVKSU9VSkxLWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analogous to shrink_dcache_parent except that it collects inodes.
It is not very appropriate to be put in dcache.c, but d_walk can only
be invoked from here.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/dcache.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 6055d61..0fc0f80 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1318,6 +1318,42 @@ void shrink_dcache_parent(struct dentry *parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static enum d_walk_ret gather_inode(void *data, struct dentry *dentry)
+{
+	struct list_head *list = data;
+	struct inode *inode = dentry->d_inode;
+
+	if ((inode == NULL) || ((!inode_owner_or_capable(inode)) &&
+				(!capable(CAP_SYS_ADMIN))))
+		goto out;
+	spin_lock(&inode->i_lock);
+	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+		(inode->i_mapping->nrpages == 0) ||
+		(!list_empty(&inode->i_lru))) {
+			goto out_unlock;
+	}
+	__iget(inode);
+	list_add_tail(&inode->i_lru, list);
+out_unlock:
+	spin_unlock(&inode->i_lock);
+out:
+	return D_WALK_CONTINUE;
+}
+
+void shrink_pagecache_parent(struct dentry *parent)
+{
+	LIST_HEAD(list);
+	struct inode *inode, *next;
+
+	d_walk(parent, &list, gather_inode, NULL);
+	list_for_each_entry_safe(inode, next, &list, i_lru) {
+		list_del_init(&inode->i_lru);
+		invalidate_mapping_pages(inode->i_mapping, 0, -1);
+		iput(inode);
+	}
+}
+EXPORT_SYMBOL(shrink_pagecache_parent);
+
 static enum d_walk_ret umount_collect(void *_data, struct dentry *dentry)
 {
 	struct select_data *data = _data;
-- 
1.7.9.5

