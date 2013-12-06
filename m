Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161958Ab3LFXPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:15:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161223Ab3LFXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:15:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 139/152] nfsd4: fix xdr decoding of large non-write compounds
Date: Fri,  6 Dec 2013 15:11:03 -0800
Message-Id: <1386371476-2477-140-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 365da4adebb1c012febf81019ad3dc5bb52e2a13 upstream.

This fixes a regression from 247500820ebd02ad87525db5d9b199e5b66f6636
"nfsd4: fix decoding of compounds across page boundaries".  The previous
code was correct: argp->pagelist is initialized in
nfs4svc_deocde_compoundargs to rqstp->rq_arg.pages, and is therefore a
pointer to the page *after* the page we are currently decoding.

The reason that patch nevertheless fixed a problem with decoding
compounds containing write was a bug in the write decoding introduced by
5a80a54d21c96590d013378d8c5f65f879451ab4 "nfsd4: reorganize write
decoding", after which write decoding no longer adhered to the rule that
argp->pagelist point to the next page.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ kamal: backport to 3.8 (next_decode_page change is in read_buf) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 859d145..3ed8550 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -162,8 +162,8 @@ static __be32 *read_buf(struct nfsd4_compoundargs *argp, u32 nbytes)
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->pagelist++;
 	argp->p = page_address(argp->pagelist[0]);
+	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
@@ -1160,6 +1160,7 @@ nfsd4_decode_write(struct nfsd4_compoundargs *argp, struct nfsd4_write *write)
 		len -= pages * PAGE_SIZE;
 
 		argp->p = (__be32 *)page_address(argp->pagelist[0]);
+		argp->pagelist++;
 		argp->end = argp->p + XDR_QUADLEN(PAGE_SIZE);
 	}
 	argp->p += XDR_QUADLEN(len);
-- 
1.8.3.2

