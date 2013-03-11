Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3CKJkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:40:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:35007 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3CKJkC (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 11 Mar 2013 05:40:02 -0400
Message-Id: <513DB47B02000078000C4852@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 11 Mar 2013 09:39:55 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jens Axboe" <axboe@kernel.dk>, "xen-devel" <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-blkback: fix dispatch_rw_block_io() error path
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartD9E9B87B.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartD9E9B87B.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Commit 7708992 ("xen/blkback: Seperate the bio allocation and the bio
submission") consolidated the pendcnt updates to just a single write,
neglecting the fact that the error path relied on it getting set to 1
up front (such that the decrement in __end_block_io_op() would actually
drop the count to zero, triggering the necessary cleanup actions).

Also remove a misleading and a stale (after said commit) comment.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/block/xen-blkback/blkback.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- 3.9-rc2/drivers/block/xen-blkback/blkback.c
+++ 3.9-rc2-xen-blkback-error-path-refcnt/drivers/block/xen-blkback/blkback=
.c
@@ -977,13 +977,7 @@ static int dispatch_rw_block_io(struct x
 		bio->bi_end_io  =3D end_block_io_op;
 	}
=20
-	/*
-	 * We set it one so that the last submit_bio does not have to call
-	 * atomic_inc.
-	 */
 	atomic_set(&pending_req->pendcnt, nbio);
-
-	/* Get a reference count for the disk queue and start sending I/O =
*/
 	blk_start_plug(&plug);
=20
 	for (i =3D 0; i < nbio; i++)
@@ -1011,6 +1005,7 @@ static int dispatch_rw_block_io(struct x
  fail_put_bio:
 	for (i =3D 0; i < nbio; i++)
 		bio_put(biolist[i]);
+	atomic_set(&pending_req->pendcnt, 1);
 	__end_block_io_op(pending_req, -EINVAL);
 	msleep(1); /* back off a bit */
 	return -EIO;




--=__PartD9E9B87B.3__=
Content-Type: text/plain; name="linux-3.9-rc2-xen-blkback-error-path-refcnt.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.9-rc2-xen-blkback-error-path-refcnt.patch"

xen-blkback: fix dispatch_rw_block_io() error path=0A=0ACommit 7708992 =
("xen/blkback: Seperate the bio allocation and the bio=0Asubmission") =
consolidated the pendcnt updates to just a single write,=0Aneglecting the =
fact that the error path relied on it getting set to 1=0Aup front (such =
that the decrement in __end_block_io_op() would actually=0Adrop the count =
to zero, triggering the necessary cleanup actions).=0A=0AAlso remove a =
misleading and a stale (after said commit) comment.=0A=0ASigned-off-by: =
Jan Beulich <jbeulich@suse.com>=0A=0A---=0A drivers/block/xen-blkback/blkba=
ck.c |    7 +------=0A 1 file changed, 1 insertion(+), 6 deletions(-)=0A=0A=
--- 3.9-rc2/drivers/block/xen-blkback/blkback.c=0A+++ 3.9-rc2-xen-blkback-e=
rror-path-refcnt/drivers/block/xen-blkback/blkback.c=0A@@ -977,13 +977,7 =
@@ static int dispatch_rw_block_io(struct x=0A 		bio->bi_end_io  =
=3D end_block_io_op;=0A 	}=0A =0A-	/*=0A-	 * We set it one =
so that the last submit_bio does not have to call=0A-	 * atomic_inc.=0A-	=
 */=0A 	atomic_set(&pending_req->pendcnt, nbio);=0A-=0A-	/* Get a =
reference count for the disk queue and start sending I/O */=0A 	blk_start_p=
lug(&plug);=0A =0A 	for (i =3D 0; i < nbio; i++)=0A@@ -1011,6 +1005,7 =
@@ static int dispatch_rw_block_io(struct x=0A  fail_put_bio:=0A 	=
for (i =3D 0; i < nbio; i++)=0A 		bio_put(biolist[i]);=0A+	=
atomic_set(&pending_req->pendcnt, 1);=0A 	__end_block_io_op(pending_r=
eq, -EINVAL);=0A 	msleep(1); /* back off a bit */=0A 	return =
-EIO;=0A
--=__PartD9E9B87B.3__=--
