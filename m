Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3D1Jkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 05:40:47 -0400
Received: from mout.web.de ([212.227.15.4]:60249 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab3D1Jkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 05:40:45 -0400
From: Markus <M4rkusXXL@web.de>
To: Shaohua Li <shli@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: hybrid raid1 with trim support [REGRESSION]
Date: Sun, 28 Apr 2013 11:40:42 +0200
Message-ID: <2069465.HvIQbCn58p@f209>
User-Agent: KMail/4.10.1 (Linux/3.8.10-gentoo; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130428010016.GA26411@kernel.org>
References: <3387108.NX1Tlx8b5x@f209> <20130428005446.GA20018@kernel.org> <20130428010016.GA26411@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nHuApYCf2++OLOVSsCKXG+bHDSvHsynGUy7tO0JA/kZ
 GrYzE/qUwdODG71rL/e8jREflLtBP3QiAQVpa55X5lZAwXsL3C
 d4LNZ9RBwurkckw8iPDw9q0d02chdgVl1f9CcuizF7Z6aE8gkb
 +IoyBunUUj6rENhGPn484Rm1PQgUfj+WawxQG+1IvjFAeUrjsb
 FUFlgUI78dsiLn2tcf8hA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Thanks for your work. The patch seems to work for me on a vanilla 3.8.10, at 
least the hdds are no longer dropped from the raid.
The code now ignores some request? What was the reason the disks fell off the 
raid? The discards are still passed to the ssd?


Thanks,
Markus


Shaohua Li schrieb am 28.04.2013:
> On Sun, Apr 28, 2013 at 08:54:46AM +0800, Shaohua Li wrote:
> > On Sat, Apr 27, 2013 at 06:29:49PM +0200, Markus wrote:
> > > Hi!
> > > 
> > > Now I had the time to bisect, started with 3.7 as good and 3.8 as bad.
> > > 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 is the bad commit. [1]
> > > block: add plug for blkdev_issue_discard
> > > 
> > > While 3.8.10 was still bad, the same kernel with the reverted patch 
applied is fine.
> > Thanks for the reporting. Does below patch work for you?
> Oops, there is a typo there, should be this one:
> 
> ---
>  drivers/md/raid1.c  |    7 ++++++-
>  drivers/md/raid10.c |    7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/md/raid1.c
> ===================================================================
> --- linux.orig/drivers/md/raid1.c	2013-03-07 14:14:05.950824173 +0800
> +++ linux/drivers/md/raid1.c	2013-04-28 08:57:17.874058434 +0800
> @@ -981,7 +981,12 @@ static void raid1_unplug(struct blk_plug
>  	while (bio) { /* submit pending writes */
>  		struct bio *next = bio->bi_next;
>  		bio->bi_next = NULL;
> -		generic_make_request(bio);
> +		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
> +			/* Just ignore it */
> +			bio_endio(bio, 0);
> +		else
> +			generic_make_request(bio);
>  		bio = next;
>  	}
>  	kfree(plug);
> Index: linux/drivers/md/raid10.c
> ===================================================================
> --- linux.orig/drivers/md/raid10.c	2013-03-07 14:14:05.950824173 +0800
> +++ linux/drivers/md/raid10.c	2013-04-28 08:57:44.765719067 +0800
> @@ -1133,7 +1133,12 @@ static void raid10_unplug(struct blk_plu
>  	while (bio) { /* submit pending writes */
>  		struct bio *next = bio->bi_next;
>  		bio->bi_next = NULL;
> -		generic_make_request(bio);
> +		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> +		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
> +			/* Just ignore it */
> +			bio_endio(bio, 0);
> +		else
> +			generic_make_request(bio);
>  		bio = next;
>  	}
>  	kfree(plug);
