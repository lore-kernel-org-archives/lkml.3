Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbaLBCnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:43:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56806 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbaLBCnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:43:47 -0500
Message-ID: <547D2759.8030200@fb.com>
Date: Mon, 1 Dec 2014 19:43:37 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: don't use rw_is_sync() to determine sync request
References: <4f327fd4f830a3fceab3694cdd7621c37f780809.1417391999.git.shli@kernel.org> <547BC5CF.7080904@fb.com> <20141201035712.GA8443@kernel.org> <20141201185934.GA52328@kernel.org>
In-Reply-To: <20141201185934.GA52328@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-02_01:2014-12-01,2014-12-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=9.02059188456761e-09 kscore.compositescore=0
 circleOfTrustscore=502.112 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412020018
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 11:59 AM, Shaohua Li wrote:
> On Sun, Nov 30, 2014 at 07:57:12PM -0800, Shaohua Li wrote:
>> On Sun, Nov 30, 2014 at 06:35:11PM -0700, Jens Axboe wrote:
>>> On 11/30/2014 05:01 PM, Shaohua Li wrote:
>>>> Buffer read is counted as sync in rw_is_sync(). If we use it,
>>>> blk_sq_make_request() will not do per-process plug any more.
>>>>
>>>> I haven't changed blk_mq_make_request() yet. It makes sense to dispatch
>>>> REQ_SYNC request immediately. But for buffer read, it's weird not to do
>>>> per-process plug, as buffer read doesn't need low latency.
>>>> blk_mq_merge_queue_io() isn't very helpful, as we don't have delay mechanism
>>>> there, the queue is immediately flushed, which makes the merge very
>>>> superficial.
>>>
>>> A read is sync, buffered or not. A buffered read is every bit as
>>> latency sensitive as an O_DIRECT read. I think it'd be fine to
>>> modify rw_is_sync() to disregard REQ_AHEAD as sync (and ensure it's
>>> carried forward in the request flags, too). At least to the extent
>>> that we process plug and get the merging, since for streamed reads
>>> we'd soon be waiting on them anyway.
>>
>> A quick search shows nobody uses REQ_AHEAD. For stream reads, only first several
>> reads are waited I suppose, later reads are read ahead. Maybe only counts
>> REQ_META read as sync?
>
> Changing rw_is_sync() sounds risky, as it will change behavior of other parts,
> like CFQ. REQ_META/REQ_PRIO isn't an option, metadata does readahead too.
> And nobody uses REQ_AHEAD. explictly checking REQ_SYNC in blk_sq_make_request()
> sounds better, which is just for pluging and we use it for ages in
> blk_queue_bio().

I'm not really disagreeing with you. The per-task plugging isn't a true 
delay mechanism like the old plugging was, and there's no question it 
makes sense to do on the single queue. For the multi queue, it's a bit 
more tricky. If it's truly a 1:1 cpu:queue mapping, then we can safely 
assume that we might as well execute it. Unless we can do batched 
submission, which would (somewhat) rely on having chains of requests to 
submit, which we'd only really get if we plug.

The fact that RAHEAD isn't currently really wired up is a shame, and it 
really should be. It might be problematic due to how we mix it up with 
failfast.

For blk_sq_make_request(), we should just make the change.

-- 
Jens Axboe

