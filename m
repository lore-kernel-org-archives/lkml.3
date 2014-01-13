Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaAMQin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:38:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaAMQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Wang <liwang@ubuntukylin.com>, Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 105/208] ceph: Avoid data inconsistency due to d-cache aliasing in readpage()
Date: Mon, 13 Jan 2014 15:59:06 +0000
Message-Id: <1389628849-1614-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <liwang@ubuntukylin.com>

commit 56f91aad69444d650237295f68c195b74d888d95 upstream.

If the length of data to be read in readpage() is exactly
PAGE_CACHE_SIZE, the original code does not flush d-cache
for data consistency after finishing reading. This patches fixes
this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/addr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5318a3b..0d2e0f1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -214,9 +214,13 @@ static int readpage_nounlock(struct file *filp, struct page *page)
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
1.8.3.2

