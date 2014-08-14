Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaHNPKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:10:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36385 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754563AbaHNPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:10:20 -0400
Message-ID: <53ECD125.3080701@fb.com>
Date: Thu, 14 Aug 2014 09:09:25 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>,
        Keith Busch <keith.busch@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR> <53EC7273.5060303@bjorling.me>
In-Reply-To: <53EC7273.5060303@bjorling.me>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-14_03:2014-08-14,2014-08-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.3251899577682e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408140187
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 02:25 AM, Matias Bjørling wrote:
> On 08/14/2014 12:27 AM, Keith Busch wrote:
>> On Sun, 10 Aug 2014, Matias Bjørling wrote:
>>> On Sat, Jul 26, 2014 at 11:07 AM, Matias Bjørling <m@bjorling.me> wrote:
>>>> This converts the NVMe driver to a blk-mq request-based driver.
>>>>
>>>
>>> Willy, do you need me to make any changes to the conversion? Can you
>>> pick it up for 3.17?
>>
>> Hi Matias,
>>
> 
> Hi Keith, Thanks for taking the time to take another look.
> 
>> I'm starting to get a little more spare time to look at this again. I
>> think there are still some bugs here, or perhaps something better we
>> can do. I'll just start with one snippet of the code:
>>
>> @@ -765,33 +619,49 @@ static int nvme_submit_bio_queue(struct nvme_queue
>> *nvmeq, struct nvme_ns *ns,
>>   submit_iod:
>>      spin_lock_irq(&nvmeq->q_lock);
>>      if (nvmeq->q_suspended) {
>>          spin_unlock_irq(&nvmeq->q_lock);
>>          goto finish_cmd;
>>      }
>>
>>   <snip>
>>
>>   finish_cmd:
>>      nvme_finish_cmd(nvmeq, req->tag, NULL);
>>      nvme_free_iod(nvmeq->dev, iod);
>>      return result;
>> }
>>
>>
>> If the nvme queue is marked "suspended", this code just goto's the finish
>> without setting "result", so I don't think that's right.
> 
> The result is set to BLK_MQ_RQ_QUEUE_ERROR, or am I mistaken?

Looks OK to me, looking at the code, 'result' is initialized to
BLK_MQ_RQ_QUEUE_BUSY though. Which looks correct, we don't want to error
on a suspended queue.

>> But do we even need the "q_suspended" flag anymore? It was there because
>> we couldn't prevent incoming requests as a bio based driver and we needed
>> some way to mark that the h/w's IO queue was temporarily inactive, but
>> blk-mq has ways to start/stop a queue at a higher level, right? If so,
>> I think that's probably a better way than using this driver specific way.
> 
> Not really, its managed by the block layer. Its on purpose I haven't
> removed it. The patch is already too big, and I want to keep the patch
> free from extra noise that can be removed by later patches.
> 
> Should I remove it anyway?

No point in keeping it, if it's not needed...

>> I haven't event tried debugging this next one: doing an insmod+rmmod
>> caused this warning followed by a panic:
>>
> 
> I'll look into it. Thanks

nr_tags must be uninitialized or screwed up somehow, otherwise I don't
see how that kmalloc() could warn on being too large. Keith, are you
running with slab debugging? Matias, might be worth trying.

FWIW, in general, we've run a bunch of testing internally at FB, all on
backported blk-mq stack and nvme-mq. No issues observed, and performance
is good and overhead low. For other reasons that I can't go into here,
this is the stack on which we'll run nvme hardware. Other features are
much easily implemented on top of a blk-mq based driver as opposed to a
bio based one, similarly to the suspended part above.

-- 
Jens Axboe

