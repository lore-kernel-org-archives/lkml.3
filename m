Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbaICKL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:11:28 -0400
Received: from relay.parallels.com ([195.214.232.42]:53993 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaICKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:11:24 -0400
Subject: [PATCH 2/2] fuse: fuse_get_user_pages(): do not pack more data than
 requested
To: viro@zeniv.linux.org.uk
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, werner.baumann@onlinehome.de
Date: Wed, 03 Sep 2014 14:11:21 +0400
Message-ID: <20140903101109.23218.60234.stgit@localhost.localdomain>
In-Reply-To: <20140903100826.23218.95122.stgit@localhost.localdomain>
References: <20140903100826.23218.95122.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes a bug introduced by commit c9c37e2e6378 ("fuse: switch to
iov_iter_get_pages()"):

The third argument of fuse_get_user_pages() "nbytesp" refers to the number of
bytes a caller asked to pack into fuse request. This value may be lesser
than capacity of fuse request or iov_iter. So fuse_get_user_pages() must
ensure that *nbytesp won't grow. Before that commit, it was ensured by:

>		ret = get_user_pages_fast(user_addr, npages, !write,
>					  &req->pages[req->num_pages]);
>		...
>		npages = ret;
>		frag_size = min_t(size_t, frag_size,
>				  (npages << PAGE_SHIFT) - offset);

Now, when helper iov_iter_get_pages() performs all hard work of extracting
pages from iov_iter, it can be done by passing properly calculated "maxsize"
to the helper.

Reported-by: Werner Baumann <werner.baumann@onlinehome.de>
Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 40ac262..1d2bb70 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1303,10 +1303,15 @@ static int fuse_get_user_pages(struct fuse_req *req, struct iov_iter *ii,
 	while (nbytes < *nbytesp && req->num_pages < req->max_pages) {
 		unsigned npages;
 		size_t start;
+		ssize_t ret;
 		unsigned n = req->max_pages - req->num_pages;
-		ssize_t ret = iov_iter_get_pages(ii,
-					&req->pages[req->num_pages],
-					n * PAGE_SIZE, &start);
+		size_t frag_size = fuse_get_frag_size(ii, *nbytesp - nbytes);
+
+		frag_size = min_t(size_t, frag_size, n << PAGE_SHIFT);
+
+		ret = iov_iter_get_pages(ii,
+				&req->pages[req->num_pages],
+				frag_size, &start);
 		if (ret < 0)
 			return ret;
 

