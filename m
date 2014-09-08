Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaIHPF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:05:57 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40581 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaIHPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1409081047420.1433-100000@iolanthe.rowland.org>
References: <CADT32eLJOd5AuFSkg34gOJx-7GXe3Lz1xNe3SzCBv9U1F1ikbA@mail.gmail.com>
	<Pine.LNX.4.44L0.1409081047420.1433-100000@iolanthe.rowland.org>
Date: Mon, 8 Sep 2014 10:05:54 -0500
Message-ID: <CADT32e+2dctZOmWLCoaKuWH4CiTywe-yVX3DgqjxWxm+4gU26g@mail.gmail.com>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So should a request queue be in bypass mode when the device is being detached
and queue is being unregistereed because requests can get queued up?


On Mon, Sep 8, 2014 at 9:51 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 7 Sep 2014, Shirish Pargaonkar wrote:
>
>> I think the problem is, when a gendisk is detached, its request queue
>> is not put in bypass mode
>> cause when it is re-attached, code tries to put it out of bypass mode,
>> hence the warning.
>>
>> So either of these should work, I have not tested it, just coded it up.
>
> I'm pretty sure that both of your solutions are wrong.
>
> Jens and James, it appears the problem is in blk_register_queue().  The
> code does this:
>
>         /*
>          * Initialization must be complete by now.  Finish the initial
>          * bypass from queue allocation.
>          */
>         queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
>         blk_queue_bypass_end(q);
>
> This doesn't work well if the queue is unregistered later and then
> registered again -- which is what happens when the sd driver is unbound
> from a device and then bound again.  It looks like the code should be:
>
>         if (!queue_flag_test_and_set(QUEUE_FLAG_INIT_DONE, q))
>                 blk_queue_bypass_end(q);
>
> Do you agree?  If so, I'll send in patch.
>
> Alan Stern
>
