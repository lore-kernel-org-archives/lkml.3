Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3HMOEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:04:08 -0400
Received: from dupo.coraid.com ([208.71.232.133]:39578 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755291Ab3HMOEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:04:06 -0400
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
In-Reply-To: <FEE91CF1-7CDE-45E5-B7BA-DA8522E7DFFE@coraid.com>
References: <FEE91CF1-7CDE-45E5-B7BA-DA8522E7DFFE@coraid.com> <1375912471-5106-1-git-send-email-kmo@daterainc.com> <1375912471-5106-5-git-send-email-kmo@daterainc.com> <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com> <20130809000943.GC15409@kmo-pixel> <F14F555B-1B1C-4E73-8AF8-DE57D77C610D@coraid.com> <20130809010530.GG15409@kmo-pixel>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "neilb@suse.de" <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 13 Aug 2013 10:03:04 -0400
Message-ID: <54e7d248ba68ecf7e7ad4a4180145b72@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 9, 2013, Ed Cashin wrote:
> On Aug 8, 2013, at 9:05 PM, Kent Overstreet wrote:
> ...
> > It's in the for-jens branch now.
> 
> 
> Just examining the patches, I like the way it cleans up the aoe code.  I
> had a question about a new BUG added by the for-jens branch the
> read-response handling path of the aoe driver.

The aoe driver in linux-bcache/for-jens commit 4c36c973a8f45 is
passing my tests.

Here is a patch against that branch illustrating my suggestion for
handling bad target responses gracefully.


commit 2c39f50b1ee02e2ac07fd072a883a91713da53cc
Author: Ed Cashin <ecashin@coraid.com>
Date:   Tue Aug 13 10:50:28 2013 -0400

    aoe: bad AoE responses fail I/O without BUG
    
    Instead of having a BUG when the AoE target does something wrong,
    just fail the I/O and log the problem with rate limiting.

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index cacd48e..b9916a6 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1096,7 +1096,6 @@ bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
 	int soff = 0;
 	struct bio_vec bv;
 
-	BUG_ON(cnt > iter.bi_size);
 	iter.bi_size = cnt;
 
 	__bio_for_each_segment(bv, bio, iter, iter) {
@@ -1196,6 +1195,14 @@ noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 			break;
 		}
+		if (n > f->iter.bi_size) {
+			pr_err_ratelimited("%s e%ld.%d.  bytes=%ld need=%u\n",
+				"aoe: too-large data size in read from",
+				(long) d->aoemajor, d->aoeminor,
+				n, f->iter.bi_size);
+			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+			break;
+		}
 		bvcpy(skb, f->buf->bio, f->iter, n);
 	case ATA_CMD_PIO_WRITE:
 	case ATA_CMD_PIO_WRITE_EXT:
