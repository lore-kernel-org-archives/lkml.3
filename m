Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbaJDA2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:28:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaJCVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.16 159/357] nfsd4: fix corruption of NFSv4 read data
Date: Fri,  3 Oct 2014 14:29:05 -0700
Message-Id: <20141003212938.247392465@linuxfoundation.org>
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

From: "J. Bruce Fields" <bfields@redhat.com>

commit 15b23ef5d348ea51c5e7573e2ef4116fbc7cb099 upstream.

The calculation of page_ptr here is wrong in the case the read doesn't
start at an offset that is a multiple of a page.

The result is that nfs4svc_encode_compoundres sets rq_next_page to a
value one too small, and then the loop in svc_free_res_pages may
incorrectly fail to clear a page pointer in rq_respages[].

Pages left in rq_respages[] are available for the next rpc request to
use, so xdr data may be written to that page, which may hold data still
waiting to be transmitted to the client or data in the page cache.

The observed result was silent data corruption seen on an NFSv4 client.

We tag this as "fixing" 05638dc73af2 because that commit exposed this
bug, though the incorrect calculation predates it.

Particular thanks to Andrea Arcangeli and David Gilbert for analysis and
testing.

Fixes: 05638dc73af2 "nfsd4: simplify server xdr->next_page use"
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3112,7 +3112,8 @@ static __be32 nfsd4_encode_splice_read(
 
 	buf->page_len = maxcount;
 	buf->len += maxcount;
-	xdr->page_ptr += (maxcount + PAGE_SIZE - 1) / PAGE_SIZE;
+	xdr->page_ptr += (buf->page_base + maxcount + PAGE_SIZE - 1)
+							/ PAGE_SIZE;
 
 	/* Use rest of head for padding and remaining ops: */
 	buf->tail[0].iov_base = xdr->p;


