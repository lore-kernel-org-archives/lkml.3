Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJOUy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:54:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33843 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaJOUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:54:57 -0400
Message-ID: <543EDF19.2070400@collabora.co.uk>
Date: Wed, 15 Oct 2014 22:54:49 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
References: <1413374496-27866-1-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=VT9RBitk5NoMKBRm=RVoNC4roLFEBLpd_L7Fuvxvs9SQ@mail.gmail.com>
In-Reply-To: <CAD=FV=VT9RBitk5NoMKBRm=RVoNC4roLFEBLpd_L7Fuvxvs9SQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

Thanks a lot for your feedback.

On 10/15/2014 06:19 PM, Doug Anderson wrote:
> Javier,
> 
> On Wed, Oct 15, 2014 at 5:01 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> The regulator framework has a set of helpers functions to be used when
>> the system is entering and leaving from suspend but these are not called
>> on Exynos platforms. This means that the .set_suspend_* function handlers
>> defined in regulator drivers are never called when the system is suspended.
>>
>> Suggested-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> Could you also add a patch to your series ripping out the call in
> "drivers/mfd/sec-core.c" since it doesn't belong there.  If you don't
> rip that out then it will be called twice on systems with that
> regulator.
> 

Sure, in fact I thought the same before sending $subject but didn't remove it
because mfd sec-core only calls regulator_suspend_prepare() but does not call
regulator_suspend_finish() on resume. So I wondered if $subject would not break
it anyways since it may change the driver assumption that the regulators .enable
function won't be called on resume. That's why I added Chanwoo Choi to the cc
list so he can be aware of this change and give his opinion is on that regard.

I should had commented that on the patch...

> 
>> ---
>>  arch/arm/mach-exynos/suspend.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
>> index f5d9773..5b9c551 100644
>> --- a/arch/arm/mach-exynos/suspend.c
>> +++ b/arch/arm/mach-exynos/suspend.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/io.h>
>>  #include <linux/irqchip/arm-gic.h>
>>  #include <linux/err.h>
>> +#include <linux/regulator/machine.h>
>>
>>  #include <asm/cacheflush.h>
>>  #include <asm/hardware/cache-l2x0.h>
>> @@ -270,14 +271,29 @@ static int exynos_suspend_enter(suspend_state_t state)
>>
>>  static int exynos_suspend_prepare(void)
>>  {
>> +       int ret;
>> +
>>         s3c_pm_check_prepare();
>>
>> +       /*
>> +        * REVISIT: It would be better if struct platform_suspend_ops
>> +        * .prepare handler get the suspend_state_t as a parameter to
>> +        * avoid hard-coding the suspend to mem state. It's safe to do
>> +        * it only because the suspend_valid_only_mem function is the
>> +        * .valid callback used to check if a given state is supported
>> +        * by the platform.
>> +        */
>> +       ret = regulator_suspend_prepare(PM_SUSPEND_MEM);
>> +       if (ret)
>> +               pr_info("Failed to prepare regulators for system suspend\n");
>> +
> 
> nit: can you put this before s3c_pm_check_prepare().  pm_check is
> pretty darn broken and I have a feeling that it will eventually be
> ripped out (or in the very least ported to not be Samsung-specific and
> include all of the "suspend volatile" crud that we have in the
> chromeos-3.8 kernel), but might as well try not to break it further.
> 
> Changing the order also has the advantage of making prepare / finish
> opposite orders (good!) and handling the fact that you would call
> s3c_pm_check_prepare() but not s3c_pm_check_cleanup() if
> regulator_suspend_prepare() fails.
> 

Good point, I'll change that on v2. I'll wait until tomorrow to see if there
are more comments and re-post with your suggestions.

> 
>>         return 0;
>>  }
>>
>>  static void exynos_suspend_finish(void)
>>  {
>>         s3c_pm_check_cleanup();
>> +       regulator_suspend_finish();
>>  }
>>
>>  static const struct platform_suspend_ops exynos_suspend_ops = {

Best regards,
Javier 

