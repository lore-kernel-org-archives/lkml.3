Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbaJDAbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:31:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaJCVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <tao.peng@primarydata.com>,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 170/357] nfs: fix error handling in lock_and_join_requests
Date: Fri,  3 Oct 2014 14:29:16 -0700
Message-Id: <20141003212938.585842972@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Weston Andros Adamson <dros@primarydata.com>

commit 94970014c46223cbcdfbfc67b89596a412f9e3dd upstream.

This fixes handling of errors from nfs_page_group_lock in
nfs_lock_and_join_requests.  It now releases the inode lock and the
reference to the head request.

Reported-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Reviewed-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/write.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -455,8 +455,11 @@ try_again:
 
 	/* lock each request in the page group */
 	ret = nfs_page_group_lock(head, true);
-	if (ret < 0)
+	if (ret < 0) {
+		spin_unlock(&inode->i_lock);
+		nfs_release_request(head);
 		return ERR_PTR(ret);
+	}
 	subreq = head;
 	do {
 		/*


