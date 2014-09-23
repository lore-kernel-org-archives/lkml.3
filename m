Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaIWEtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:49:24 -0400
Received: from mx1.mxmail.xiaomi.com ([58.68.235.87]:7152 "EHLO
	mx1.mxmail.xiaomi.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752876AbaIWEtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:49:22 -0400
From: =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "rientjes@google.com" <rientjes@google.com>,
        "vinayakm.list@gmail.com" <vinayakm.list@gmail.com>,
        "weijie.yang@samsung.com" <weijie.yang@samsung.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "teawater@gmail.com" <teawater@gmail.com>
Subject: Re: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
Thread-Topic: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
Thread-Index: AQHP1toi3qW7tRqemUGYwU3B97qppQ==
Date: Tue, 23 Sep 2014 04:48:55 +0000
Message-ID: <C1476EAB93B413409890F290A20101879D8C96@ex-mbox2>
References: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
 <20140923041738.GA6779@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.37.216.50]
x-esetresult: clean, is OK
x-esetid: B888893E9A6C9E31E8C8D1
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8N4nSbP001122



On 09/23/14 12:18, Greg KH wrote:
> On Tue, Sep 23, 2014 at 10:57:09AM +0800, Hui Zhu wrote:
>> The cause of this issue is when free memroy size is low and a lot of task is
>> trying to shrink the memory, the task that is killed by lowmemkiller cannot get
>> CPU to exit itself.
>>
>> Fix this issue with change the scheduling policy to SCHED_FIFO if a task's flag
>> is TIF_MEMDIE in lowmemkiller.
>>
>> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
>> ---
>>   drivers/staging/android/lowmemorykiller.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
>> index b545d3d..ca1ffac 100644
>> --- a/drivers/staging/android/lowmemorykiller.c
>> +++ b/drivers/staging/android/lowmemorykiller.c
>> @@ -129,6 +129,10 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
>>
>>   		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
>>   		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
>> +			struct sched_param param = { .sched_priority = 1 };
>> +
>> +			if (p->policy == SCHED_NORMAL)
>> +				sched_setscheduler(p, SCHED_FIFO, &param);
>
> This seems really specific to a specific scheduler pattern now.  Isn't
> there some other way to resolve this?

I tried to let the task that call lowmemkiller sleep some time when it 
try to kill same task.  But it doesn't work.
I think the issue is that the free memroy size is too low to make more 
and more tasks come to call lowmemkiller.

Thanks,
Hui

>
> thanks,
>
> greg k-h
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
