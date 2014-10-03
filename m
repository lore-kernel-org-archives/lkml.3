Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbaJDAbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:31:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbaJCVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Weston Andros Adamson <dros@primarydata.com>,
        Peng Tao <tao.peng@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 169/357] nfs: use blocking page_group_lock in add_request
Date: Fri,  3 Oct 2014 14:29:15 -0700
Message-Id: <20141003212938.556406898@linuxfoundation.org>
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

commit bfd484a5606d6a0379a0a2f04251b1e5c1f8995c upstream.

__nfs_pageio_add_request was calling nfs_page_group_lock nonblocking, but
this can return -EAGAIN which would end up passing -EIO to the application.

There is no reason not to block in this path, so change the two calls to
do so. Also, there is no need to check the return value of
nfs_page_group_lock when nonblock=false, so remove the error handling code.

Signed-off-by: Weston Andros Adamson <dros@primarydata.com>
Reviewed-by: Peng Tao <tao.peng@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/pagelist.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -873,13 +873,8 @@ static int __nfs_pageio_add_request(stru
 	struct nfs_page *subreq;
 	unsigned int bytes_left = 0;
 	unsigned int offset, pgbase;
-	int ret;
 
-	ret = nfs_page_group_lock(req, true);
-	if (ret < 0) {
-		desc->pg_error = ret;
-		return 0;
-	}
+	nfs_page_group_lock(req, false);
 
 	subreq = req;
 	bytes_left = subreq->wb_bytes;
@@ -901,11 +896,7 @@ static int __nfs_pageio_add_request(stru
 			if (desc->pg_recoalesce)
 				return 0;
 			/* retry add_request for this subreq */
-			ret = nfs_page_group_lock(req, true);
-			if (ret < 0) {
-				desc->pg_error = ret;
-				return 0;
-			}
+			nfs_page_group_lock(req, false);
 			continue;
 		}
 


