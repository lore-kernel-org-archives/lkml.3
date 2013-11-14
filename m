Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3KNO1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:27:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38862 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab3KNO1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:27:10 -0500
Message-ID: <5284DDB9.7040502@ti.com>
Date: Thu, 14 Nov 2013 08:27:05 -0600
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
References: <1382638087-32054-1-git-send-email-nm@ti.com> <CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com> <52824522.7020401@ti.com> <CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com> <20131113151645.GA17828@kahuna> <52842671.40703@linaro.org>
In-Reply-To: <52842671.40703@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 07:25 PM, viresh kumar wrote:
> On Wednesday 13 November 2013 08:46 PM, Nishanth Menon wrote:
>> arrgh, my bad.. Apologies for the bad one.. I missed it :( Does the following
>> look equivalent?
> 
> yes.
> 
>> With this, I now see:
> 
>> [   43.212714] cpufreq: cpufreq_add_policy_cpu: Failed to stop governor
>> ^^^ ??
> 
> Ahh, I missed this part. I thought it will fail at some other place where there
> is no error checking :), but that's not true.
> 
> Following should fix it for you and looks to be the right way as well.
> 
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index dc67fa0..30b09d3 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1530,6 +1530,14 @@ static void cpufreq_bp_resume(void)
>                 }
>         }
> 
> +       if (has_target()) {
> +               if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
> +                       (ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
> +                       pr_err("%s: Failed to start governor\n", __func__);
> +                       goto fail;
> +               }
> +       }
> +
>         schedule_work(&policy->update);
> 
>  fail:
> 
I am guessing this is a little too early for restarting policy here
considering syscore_ops->resume is pretty early..

http://pastebin.mozilla.org/3602746 is the equivalent patch for v3.12
http://pastebin.mozilla.org/3602747 is the result.

-- 
Regards,
Nishanth Menon
