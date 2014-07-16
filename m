Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaGPVbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:31:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54899 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaGPVbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:31:07 -0400
Message-ID: <53C6EF16.30506@arm.com>
Date: Wed, 16 Jul 2014 23:31:02 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Donald <gdonald@gmail.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: find_busiest_group divide error
References: <20140714165659.GA9289@gmail.com> <20140716152736.GD19379@twins.programming.kicks-ass.net> <20140716175259.GA5956@gmail.com>
In-Reply-To: <20140716175259.GA5956@gmail.com>
X-OriginalArrivalTime: 16 Jul 2014 21:31:03.0549 (UTC) FILETIME=[3EC94AD0:01CFA13D]
X-MC-Unique: 114071622310500201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 16/07/14 19:52, Greg Donald wrote:
> On Wed, Jul 16, 2014 at 05:27:36PM +0200, Peter Zijlstra wrote:
>> Could you confirm if reverting caffcdd8d27ba78730d5540396ce72ad022aff2c
>> cures things for you?
>>
>> Otherwise there's two very similar issues, see also:
>>
>>     lkml.kernel.org/r/20140716145546.GA6922@wolff.to
>
> Cured.
>
> I reverted caffcdd8d27ba78730d5540396ce72ad022aff2c which did nothing as
> far as I can tell, then I removed the
> two lines from http://marc.info/?l=linux-kernel&m=140552264825755, then
> I added back the one line from
> https://bugzilla.kernel.org/show_bug.cgi?id=80251#c8.

My patch caffcdd8d27ba78730d5540396ce72ad022aff2c got rid of 
cpumask_clear(sched_group_cpus(sg)); and sg->sgp->power = 0; so 
reverting it (and replacing sg->sgp->power = 0 with
sg->sgc->capacity = 0) should cure it too. (although the missing 
cpumask_clear() is the culprit on your machine here).

Could I ask you to share the content of your /proc/cpuinfo file? I 
suspect it might be the same topology as the one Bruno just sent out 
(the one of a dual single core CPU with hyper-threading ?)

https://lkml.org/lkml/2014/7/16/603

Thanks,

-- Dietmar

>
> I ended up with
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index dc2927c..7c3674d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5848,7 +5848,6 @@ build_sched_groups(struct sched_domain *sd, int
> cpu)
>
>                  group = get_group(i, sdd, &sg);
>                  cpumask_clear(sched_group_cpus(sg));
> -               sg->sgp->power = 0;
>                  cpumask_setall(sched_group_mask(sg));
>
>                  for_each_cpu(j, span) {
>
>
> Thanks.
>


