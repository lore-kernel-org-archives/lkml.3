Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaIHWyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:54:46 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:23901 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaIHWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:54:44 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Ming Lei <ming.lei@canonical.com>, Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Thread-Topic: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Thread-Index: AQHPyndBCdYWBRGdx0SqYvXH0smrz5v2BBoAgAFyO4CAAF/iUA==
Date: Mon, 8 Sep 2014 22:53:05 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C67C0E@G9W0745.americas.hpqcorp.net>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
	<20140907184956.GB23026@lst.de>
 <CACVXFVP-kUkCoW_pPrxqKWeoSKkxCACLLth2ycv87EVzfr2mUA@mail.gmail.com>
In-Reply-To: <CACVXFVP-kUkCoW_pPrxqKWeoSKkxCACLLth2ycv87EVzfr2mUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s88MsooD001851



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Ming Lei
> Sent: Monday, 08 September, 2014 11:55 AM
> To: Christoph Hellwig
> Cc: Jens Axboe; Linux Kernel Mailing List; Linux SCSI List
> Subject: Re: [PATCH 0/6] blk-mq: initialize pdu of flush req
> explicitly
> 
> On Mon, Sep 8, 2014 at 2:49 AM, Christoph Hellwig <hch@lst.de> wrote:
> > This works fine for me, although I still don't really like it very
> much.
> >
> > If you really want to go down the path of major surgery in this
> > area we should probably allocate a flush request per hw_ctx, and
> > initialize it using the normal init/exit functions.  If we want
> > to have proper multiqueue performance on devices needing flushes
> > we'll need something like that anyway.
> 
> Yes, that should be the final solution for the problem, and looks the
> whole flush machinery need to move into hctx, I will try to figure
> out one patch to do that.

Please change flush_rq allocation from kzalloc to kzalloc_node 
while operating on that code (would have affected PATCH 1/6).

blk_mq_init_queue currently has this for q->flush_rq:
        q->flush_rq = kzalloc(round_up(sizeof(struct request) +
                                set->cmd_size, cache_line_size()),
                                GFP_KERNEL);

while all its other allocations are tied to set->numa_node:
        hctxs = kmalloc_node(set->nr_hw_queues * sizeof(*hctxs), GFP_KERNEL,
                        set->numa_node);
        q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);

or, for per-CPU structures, tied to the appropriate node:
        for (i = 0; i < set->nr_hw_queues; i++) {
                int node = blk_mq_hw_queue_to_node(map, i);

                hctxs[i] = kzalloc_node(sizeof(struct blk_mq_hw_ctx),
                                        GFP_KERNEL, node);

Per-hctx flush requests would mean following the hctxs[i]
approach.


---
Rob Elliott    HP Server Storage



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
