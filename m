Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3HMQ3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:29:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27398 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab3HMQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:57 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ZvIBA7SDYIYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Yzy9AmNbhxUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=hQ_aZrwG1t3alzDH:21 a=QrOBiADRJjpV4bFV:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155833.238374305@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rick Macklem <rmacklem@uoguelph.ca>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [61/88] nfsd4: fix decoding of compounds across page boundaries
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0061-nfsd4-fix-decoding-of-compounds-across-page-boundari.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 247500820ebd02ad87525db5d9b199e5b66f6636 ]

A freebsd NFSv4.0 client was getting rare IO errors expanding a tarball.
A network trace showed the server returning BAD_XDR on the final getattr
of a getattr+write+getattr compound.  The final getattr started on a
page boundary.

I believe the Linux client ignores errors on the post-write getattr, and
that that's why we haven't seen this before.

Cc: stable@vger.kernel.org
Reported-by: Rick Macklem <rmacklem@uoguelph.ca>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 348937b..1f43627 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -161,8 +161,8 @@ static __be32 *read_buf(struct nfsd4_compoundargs *argp, u32 nbytes)
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->p = page_address(argp->pagelist[0]);
 	argp->pagelist++;
+	argp->p = page_address(argp->pagelist[0]);
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
-- 
1.7.10.4


