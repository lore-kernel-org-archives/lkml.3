Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3KKPlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:41:44 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52863 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3KKPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:28 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 5/7] Cifs: Introduce routine for uncaching single no-data page
Date: Mon, 11 Nov 2013 23:27:27 +0800
Message-Id: <b4c84ba0eeeda3bf915524c8173d44abb30506ff.1384183054.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1384183054.git.liwang@ubuntukylin.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU5VQ0hLS0tLT0tLTk9ISUpIV1kJDhceCFlBWS
	grPSQoND0vPToyNyQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNS
	QzPjo*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQ8Ljo1PD
	80NTxBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0A2LjcvMiQpOCsvJD8yPT0#KT41Ly
	QyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSk
	tBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtAMiskSiQzNC4pJDg1LyRLJEpLS0FLVUtAMi
	skSiQ2MjUuLz4kODUvJEskSktBS1VLQCguOSQ#QUpVTk5APTUkKC45JD41LDQpPygkMzcxJEpLS0
	lLSkFLVUlDWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENP
	SkNPT0NNS0NIVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlCQko3V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a routine for uncaching single no-data page, typically
in readpage().

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/cifs/fscache.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
index 24794b6..c712f42 100644
--- a/fs/cifs/fscache.h
+++ b/fs/cifs/fscache.h
@@ -54,6 +54,7 @@ extern int __cifs_readpages_from_fscache(struct inode *,
 					 struct address_space *,
 					 struct list_head *,
 					 unsigned *);
+extern void __cifs_fscache_readpage_cancel(struct inode *, struct page *);
 extern void __cifs_fscache_readpages_cancel(struct inode *, struct list_head *);
 
 extern void __cifs_readpage_to_fscache(struct inode *, struct page *);
@@ -92,6 +93,13 @@ static inline void cifs_readpage_to_fscache(struct inode *inode,
 		__cifs_readpage_to_fscache(inode, page);
 }
 
+static inline void cifs_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+	if (CIFS_I(inode)->fscache)
+		return __cifs_fscache_readpage_cancel(inode, page);
+}
+
 static inline void cifs_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
@@ -139,6 +147,11 @@ static inline int cifs_readpages_from_fscache(struct inode *inode,
 static inline void cifs_readpage_to_fscache(struct inode *inode,
 			struct page *page) {}
 
+static inline void cifs_fscache_readpage_cancel(struct inode *inode,
+						struct page *page)
+{
+}
+
 static inline void cifs_fscache_readpages_cancel(struct inode *inode,
 						 struct list_head *pages)
 {
-- 
1.7.9.5

