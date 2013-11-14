Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3KNRFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:05:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55502 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3KNREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:04:52 -0500
Message-ID: <528502AC.4010604@ti.com>
Date: Thu, 14 Nov 2013 11:04:44 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
References: <1382638087-32054-1-git-send-email-nm@ti.com> <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com> <52824522.7020401@ti.com> <CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com> <20131113151645.GA17828@kahuna> <52842671.40703@linaro.org> <5284DDB9.7040502@ti.com> <5284FE48.8040802@linaro.org>
In-Reply-To: <5284FE48.8040802@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 10:46 AM, viresh kumar wrote:
> On Thursday 14 November 2013 07:57 PM, Nishanth Menon wrote:
>> I am guessing this is a little too early for restarting policy here
>> considering syscore_ops->resume is pretty early..
> 
> Yeah, looks like that..
> 
>> http://pastebin.mozilla.org/3602746 is the equivalent patch for v3.12
>> http://pastebin.mozilla.org/3602747 is the result.
> 
> Can you try this instead of last diff I sent?
> 
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index dc67fa0..e70e906 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1324,6 +1324,15 @@ static void handle_update(struct work_struct *work)
>                 container_of(work, struct cpufreq_policy, update);
>         unsigned int cpu = policy->cpu;
>         pr_debug("handle_update for cpu %u called\n", cpu);
> +
> +       if (has_target() && !policy->governor_enabled) {
> +               if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
> +                       (ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
> +                       pr_err("%s: Failed to start governor\n", __func__);
> +                       goto fail;
> +               }
> +       }
> +
>         cpufreq_update_policy(cpu);
>  }
> 
> 
I think it is still too early to do so :(

equivalent patch: http://pastebin.mozilla.org/3603467 (with minor
changes for build)

Basic tests: http://pastebin.mozilla.org/3603456 (governor is
functional, but governor kicks in early before i2c is resumed)

With call stack: http://pastebin.mozilla.org/3603455 to highlight call
sequences

Seems like we might want to pause governor as early in the suspend
sequence as possible to allow SoC and regulator stuff to suspend
themselves without cpufreq interfering.. just my 2 cents..

-- 
Regards,
Nishanth Menon
