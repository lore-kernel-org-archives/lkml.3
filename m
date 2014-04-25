Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaDYFyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:54:46 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47579 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaDYFyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:54:44 -0400
Message-ID: <5359F894.4070205@linaro.org>
Date: Fri, 25 Apr 2014 11:24:28 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: kgene.kim@samsung.com, t.figa@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org, arnd@arndb.de,
        olof@lixom.net, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        sachin.kamat@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 3/7] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com> <1398388572-30239-4-git-send-email-cw00.choi@samsung.com> <5359E4E6.90102@linaro.org> <5359F5F5.7030109@samsung.com>
In-Reply-To: <5359F5F5.7030109@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 11:13 AM, Chanwoo Choi wrote:
> Hi,
> 
> On 04/25/2014 01:30 PM, Tushar Behera wrote:
>> On 04/25/2014 06:46 AM, Chanwoo Choi wrote:
>>> This patch fix the offset of CPU boot address and don't need to send smc call
>>> of SMC_CMD_CPU1BOOT command for secondary CPU boot because Exynos3250 removes
>>> WFE in secure mode.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  arch/arm/mach-exynos/firmware.c | 10 ++++++++--
>>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>>> index aa01c42..386d01d 100644
>>> --- a/arch/arm/mach-exynos/firmware.c
>>> +++ b/arch/arm/mach-exynos/firmware.c
>>> @@ -31,11 +31,17 @@ static int exynos_do_idle(void)
>>>  static int exynos_cpu_boot(int cpu)
>>>  {
>>>  	/*
>>> +	 * Exynos3250 doesn't need to send smc command for secondary CPU boot
>>> +	 * because Exynos3250 removes WFE in secure mode.
>>> +	 */
>>> +	if (soc_is_exynos3250())
>>> +		return 0;
>>> +	/*
>>>  	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
>>>  	 * But, Exynos4212 has only one secondary CPU so second parameter
>>>  	 * isn't used for informing secure firmware about CPU id.
>>>  	 */
>>> -	if (soc_is_exynos4212())
>>> +	else if (soc_is_exynos4212())
>>
>> This changes is not required.
> 
> Do you mean it as following?
> 
> 	if (soc_is_exynos3250())
> 		return 0
> 
> 	if (soc_is_exynos4212())
> 		cpu = 0;
> 

Yes, logically the flow would be same and code would be more readable.

>>
>>>  		cpu = 0;
>>>  
>>>  	exynos_smc(SMC_CMD_CPU1BOOT, cpu, 0, 0);
>>> @@ -46,7 +52,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>>>  {
>>>  	void __iomem *boot_reg = S5P_VA_SYSRAM_NS + 0x1c;
>>>  
>>> -	if (!soc_is_exynos4212())
>>> +	if (!soc_is_exynos4212() && !soc_is_exynos3250())
>>>  		boot_reg += 4*cpu;
>>>  
>>>  	__raw_writel(boot_addr, boot_reg);
>>>
>>
>>
> 


-- 
Tushar Behera
