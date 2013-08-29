Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3H2HMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:12:21 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:32983 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3H2HMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <521EEF26.80803@nvidia.com>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
	<521EEF26.80803@nvidia.com>
Date: Thu, 29 Aug 2013 00:12:17 -0700
X-Google-Sender-Auth: Z7ELiw_5uLNR8QUam98awRbVd9M
Message-ID: <CAMbhsRSTv9ivMY1=-4YPxPV0tCTcJnHwWOEvr_F5exg9A2Z1Mw@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering
 safe state
From: Colin Cross <ccross@android.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>, Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:50 PM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> On Saturday 24 August 2013 01:15 AM, Colin Cross wrote:
>>
>> Calling cpuidle_enter_state is expected to return with interrupts
>> enabled, but interrupts must be disabled before starting the
>> ready loop synchronization stage.  Call local_irq_disable after
>> each call to cpuidle_enter_state for the safe state.
>>
>> CC: stable@vger.kernel.org
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>   drivers/cpuidle/coupled.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
>> index 2a297f8..db92bcb 100644
>> --- a/drivers/cpuidle/coupled.c
>> +++ b/drivers/cpuidle/coupled.c
>> @@ -460,6 +460,7 @@ int cpuidle_enter_state_coupled(struct cpuidle_device
>> *dev,
>>                 }
>>                 entered_state = cpuidle_enter_state(dev, drv,
>>                         dev->safe_state_index);
>> +               local_irq_disable();
>
>
> Colin,
>
> There is still some window where irq remains enabled after exiting safe
> state. It may introduce some corner case.
> Instead of this can we pass a parameter to cpuidle_enter_state indicating
> that irq has to be enabled or not after exit from idle state, which would be
> false when entering safe state from coupled idle.

It's fine for irqs to be enabled when exiting the safe state, in fact
on further inspection this patch isn't strictly necessary at all - we
always enable interrupts inside cpuidle_coupled_clear_pokes soon after
cpuidle_enter_state returns, and then disable them again.  It's
probably better to disable interrupts right after cpuidle_enter_state,
it makes sure interrupts are consistently disabled when calling
cpuidle_coupled_set_waiting, cpuidle_coupled_cpus_waiting and
cpuidle_coupled_clear_pokes, although that doesn't matter in the
current implementation.

Rafael, feel free to drop the stable annotation from this patch.
