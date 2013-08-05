Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3HEQTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:19:06 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:45636 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3HEQTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:19:04 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC PATCH] cfq-iosched: limit slice_idle when many busy queues
 are in idle window
Thread-Topic: [RFC PATCH] cfq-iosched: limit slice_idle when many busy
 queues are in idle window
Thread-Index: AQHOjVtGIPXCyBn/QUeyROYvxWg6AZl+TlAAgALFUYCAAAoPgIAFto4A
Date: Mon, 5 Aug 2013 16:18:55 +0000
Message-ID: <CE25409F.5A01%Tomoki.Sekiyama@hds.com>
In-Reply-To: <51FACD4D.9080300@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2366133DF5BB9544B62F6B9DA2A5006B@hds.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-05_05:2013-08-05,2013-08-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308050138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/13 17:04 , "Jens Axboe" <axboe@kernel.dk> wrote:

>On 08/01/2013 02:28 PM, Tomoki Sekiyama wrote:
>> On 7/30/13 10:09 PM, Shaohua Li wrote:
>>> On Tue, Jul 30, 2013 at 03:30:33PM -0400, Tomoki Sekiyama wrote:
>>>> Hi,
>>>>
>>>> When some application launches several hundreds of processes that
>>>>issue
>>>> only a few small sync I/O requests, CFQ may cause heavy latencies
>>>> (10+ seconds at the worst case), although the request rate is low
>>>>enough for
>>>> the disk to handle it without waiting. This is because CFQ waits for
>>>> slice_idle (default:8ms) every time before processing each request,
>>>>until
>>>> their thinktimes are evaluated.
>>>>
>>>> This scenario can be reproduced using fio with parameters below:
>>>>   fio -filename=/tmp/test -rw=randread -size=5G -runtime=15
>>>>-name=file1 \
>>>>       -bs=4k -numjobs=500 -thinktime=1000000
>>>> In this case, 500 processes issue a random read request every second.
>>>
>>> For this workload CFQ should perfectly detect it's a seek queue and
>>>disable
>>> idle. I suppose the reason is CFQ hasn't enough data/time to disable
>>>idle yet,
>>> since your thinktime is long and runtime is short.
>> 
>> Right, CFQ will learn the patten, but it takes too long time to reach
>>stable
>> performance when a lot of I/O processes are launched.
>> 
>>> I thought the real problem here is cfq_init_cfqq() shouldn't set
>>>idle_window
>>> when initializing a queue. We should enable idle window after we
>>>detect the
>>> queue is worthy idle.
>> 
>> Do you think the patch below is appropriate? Or should we check whether
>> busy_idle_queues in my original patch is high enough and only then
>> disable default idle_window in cfq_init_cfqq()?
>> 
>>> Thanks,
>>> Shaohua
>> 
>> Thanks,
>> Tomoki Sekiyama
>> 
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index d5cd313..abbe28f 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -3514,11 +3514,8 @@ static void cfq_init_cfqq(struct cfq_data *cfqd,
>>struct cfq_queue *cfqq,
>>  
>>  	cfq_mark_cfqq_prio_changed(cfqq);
>>  
>> -	if (is_sync) {
>> -		if (!cfq_class_idle(cfqq))
>> -			cfq_mark_cfqq_idle_window(cfqq);
>> +	if (is_sync)
>>  		cfq_mark_cfqq_sync(cfqq);
>> -	}
>>  	cfqq->pid = pid;
>>  }
>
>I do agree in principle with this, but now you are going to have the
>reverse problem where idling workloads take longer to reach their
>natural steady state. It could probably be argued that they should
>converge quicker, however, in which case it's probably a good change.

Even with this change, idling workload looks estimated worth for
idle_window soon if I/O rate is not so high and think time is low enough.
When the I/O rate is high, it might be regarded as not worth for idling
as the thinktimes were overestimated (although I couldn't find out
patterns which lost performance by that, as far as I tried).

How about fairness? Doesn't this make new processes disadvantageous?
If unfairness by this change was unacceptable, it might be helpful for
mitigating unfairness to add conditions like
 "the number of busy queues marked idle_window in the group == 0"
to marking idle_window as default.


Thanks,
Tomoki Sekiyama

