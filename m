Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaG1PFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaG1PFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:05:36 -0400
Message-ID: <53D6667C.8040703@redhat.com>
Date: Mon, 28 Jul 2014 11:04:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2] sched: make update_sd_pick_busiest return true on
 a busier sd
References: <20140722144559.382c5243@annuminas.surriel.com> <20140725152728.GB6758@twins.programming.kicks-ass.net> <53D27B7E.8090404@redhat.com> <20140725160549.GD6758@twins.programming.kicks-ass.net> <53D28457.202@redhat.com> <CAKfTPtBVTgTYmgRKbuhKNZZRuCRK126YVvsG1+a-hjfKao08=g@mail.gmail.com> <20140725153210.47c09bfe@annuminas.surriel.com> <CAKfTPtCoH00jdz-Qkns_j7LNyorWc+GQXj-WSmdDGcooWOMW7w@mail.gmail.com>
In-Reply-To: <CAKfTPtCoH00jdz-Qkns_j7LNyorWc+GQXj-WSmdDGcooWOMW7w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/28/2014 04:23 AM, Vincent Guittot wrote:
> On 25 July 2014 21:32, Rik van Riel <riel@redhat.com> wrote:
>> Subject: sched: make update_sd_pick_busiest return true on a
>> busier sd
>> 
>> Currently update_sd_pick_busiest only identifies the busiest sd 
>> that is either overloaded, or has a group imbalance. When no sd
>> is imbalanced or overloaded, the load balancer fails to find the
>> busiest domain.
>> 
>> This breaks load balancing between domains that are not
>> overloaded, in the !SD_ASYM_PACKING case. This patch makes
>> update_sd_pick_busiest return true when the busiest sd yet is
>> encountered.
>> 
>> Behaviour for SD_ASYM_PACKING does not seem to match the
>> comment, but I have no hardware to test that so I have left the
>> behaviour of that code unchanged.
>> 
>> It is unclear what to do with the group_imb condition. Should
>> group_imb override a busier load? If so, should we fix
> 
> IMHO, group_imb should have a lower priority compared to
> overloaded group because it generates active migration whereas the
> use of overloaded group could solve the imbalance with normal
> migration Then, AFAICT, we already have a special way to compute
> imbalance when group_imb is set
> 
>> calculate_imbalance to return a sensible number when the
>> "busiest" node found has a below average load? We probably need
>> to fix calculate_imbalance anyway, to deal with an overloaded
>> group that happens to have a below average load...
>> 
>> Cc: mikey@neuling.org Cc: peterz@infradead.org Signed-off-by: Rik
>> van Riel <riel@redhat.com> --- kernel/sched/fair.c | 18
>> +++++++++++++----- 1 file changed, 13 insertions(+), 5
>> deletions(-)
>> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index
>> 45943b2..c96044f 100644 --- a/kernel/sched/fair.c +++
>> b/kernel/sched/fair.c @@ -5949,6 +5949,11 @@ static inline void
>> update_sg_lb_stats(struct lb_env *env, 
>> sgs->group_has_free_capacity = 1; }
>> 
>> +static bool group_overloaded(struct sg_lb_stats *sgs) +{ +
>> return sgs->sum_nr_running > sgs->group_capacity_factor; +} + 
>> /** * update_sd_pick_busiest - return 1 on busiest group * @env:
>> The load balancing environment. @@ -5957,7 +5962,7 @@ static
>> inline void update_sg_lb_stats(struct lb_env *env, * @sgs:
>> sched_group statistics * * Determine if @sg is a busier group
>> than the previously selected - * busiest group. + * busiest
>> group. * * Return: %true if @sg is a busier group than the
>> previously selected * busiest group. %false otherwise. @@
>> -5967,13 +5972,17 @@ static bool update_sd_pick_busiest(struct
>> lb_env *env, struct sched_group *sg, struct sg_lb_stats *sgs) { +
>> if (group_overloaded(sgs) &&
>> !group_overloaded(&sds->busiest_stat))
> 
> The 1st time you run update_sd_pick_busiest, group_capacity_factor
> and sum_nr_running of sds->busiest_stat are uninitialized.

Good point, init_sd_lb_stats only zeroes out a few fields.

I will fix this in the next version.

>> +               return true; +
> 
> IIUC your new test sequence, you haven't solved the following use
> case:

Fixed in the next version, with Peter's idea.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT1mZ8AAoJEM553pKExN6DpPAH/A+a9Lbz/pV8uFGG3RRrs2gI
l8rhgtVLEM0uiDTDavB/D1GBnWcxfNbg6o/yF7dTXDA+sWltztZISi6dZ9JpEhww
0wK3rOD6t+VYpu6OaA2rIp2p2o12ou2d8ipjimjGf9gGD8i6vZiGOfTytsSateZH
X9pSQ5Tv63ES8m3DeLcXEy+YQVunyLD83aTwSpziBFKUGguttTvvqEx5MutxVQyA
Wx7hqX4VTR2oC3mS6djzK/hp0OmpZL4WKmnqUgjm11k0+UvBc1MnYE937CHixOdQ
GjfIgk+G8EGVucbKFfhgwrNFfemL4MXxSVxMMor1lMFt9yFKcwoSMRS40mcH+Rw=
=qENP
-----END PGP SIGNATURE-----
