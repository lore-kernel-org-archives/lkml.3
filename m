Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3LSOE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:04:29 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:44490 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3LSOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:04:25 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Milosz Tanski <milosz@adfin.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 1/2] ceph fscache: Introduce a routine for uncaching single no data page from fscache
Date: Thu, 19 Dec 2013 06:03:48 -0800
Message-Id: <65d023ce80c02fd37fcd2e88dc9c01f4959c574c.1387461299.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387461299.git.liwang@ubuntukylin.com>
References: <cover.1387461299.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1387461299.git.liwang@ubuntukylin.com>
References: <cover.1387461299.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpMVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNSQzPj
	o*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQzLjU6NUFLVU
	tAPyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQCk#OjckMiskMjUkKTk3JDI1JDM#Oj8#KUFKSV
	VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JDM#Oj8#KUFJVUtAMiskLzQ*OiIkODUvJEskSktLQU
	tVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskSiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJE
	okMzQuKSQ4NS8kSyRKS0tBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtAKC45JD5BSlVOTk
	A9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	T01KQ01IS0pMVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlOSU83V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/cache.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index ba94940..da95f61 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -67,6 +67,14 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return fscache_maybe_release_page(ci->fscache, page, gfp);
 }
 
+static inline void ceph_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	if (fscache_cookie_valid(ci->fscache) && PageFsCache(page))
+		__fscache_uncache_page(ci->fscache, page);
+}
+
 static inline void ceph_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
@@ -145,6 +153,11 @@ static inline int ceph_release_fscache_page(struct page *page, gfp_t gfp)
 	return 1;
 }
 
+static inline void ceph_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+}
+
 static inline void ceph_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
-- 
1.7.9.5

