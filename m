Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbbAJVwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:52:10 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbbAJVwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:52:07 -0500
Message-ID: <54B19F02.2070506@nod.at>
Date: Sat, 10 Jan 2015 22:52:02 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        axboe@fb.com, tom.leiming@gmail.com
Subject: Re: [PATCH 2/2] UBI: Block: Add blk-mq support
References: <1420900188-15781-1-git-send-email-richard@nod.at> <1420900188-15781-2-git-send-email-richard@nod.at> <20150110185851.GA3945@infradead.org>
In-Reply-To: <20150110185851.GA3945@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.01.2015 um 19:58 schrieb Christoph Hellwig:
>> +struct ubiblock_pdu {
>> +	struct request *req;
> 
> No need to store the request, you can trivially get at it using
> blk_mq_rq_from_pdu().

Very handy, I was not aware of blk_mq_rq_from_pdu().

>> +	struct ubiblock *dev;
> 
> Why do you need the dev pointer?  You can always trivially get
> it using req->queuedata.

Same here.

>> +static void ubiblock_do_work(struct work_struct *work)
>> +{
>> +	int ret;
>> +	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
>> +
>> +	ret = ubiblock_read(pdu);
>> +	blk_mq_end_request(pdu->req, ret ?: 0);
> 
> Why not just pass ret as-is?

Obviously a brain fart. :-\

>> +	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
>> +	    get_capacity(req->rq_disk))
>> +		return BLK_MQ_RQ_QUEUE_ERROR;
> 
> The upper layers take are of this check.

Ok.

>> +	pdu->usgl.list_pos = 0;
>> +	pdu->usgl.page_pos = 0;
> 
> Having a helper to initialize a ubi_sgl would be nicer than having
> to open code it ike here.

Ok.

>> +
>> +	blk_mq_start_request(req);
>> +	ret = blk_rq_map_sg(hctx->queue, req, pdu->usgl.sg);
>> +
>> +	queue_work(dev->wq, &pdu->work);
> 
> Why don't you move these calls into the work queue as well?  The
> queue_rq call would literally just become a queue_work call.

I did not know that I'm allowed to get hctx->queue also via req->q.

> And given that this is a fairly common patter this should allow
> us to refactor / optimize this case a bit later on.

Will send a v2 in a jiffy!

Thanks,
//richard
