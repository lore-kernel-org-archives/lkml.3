Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaJNHB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:01:29 -0400
Received: from [42.62.48.242] ([42.62.48.242]:54929 "EHLO manager.mioffice.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753988AbaJNHBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:01:21 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 03:01:21 EDT
From: =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>
To: Rik van Riel <riel@redhat.com>, =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "vinayakm.list@gmail.com" <vinayakm.list@gmail.com>,
        "weijie.yang@samsung.com" <weijie.yang@samsung.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "teawater@gmail.com" <teawater@gmail.com>
Subject: Re: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
Thread-Topic: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
Thread-Index: AQHP1toi3qW7tRqemUGYwU3B97qppQ==
Date: Tue, 14 Oct 2014 06:51:26 +0000
Message-ID: <a42b1bc3882c4693ad8eadfa68659601@cnbox3.mioffice.cn>
References: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
 <5422E474.4010001@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.37.216.50]
x-esetresult: clean, is OK
x-esetid: 357748384EDFD471623A10
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9E71YFx023454

2014 09 24 23:36, Rik van Riel:
> On 09/22/2014 10:57 PM, Hui Zhu wrote:
>> The cause of this issue is when free memroy size is low and a lot of task is
>> trying to shrink the memory, the task that is killed by lowmemkiller cannot get
>> CPU to exit itself.
>>
>> Fix this issue with change the scheduling policy to SCHED_FIFO if a task's flag
>> is TIF_MEMDIE in lowmemkiller.
>
> Is it actually true that the task that was killed by lowmemkiller
> cannot get CPU time?

I am so sorry that answer this mail late because I tried to do more test 
around it.
But this issue is really hard to reproduce the issue.  I got a special 
app that can reproduce this issue easyly. But I still need retry a lot 
of times to repdroduce this issue.

And I found that most of time, the task cannot be killed because it is 
blocked by binder_lock.
It looks like there are something wrong with a task that get binder_lock 
and it is blocked by another thing.

So I make a patch that change a binder_lock to binder_lock_killable to 
handle this issue.(I will post it later)
It work sometime but I am not sure it is right.
And I just met one time, the kernel with the binder patch and without 
the lowmemkiller SCHED_FIFO patch, a task that didn't blocked by a lock. 
  And different tasks call lowmemkiller tried to kill this task.
I think the root cause of this issue is killed task cannot get cpu.
But I just got this issue one time.

>
> It is also possible that the task is busy in the kernel, for example
> in the reclaim code, and is not breaking out of some loop fast enough,
> despite the TIF_MEMDIE flag being set.
>
> I suspect SCHED_FIFO simply papers over that kind of issue, by not
> letting anything else run until the task is gone, instead of fixing
> the root cause of the problem.
>
>

According to I introduction, I think lowmemkiller SCHED_FIFO patch maybe 
can handle some issue.

Thanks,
Hui
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
