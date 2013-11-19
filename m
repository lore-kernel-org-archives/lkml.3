Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3KSO7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:59:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55549 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3KSO7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:59:54 -0500
Message-ID: <528B7CE5.5040502@ti.com>
Date: Tue, 19 Nov 2013 08:59:49 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
References: <1384568535-26611-1-git-send-email-nm@ti.com>	<20131116134445.GI11014@S2101-09.ap.freescale.net>	<CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>	<528A27F8.3070402@ti.com>	<20131118155753.GU11014@S2101-09.ap.freescale.net>	<528A4340.3020508@ti.com>	<20131119022133.GB18434@S2101-09.ap.freescale.net>	<CAKohpok_yRZr-XQEC+w8PLN+ZyW83uijFyZrDM1LB8G2X4h-fg@mail.gmail.com>	<528B72C1.5060006@ti.com> <CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>
In-Reply-To: <CAKohpo=hzCSuQBGreRStzkOuH6aFiZKTtK9SF+_eGEajkwSXEA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 08:26 AM, Viresh Kumar wrote:
> On 19 November 2013 19:46, Nishanth Menon <nm@ti.com> wrote:
>> Consider something like userspace governor selection -> the device at
>> boot will probably remain in an unknown/"invalid" configuration till
>> the very first transition attempt. I am less worried about the stats
>> than not following what the hardware description is (as stated by
>> device tree/other forms).
>>
>> I staunchly disagree that at a point of mismatch detection, we just
>> refuse to load up cpufreq governor -even though we know from device
>> tree/other alternative entries what the hardware behavior is supposed
>> to be. To refuse to loadup to a known configuration is considering the
>> "valid configuration" data provided to the driver is wrong - an
>> equivalent(considering the i2c example) is that if i2c driver sees bus
>> configured for 3.4MHz and was asked to use 100KHz, it just refuses to
>> load up!
> 
> CPU looks to be a bit different in that aspect as compared to I2C. We
> aren't really sure if I2C will work at the existing freq but we are 100%
> sure that current freq of CPU is valid enough, otherwise we wouldn't
> have reached to this point.. :)
> 
Not completely true - reaching probe after boot in a few seconds may
not mean that system will remain stable at that frequency for longer
duration. From a silicon vendor perspective, I do know that we
gaurentee the discrete frequencies in the data manual (and that gets
populated in devicetree and hence in freq_table), but we will not
guarentee any other frequency to be functional for any length of time.
in short, if a actual product is manufactured and operational at a
frequency we do not "officially support", there is a risk associated
with that. just a boot on a few development systems do not ever
guarentee productization capability.

>> The above two are fair comments -> but that implies that policy->cur
>> population should no longer be the responsibility of cpufreq drivers
>> and be the responsibility of cpufreq core. are we stating we want to
>> move that to cpufreq core?
> 
> I am sure you want to have a look at this:

my bad. I missed this one.

So, to summarize: what is our overall strategy here? to move to a
frequency matched in freq_table OR just giveup? I can try and respin
accordingly.

> 
> commit da60ce9f2faca87013fd3cab1c3bed5183608c3d
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Thu Oct 3 20:28:30 2013 +0530
> 
>     cpufreq: call cpufreq_driver->get() after calling ->init()
> 
>     Almost all drivers set policy->cur with current CPU frequency in
> their ->init()
>     part. This can be done for all of them at core level and so they
> wouldn't need
>     to do it.
> 
>     This patch adds supporting code in cpufreq core for calling get()
> after we have
>     called init() for a policy.
> 
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 


-- 
Regards,
Nishanth Menon
