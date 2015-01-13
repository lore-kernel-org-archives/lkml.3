Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbbAMWv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:51:57 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbbAMWvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:51:55 -0500
Message-ID: <54B5A188.2000001@nod.at>
Date: Tue, 13 Jan 2015 23:51:52 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        axboe@fb.com, tom.leiming@gmail.com
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org>
In-Reply-To: <20150113162553.GA24351@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.01.2015 um 17:25 schrieb Christoph Hellwig:
>> +	struct ubi_sgl usgl;
> 
> Btw, what's in struct ubi_sgl?  Can't find that in my tree.

"[PATCH 1/2] UBI: Add initial support for scatter gather" adds it.

/**
 * struct ubi_sgl - UBI scatter gather list data structure.
 * @list_pos: current position in @sg[]
 * @page_pos: current position in @sg[@list_pos]
 * @sg: the scatter gather list itself
 *
 * ubi_sgl is a wrapper around a scatter list which keeps track of the
 * current position in the list and the current list item such that
 * it can be used across multiple ubi_leb_read_sg() calls.
 */
struct ubi_sgl {
        int list_pos;
        int page_pos;
        struct scatterlist sg[UBI_MAX_SG_COUNT];
};

>> +static void ubiblock_do_work(struct work_struct *work)
>> +{
>> +	int ret;
>> +	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
>> +	struct request *req = blk_mq_rq_from_pdu(pdu);
>> +
>> +	blk_mq_start_request(req);
>> +	blk_rq_map_sg(req->q, req, pdu->usgl.sg);
> 
> blk_rq_map_sg returns the number of entries actually mapped, which
> might be smaller than the number passed in due to merging.

Yep, but the ubi_sql has a fixed number of scatterlist entries, UBI_MAX_SG_COUNT.
And I limit it also to that using: blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);

Is there another reason why I should use the return value of blk_rq_map_sg()?
Please also note that the UBI block driver is read-only.

Thanks,
//richard
