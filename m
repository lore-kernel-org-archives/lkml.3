Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaBLB4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:56:24 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8771 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaBLB4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:56:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 11 Feb 2014 17:54:32 -0800
Message-ID: <52FAD4C2.80803@nvidia.com>
Date: Wed, 12 Feb 2014 10:56:18 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH v2 6/6] ARM: tegra: cpuidle: use firmware for power down
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com> <1391747706-1847-7-git-send-email-acourbot@nvidia.com> <20140212013650.GA7584@quad.lixom.net>
In-Reply-To: <20140212013650.GA7584@quad.lixom.net>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 10:36 AM, Olof Johansson wrote:
> On Fri, Feb 07, 2014 at 01:35:06PM +0900, Alexandre Courbot wrote:
>> Attempt to invoke the prepare_idle() and do_idle() firmware calls
>> to power down a CPU so an underlying firmware gets informed of
>> the idle operation and performs it by itself if designed in such a way.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   arch/arm/mach-tegra/cpuidle-tegra114.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
>> index e0b87300243d..558067ddc186 100644
>> --- a/arch/arm/mach-tegra/cpuidle-tegra114.c
>> +++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/cpuidle.h>
>>   #include <linux/cpu_pm.h>
>>   #include <linux/clockchips.h>
>> +#include <asm/firmware.h>
>>
>>   #include <asm/cpuidle.h>
>>   #include <asm/suspend.h>
>> @@ -45,7 +46,15 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
>>
>>   	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
>>
>> -	cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>> +	call_firmware_op(prepare_idle);
>> +
>> +	switch (call_firmware_op(do_idle)) {
>> +	case -ENOSYS:
>> +		cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
>> +		break;
>> +	default:
>> +		break;
>
> Do you expect other cases down the road? If not, this is a simple if instead:
>
> 	/* Only call cpu_suspend if TF didn't handle the pre-suspend logic */
> 	if (call_firmware_op(do_idle) == -ENOSYS)
> 		cpu_suspend(....);

I might have been overdoing it indeed. Let me submit a v3 just for this 
one patch.

Thanks!
Alex.

