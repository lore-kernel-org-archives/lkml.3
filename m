Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3H0JC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:02:26 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45270 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab3H0JCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:02:22 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Colin Cross <ccross@android.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Date: Tue, 27 Aug 2013 01:57:43 -0700
Subject: RE: [PATCH 3/3] cpuidle: coupled: fix race condition between pokes
 and safe state
Thread-Topic: [PATCH 3/3] cpuidle: coupled: fix race condition between pokes
 and safe state
Thread-Index: Ac6gOUvyJJHDZkuLSNq/1MsKrjpp9ACyWb4g
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE3DBD2B9E21@SC-VEXCH4.marvell.com>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
 <1377287112-12018-3-git-send-email-ccross@android.com>
In-Reply-To: <1377287112-12018-3-git-send-email-ccross@android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7R92VPQ029066

> -----Original Message-----
> From: Colin Cross [mailto:ccross@android.com]
> Sent: 2013Äê8ÔÂ24ÈÕ 3:45
> To: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Neil Zhang; Joseph Lo;
> linux-tegra@vger.kernel.org; Colin Cross; stable@vger.kernel.org; Rafael J.
> Wysocki; Daniel Lezcano
> Subject: [PATCH 3/3] cpuidle: coupled: fix race condition between pokes and safe
> state
> 
> The coupled cpuidle waiting loop clears pending pokes before entering the safe
> state.  If a poke arrives just before the pokes are cleared, but after the while
> loop condition checks, the poke will be lost and the cpu will stay in the safe state
> until another interrupt arrives.  This may cause the cpu that sent the poke to
> spin in the ready loop with interrupts off until another cpu receives an interrupt,
> and if no other cpus have interrupts routed to them it can spin forever.
> 
> Change the return value of cpuidle_coupled_clear_pokes to return if a poke was
> cleared, and move the need_resched() checks into the callers.  In the waiting
> loop, if a poke was cleared restart the loop to repeat the while condition checks.
> 
> Reported-by: Neil Zhang <zhangwm@marvell.com>
> CC: stable@vger.kernel.org
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/cpuidle/coupled.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c index
> bbc4ba5..c91230b 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -408,19 +408,22 @@ static void cpuidle_coupled_set_done(int cpu, struct
> cpuidle_coupled *coupled)
>   * been processed and the poke bit has been cleared.
>   *
>   * Other interrupts may also be processed while interrupts are enabled, so
> - * need_resched() must be tested after turning interrupts off again to make sure
> + * need_resched() must be tested after this function returns to make
> + sure
>   * the interrupt didn't schedule work that should take the cpu out of idle.
>   *
> - * Returns 0 if need_resched was false, -EINTR if need_resched was true.
> + * Returns 0 if no poke was pending, 1 if a poke was cleared.
>   */
>  static int cpuidle_coupled_clear_pokes(int cpu)  {
> +	if (!cpumask_test_cpu(cpu, &cpuidle_coupled_poke_pending))
> +		return 0;
> +
>  	local_irq_enable();
>  	while (cpumask_test_cpu(cpu, &cpuidle_coupled_poke_pending))
>  		cpu_relax();
>  	local_irq_disable();
> 
> -	return need_resched() ? -EINTR : 0;
> +	return 1;
>  }
> 
>  static bool cpuidle_coupled_any_pokes_pending(struct cpuidle_coupled
> *coupled) @@ -464,7 +467,8 @@ int cpuidle_enter_state_coupled(struct
> cpuidle_device *dev,
>  		return -EINVAL;
> 
>  	while (coupled->prevent) {
> -		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
> +		cpuidle_coupled_clear_pokes(dev->cpu);
> +		if (need_resched()) {
>  			local_irq_enable();
>  			return entered_state;
>  		}
> @@ -503,7 +507,10 @@ retry:
>  	 */
>  	while (!cpuidle_coupled_cpus_waiting(coupled) ||
>  			!cpumask_test_cpu(dev->cpu, &cpuidle_coupled_poked)) {
> -		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
> +		if (cpuidle_coupled_clear_pokes(dev->cpu))
> +			continue;
> +
> +		if (need_resched()) {
>  			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
>  			goto out;
>  		}
> @@ -518,7 +525,8 @@ retry:
>  		local_irq_disable();
>  	}
> 
> -	if (cpuidle_coupled_clear_pokes(dev->cpu)) {
> +	cpuidle_coupled_clear_pokes(dev->cpu);
> +	if (need_resched()) {
>  		cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
>  		goto out;
>  	}
> --
> 1.8.3

I think this patch should also be workable.
Thanks.

Reviewed-by: Neil Zhang <zhangwm@marvell.com>

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
