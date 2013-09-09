Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3IIMi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:38:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45456 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3IIMi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:38:27 -0400
Date: Mon, 9 Sep 2013 15:34:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: zram: remove init_done from zram struct (v2)
Message-ID: <20130909123448.GA19256@mwanda>
References: <20130906152120.GF2238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906152120.GF2238@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 06:21:20PM +0300, Sergey Senozhatsky wrote:
> @@ -558,14 +563,12 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	flush_work(&zram->free_work);
>  
>  	down_write(&zram->init_lock);
> -	if (!zram->init_done) {
> +	if (!init_done(zram)) {
>  		up_write(&zram->init_lock);
>  		return;
>  	}
>  
>  	meta = zram->meta;
> -	zram->init_done = 0;
> -
>  	/* Free all pages that are still in this zram device */
>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>  		unsigned long handle = meta->table[index].handle;
> @@ -604,9 +607,7 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
>  
>  	/* zram devices sort of resembles non-rotational disks */
>  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
> -
>  	zram->meta = meta;
> -	zram->init_done = 1;
>  
>  	pr_debug("Initialization done!\n");
>  }

I am uncomfortable with the locking in zram_reset_device().  There
should be a check for init_done() in zram_slot_free_notify() otherwise
we could add more work at the same time we are calling flush_work().

It should be that as soon as we start to reset then we say init is not
done, we stop loading more work, we any existing work and then clean up.
(There are details involved that I haven't looked at, but the original
code looks racy to me).

regards,
dan carpenter


