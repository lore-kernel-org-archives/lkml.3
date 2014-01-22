Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaAVPqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:46:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:48414 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaAVPqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:46:45 -0500
Message-ID: <52DFE7D9.5050001@windriver.com>
Date: Wed, 22 Jan 2014 10:46:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RESEND] cpufreq: exynos: Fix build error of no type of
 module_init
References: <1390400476-22951-1-git-send-email-k.kozlowski@samsung.com> <CAKohpo=2wR+Sqwxj4koH0rvuk29BkNyAZgN0RR7bVH+3uqpB1Q@mail.gmail.com> <1390402760.18340.6.camel@AMDC1943> <1390405030.18340.11.camel@AMDC1943>
In-Reply-To: <1390405030.18340.11.camel@AMDC1943>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-22 10:37 AM, Krzysztof Kozlowski wrote:
> 
>>
>> On Wed, 2014-01-22 at 20:12 +0530, Viresh Kumar wrote:
>>> On 22 January 2014 19:51, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
>>>> Add missing include to fix build error:
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_init’ [-Werror=implicit-int]
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_exit’ [-Werror=implicit-int]
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
>>>> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: ‘exynos_cpufreq_platdrv_init’ defined but not used [-Wunused-function]
>>>> cc1: some warnings being treated as errors
>>>> make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
>>>> make[1]: *** [drivers/cpufreq] Error 2
>>>>
>>>> Build error happens on gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
>>>> and was introduced by commit d568b6f71df1 (cpufreq: exynos: Convert
>>>> exynos-cpufreq to platform driver).
>>>>
>>>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>>> Cc: Lukasz Majewski <l.majewski@samsung.com>
>>>> Cc: Tomasz Figa <t.figa@samsung.com>
>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  drivers/cpufreq/exynos-cpufreq.c |    1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
>>>> index fcd2914d081a..fa54c2b88dd7 100644
>>>> --- a/drivers/cpufreq/exynos-cpufreq.c
>>>> +++ b/drivers/cpufreq/exynos-cpufreq.c
>>>> @@ -17,6 +17,7 @@
>>>>  #include <linux/regulator/consumer.h>
>>>>  #include <linux/cpufreq.h>
>>>>  #include <linux/suspend.h>
>>>> +#include <linux/module.h>
>>>>  #include <linux/platform_device.h>
>>>
>>> I am surprised how that patch went through then? And nothing was
>>> reported by kbuild for it..
>>
>> Hi,
>>
>> A little more explanation from my side: the build error actually happens
>> only on next/master, not Linus' tree.
>>
>> Mentioned commit which changes the driver to platform driver is in
>> mainline since 3.12-rc2 so it seems this is not the cause of the build
>> error. I think I need to find first the real cause of this build error.
>>
>> Best regards,
>> Krzysztof
> 
> After bisecting, the real commit for build error is:
> caa7dcde7c424cdc81698a6e4e48072eb67ec67e
>     module: relocate module_init from init.h to module.h

Yep, even though I fixed a crap-tonne of implicit includes, and
built all the arm configs, some were bound to sneak through.

I'll push a fix shortly to the init cleanup queue:

   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/

so it will be fine for the next linux-next tree.

Thanks,
Paul.
--

> 
> My patch seems valid although the reason in commit msg should be updated:
> ################
> Add missing include to fix build error:
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_init’ [-Werror=implicit-int]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: data definition has no type or storage class [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: error: type defaults to ‘int’ in declaration of ‘module_exit’ [-Werror=implicit-int]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: parameter names (without types) in function declaration [enabled by default]
> drivers/cpufreq/exynos-cpufreq.c:292:1: warning: ‘exynos_cpufreq_platdrv_init’ defined but not used [-Wunused-function]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/cpufreq/exynos-cpufreq.o] Error 1
> make[1]: *** [drivers/cpufreq] Error 2
> 
> Build error happens on gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)
> and was introduced in next tree by commit caa7dcde7c42 (module: relocate
> module_init from init.h to module.h).
> ################
> 
> 
> 
