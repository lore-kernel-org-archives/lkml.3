Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaG3JdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:33:01 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:57073 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaG3Jc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140729152705.GX12054@laptop.lan>
References: <1406571388-3227-1-git-send-email-riel@redhat.com>
 <1406571388-3227-2-git-send-email-riel@redhat.com> <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com>
 <20140729145910.GH3935@laptop> <20140729152705.GX12054@laptop.lan>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 30 Jul 2014 11:32:36 +0200
Message-ID: <CAKfTPtC8kJuBRT4HsZnQhzH4k_qDaq4nybYR+UW7rk6_Yx9_NQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
To: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 July 2014 17:27, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 29, 2014 at 04:59:10PM +0200, Peter Zijlstra wrote:
>> On Tue, Jul 29, 2014 at 11:04:50AM +0200, Vincent Guittot wrote:
>> > > In situations where all the domains are overloaded, or where only the
>> > > busiest domain is overloaded, that code is also superfluous, since
>> > > the normal env->imbalance calculation will figure out how much to move.
>> > > Remove the load_above_capacity calculation.
>> >
>> > IMHO, we should not remove that part which is used by prefer_sibling
>> >
>> > Originally, we had 2 type of busiest group: overloaded or imbalanced.
>> > You add a new one which has only a avg_load higher than other so you
>> > should handle this new case and keep the other ones unchanged
>>
>> Right, so we want that code for overloaded -> overloaded migrations such
>> as not to cause idle cpus in an attempt to balance things. Idle cpus are
>> worse than imbalance.
>>
>> But in case of overloaded/imb -> !overloaded migrations we can allow it,
>> and in fact want to allow it in order to balance idle cpus.
>
> Which would be patch 3/2

FWIW, you can add my ack for the new version of the patchset which
includes this patch

>
> ---
> Subject: sched,fair: Allow calculate_imbalance() to move idle cpus
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue Jul 29 17:15:11 CEST 2014
>
> Allow calculate_imbalance() to 'create' idle cpus in the busiest group
> if there are idle cpus in the local group.
>
> Suggested-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-7k95k4i2tjv78iivstggiude@git.kernel.org
> ---
>  kernel/sched/fair.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6273,12 +6273,11 @@ static inline void calculate_imbalance(s
>                 return fix_small_imbalance(env, sds);
>         }
>
> -       if (busiest->group_type == group_overloaded) {
> -               /*
> -                * Don't want to pull so many tasks that a group would go idle.
> -                * Except of course for the group_imb case, since then we might
> -                * have to drop below capacity to reach cpu-load equilibrium.
> -                */
> +       /*
> +        * If there aren't any idle cpus, avoid creating some.
> +        */
> +       if (busiest->group_type == group_overloaded &&
> +           local->group_type   == group_overloaded) {
>                 load_above_capacity =
>                         (busiest->sum_nr_running - busiest->group_capacity_factor);
>
