Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3KKPlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:41:55 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52878 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KKPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:29 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 7/7] Cifs: Uncaching no-data page in readpage()
Date: Mon, 11 Nov 2013 23:27:29 +0800
Message-Id: <00261f7875c015f1a466ec69745d695efe43ac5d.1384183054.git.liwang@ubuntukylin.com>
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
	SkNPT0NMS0JDVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlLQko3V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if one page allocated into fscache in readpage(), however, with
no-data read, it is not uncached. This patch fixes this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
---
 fs/cifs/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7ddddf2..153bc58 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3406,8 +3406,10 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 
 	rc = cifs_read(file, read_data, PAGE_CACHE_SIZE, poffset);
 
-	if (rc < 0)
+	if (rc < 0) {
+		cifs_fscache_readpage_cancel(file_inode(file), page);
 		goto io_error;
+	}
 	else
 		cifs_dbg(FYI, "Bytes read %d\n", rc);
 
-- 
1.7.9.5

