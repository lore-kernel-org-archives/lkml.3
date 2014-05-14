Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaENKVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:21:19 -0400
Received: from forward3h.mail.yandex.net ([84.201.187.148]:37481 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaENKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:21:16 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Michael wang <wangyun@linux.vnet.ibm.com>,
        "ktkhai@parallels.com" <ktkhai@parallels.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20140514101354.GI30445@twins.programming.kicks-ass.net>
References: <20140224071028.GW9987@twins.programming.kicks-ass.net>
	 <530B1B80.4000307@linux.vnet.ibm.com>
	 <20140224121218.GR15586@twins.programming.kicks-ass.net>
	 <534610A4.5000302@oracle.com>
	 <53464164.5030701@linux.vnet.ibm.com>
	 <336561397137116@web27h.yandex.ru>
	 <5347FCED.8040706@oracle.com>
	 <1442521397229373@web20m.yandex.ru>
	 <53711785.5010504@oracle.com>
	 <2614131400060552@web30m.yandex.ru> <20140514101354.GI30445@twins.programming.kicks-ass.net>
Subject: Re: sched: hang in migrate_swap
MIME-Version: 1.0
Message-Id: <2158101400062864@web10h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 14 May 2014 14:21:04 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



14.05.2014, 14:14, "Peter Zijlstra" <peterz@infradead.org>:
> On Wed, May 14, 2014 at 01:42:32PM +0400, Kirill Tkhai wrote:
>
>> šPeter, do we have to queue stop works orderly?
>>
>> šIs there is not a possibility, when two pair of works queued different on
>> šdifferent cpus?
>>
>> šškernel/stop_machine.c | 10 ++++++++--
>> šš1 file changed, 8 insertions(+), 2 deletions(-)
>> šdiff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
>> šindex b6b67ec..29e221b 100644
>> š--- a/kernel/stop_machine.c
>> š+++ b/kernel/stop_machine.c
>> š@@ -250,8 +250,14 @@ struct irq_cpu_stop_queue_work_info {
>> ššstatic void irq_cpu_stop_queue_work(void *arg)
>> šš{
>> ššššššššššstruct irq_cpu_stop_queue_work_info *info = arg;
>> š- cpu_stop_queue_work(info->cpu1, info->work1);
>> š- cpu_stop_queue_work(info->cpu2, info->work2);
>> š+
>> š+ if (info->cpu1 < info->cpu2) {
>> š+ cpu_stop_queue_work(info->cpu1, info->work1);
>> š+ cpu_stop_queue_work(info->cpu2, info->work2);
>> š+ } else {
>> š+ cpu_stop_queue_work(info->cpu2, info->work2);
>> š+ cpu_stop_queue_work(info->cpu1, info->work1);
>> š+ }
>> šš}
>
> I'm not sure, we already send the IPI to the first cpu of the pair, so
> supposing we have 4 cpus, and get 4 pairs like:
>
> 0,1 1,2 2,3 3,0
>
> That would result in IPIs to 0, 1, 2, and 0 again, and since the IPI
> function is serialized I don't immediately see a way for this to
> deadlock.

It's about stop_two_cpus(), I have a distrust about other users of stop task:

queue_stop_cpus_work() queues work consequentially:

0 1 2 4

stop_two_cpus() may queue:

1 0

Looks like, stop thread on 0th and on 1th are waiting for wrong works.
