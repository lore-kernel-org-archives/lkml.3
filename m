Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaIXPgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaIXPgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:36:22 -0400
Message-ID: <5422E474.4010001@redhat.com>
Date: Wed, 24 Sep 2014 11:34:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hui Zhu <zhuhui@xiaomi.com>, gregkh@linuxfoundation.org,
        rientjes@google.com, vinayakm.list@gmail.com, weijie.yang@samsung.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        teawater@gmail.com
Subject: Re: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
References: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
In-Reply-To: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 10:57 PM, Hui Zhu wrote:
> The cause of this issue is when free memroy size is low and a lot of task is
> trying to shrink the memory, the task that is killed by lowmemkiller cannot get
> CPU to exit itself.
> 
> Fix this issue with change the scheduling policy to SCHED_FIFO if a task's flag
> is TIF_MEMDIE in lowmemkiller.

Is it actually true that the task that was killed by lowmemkiller
cannot get CPU time?

It is also possible that the task is busy in the kernel, for example
in the reclaim code, and is not breaking out of some loop fast enough,
despite the TIF_MEMDIE flag being set.

I suspect SCHED_FIFO simply papers over that kind of issue, by not
letting anything else run until the task is gone, instead of fixing
the root cause of the problem.

