Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab3FCVS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:18:26 -0400
Received: from exprod6og118.obsmtp.com ([64.18.1.233]:39881 "EHLO
	exprod6og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758353Ab3FCVSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:18:22 -0400
X-Greylist: delayed 2397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 17:18:22 EDT
Message-ID: <51ACFEBE.1050801@verisign.com>
Date: Mon, 03 Jun 2013 16:38:22 -0400
From: David C Niemi <dniemi@verisign.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stratos Karafotis <stratosk@semaphore.gr>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51ACF2EA.70001@semaphore.gr>
In-Reply-To: <51ACF2EA.70001@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2013 20:38:23.0006 (UTC) FILETIME=[4A6AB3E0:01CE609A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Interesting analysis; I just got back from vacation and have not had a chance to comment until now.

I like Stratos' general idea of making the decision to upshift or downshift independent of current frequency, as it makes thinks simpler and potentially more stable.  But I believe it will be important to measure performance and power consumption in a wider range of use cases to know whether it is an overall win (or whether it can at least be tuned to match the status quo for various use cases).

In my main use case (network servers), I don't think using more middle frequencies is a good thing at all; as soon as a load gets heavy even briefly I want the CPU doing all it can until the load has clearly abated.  The main competition in this use case is between using ondemand (tuned for performance at the cost of some extra power consumption) or the "performance" governor (which cannot be tuned at all, and where C-states are the only hope for moderating power consumption).

A couple of additional points -- it is possible to get excellent overall performance and avoid oscillation using ondemand right now by using a low up_threshold and a sampling_down_factor of around 100; in this case you spend most of your time at either the lowest or highest possible frequency and you spend very little time thinking about slowing down.  The main downside of this is an increase in power consumption, so it is not a battery-friendly approach, but someone will need to also measure power consumption if we want to justify a change from the status quo on that basis.  There are dozens of ways to save power at the expense of performance or vice versa, so any major change like this needs to be analyzed for both, in case your patch just results in running at higher average frequencies and gets its performance boost from that.

David C Niemi

On 06/03/13 15:47, Stratos Karafotis wrote:
> Ondemand calculates load in terms of frequency and increases it only
> if the load_freq is greater than up_threshold multiplied by current
> or average frequency. This seems to produce oscillations of frequency
> between min and max because, for example, a relatively small load can
> easily saturate minimum frequency and lead the CPU to max. Then, the
> CPU will decrease back to min due to a small load_freq.
>
> This patch changes the calculation method of load and target frequency
> considering 2 points:
> - Load computation should be independent from current or average
> measured frequency. For example an absolute load 80% at 100MHz is not
> necessarily equivalent to 8% at 1000MHz in the next sampling interval.
> - Target frequency should be increased to any value of frequency table
> proportional to absolute load, instead to only the max. Thus:
>
> Target frequency = C * load
>
> where C = policy->cpuinfo.max_freq / 100
>
> Tested on Intel i7-3770 CPU @ 3.40GHz and on Quad core 1500MHz Krait.
> Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
> increase ~1.5% in performance. cpufreq_stats (time_in_state) shows
> that middle frequencies are used more, with this patch. Highest
> and lowest frequencies were used less by ~9%
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_governor.c | 10 +---------
>  drivers/cpufreq/cpufreq_governor.h |  1 -
>  drivers/cpufreq/cpufreq_ondemand.c | 39 +++++++-------------------------------
>  3 files changed, 8 insertions(+), 42 deletions(-)
>
...
