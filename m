Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3CETmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:42:53 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12933 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3CETmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:42:52 -0500
Message-ID: <51364AB9.80206@hp.com>
Date: Tue, 05 Mar 2013 14:42:49 -0500
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ipc: reduce ipc lock contention
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net> <513626E9.2040509@redhat.com>
In-Reply-To: <513626E9.2040509@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 12:10 PM, Rik van Riel wrote:
> On 03/05/2013 04:35 AM, Davidlohr Bueso wrote:
>
>> 2) While on an Oracle swingbench DSS (data mining) workload the
>> improvements are not as exciting as with Rik's benchmark, we can see
>> some positive numbers. For an 8 socket machine the following are the
>> percentages of %sys time incurred in the ipc lock:
>>
>> Baseline (3.9-rc1):
>> 100 swingbench users: 8,74%
>> 400 swingbench users: 21,86%
>> 800 swingbench users: 84,35%
>>
>> With this patchset:
>> 100 swingbench users: 8,11%
>> 400 swingbench users: 19,93%
>> 800 swingbench users: 77,69%
>
> Does the swingbench DSS workload use multiple semaphores, or
> just one?
>
> Your patches look like a great start to make the semaphores
> more scalable. If the swingbench DSS workload uses multiple
> semaphores, I have ideas for follow-up patches to make things
> scale better.
>
> What does ipcs output look like while running swingbench DSS?
>

For Oracle, the semaphores are set up when the instance is started 
irrespective of the workload. For a 8-socket 80 cores test system, the 
output of ipcs look like:

------ Semaphore Arrays --------
key        semid      owner      perms      nsems
0x00000000 0          root       600        1
0x00000000 65537      root       600        1
0xcd9652f0 4718594    oracle     640        226
0xcd9652f1 4751363    oracle     640        226
0xcd9652f2 4784132    oracle     640        226
0xcd9652f3 4816901    oracle     640        226
0xcd9652f4 4849670    oracle     640        226

The recommended kernel.sem value from Oracle is "250 32000 100 128". I 
have tried to reduce the maximum semaphores per array (1st value) while 
increasing the max number of arrays. That tends to reduce the ipc_lock 
contention in kernel, but it is against Oracle's recommendation.

-Longman

