Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaI1Qfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:35:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59736 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaI1Qfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:35:45 -0400
Message-ID: <542838E0.9000604@kernel.dk>
Date: Sun, 28 Sep 2014 10:35:44 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kieran Kunhya <kieran@kunhya.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Fabian Frederick <fabf@skynet.be>,
        Akhil Bhansali <abhansali@stec-inc.com>, Jiri Kosina <jkosina@suse.cz>,
        Alan <gnomes@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] block: Add support for Sony SxS cards
References: <1405814499-4163-1-git-send-email-kieran@kunhya.com> <1411861415-16210-1-git-send-email-kieran@kunhya.com> <542772E7.80902@kernel.dk> <1411915159.78518.YahooMailNeo@web161504.mail.bf1.yahoo.com>
In-Reply-To: <1411915159.78518.YahooMailNeo@web161504.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2014 08:39 AM, Kieran Kunhya wrote:
>> So a few questions here... This device only does reads? And it seems to 
>> be assuming that only reads end up in the request handler? How so?
> 
> I have only reverse engineered the read-part of the device. Yes, the 
> driver should check whether the request is a read. 

And you should also deny any writeable opens, in that case. Add an open
method and check for FMODE_WRITE. Then add a check ala:

	if (bio_data_dir(bio)) {
		bio_endio(bio, -EROFS);
		return;
	}

and the top of your sxs_request().

>> Second question. IO never fails? There's no status checking and IO is 
>> always ended successfully. This too seems odd.
> 
> I will fix this.
> 
>> Third, this wong work as-is, at least not of HIGHMEM is used. After the 
>> bvec_kmap_irq(), irqs will be disabled. But your sxs_memcpy_read() 
>> invokes schedule through the completion waits, that will instantly go bad.
> 
> Is there a better way of doing this? I spent a long time trying to get DMA 
> to work but couldn't so had to resort to this ugly hack. I assume the memcpy 
> also needs to have some locking somewhere?

It really is pretty horrible and slow, but if you can't get DMA working,
then so be it. And yes, you should add a mutex that is held for the
duration of the memcpy_read(), otherwise things will go bad very fast if
two or more processes attempt to read from it at the same time. A quick
work-around for the irq issue would be to have the block layer bounce
the highmem pages for you. That's actually the default behavior, but I
would make it explicit with a call to:

	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);

after the blk_queue_make_request() call. If you do that, then get rid of
the bvec_kmap_irq(), and just do:

	buffer = page_address(bvec.bv_page) + bvec.bv_offset;

to get the destination for your read.

-- 
Jens Axboe

