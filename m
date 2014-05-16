Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbaEPSuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:50:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48282 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaEPSuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:50:05 -0400
Message-ID: <53765DD9.6040403@wwwdotorg.org>
Date: Fri, 16 May 2014 12:50:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, dianders@chromium.org,
        linux@arm.linux.org.uk, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 2/3] cpufreq: add support for intermediate (stable)
 frequencies
References: <cover.1400230695.git.viresh.kumar@linaro.org> <9e1ed1bf8c3610709436fe5ef8df3a63856f8f5c.1400230695.git.viresh.kumar@linaro.org>
In-Reply-To: <9e1ed1bf8c3610709436fe5ef8df3a63856f8f5c.1400230695.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 03:07 AM, Viresh Kumar wrote:
> Douglas Anderson, recently pointed out an interesting problem due to which
> udelay() was expiring earlier than it should.
> 
> While transitioning between frequencies few platforms may temporarily switch to
> a stable frequency, waiting for the main PLL to stabilize.
> 
> For example: When we transition between very low frequencies on exynos, like
> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
> No CPUFREQ notification is sent for that. That means there's a period of time
> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
> and 300MHz. And so udelay behaves badly.
> 
> To get this fixed in a generic way, lets introduce another set of callbacks
> get_intermediate() and target_intermediate(), only for drivers with
> target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.
> 
> get_intermediate should return a stable intermediate frequency platform wants to
> switch to, and target_intermediate() should set CPU to to that frequency, before
> jumping to the frequency corresponding to 'index'. Core will take care of
> sending notifications and driver doesn't have to handle them in
> target_intermediate() or target_index().
> 
> NOTE: Once set to intermediate frequency, driver isn't expected to fail for the
> following ->target_index() call, if it fails core will issue a WARN().

> diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt

> +cpufreq_driver.get_intermediate
> +and target_intermediate		Uset to switch to stable frequency while
> +				changing CPU frequency.

s/Uset/Used.

> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h

> @@ -226,6 +226,21 @@ struct cpufreq_driver {

> +	unsigned int (*get_intermediate)(struct cpufreq_policy *policy,
> +					 unsigned int index);

Should get_intermediate be passed a struct cpufreq_freqs freqs rather
than just the target index? That way, if the intermediate frequency
varies depending on old/new frequencies, then the driver won't have to
go look up the current frequency in order to implement that logic.
