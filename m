Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3H2Guh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:50:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15932 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3H2Gug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:50:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 23:48:01 -0700
Message-ID: <521EEF26.80803@nvidia.com>
Date: Thu, 29 Aug 2013 12:20:14 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>, Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering
 safe state
References: <1377287112-12018-1-git-send-email-ccross@android.com>
In-Reply-To: <1377287112-12018-1-git-send-email-ccross@android.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 August 2013 01:15 AM, Colin Cross wrote:
> Calling cpuidle_enter_state is expected to return with interrupts
> enabled, but interrupts must be disabled before starting the
> ready loop synchronization stage.  Call local_irq_disable after
> each call to cpuidle_enter_state for the safe state.
>
> CC: stable@vger.kernel.org
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>   drivers/cpuidle/coupled.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2a297f8..db92bcb 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -460,6 +460,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device *dev,
>   		}
>   		entered_state = cpuidle_enter_state(dev, drv,
>   			dev->safe_state_index);
> +		local_irq_disable();

Colin,

There is still some window where irq remains enabled after exiting safe 
state. It may introduce some corner case.
Instead of this can we pass a parameter to cpuidle_enter_state 
indicating that irq has to be enabled or not after exit from idle state, 
which would be false when entering safe state from coupled idle.

>   	}
>   
>   	/* Read barrier ensures online_count is read after prevent is cleared */
> @@ -485,6 +486,7 @@ retry:
>   
>   		entered_state = cpuidle_enter_state(dev, drv,
>   			dev->safe_state_index);
> +		local_irq_disable();
>   	}
>   
>   	if (cpuidle_coupled_clear_pokes(dev->cpu)) {

