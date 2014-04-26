Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaDZAbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:31:47 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51767 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751265AbaDZAbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:31:45 -0400
Date: Sat, 26 Apr 2014 01:30:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        t.figa@samsung.com, sajjan.linux@gmail.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, marc.zyngier@arm.com,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        thomas.abraham@linaro.org, ben-linux@fluff.org, olof@lixom.net,
        chanho61.park@samsung.com, sachin.kamat@linaro.org,
        linux-arm-kernel@lists.infradead.org, tushar.behera@linaro.org
Subject: Re: [PATCHv4 4/7] ARM: EXYNOS: Enter a15 lowpower mode for
	Exynos3250 based on Cortex-a7
Message-ID: <20140426003044.GW26756@n2100.arm.linux.org.uk>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-5-git-send-email-cw00.choi@samsung.com> <535AFCDF.20503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535AFCDF.20503@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 02:25:03AM +0200, Tomasz Figa wrote:
> On 25.04.2014 03:16, Chanwoo Choi wrote:
>> This patch decide proper lowpower mode of either a15 or a9 according to own ID
>> from Main ID register.
>>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Marc Zynigier <marc.zyngier@arm.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   arch/arm/mach-exynos/hotplug.c | 19 ++++++++++++-------
>>   1 file changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
>> index 5eead53..acf3119 100644
>> --- a/arch/arm/mach-exynos/hotplug.c
>> +++ b/arch/arm/mach-exynos/hotplug.c
>> @@ -135,16 +135,21 @@ void __ref exynos_cpu_die(unsigned int cpu)
>>   	int primary_part = 0;
>>
>>   	/*
>> -	 * we're ready for shutdown now, so do it.
>> -	 * Exynos4 is A9 based while Exynos5 is A15; check the CPU part
>> -	 * number by reading the Main ID register and then perform the
>> -	 * appropriate sequence for entering low power.
>> +	 * Prepare the CPU for shutting down. The required sequence of
>> +	 * operations depends on core type. CPUID part number can be used to
>> +	 * determine the right way.
>>   	 */
>> -	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(primary_part) : : "cc");
>> -	if ((primary_part & 0xfff0) == 0xc0f0)
>> +	primary_part = read_cpuid_part_number();
>> +
>> +	switch (primary_part) {
>> +	case ARM_CPU_PART_CORTEX_A7:
>> +	case ARM_CPU_PART_CORTEX_A15:

Although I believe we're approaching the point where everyone just uses
ARM Ltd designed CPUs, it should be remembered that the part number
field is designer specific, so if we were being strict, we'd check both
the part number and the designer fields together.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
