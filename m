Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3HZJL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:11:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15771 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab3HZJL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:11:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Aug 2013 02:11:55 -0700
Subject: Re: [PATCH 2/3] cpuidle: coupled: abort idle if pokes are pending
From: Joseph Lo <josephl@nvidia.com>
To: Colin Cross <ccross@android.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <1377287112-12018-2-git-send-email-ccross@android.com>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
	 <1377287112-12018-2-git-send-email-ccross@android.com>
Date: Mon, 26 Aug 2013 17:10:21 +0800
Message-ID: <1377508221.16229.34.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-24 at 03:45 +0800, Colin Cross wrote:
> Joseph Lo <josephl@nvidia.com> reported a lockup on Tegra3 caused
> by a race condition in coupled cpuidle.  When two or more cpus
Actually this issue can be reproduced on both Tegra20/30 platforms. And
I suggest using Tegra20 to replace Tegra3 here, we only apply coupled
CPU idle function on Tegra20 in the mainline right now.
> enter idle at the same time, the first cpus to arrive may go to the
> ready loop without processing pending pokes from the last cpu to
> arrive.
> 
> This patch adds a check for pending pokes once all cpus have been
> synchronized in the ready loop and resets the coupled state and
> retries if any cpus failed to handle their pending poke.
> 
> Retrying on all cpus may trigger the same issue again, so this patch
> also adds a check to ensure that each cpu has received at least one
> poke between when it enters the waiting loop and when it moves on to
> the ready loop.
> 
> Reported-by: Joseph Lo <josephl@nvidia.com>
> CC: stable@vger.kernel.org
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/cpuidle/coupled.c | 107 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 82 insertions(+), 25 deletions(-)
> 
[snip]
> +/*
> + * The cpuidle_coupled_poke_pending mask is used to ensure that each cpu has
s/cpuidle_coupled_poke_pending/cpuidle_coupled_poked/? :)
> + * been poked once to minimize entering the ready loop with a poke pending,
> + * which would require aborting and retrying.
> + */
> +static cpumask_t cpuidle_coupled_poked;
> 
I fixed this issue by checking if there is a pending SGI, then abort the
coupled state on Tegra20. It still can be reproduced easily if I remove
the checking code. So I tested the case with this patch, the result is
good. This patch can fix the issue indeed.

I also tested with the other two patches. It didn't cause any
regression.

So this series:
Tested-by: Joseph Lo <josephl@nvidia.com>


