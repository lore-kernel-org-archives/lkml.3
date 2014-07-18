Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966026AbaGRNdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:33:36 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17784 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965754AbaGRNOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:53 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 114/170] nfsd: fix rare symlink decoding bug
Date: Fri, 18 Jul 2014 14:11:59 +0200
Message-Id: <6f6d1162855d011954c5dada0a0b9c107eb05c7c.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 76f47128f9b33af1e96819746550d789054c9664 upstream.

An NFS operation that creates a new symlink includes the symlink data,
which is xdr-encoded as a length followed by the data plus 0 to 3 bytes
of zero-padding as required to reach a 4-byte boundary.

The vfs, on the other hand, wants null-terminated data.

The simple way to handle this would be by copying the data into a newly
allocated buffer with space for the final null.

The current nfsd_symlink code tries to be more clever by skipping that
step in the (likely) case where the byte following the string is already
0.

But that assumes that the byte following the string is ours to look at.
In fact, it might be the first byte of a page that we can't read, or of
some object that another task might modify.

Worse, the NFSv4 code tries to fix the problem by actually writing to
that byte.

In the NFSv2/v3 cases this actually appears to be safe:

	- nfs3svc_decode_symlinkargs explicitly null-terminates the data
	  (after first checking its length and copying it to a new
	  page).
	- NFSv2 limits symlinks to 1k.  The buffer holding the rpc
	  request is always at least a page, and the link data (and
	  previous fields) have maximum lengths that prevent the request
	  from reaching the end of a page.

In the NFSv4 case the CREATE op is potentially just one part of a long
compound so can end up on the end of a page if you're unlucky.

The minimal fix here is to copy and null-terminate in the NFSv4 case.
The nfsd_symlink() interface here seems too fragile, though.  It should
really either do the copy itself every time or just require a
null-terminated string.

Reported-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/nfsd/nfs4proc.c |  9 ---------
 fs/nfsd/nfs4xdr.c  | 13 ++++++++++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index b9e784486729..08c8e023c157 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -610,15 +610,6 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	switch (create->cr_type) {
 	case NF4LNK:
-		/* ugh! we have to null-terminate the linktext, or
-		 * vfs_symlink() will choke.  it is always safe to
-		 * null-terminate by brute force, since at worst we
-		 * will overwrite the first byte of the create namelen
-		 * in the XDR buffer, which has already been extracted
-		 * during XDR decode.
-		 */
-		create->cr_linkname[create->cr_linklen] = 0;
-
 		status = nfsd_symlink(rqstp, &cstate->current_fh,
 				      create->cr_name, create->cr_namelen,
 				      create->cr_linkname, create->cr_linklen,
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8fb749d7bbe6..42c8c8aeb465 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -594,7 +594,18 @@ nfsd4_decode_create(struct nfsd4_compoundargs *argp, struct nfsd4_create *create
 		READ_BUF(4);
 		READ32(create->cr_linklen);
 		READ_BUF(create->cr_linklen);
-		SAVEMEM(create->cr_linkname, create->cr_linklen);
+		/*
+		 * The VFS will want a null-terminated string, and
+		 * null-terminating in place isn't safe since this might
+		 * end on a page boundary:
+		 */
+		create->cr_linkname =
+				kmalloc(create->cr_linklen + 1, GFP_KERNEL);
+		if (!create->cr_linkname)
+			return nfserr_jukebox;
+		memcpy(create->cr_linkname, p, create->cr_linklen);
+		create->cr_linkname[create->cr_linklen] = '\0';
+		defer_free(argp, kfree, create->cr_linkname);
 		break;
 	case NF4BLK:
 	case NF4CHR:
-- 
2.0.0

