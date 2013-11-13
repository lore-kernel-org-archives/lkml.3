Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab3KMHdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:33:06 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:36081 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab3KMHdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:33:02 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH] Ceph: Avoid data inconsistency due to d-cache aliasing in readpage()
Date: Wed, 13 Nov 2013 15:22:14 +0800
Message-Id: <1384327335-18812-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpMVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQ1NCQyNSQzPj
	o*PilBSVVLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQ8Ljo1PD80NT
	xBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVU
	tAMiskSiQzNC4pJDg1LyRLJEpLS0FLVUtAMiskSiQ2MjUuLz4kODUvJEskSktBS1VLQCguOSQ#QU
	pVTk5APTUkKC45JD41LDQpPygkMzcxJEpLS0lLSkFLVUlDWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENP
	SElMSENMTE5CVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUpMSEo3V1kSC1lBWUpDSFVNSFVJTktVTVkG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the length of data to be read in readpage() is exactly
PAGE_CACHE_SIZE, the original code does not flush d-cache
for data consistency after finishing reading. This patches fixes
this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/addr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6df8bd4..7b0000a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -210,9 +210,13 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 	if (err < 0) {
 		SetPageError(page);
 		goto out;
-	} else if (err < PAGE_CACHE_SIZE) {
+	} else {
+		if (err < PAGE_CACHE_SIZE) {
 		/* zero fill remainder of page */
-		zero_user_segment(page, err, PAGE_CACHE_SIZE);
+			zero_user_segment(page, err, PAGE_CACHE_SIZE);
+		} else {
+			flush_dcache_page(page);
+		}
 	}
 	SetPageUptodate(page);
 
-- 
1.7.9.5

