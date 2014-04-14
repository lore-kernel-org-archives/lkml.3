Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaDNW1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:27:32 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:45228 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754083AbaDNW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:27:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:2901:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:4250:4321:4605:5007:7514:7652:7904:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hall64_4145cb0854b18
X-Filterd-Recvd-Size: 2876
Message-ID: <1397514447.10969.10.camel@joe-AO722>
Subject: Re: [PATCH] block/blk-core.c: print readable string instead of
 values.
From: Joe Perches <joe@perches.com>
To: Muthukumar R <muthu.lkml@gmail.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Apr 2014 15:27:27 -0700
In-Reply-To: <CAFR8ueeGpR=+7RmDHLANUhkdxYiZjrkNODbLeizkSJBCwohMdw@mail.gmail.com>
References: <1397287343-10059-1-git-send-email-nasa4836@gmail.com>
	 <CAFR8ueeGpR=+7RmDHLANUhkdxYiZjrkNODbLeizkSJBCwohMdw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 15:00 -0700, Muthukumar R wrote:
> FYI, bi_rw tracks more than WRITE or READ...
> 
> On Sat, Apr 12, 2014 at 12:22 AM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> > Print the r/w direction string instead of internal values.
[]
> > diff --git a/block/blk-core.c b/block/blk-core.c
[]
> > @@ -1625,9 +1625,9 @@ static void handle_bad_sector(struct bio *bio)
> >         char b[BDEVNAME_SIZE];
> >
> >         printk(KERN_INFO "attempt to access beyond end of device\n");
> > -       printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
> > +       printk(KERN_INFO "%s: rw=%s, want=%Lu, limit=%Lu\n",
> >                         bdevname(bio->bi_bdev, b),
> > -                       bio->bi_rw,
> > +                       (bio->bi_rw & WRITE) ? "WRITE" : "READ",

Perhaps print the hex value as well and emit
both messages on a single line to make grepping
a bit easier.

Something like:
---
 block/blk-core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..2a710df 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1624,12 +1624,11 @@ static void handle_bad_sector(struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
-			bdevname(bio->bi_bdev, b),
-			bio->bi_rw,
-			(unsigned long long)bio_end_sector(bio),
-			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
+	printk(KERN_INFO "%s: attempt to access beyond end of device - rw=%s(%lx), want=%Lu, limit=%Lu\n",
+	       bdevname(bio->bi_bdev, b),
+	       bio->bi_rw & WRITE ? "WRITE" : "READ", bio->bi_rw,
+	       (unsigned long long)bio_end_sector(bio),
+	       (long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
 
 	set_bit(BIO_EOF, &bio->bi_flags);
 }


