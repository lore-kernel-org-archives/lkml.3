Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3AYVcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 16:32:52 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:52075 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3AYVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 16:32:48 -0500
Date: Fri, 25 Jan 2013 15:32:13 -0600
From: "Philip J. Kelleher" <pjk1939@us.ibm.com>
To: jmoyer@redhat.com
Cc: axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com
Subject: Re: Re: [PATCH] block: IBM RamSan 70/80 device driver.
Message-ID: <20130125213213.GA7460@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012521-7408-0000-0000-00000C38C0BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > From: Joshua H Morris <josh.h.morris@us.ibm.com>
> > 	Philip J Kelleher <pjk1939@us.ibm.com>
> >
> > This patch includes the device driver for the IBM RamSan family
> > of PCI SSD flash storage cards. This driver will inlcude support for the
> > RamSan 70 and 80. The driver presents a block device for device I/O.
> 
> Hi,
> 
> Your driver does not handle REQ_FLUSH.  Does that mean that the
> supported cards do not have a volatile write-back cache?
> 

We do not have a volatile write-back cache.

> > +	blk_size = rsxx_get_logical_block_size(card);
> > +
> > +	blk_queue_make_request(card->queue, rsxx_make_request);
> > +	blk_queue_bounce_limit(card->queue, BLK_BOUNCE_ANY);
> > +	blk_queue_dma_alignment(card->queue, blk_size - 1);
> > +	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
> > +	blk_queue_logical_block_size(card->queue, blk_size);
> > +	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
> > +	blk_queue_max_discard_sectors(card->queue, RSXX_HW_BLK_SIZE >> 9);
> 
> Did you mean to set max_discard_sectors inside the below for loop?
> Either way, do you really only support a single hardware sector discard?
> 
> > +	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, card->queue);
> > +	if (rsxx_discard_supported(card)) {
> > +		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, card->queue);
> > +		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
> > +		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
> > +		card->queue->limits.discard_zeroes_data = 1;
> > +	}

Yes, we only do discards in 4k chunks. It does look as though the
max_discard_sectors can/should be moved inside the if statement.

Thanks,
Philip

