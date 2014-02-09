Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaBIQNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:13:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaBIQNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:13:11 -0500
Message-ID: <52F7A909.5030408@redhat.com>
Date: Sun, 09 Feb 2014 11:12:57 -0500
From: Doug Ledford <dledford@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: m@silodev.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: Max number of posix queues in vanilla kernel (/proc/sys/fs/mqueue/queues_max)
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>	 <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>	 <52F54F08.6060507@redhat.com> <1391919420.1099.31.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1391919420.1099.31.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 11:17 PM, Davidlohr Bueso wrote:
> On Fri, 2014-02-07 at 16:24 -0500, Doug Ledford wrote:
>> On 2/7/2014 3:11 PM, Davidlohr Bueso wrote:
>>> On Thu, 2014-02-06 at 12:21 +0200, m@silodev.com wrote:
>>>> Hi Folks,
>>>>
>>>> I have recently ported my multi-process application (like a classical open
>>>> system) which uses POSIX Queues as IPC to one of the latest Linux kernels,
>>>> and I have faced issue that number of maximum queues are dramatically
>>>> limited down to 1024 (see include/linux/ipc_namespace.h, #define
>>>> HARD_QUEUESMAX 1024).
>>>>
>>>> Previously the max number of queues was INT_MAX (on 64bit system was:
>>>> 2147483647).
>>>
>>> Hmm yes, 1024 is quite unrealistic for some workloads and breaks
>>> userspace - I don't see any reasons for _this_ specific value in the
>>> changelog or related changes in the patchset that introduced commits
>>> 93e6f119 and 02967ea0.
>>
>> There wasn't a specific selection of that number other than a general
>> attempt to make the max more reasonable (INT_MAX isn't really reasonable
>> given the overhead of each individual queue, even if the queue number
>> and max msg size are small).
>>
>>> And the fact that this limit is per namespace
>>> makes no difference really. Hell, if nothing else, the mq_overview(7)
>>> manpage description is evidence enough. For privileged users:
>>>
>>> The default value for queues_max is 256; it can be changed to any value in the range 0 to INT_MAX.
>>
>> That was obviously never updated to match the change.
>>
>> In hindsight, I'm not sure we really even care though.  Since the limit
>> on queues is per namespace, and we can make as many namespaces as we
>> want, the limit is more or less meaningless and only serves as a
>> nuisance to people.
>
> Yes, but namespaces aren't _that_ popular in reality, specially as you
> describe the workaround.
>
>>   Since we have accounting on a per user basis that
>> spans across namespaces and across queues, maybe that should be
>> sufficient and the limit on queues should simply be removed and we
>> should instead just rely on memory limits.  When the user has exhausted
>> their allowed memory usage, whether by large queue sizes, large message
>> sizes, or large queue counts, then they are done.  When they haven't,
>> they can keep allocating.  Would make things considerably easier and
>> would avoid the breakage we are talking about here.
>>
>
> Right, and this is taken care of in mqueue_get_inode().
>
> The (untested) code below simply removes this global limit, let me know
> if you're okay with it and I'll send a formal/tested patch.
>
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index e7831d2..d78a09f 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -120,7 +120,6 @@ extern int mq_init_ns(struct ipc_namespace *ns);
>    */
>   #define MIN_QUEUESMAX			1
>   #define DFLT_QUEUESMAX		      256
> -#define HARD_QUEUESMAX		     1024

Since you are passing the queue setting off to proc_dointvec, I don't 
think the3 MIN_QUEUESMAX value is used any longer, so might as well kill 
it too.  Otherwise, it looks acceptable to me.

