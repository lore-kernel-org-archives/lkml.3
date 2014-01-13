Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaAMXzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:55:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaAMXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:55:29 -0500
Date: Mon, 13 Jan 2014 15:55:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/7] zram: fix race between reset and flushing pending
 work
Message-Id: <20140113155527.5731d24ca86f01bfd5ec716f@linux-foundation.org>
In-Reply-To: <1389611942-15544-2-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
	<1389611942-15544-2-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 20:18:56 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Dan and Sergey reported that there is a racy between reset and
> flushing of pending work so that it could make oops by freeing
> zram->meta in reset while zram_slot_free can access zram->meta
> if new request is adding during the race window.
> 
> This patch moves flush after taking init_lock so it prevents
> new request so that it closes the race.
> 
> ..
>
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -553,14 +553,14 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	size_t index;
>  	struct zram_meta *meta;
>  
> -	flush_work(&zram->free_work);
> -
>  	down_write(&zram->init_lock);
>  	if (!zram->init_done) {
>  		up_write(&zram->init_lock);
>  		return;
>  	}
>  
> +	flush_work(&zram->free_work);
> +
>  	meta = zram->meta;
>  	zram->init_done = 0;

This makes zram.lock nest inside zram.init_lock, which afaict is new
behaviour.

That all seems OK and logical - has it been well tested with lockdep?
