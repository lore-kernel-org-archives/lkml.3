Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbbAMWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:54:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18229 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbbAMWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:54:34 -0500
Message-ID: <54B5A213.1090502@fb.com>
Date: Tue, 13 Jan 2015 15:54:11 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@infradead.org>
CC: <dedekind1@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org> <54B5A188.2000001@nod.at>
In-Reply-To: <54B5A188.2000001@nod.at>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_07:2015-01-13,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.160988131301636 urlsuspect_oldscore=0.160988131301636
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.160988131301636 spamscore=0
 recipient_to_sender_domain_totalscore=4 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501130226
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:51 PM, Richard Weinberger wrote:
> Am 13.01.2015 um 17:25 schrieb Christoph Hellwig:
>>> +	struct ubi_sgl usgl;
>>
>> Btw, what's in struct ubi_sgl?  Can't find that in my tree.
> 
> "[PATCH 1/2] UBI: Add initial support for scatter gather" adds it.
> 
> /**
>  * struct ubi_sgl - UBI scatter gather list data structure.
>  * @list_pos: current position in @sg[]
>  * @page_pos: current position in @sg[@list_pos]
>  * @sg: the scatter gather list itself
>  *
>  * ubi_sgl is a wrapper around a scatter list which keeps track of the
>  * current position in the list and the current list item such that
>  * it can be used across multiple ubi_leb_read_sg() calls.
>  */
> struct ubi_sgl {
>         int list_pos;
>         int page_pos;
>         struct scatterlist sg[UBI_MAX_SG_COUNT];
> };
> 
>>> +static void ubiblock_do_work(struct work_struct *work)
>>> +{
>>> +	int ret;
>>> +	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
>>> +	struct request *req = blk_mq_rq_from_pdu(pdu);
>>> +
>>> +	blk_mq_start_request(req);
>>> +	blk_rq_map_sg(req->q, req, pdu->usgl.sg);
>>
>> blk_rq_map_sg returns the number of entries actually mapped, which
>> might be smaller than the number passed in due to merging.
> 
> Yep, but the ubi_sql has a fixed number of scatterlist entries, UBI_MAX_SG_COUNT.
> And I limit it also to that using: blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
> 
> Is there another reason why I should use the return value of blk_rq_map_sg()?
> Please also note that the UBI block driver is read-only.

It can return less than what you asked for, if segments are coalesced.
Read/write, doesn't matter. You should always use the returned value as
the indication of how many segments to access in pdu->usgl.sg for data
transfer.

-- 
Jens Axboe

