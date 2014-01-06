Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbaAFXPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:15:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbaAFWl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 050/129] ceph: Avoid data inconsistency due to d-cache aliasing in readpage()
Date: Mon,  6 Jan 2014 14:37:59 -0800
Message-Id: <20140106223901.037782789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <liwang@ubuntukylin.com>

commit 56f91aad69444d650237295f68c195b74d888d95 upstream.

If the length of data to be read in readpage() is exactly
PAGE_CACHE_SIZE, the original code does not flush d-cache
for data consistency after finishing reading. This patches fixes
this.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/addr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -213,9 +213,13 @@ static int readpage_nounlock(struct file
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
 


