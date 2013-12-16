Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3LPPK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:10:58 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:54717 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3LPPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:55 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 10:10:54 EST
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 4/5] VFS: Add shrink_pagecache_parent
Date: Mon, 16 Dec 2013 07:00:08 -0800
Message-Id: <2545525b8fff4d00a574c2230cd1e772785ec1d2.1387205337.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlMVU5PQkJCQklITEtNS05PTFdZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0
	AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9Oj
	Y0LigkPzQ2OjI1JCgrPSQ9OjI3QUpLVUtAKC45JD5BSlVOTlkG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SUtNS05NSktLVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlCQkI3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analogous to shrink_dcache_parent except that it collects inodes.
It is not very appropriate to be put in dcache.c, but d_walk can only
be invoked from here.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/dcache.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4bdb300..bcbfd0d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1318,6 +1318,41 @@ void shrink_dcache_parent(struct dentry *parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+static enum d_walk_ret gather_inode(void *data, struct dentry *dentry)
+{
+	struct list_head *list = data;
+	struct inode *inode = dentry->d_inode;
+
+	if (inode == NULL)
+		goto out;
+	spin_lock(&inode->i_lock);
+	if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
+	(inode->i_mapping->nrpages == 0) ||
+		(!list_empty(&inode->i_lru))) {
+		goto out_unlock;
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

