Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3HMTTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:19:01 -0400
Received: from server506d.appriver.com ([50.56.144.156]:50595 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757824Ab3HMTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:18:58 -0400
X-Note-AR-ScanTimeLocal: 8/13/2013 2:18:55 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-104/SG:2 8/13/2013 2:18:14 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.971458 Source White
X-Signature-Violations: 0-0-0-6218-c
X-Note-419: 31.2022 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/13/2013 2:18:46 PM
X-Note: Spam Tests Failed: 
X-Country-Path: ->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G323 G324 G325 G326 G330 G331 G438 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Date: Tue, 13 Aug 2013 15:18:43 -0400
From: Ed L Cashin <ecashin@coraid.com>
To: Kent Overstreet <kmo@daterainc.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "neilb@suse.de" <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
Message-ID: <20130813191841.GA55109@Ed-Cashins-MacBook-Pro.local>
References: <FEE91CF1-7CDE-45E5-B7BA-DA8522E7DFFE@coraid.com>
 <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-5-git-send-email-kmo@daterainc.com>
 <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com>
 <20130809000943.GC15409@kmo-pixel>
 <F14F555B-1B1C-4E73-8AF8-DE57D77C610D@coraid.com>
 <20130809010530.GG15409@kmo-pixel>
 <54e7d248ba68ecf7e7ad4a4180145b72@coraid.com>
 <20130813185158.GA8981@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130813185158.GA8981@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:51:58AM -0700, Kent Overstreet wrote:
> On Tue, Aug 13, 2013 at 10:03:04AM -0400, Ed Cashin wrote:
> > On Aug 9, 2013, Ed Cashin wrote:
> > > On Aug 8, 2013, at 9:05 PM, Kent Overstreet wrote:
> > > ...
> > > > It's in the for-jens branch now.
> > > 
> > > 
> > > Just examining the patches, I like the way it cleans up the aoe code.  I
> > > had a question about a new BUG added by the for-jens branch the
> > > read-response handling path of the aoe driver.
> > 
> > The aoe driver in linux-bcache/for-jens commit 4c36c973a8f45 is
> > passing my tests.
> > 
> > Here is a patch against that branch illustrating my suggestion for
> > handling bad target responses gracefully.
> 
> Thanks - shall I just fold that into the aoe immutable bvec patch?

Yes, that would be good, thanks.

Unfortunately, the way I usually send patches to vger didn't work
this time.  It looks like the MTA didn't retry after the
greylisting used SMTP temporary failures.  So I'm trying a
different way to send and including the same patch for the
benefit of the Cc list.

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

-- 
  Ed
