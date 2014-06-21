Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaFUAzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 20:55:31 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:51232 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaFUAz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 20:55:29 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: scsi-mq
Thread-Topic: scsi-mq
Thread-Index: AQHPhkTL6P783gg4/EmIzBJz+o9Cjpt1ZBoAgADetQCAADkSgIAERC0g
Date: Sat, 21 Jun 2014 00:52:22 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B41923@G9W0745.americas.hpqcorp.net>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
 <53A05068.4080702@acm.org> <53A10B3A.6050705@kernel.dk>
 <53A13B19.2010305@acm.org>
In-Reply-To: <53A13B19.2010305@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:bvanassche@acm.org]
> Sent: Wednesday, 18 June, 2014 2:09 AM
> To: Jens Axboe; Christoph Hellwig; James Bottomley
> Cc: Elliott, Robert (Server Storage); linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: scsi-mq
> 
...
> Hello Jens,
> 
> Fio reports the same queue depth for use_blk_mq=Y (mq below) and
> use_blk_mq=N (sq below), namely ">=64". However, the number of context
> switches differs significantly for the random read-write tests.
> 
...
> It seems like with the traditional SCSI mid-layer and block core (sq)
> that the number of context switches does not depend too much on the
> number of I/O operations but that for the multi-queue SCSI core there
> are a little bit more than two context switches per I/O in the
> particular test I ran. The "randrw" script I used for this test takes
> SCSI LUNs as arguments (/dev/sdX) and starts the fio tool as follows:

Some of those context switches might be from scsi_end_request(), 
which always schedules the scsi_requeue_run_queue() function via the
requeue_work workqueue for scsi-mq.  That causes lots of context 
switches from a busy application thread (e.g., fio) to a 
kworker thread.

As shown by ftrace:

             fio-19340 [005] dNh. 12067.908444: scsi_io_completion <-scsi_finish_command
             fio-19340 [005] dNh. 12067.908444: scsi_end_request <-scsi_io_completion
             fio-19340 [005] dNh. 12067.908444: blk_update_request <-scsi_end_request
             fio-19340 [005] dNh. 12067.908445: blk_account_io_completion <-blk_update_request
             fio-19340 [005] dNh. 12067.908445: scsi_mq_free_sgtables <-scsi_end_request
             fio-19340 [005] dNh. 12067.908445: scsi_free_sgtable <-scsi_mq_free_sgtables
             fio-19340 [005] dNh. 12067.908445: blk_account_io_done <-__blk_mq_end_io
             fio-19340 [005] dNh. 12067.908445: blk_mq_free_request <-__blk_mq_end_io
             fio-19340 [005] dNh. 12067.908446: blk_mq_map_queue <-blk_mq_free_request
             fio-19340 [005] dNh. 12067.908446: blk_mq_put_tag <-__blk_mq_free_request
             fio-19340 [005] .N.. 12067.908446: blkdev_direct_IO <-generic_file_direct_write
    kworker/5:1H-3207  [005] .... 12067.908448: scsi_requeue_run_queue <-process_one_work
    kworker/5:1H-3207  [005] .... 12067.908448: scsi_run_queue <-scsi_requeue_run_queue
    kworker/5:1H-3207  [005] .... 12067.908448: blk_mq_start_stopped_hw_queues <-scsi_run_queue
             fio-19340 [005] .... 12067.908449: blk_start_plug <-do_blockdev_direct_IO
             fio-19340 [005] .... 12067.908449: blkdev_get_block <-do_direct_IO
             fio-19340 [005] .... 12067.908450: blk_throtl_bio <-generic_make_request_checks
             fio-19340 [005] .... 12067.908450: blk_sq_make_request <-generic_make_request
             fio-19340 [005] .... 12067.908450: blk_queue_bounce <-blk_sq_make_request
             fio-19340 [005] .... 12067.908450: blk_mq_map_request <-blk_sq_make_request
             fio-19340 [005] .... 12067.908451: blk_mq_queue_enter <-blk_mq_map_request
             fio-19340 [005] .... 12067.908451: blk_mq_map_queue <-blk_mq_map_request
             fio-19340 [005] .... 12067.908451: blk_mq_get_tag <-__blk_mq_alloc_request
             fio-19340 [005] .... 12067.908451: blk_mq_bio_to_request <-blk_sq_make_request
             fio-19340 [005] .... 12067.908451: blk_rq_bio_prep <-init_request_from_bio
             fio-19340 [005] .... 12067.908451: blk_recount_segments <-bio_phys_segments
             fio-19340 [005] .... 12067.908452: blk_account_io_start <-blk_mq_bio_to_request
             fio-19340 [005] .... 12067.908452: blk_mq_hctx_mark_pending <-__blk_mq_insert_request
             fio-19340 [005] .... 12067.908452: blk_mq_run_hw_queue <-blk_sq_make_request
             fio-19340 [005] .... 12067.908452: blk_mq_start_request <-__blk_mq_run_hw_queue

In one snapshot just tracing scsi_end_request() and
scsi_request_run_queue(), 30K scsi_end_request() calls yielded 
20k scsi_request_run_queue() calls.

In this case, blk_mq_start_stopped_hw_queues() doesn't end up
doing anything since there aren't any stopped queues to restart 
(blk_mq_run_hw_queue() gets called a bit later during routine 
fio work); the context switch turned out to be a waste of time.  
If it did find a stopped queue, then it would call 
blk_mq_run_hw_queue() itself.

---
Rob Elliott    HP Server Storage

