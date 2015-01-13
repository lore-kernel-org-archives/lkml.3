Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbbAMXak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:30:40 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17246 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbbAMXai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:30:38 -0500
Message-ID: <54B5AA84.9010306@fb.com>
Date: Tue, 13 Jan 2015 16:30:12 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@infradead.org>
CC: <dedekind1@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org> <54B5A188.2000001@nod.at> <54B5A213.1090502@fb.com> <54B5A77C.9040405@nod.at>
In-Reply-To: <54B5A77C.9040405@nod.at>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_07:2015-01-13,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501130230
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 04:17 PM, Richard Weinberger wrote:
> Am 13.01.2015 um 23:54 schrieb Jens Axboe:
>>>> blk_rq_map_sg returns the number of entries actually mapped, which
>>>> might be smaller than the number passed in due to merging.
>>>
>>> Yep, but the ubi_sql has a fixed number of scatterlist entries, UBI_MAX_SG_COUNT.
>>> And I limit it also to that using: blk_queue_max_segments(dev->rq, UBI_MAX_SG_COUNT);
>>>
>>> Is there another reason why I should use the return value of blk_rq_map_sg()?
>>> Please also note that the UBI block driver is read-only.
>>
>> It can return less than what you asked for, if segments are coalesced.
>> Read/write, doesn't matter. You should always use the returned value as
>> the indication of how many segments to access in pdu->usgl.sg for data
>> transfer.
> 
> Sorry, I don't fully understand.
> 
> Currently the driver does:
> to_read = blk_rq_bytes(req);
> Then it fills pdu->usgl.sg up to to_read bytes
> and calls blk_mq_end_request().
> 
> If I understand you correctly it can happen that blk_rq_bytes() returns
> more bytes than blk_rq_map_sg() allocated, right?

No, the number of bytes will be the same, no magic is involved :-)

But lets say the initial request has 4 bios, with each 2 pages, for a
total of 8 segments. Lets further assume that the pages in each bio are
contiguous, so that blk_rq_map_sg() will map this to 4 sg elements, each
2xpages long.

Now, this may already be handled just fine, and you don't need to
update/store the actual sg count. I just looked at the source, and I'm
assuming it'll do the right thing (ubi_read_sg() will bump the active sg
element, when that size has been consumed), but I don't have
ubi_read_sg() in my tree to verify.

-- 
Jens Axboe

