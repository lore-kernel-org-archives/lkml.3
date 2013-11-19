Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3KSExS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 23:53:18 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13094 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSExO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 23:53:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Nov 2013 20:47:18 -0800
Message-ID: <528AEEB6.4070107@nvidia.com>
Date: Tue, 19 Nov 2013 13:53:10 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] ARM: tegra: properly use FUSE clock
References: <1384771247-16547-1-git-send-email-acourbot@nvidia.com> <20131118114330.GD8646@ulmo.nvidia.com> <528AA750.3080201@wwwdotorg.org>
In-Reply-To: <528AA750.3080201@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 08:48 AM, Stephen Warren wrote:
> On 11/18/2013 04:43 AM, Thierry Reding wrote:
>> On Mon, Nov 18, 2013 at 07:40:47PM +0900, Alexandre Courbot wrote:
>>> FUSE clock is enabled by most bootloaders, but we cannot expect
>>> it to be on in all contexts (e.g. kexec).
>>>
>>> This patch adds a FUSE clkdev to all Tegra platforms and makes
>>> sure it is enabled before touching FUSE registers.
>>> tegra_init_fuse() is invoked during very early boot and thus
>>> cannot rely on the clock framework ; therefore the FUSE clock is
>>> forcibly enabled using a register write in that function, and
>>> remains that way until the clock framework can be used.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com> ---
>>> arch/arm/mach-tegra/fuse.c       | 41
>>> +++++++++++++++++++++++++++++++++++++++-
>>> drivers/clk/tegra/clk-tegra114.c |  1 +
>>> drivers/clk/tegra/clk-tegra124.c |  1 +
>>> drivers/clk/tegra/clk-tegra20.c  |  1 +
>>
>> Isn't this missing the clock driver changes for Tegra30? Ah...
>> Tegra30 already has this clock defined. I wonder why only Tegra30
>> has it. grep says that fuse-tegra isn't used by any drivers, which
>> also indicates that perhaps we don't need the .dev_id in the first
>> place. We should be able to get by with just the .con_id = "fuse".
>>
>> Also are there any reasons to keep this in one single patch? Since
>> none of the fuse clocks are used yet, I think the clock changes
>> could be a separate patch that can go in through the clock tree.
>> And there isn't even a hard runtime dependency, since if the Tegra
>> changes were to go in without the clock changes, then the fallback
>> code in this patch should still turn the clock on properly. It just
>> might not be turned off again, but isn't that something we can live
>> with for a short period of time? I think perhaps that could even be
>> improved, see further below.
>>
>> I've added Mike on Cc, he'll need to either take the patch in
>> through his tree or Ack this one, so he needs to see it
>> eventually.
>>
>>> 4 files changed, 43 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm/mach-tegra/fuse.c
>>> b/arch/arm/mach-tegra/fuse.c index 9a4e910c3796..3b9191b930b5
>>> 100644 --- a/arch/arm/mach-tegra/fuse.c +++
>>> b/arch/arm/mach-tegra/fuse.c @@ -22,6 +22,7 @@ #include
>>> <linux/io.h> #include <linux/export.h> #include <linux/random.h>
>>> +#include <linux/clk.h> #include <linux/tegra-soc.h>
>>>
>>> #include "fuse.h" @@ -54,6 +55,7 @@ int tegra_cpu_speedo_id;		/*
>>> only exist in Tegra30 and later */ int tegra_soc_speedo_id; enum
>>> tegra_revision tegra_revision;
>>>
>>> +static struct clk *fuse_clk; static int tegra_fuse_spare_bit;
>>> static void (*tegra_init_speedo_data)(void);
>>>
>>> @@ -77,6 +79,22 @@ static const char
>>> *tegra_revision_name[TEGRA_REVISION_MAX] = { [TEGRA_REVISION_A04]
>>> = "A04", };
>>>
>>> +static void tegra_fuse_enable_clk(void) +{ +	if
>>> (IS_ERR(fuse_clk)) +		fuse_clk = clk_get_sys("fuse-tegra",
>>> "fuse"); +	if (IS_ERR(fuse_clk)) +		return;
>>
>> Perhaps instead of just returning here, this should actually be
>> where the code to enable the clock should go.
>>
>>> +	clk_prepare_enable(fuse_clk); +} + +static void
>>> tegra_fuse_disable_clk(void) +{ +	if (IS_ERR(fuse_clk)) +
>>> return;
>>
>> And this is where we could disable it again. That way we should
>> get equal functionality in both cases.
>
> That would need a shared lock with the clock code; at some point, the
> clock will be registered, and the clock subsystem in control of the
> enable bit. I think having a very early tegra_init_fuse() come along
> and force the clock on, and then having the rest of the fuse code use
> the clock object as soon as it's available, is the safest approach.
>
> Of course, I suppose there's still a window where the following might
> happen:
>
> cpu 0:
> - tegra_fuse_enable_clk entered
> - fails to clk_get
> 				cpu 1
> 				- tegra clk driver is registered
> 				- clk subsystem initcall disables all
> 				  unused clocks
> - access a fuse register
>
> -> badness

It seems to me that both solutions require a shared lock with the clock 
code in order to be theoretically safe. The situation you described 
requires a lock to be addressed ; and unless I missed something, 
anything that could break with Thierry's proposal could also only do so 
if we "hold" the clock when the tegra clk driver is registered.

However we can consider ourselves safe for both cases if we know for 
sure that there is no fuse function in use when this happens. Since 
of_clk_init() is called very early during boot with SMP and preemption 
disabled, isn't that always the case?

>
> I'm not sure how to protect against that, unless we simply assume that
> all the fuse driver functions are guaranteed to happen early and
> before the clk subsystem's initcall, so that can't happen?

That's probably the current behavior actually - the clk subsystem's 
initcall disables the fuse clock, fuse functions are never used after 
that, and we only notice when we try to kexec into another kernel that 
the fuse clock is not enabled as expected.

With that in mind, it's probably a good idea to preemptively implement 
proper clock enabling in fuse.c, in case we come to use it more in the 
future.

Thanks,
Alex.

