Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbaJ1HLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:11:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbaJ1DpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Dickson <SteveD@redhat.com>,
        Weston Andros Adamson <dros@primarydata.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.16 055/127] NFS: Fix a bogus warning in nfs_generic_pgio
Date: Tue, 28 Oct 2014 11:34:50 +0800
Message-Id: <20141028033423.289793222@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit b8fb9c30f25e45dab5d2cd310ab6913b6861d00f upstream.

It is OK for pageused == pagecount in the loop, as long as we don't add
another entry to the *pages array. Move the test so that it only triggers
in that case.

Reported-by: Steve Dickson <SteveD@redhat.com>
Fixes: bba5c1887a92 (nfs: disallow duplicate pages in pgio page vectors)
Cc: Weston Andros Adamson <dros@primarydata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pagelist.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -754,12 +754,11 @@ int nfs_generic_pgio(struct nfs_pageio_d
 		nfs_list_remove_request(req);
 		nfs_list_add_request(req, &hdr->pages);
 
-		if (WARN_ON_ONCE(pageused >= pagecount))
-			return nfs_pgio_error(desc, hdr);
-
 		if (!last_page || last_page != req->wb_page) {
-			*pages++ = last_page = req->wb_page;
 			pageused++;
+			if (pageused > pagecount)
+				break;
+			*pages++ = last_page = req->wb_page;
 		}
 	}
 	if (WARN_ON_ONCE(pageused != pagecount))


