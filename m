Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaIHOvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:51:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49176 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751584AbaIHOvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:51:43 -0400
Date: Mon, 8 Sep 2014 10:51:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
In-Reply-To: <CADT32eLJOd5AuFSkg34gOJx-7GXe3Lz1xNe3SzCBv9U1F1ikbA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1409081047420.1433-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2014, Shirish Pargaonkar wrote:

> I think the problem is, when a gendisk is detached, its request queue
> is not put in bypass mode
> cause when it is re-attached, code tries to put it out of bypass mode,
> hence the warning.
> 
> So either of these should work, I have not tested it, just coded it up.

I'm pretty sure that both of your solutions are wrong.

Jens and James, it appears the problem is in blk_register_queue().  The 
code does this:

	/*
	 * Initialization must be complete by now.  Finish the initial
	 * bypass from queue allocation.
	 */
	queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
	blk_queue_bypass_end(q);

This doesn't work well if the queue is unregistered later and then
registered again -- which is what happens when the sd driver is unbound
from a device and then bound again.  It looks like the code should be:

	if (!queue_flag_test_and_set(QUEUE_FLAG_INIT_DONE, q))
		blk_queue_bypass_end(q);

Do you agree?  If so, I'll send in patch.

Alan Stern

