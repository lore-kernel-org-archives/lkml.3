Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3K0A7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:59:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601Ab3K0A7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.12 073/116] nfsd4: fix xdr decoding of large non-write compounds
Date: Tue, 26 Nov 2013 16:57:26 -0800
Message-Id: <20131127005741.976497395@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -141,8 +141,8 @@ xdr_error:					\
 
 static void next_decode_page(struct nfsd4_compoundargs *argp)
 {
-	argp->pagelist++;
 	argp->p = page_address(argp->pagelist[0]);
+	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
@@ -1209,6 +1209,7 @@ nfsd4_decode_write(struct nfsd4_compound
 		len -= pages * PAGE_SIZE;
 
 		argp->p = (__be32 *)page_address(argp->pagelist[0]);
+		argp->pagelist++;
 		argp->end = argp->p + XDR_QUADLEN(PAGE_SIZE);
 	}
 	argp->p += XDR_QUADLEN(len);


