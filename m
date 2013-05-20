Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3ETMT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:19:58 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:57796 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3ETMT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:19:56 -0400
X-ASG-Debug-ID: 1369052394-03d6a5737b1f99e0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130520140449.5da8b61ceaaf06618914e76f@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kent Overstreet <koverstreet@google.com>
References: <20130520140449.5da8b61ceaaf06618914e76f@canb.auug.org.au>
Message-ID: <20130520121952.31110.50221@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Date: Mon, 20 May 2013 08:19:52 -0400
X-ASG-Orig-Subj: Re: linux-next: manual merge of the akpm tree with Linus' tree
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1369052394
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.131503
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (2013-05-20 00:04:49)
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got conflicts in
> fs/btrfs/inode.c and fs/btrfs/volumes.c between commit 9be3395bcd4a
> ("Btrfs: use a btrfs bioset instead of abusing bio internals") from
> Linus' tree and commit "block: prep work for batch completion" from the
> akpm tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
> 
> I also noticed that a single conversion of bio_endio to bio_endio_batch
> is done in the akpm patch but bio_endio_batch is not introduced until a
> later patch ... :-(

Thanks, this looks right and I've linux-next through an aio/dio test on
btrfs.

Kent, reviewing the merge I see a missing bio_endio_batch conversion.  I
think this was missing from the original:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index faf20f5..a47bc10 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7084,7 +7084,7 @@ static void btrfs_end_dio_bio(struct bio *bio, int err,
 		bio_io_error(dip->orig_bio);
 	} else {
 		set_bit(BIO_UPTODATE, &dip->dio_bio->bi_flags);
-		bio_endio(dip->orig_bio, 0);
+		bio_endio_batch(dip->orig_bio, 0, batch);
 	}
 out:
 	bio_put(bio);
