Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab3KAEDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:03:39 -0400
Received: from m59-178.qiye.163.com ([123.58.178.59]:37384 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3KAEDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:03:39 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 00:03:38 EDT
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: linux-cachefs@redhat.com, Sage Weil <sage@inktank.com>,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>,
        Min Chen <minchen@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH] ceph: Update the pages in fscache in writepages() path
Date: Fri,  1 Nov 2013 11:56:48 +0800
Message-Id: <1383278208-4053-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpMVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNSQzPj
	o*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQzLjU6NUFLVU
	tAPyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQCk#OjckMiskMjUkKTk3JDI1JDM#Oj8#KUFKSV
	VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JDM#Oj8#KUFJVUtAMiskLzQ*OiIkODUvJEskSktLQU
	tVS0AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRKJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskSE
	skNjI1Li8#JDg1LyRLJE5LQUtVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVUtAKC45JD5BSlVOTk
	A9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENI
	SUxDSUlOSEJIVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlKTEo3V1kSC1lBWUlJSVVJT0tVSkxMVUhPWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the pages in fscache only are updated in writepage() path,
add the process in writepages().

Signed-off-by: Min Chen <minchen@ubuntukylin.com>
Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 fs/ceph/addr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6df8bd4..cc57911 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -746,7 +746,7 @@ retry:
 
 	while (!done && index <= end) {
 		int num_ops = do_sync ? 2 : 1;
-		unsigned i;
+		unsigned i, j;
 		int first;
 		pgoff_t next;
 		int pvec_pages, locked_pages;
@@ -894,7 +894,6 @@ get_more_pages:
 		if (!locked_pages)
 			goto release_pvec_pages;
 		if (i) {
-			int j;
 			BUG_ON(!locked_pages || first < 0);
 
 			if (pvec_pages && i == pvec_pages &&
@@ -924,7 +923,10 @@ get_more_pages:
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0,
 							!!pool, false);
-
+		for(j = 0; j < locked_pages; j++) {
+			struct page *page = pages[j];
+			ceph_readpage_to_fscache(inode, page);
+		}		
 		pages = NULL;	/* request message now owns the pages array */
 		pool = NULL;
 
-- 
1.7.9.5

