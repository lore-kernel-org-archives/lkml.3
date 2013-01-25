Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3AYULB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:11:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab3AYUK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:10:58 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: "Philip J. Kelleher" <pjk1939@us.ibm.com>
Cc: axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH] block: IBM RamSan 70/80 device driver.
References: <20130125194050.GA28313@oc6784271780.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 25 Jan 2013 15:10:47 -0500
In-Reply-To: <20130125194050.GA28313@oc6784271780.ibm.com> (Philip
	J. Kelleher's message of "Fri, 25 Jan 2013 13:40:50 -0600")
Message-ID: <x494ni5uipk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Philip J. Kelleher" <pjk1939@us.ibm.com> writes:

> From: Joshua H Morris <josh.h.morris@us.ibm.com>
> 	Philip J Kelleher <pjk1939@us.ibm.com>
>
> This patch includes the device driver for the IBM RamSan family
> of PCI SSD flash storage cards. This driver will inlcude support for the
> RamSan 70 and 80. The driver presents a block device for device I/O.

Hi,

Your driver does not handle REQ_FLUSH.  Does that mean that the
supported cards do not have a volatile write-back cache?

> +	blk_size = rsxx_get_logical_block_size(card);
> +
> +	blk_queue_make_request(card->queue, rsxx_make_request);
> +	blk_queue_bounce_limit(card->queue, BLK_BOUNCE_ANY);
> +	blk_queue_dma_alignment(card->queue, blk_size - 1);
> +	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
> +	blk_queue_logical_block_size(card->queue, blk_size);
> +	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
> +	blk_queue_max_discard_sectors(card->queue, RSXX_HW_BLK_SIZE >> 9);

Did you mean to set max_discard_sectors inside the below for loop?
Either way, do you really only support a single hardware sector discard?

> +	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, card->queue);
> +	if (rsxx_discard_supported(card)) {
> +		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, card->queue);
> +		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
> +		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
> +		card->queue->limits.discard_zeroes_data = 1;
> +	}

Cheers,
Jeff
