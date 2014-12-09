Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaLIEj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 23:39:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9865 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533AbaLIEj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 23:39:28 -0500
Message-ID: <54867CFA.8040304@fb.com>
Date: Mon, 8 Dec 2014 21:39:22 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: prevent unmapped hw queue from being scheduled
References: <1417606684-20907-1-git-send-email-ming.lei@canonical.com> <CACVXFVMzQ8TkxsiUujUZR0E=0Lx=BtZ2BsLmhCTHk8D9dr8rag@mail.gmail.com>
In-Reply-To: <CACVXFVMzQ8TkxsiUujUZR0E=0Lx=BtZ2BsLmhCTHk8D9dr8rag@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-09_01:2014-12-08,2014-12-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.3289928853294e-12 kscore.compositescore=0
 circleOfTrustscore=26.0548541350743 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412090049
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 05:41 PM, Ming Lei wrote:
> On Wed, Dec 3, 2014 at 7:38 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> When one hardware queue has no mapped software queues, it
>> shouldn't have been scheduled. Otherwise WARNING or OOPS
>> can triggered.
>>
>> blk_mq_hw_queue_mapped() helper is introduce for fixing
>> the problem.
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>   block/blk-mq.c |    8 ++++++--
>>   block/blk-mq.h |    5 +++++
>>   2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index c95abc6..c916ad0 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -599,7 +599,7 @@ static void blk_mq_rq_timer(unsigned long priv)
>>                   * If not software queues are currently mapped to this
>>                   * hardware queue, there's nothing to check
>>                   */
>> -               if (!hctx->nr_ctx || !hctx->tags)
>> +               if (!blk_mq_hw_queue_mapped(hctx))
>>                          continue;
>>
>>                  blk_mq_tag_busy_iter(hctx, blk_mq_check_expired, &data);
>> @@ -819,7 +819,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
>>
>>   void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
>>   {
>> -       if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
>> +       if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state) ||
>> +           !blk_mq_hw_queue_mapped(hctx)))
>>                  return;
>>
>>          if (!async) {
>> @@ -926,6 +927,9 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
>>
>>   void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
>>   {
>> +       if (unlikely(!blk_mq_hw_queue_mapped(hctx)))
>> +               return;
>> +
>>          kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
>>                          &hctx->delay_work, msecs_to_jiffies(msecs));
>>   }
>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>> index d567d52..206230e 100644
>> --- a/block/blk-mq.h
>> +++ b/block/blk-mq.h
>> @@ -115,4 +115,9 @@ static inline void blk_mq_set_alloc_data(struct blk_mq_alloc_data *data,
>>          data->hctx = hctx;
>>   }
>>
>> +static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
>> +{
>> +       return hctx->nr_ctx && hctx->tags;
>> +}
>> +
>>   #endif
>
> Gentle ping...

Picked up for 3.19, sorry for the delay. I'm curious how this queue gets 
scheduled, though. My worry here would be that we are masking a bug that 
should be fixed separately.

-- 
Jens Axboe

