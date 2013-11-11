Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3KKPma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:42:30 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52857 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3KKPl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:27 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 4/7] Ceph: Uncaching no-data page in readpage()
Date: Mon, 11 Nov 2013 23:27:26 +0800
Message-Id: <1328cc859d1b2d40786fc3aa634a36764b286e70.1384183054.git.liwang@ubuntukylin.com>
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
	SkNPT0NOTUtMVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlLSU83V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if one page allocated into fscache in readpage(), however, with
no-data read, it is not uncached. This patch fixes this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/ceph/addr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6df8bd4..be5f4b6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -209,6 +209,7 @@ static int readpage_nounlock(struct file *filp, struct page *page)
 		err = 0;
 	if (err < 0) {
 		SetPageError(page);
+		ceph_fscache_readpage_cancel(inode, page);
 		goto out;
 	} else if (err < PAGE_CACHE_SIZE) {
 		/* zero fill remainder of page */
-- 
1.7.9.5

