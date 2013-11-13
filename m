Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3KMFtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:49:35 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49016 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab3KMFt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <52824522.7020401@ti.com>
References: <1382638087-32054-1-git-send-email-nm@ti.com>
	<CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com>
	<52824522.7020401@ti.com>
Date: Wed, 13 Nov 2013 11:19:27 +0530
Message-ID: <CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2013 20:41, Nishanth Menon <nm@ti.com> wrote:
> On 11/12/2013 12:03 AM, Viresh Kumar wrote:

>> Yes the problem looks real but there are issues with this patch.
>> - It doesn't solve your problem completely, because you returned -EBUSY,
>> your suspend operation failed and we resumed immediately.
>
> Seems like there was an error handling miss somewhere - for some
> reason, it did suspend properly.

Yeah, its missing in cpufreq_cpu_callback()..

>> But I think the problem can/should be solved some other way.. Looking closely,
>> we got to the problem because we called
>>
>> __cpufreq_governor(policy, CPUFREQ_GOV_START)
>>
>> at the first place. This happened because the policy structure had more than
>> one cpu to take care of and after stopping goveronr for CPU1 it has to start it
>> again for CPU0... But this is really not required as anyway we are going to
>> suspend.
>>
>> Can you try attached patch? I will then repost it formally...
>
> I tried a equivalent of this for v3.12 tag:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 04548f7..9ec243c 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1186,7 +1186,7 @@ static int __cpufreq_remove_dev_prepare(struct
> device *dev,
>                 return -EINVAL;
>         }
>
> -       if (cpufreq_driver->target) {
> +       if (cpufreq_driver->target && (!frozen ||
> policy->governor_enabled)) {
>                 ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>                 if (ret) {
>                         pr_err("%s: Failed to stop governor\n", __func__);
> @@ -1252,7 +1252,7 @@ static int __cpufreq_remove_dev_finish(struct
> device *dev,
>
>         /* If cpu is last user of policy, free policy */
>         if (cpus == 1) {
> -               if (cpufreq_driver->target) {
> +               if (cpufreq_driver->target && !frozen) {
>                         ret = __cpufreq_governor(policy,
>                                         CPUFREQ_GOV_POLICY_EXIT);

This is not an equivalent of my patch :)

@@ -1282,7 +1282,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
                if (!frozen)
                        cpufreq_policy_free(policy);
        } else {
-               if (has_target()) {
+               if (has_target() && !frozen) {
                        if ((ret = __cpufreq_governor(policy,
CPUFREQ_GOV_START)) ||
                                        (ret =
__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {


> And I see http://pastebin.mozilla.org/3528478
>
> with a WARN patch for generating call stack.

that's why you got it.. I was really surprised to see it just didn't
worked for you
and believe me it took me a lot of time understanding how isn't it
working for u.
Because I simply believed on your equivalent version and didn't looked at it
closely :)

> Finally squelched warnings with a net diff (v3.12) of
> http://pastebin.mozilla.org/3546062

we don't need that stuff in cpufreq_add_policy_cpu()

> However, ondemand is no longer functioning on resume (governor needs a
> start after being unfrozen.. and obviously by avoiding that entirely
> in frozen case.. not sure if I missed any other)..

It would be, try the right code once. :)
