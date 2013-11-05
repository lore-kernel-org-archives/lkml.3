Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3KEU4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:56:30 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:37573 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3KEU42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:56:28 -0500
X-ASG-Debug-ID: 1383684987-03d6a54d1a10eae0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Olof Johansson <olof@lixom.net>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <CAOesGMirg=ex9hLCjGBpj0cMhLeQ5cJQoRv72tgg7PoSKWUDhA@mail.gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Tushar Behera <tushar.behera@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
 <52794823.7080503@kernel.dk>
 <CAOesGMj1xXXM-gNgWQwBKOczpJtM7CobYy4h7Fe=4W3U43EJGQ@mail.gmail.com>
 <20131105203308.3802.45122@localhost.localdomain>
 <CAOesGMirg=ex9hLCjGBpj0cMhLeQ5cJQoRv72tgg7PoSKWUDhA@mail.gmail.com>
Message-ID: <20131105205623.3802.5166@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: Boot failure on Arndale with next-20131105
Date: Tue, 5 Nov 2013 15:56:23 -0500
X-ASG-Orig-Subj: Re: Boot failure on Arndale with next-20131105
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1383684987
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142084
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Olof Johansson (2013-11-05 15:38:33)
> On Tue, Nov 5, 2013 at 12:33 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> > Quoting Olof Johansson (2013-11-05 15:23:51)
> >> On Tue, Nov 5, 2013 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > [ horrible crashes fixed by removing my patch ]
> >
> >> > Very weird! What file system is being used?
> >>
> >> Most of my failures have happened on regular MMC cards with ext4
> >> filesystems on them.
> >>
> >> Note that the panic happens during device probe / partition table
> >> scanning, not after mounting the filesystem.
> >>
> >> Giving your patch a go now across the board. I'm very concerned about
> >> the reports of bisectability, build failures and heaps of warnings
> >> though. Did the 0-day builder pick up any of those? :-/
> >>
> >
> > Hmmm, is bcache in your config?
> 
> Doesn't look that way -- no ARM defconfigs enable it (it's what I
> build and boot), and the option defaults to off and nothing selects
> it.

Ok, I think I see it.  My guess is that you're hitting bounce buffers.
__blk_queue_bounce is the only caller of the bio splitting code I can
see that you might be hitting.

My first patch exposed a lurking bug in bio_clone_biovec.  Basically
bio->bi_vcnt is being doubled instead of initialized.

This patch is only compile tested, but I think it'll fix it.

diff --git a/fs/bio.c b/fs/bio.c
index be93de1..3595456 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -612,6 +612,7 @@ int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask)
 	unsigned nr_iovecs = 0;
 	struct bio_vec bv, *bvl = NULL;
 	struct bvec_iter iter;
+	int i;
 
 	BUG_ON(!bio->bi_pool);
 	BUG_ON(BIO_POOL_IDX(bio) != BIO_POOL_NONE);
@@ -628,8 +629,9 @@ int bio_clone_biovec(struct bio *bio, gfp_t gfp_mask)
 		bvl = bio->bi_inline_vecs;
 	}
 
+	i = 0;
 	bio_for_each_segment(bv, bio, iter)
-		bvl[bio->bi_vcnt++] = bv;
+		bvl[i++] = bv;
 
 	bio->bi_io_vec = bvl;
 	bio->bi_iter.bi_idx = 0;
