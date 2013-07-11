Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3GKWL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:11:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3GKWLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:11:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rick Macklem <rmacklem@uoguelph.ca>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 09/11] nfsd4: fix decoding of compounds across page boundaries
Date: Thu, 11 Jul 2013 15:11:09 -0700
Message-Id: <20130711220546.614092348@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711220545.542911892@linuxfoundation.org>
References: <20130711220545.542911892@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 247500820ebd02ad87525db5d9b199e5b66f6636 upstream.

A freebsd NFSv4.0 client was getting rare IO errors expanding a tarball.
A network trace showed the server returning BAD_XDR on the final getattr
of a getattr+write+getattr compound.  The final getattr started on a
page boundary.

I believe the Linux client ignores errors on the post-write getattr, and
that that's why we haven't seen this before.

Reported-by: Rick Macklem <rmacklem@uoguelph.ca>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -161,8 +161,8 @@ static __be32 *read_buf(struct nfsd4_com
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->p = page_address(argp->pagelist[0]);
 	argp->pagelist++;
+	argp->p = page_address(argp->pagelist[0]);
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;


