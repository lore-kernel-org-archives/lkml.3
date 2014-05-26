Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaEZDEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 23:04:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:3380 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaEZDEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 23:04:32 -0400
Message-ID: <5382AF2E.1040407@huawei.com>
Date: Mon, 26 May 2014 11:04:14 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <tglx@linutronix.de>, <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Subject: balance storm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
    my box has 16 cpu (E5-2658,8 core, 2 thread per core), i did a test on
3.4.24stable, startup 50 same process, every process is sample:

 	#include <unistd.h>

 	int main()
 	{
          	for (;;)
          	{
                  	unsigned int i = 0;
                 	 while (i< 100){
                     	 i++;
                  	}
                  	usleep(100);
          	}

         	 return 0;
  	}

the result is process uses 15% cpu time, perf tool shows 70w migrations in 5 second.

  	PID USER      PR  NI  VIRT  RES  SHR S   %CPU %MEM    TIME+  COMMAND
 	4374 root      20   0  6020  332  256 S     15  0.0   0:03.73 a2.out
	4371 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
	4373 root      20   0  6020  332  256 R     15  0.0   0:03.72 a2.out
 	4377 root      20   0  6020  332  256 R     15  0.0   0:03.72 a2.out
 	4389 root      20   0  6020  328  256 S     15  0.0   0:03.71 a2.out
 	4391 root      20   0  6020  332  256 S     15  0.0   0:03.72 a2.out
 	4394 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4398 root      20   0  6020  328  256 S     15  0.0   0:03.71 a2.out
 	4403 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4405 root      20   0  6020  328  256 S     15  0.0   0:03.72 a2.out
 	4407 root      20   0  6020  332  256 S     15  0.0   0:03.73 a2.out
 	4369 root      20   0  6020  332  256 S     15  0.0   0:03.72 a2.out
 	4370 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4372 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4375 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4378 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4379 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4380 root      20   0  6020  332  256 S     15  0.0   0:03.72 a2.out
 	4381 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4383 root      20   0  6020  332  256 S     15  0.0   0:03.69 a2.out
 	4384 root      20   0  6020  332  256 S     15  0.0   0:03.72 a2.out
 	4386 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4387 root      20   0  6020  328  256 S     15  0.0   0:03.70 a2.out
 	4388 root      20   0  6020  332  256 R     15  0.0   0:03.72 a2.out
 	4390 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4392 root      20   0  6020  332  256 S     15  0.0   0:03.72 a2.out
 	4393 root      20   0  6020  332  256 S     15  0.0   0:03.72 a2.out
 	4395 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4396 root      20   0  6020  328  256 S     15  0.0   0:03.71 a2.out
 	4397 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4399 root      20   0  6020  332  256 R     15  0.0   0:03.72 a2.out
 	4400 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4402 root      20   0  6020  332  256 S     15  0.0   0:03.70 a2.out
 	4404 root      20   0  6020  332  256 R     15  0.0   0:03.69 a2.out
 	4406 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out
 	4408 root      20   0  6020  328  256 R     15  0.0   0:03.71 a2.out
 	4409 root      20   0  6020  332  256 R     15  0.0   0:03.71 a2.out
 	4410 root      20   0  6020  328  256 S     15  0.0   0:03.72 a2.out
 	4411 root      20   0  6020  332  256 S     15  0.0   0:03.71 a2.out

===========================================================================

when i reverts commit 908a3283728d92df36e0c7cd63304fd35e93a8a9:

	diff --git a/kernel/sched.c b/kernel/sched.c
	index 1874c74..4cdc91c 100644
	--- a/kernel/sched.c
	+++ b/kernel/sched.c
	@@ -5138,7 +5138,20 @@ EXPORT_SYMBOL(task_nice);
 	 */
 	int idle_cpu(int cpu)
 	{
	-       return cpu_curr(cpu) == cpu_rq(cpu)->idle;
	+       struct rq *rq = cpu_rq(cpu);
	+
	+       if (rq->curr != rq->idle)
	+               return 0;
	+
	+       if (rq->nr_running)
	+               return 0;
	+
	+#ifdef CONFIG_SMP
	+       if (!llist_empty(&rq->wake_list))
	+               return 0;
	+#endif
	+
	+       return 1;
	}

 the result is process uses 3-5% cpu time, perf tool shows only 1k migrations in 5 second.

 	4444 root      20   0  6020  328  256 S      5  0.0   2:18.49 a2.out
 	4469 root      20   0  6020  328  256 S      5  0.0   2:15.93 a2.out
 	4423 root      20   0  6020  328  256 S      5  0.0   2:14.36 a2.out
 	4433 root      20   0  6020  332  256 S      5  0.0   2:15.81 a2.out
 	4466 root      20   0  6020  328  256 S      4  0.0   2:17.62 a2.out
	4428 root      20   0  6020  332  256 S      4  0.0   2:13.92 a2.out
	4457 root      20   0  6020  332  256 R      4  0.0   2:15.30 a2.out
	4429 root      20   0  6020  328  256 R      4  0.0   2:17.13 a2.out
	4431 root      20   0  6020  332  256 S      3  0.0   2:15.91 a2.out
	4438 root      20   0  6020  332  256 S      3  0.0   2:14.04 a2.out
	4439 root      20   0  6020  332  256 S      3  0.0   2:15.94 a2.out
	4462 root      20   0  6020  332  256 R      3  0.0   2:16.40 a2.out
 	4422 root      20   0  6020  328  256 S      3  0.0   2:17.41 a2.out
	4434 root      20   0  6020  332  256 R      3  0.0   2:15.67 a2.out
	4440 root      20   0  6020  332  256 S      3  0.0   2:14.40 a2.out
 	4447 root      20   0  6020  332  256 S      3  0.0   2:16.02 a2.out
 	4448 root      20   0  6020  332  256 S      3  0.0   2:16.40 a2.out
 	4453 root      20   0  6020  332  256 R      3  0.0   2:15.75 a2.out
	4459 root      20   0  6020  328  256 S      3  0.0   2:16.66 a2.out
	4461 root      20   0  6020  332  256 S      3  0.0   2:15.77 a2.out
 	4471 root      20   0  6020  328  256 S      3  0.0   2:20.68 a2.out
 	4424 root      20   0  6020  328  256 S      3  0.0   2:15.90 a2.out
 	4427 root      20   0  6020  332  256 S      3  0.0   2:14.28 a2.out
 	4432 root      20   0  6020  332  256 S      3  0.0   2:14.63 a2.out
 	4435 root      20   0  6020  328  256 S      3  0.0   2:15.32 a2.out
 	4436 root      20   0  6020  328  256 S      3  0.0   2:15.40 a2.out
 	4437 root      20   0  6020  332  256 S      3  0.0   2:15.42 a2.out
 	4441 root      20   0  6020  332  256 S      3  0.0   2:18.59 a2.out
 	4443 root      20   0  6020  332  256 S      3  0.0   2:14.82 a2.out
 	4445 root      20   0  6020  332  256 R      3  0.0   2:13.12 a2.out
 	4449 root      20   0  6020  332  256 R      3  0.0   2:21.37 a2.out
 	4450 root      20   0  6020  332  256 S      3  0.0   2:15.78 a2.out
 	4451 root      20   0  6020  332  256 S      3  0.0   2:16.25 a2.out
 	4455 root      20   0  6020  332  256 S      3  0.0   2:18.58 a2.out
 	4456 root      20   0  6020  332  256 S      3  0.0   2:16.37 a2.out
 	4458 root      20   0  6020  328  256 S      3  0.0   2:18.03 a2.out
 	4460 root      20   0  6020  332  256 S      3  0.0   2:14.04 a2.out
 	4463 root      20   0  6020  328  256 S      3  0.0   2:16.74 a2.out
 	4464 root      20   0  6020  328  256 S      3  0.0   2:18.11 a2.out

I guess task migration takes up a lot of cpu, so i did another test. use taskset tool to bind
a task to a fixed cpu. Results in line with expectations, cpu usage is down to 5%.

other test:
- 3.15upstream has the same problem with 3.4.24.
- suse sp2 has low cpu usage about 5%.

so I think 15% cpu usage and migration event are too high, how to fixed?

