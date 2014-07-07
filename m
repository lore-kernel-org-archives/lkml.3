Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaGHAQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:16:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaGGXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 40/53] nfsd: fix rare symlink decoding bug
Date: Mon,  7 Jul 2014 16:58:25 -0700
Message-Id: <20140707235830.496176184@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    9 ---------
 fs/nfsd/nfs4xdr.c  |   13 ++++++++++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -576,15 +576,6 @@ nfsd4_create(struct svc_rqst *rqstp, str
 
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
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -553,7 +553,18 @@ nfsd4_decode_create(struct nfsd4_compoun
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


