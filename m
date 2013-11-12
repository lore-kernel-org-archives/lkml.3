Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3KLPLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:11:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47283 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab3KLPLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:11:35 -0500
Message-ID: <52824522.7020401@ti.com>
Date: Tue, 12 Nov 2013 09:11:30 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
References: <1382638087-32054-1-git-send-email-nm@ti.com> <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com>
In-Reply-To: <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 12:03 AM, Viresh Kumar wrote:
> Cc'ing Shawn as well.
> 
> Sorry for being really late.. I just forgot about it :(

Thanks for responding :)

> 
> On 24 October 2013 23:38, Nishanth Menon <nm@ti.com> wrote:
>> For platforms where regulators are used, regulator access tends to be
>> disabled as part of the suspend path. In SMP systems such as OMAP,
>> CPU1 is disabled as post suspend_noirq. This results in the following
>> tail end sequence of actions:
>> cpufreq_cpu_callback gets called with CPU_POST_DEAD
>>         __cpufreq_remove_dev_finish is invoked as a result
>>                 __cpufreq_governor(policy, CPUFREQ_GOV_START) is
>>                 triggered
>>
>> At this point, with ondemand governor, if the cpu entered suspend path
>> at a lower OPP, this triggers a transition request. However, since
>> irqs are disabled, typically, regulator control using I2C operations
>> are not possible either, regulator operations will naturally fail
>> (even though clk_set_rate might succeed depending on the platform).
>>
>> Unfortunately, cpufreq_driver->suspend|resume is too late as well, since
>> they are invoked as part of syscore_ops (after CPU1 is hotplugged out).
>>
>> The proposal here is to use pm notifier suspend to disable any
>> requests to target, as we may very well expect this to fail at a later
>> suspend sequence.
> 
> Yes the problem looks real but there are issues with this patch.
> - It doesn't solve your problem completely, because you returned -EBUSY,
> your suspend operation failed and we resumed immediately.

Seems like there was an error handling miss somewhere - for some
reason, it did suspend properly.

> - We can't make this solution true for everybody using cpu0 driver, it should
> be platform specific.

Agreed.

> - Its not a problem of cpu0 driver but all drivers. So, probably a better idea
> would be not calling ->target() at all when drivers have marked them unusable
> in suspend path..

Ack.

> 
> But I think the problem can/should be solved some other way.. Looking closely,
> we got to the problem because we called
> 
> __cpufreq_governor(policy, CPUFREQ_GOV_START)
> 
> at the first place. This happened because the policy structure had more than
> one cpu to take care of and after stopping goveronr for CPU1 it has to start it
> again for CPU0... But this is really not required as anyway we are going to
> suspend.
> 
> Can you try attached patch? I will then repost it formally...

I tried a equivalent of this for v3.12 tag:
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 04548f7..9ec243c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1186,7 +1186,7 @@ static int __cpufreq_remove_dev_prepare(struct
device *dev,
                return -EINVAL;
        }

-       if (cpufreq_driver->target) {
+       if (cpufreq_driver->target && (!frozen ||
policy->governor_enabled)) {
                ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
                if (ret) {
                        pr_err("%s: Failed to stop governor\n", __func__);
@@ -1252,7 +1252,7 @@ static int __cpufreq_remove_dev_finish(struct
device *dev,

        /* If cpu is last user of policy, free policy */
        if (cpus == 1) {
-               if (cpufreq_driver->target) {
+               if (cpufreq_driver->target && !frozen) {
                        ret = __cpufreq_governor(policy,
                                        CPUFREQ_GOV_POLICY_EXIT);
                        if (ret) {

And I see http://pastebin.mozilla.org/3528478

with a WARN patch for generating call stack.


Finally squelched warnings with a net diff (v3.12) of
http://pastebin.mozilla.org/3546062

However, ondemand is no longer functioning on resume (governor needs a
start after being unfrozen.. and obviously by avoiding that entirely
in frozen case.. not sure if I missed any other)..

> 
> commit 2aecab9be85ceafdbab5f824eec5d1f81f3fa803
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Tue Nov 12 11:26:36 2013 +0530
> 
>     cpufreq: don't start governor in suspend path
> 
>     When we suspend our system, we remove all non-boot CPUs one by one. At this
>     point we actually STOP/START governor for each non-boot cpu, which
> is a total
>     waste of time as we aren't going to use governor until the time we are back.
> 
>     Also, this is causing problems for some platforms (like OMAP),
> where governor
>     tries to change freq of core in suspend path which requires programming
>     regulators via I2C which isn't possible then.
> 
>     So, to make it better for everybody don't start the governor again
> in suspend
>     path.
> 
>     Reported-by: Nishanth Menon <nm@ti.com>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..bec58cf 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1174,7 +1174,7 @@ static int __cpufreq_remove_dev_prepare(struct
> device *dev,
>                 return -EINVAL;
>         }
> 
> -       if (has_target()) {
> +       if (has_target() && (!frozen || policy->governor_enabled)) {
>                 ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>                 if (ret) {
>                         pr_err("%s: Failed to stop governor\n", __func__);
> @@ -1282,7 +1282,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>                 if (!frozen)
>                         cpufreq_policy_free(policy);
>         } else {
> -               if (has_target()) {
> +               if (has_target() && !frozen) {
>                         if ((ret = __cpufreq_governor(policy,
> CPUFREQ_GOV_START)) ||
>                                         (ret =
> __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
>                                 pr_err("%s: Failed to start governor\n",
> 
> 




-- 
Regards,
Nishanth Menon
