Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbaGYPCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:02:34 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:37463 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaGYPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <53D26383.60707@redhat.com>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <CAKfTPtDdAzZcMA5bJvhyrdH9J1F69jMy5q3w5xc4t+PSKPQ0eA@mail.gmail.com> <53D26383.60707@redhat.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 25 Jul 2014 17:02:12 +0200
Message-ID: <CAKfTPtCjw9LTh_LYT=rRs=Q1gS2mVcz9Ef6E7KHLqFhdm8Y8pA@mail.gmail.com>
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2014 16:02, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 07/23/2014 03:41 AM, Vincent Guittot wrote:
>
>> Regarding your issue with "perf bench numa mem" that is not spread
>> on all nodes, SD_PREFER_SIBLING flag (of DIE level) should do the
>> job by reducing the capacity of  "not local DIE" group at NUMA
>> level to 1 task during the load balance computation. So you should
>> have 1 task per sched_group at NUMA level.
>
> Looking at the code some more, it is clear why this does not
> happen. If sd->flags & SD_NUMA, then SD_PREFER_SIBLING will
> never be set.

I don't have a lot of experience on NUMA system and how their
sched_domain topology is described but IIUC, you don't have other
sched_domain level than NUMA ones ? otherwise the flag should be
present in one of the non NUMA level (SMT, MC or DIE)

>
>
> On a related note, that part of the load balancing code probably
> needs to be rewritten to deal with unequal group_capacity_factors
> anyway.
>
> Say that one group has a group_capacity_factor twice that of
> another group.
>
> The group with the smaller group_capacity_factor is overloaded
> by a factor 1.3. The larger group is loaded by a factor 0.8.
> This means the larger group has a higher load than the first
> group, and the current code in update_sd_pick_busiest will
> not select the overloaded group as the busiest one, due to not
> scaling load with the capacity...
>

AFAICT, sgs->avg_load is weighted by the capacity in update_sg_lb_stats

> static bool update_sd_pick_busiest(struct lb_env *env,
>                                    struct sd_lb_stats *sds,
>                                    struct sched_group *sg,
>                                    struct sg_lb_stats *sgs)
> {
>         if (sgs->avg_load <= sds->busiest_stat.avg_load)
>                 return false;
>
> I believe we may need to factor the group_capacity_factor
> into this calculation, in order to properly identify which
> group is busiest.
>
> However, if we do that we may need to get rid of the
> SD_PREFER_SIBLING hack that forces group_capacity_factor
> to 1 on domains that have SD_PREFER_SIBLING set.

I'm working on a patchset that get ride of capacity_factor (as
mentioned by Peter) and directly uses capacity instead. I should send
the v4 next week.

Vincent
>
> I suspect that should be ok though, if we make sure
> update_sd_pick_busiest does the right thing...
>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQEcBAEBAgAGBQJT0mOCAAoJEM553pKExN6DHq4H/2THfH33d+JYvfOq95OpGLaD
> HATAp8Dv0kTiGjnbZrHPp8TqqgLLXuM6HhLvsvURuhoJw6F/nOX6qOQWEtjcMyYp
> omShkDSLnPjs/0Iwf9vNocT7K7Sn3Gk0hOj6+ICW7wchyug8JYtuiHunP8pYrpzW
> G6l2qHMRqRs5mSENY/uWwH9qh6Z6jcfDoDDDKRTNBe0z67FzwMnX1IYCUA6XOBsZ
> iRdXe8E0CIgio+ek8HVzRm5sUlkRyfJpTXJj+pemVJhTrNCCbMGTHxzADU4Ngc8S
> +JQ+G6bsHz9R4pffsuzYFbL0avK0mm5SrjCIatE7MX171dQJ1cKpju+fAmnwuNg=
> =EAzG
> -----END PGP SIGNATURE-----
