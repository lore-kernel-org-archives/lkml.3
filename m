Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaIXImc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:42:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33635 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaIXIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:42:28 -0400
Message-ID: <542283EB.3030809@samsung.com>
Date: Wed, 24 Sep 2014 17:42:19 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        acourbot@nvidia.com, tomeu@tomeuvizoso.net,
        "'Olof Johansson'" <olof@lixom.net>, swarren@nvidia.com,
        drake@endlessm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com> <5415D4A8.4010304@gmail.com> <0d2401cfd07b$0e21e190$2a65a4b0$@kernel.org> <54227893.7020808@samsung.com> <54227F7B.80702@samsung.com>
In-Reply-To: <54227F7B.80702@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 17:23, Marek Szyprowski wrote:
> Hi Kukjin,
>
> On 2014-09-24 09:53, Kukjin Kim wrote:
>>
>> On 09/15/14 09:21, Kukjin Kim wrote:
>>>
>>>> On 26.08.2014 16:10, Tomasz Figa wrote:
>>>>> On Exynos-based boards running secure firmware the sequence of low
>>>>> level
>>>>> operations to enter and leave system-wide sleep mode is different than
>>>>> on those without the firmware. Namely:
>>>>> - CP15 power control and diagnostic registers cannot be written
>>>>> directly,
>>>>> - the way of setting boot address and boot flag is different,
>>>>> - different resume handler needs to be used,
>>>>> - dedicated SMC call needs to be performed instead of letting the
>>>>> CPU enter
>>>>> WFI.
>>>>>
>>>>> This series introduces .suspend() and .resume() firmware operations to
>>>>> perform low level firmware-specific suspend and resume and then
>>>>> leverages
>>>>> them to provide suspend-resume path meeting the above requirements.
>>>>> Three
>>>>> additional patches extend device tree sources of Trats2 board with
>>>>> necessary
>>>>> setup to enable suspend/resume support.
>>>>>
>>>>> This series has been tested on Exynos4412-based Trats2 board,
>>>>> without any
>>>>> additional patches. Unfortunately v3.17-rc1 regressed ODROID
>>>>> support and
>>>>> suspend stopped working on those boards, due to unknown reasons
>>>>> still being
>>>>> investigated. It does not seem to be related to anything in this
>>>>> series,
>>>>> though, so I would not consider this as a stopper.
>>>>>
>>>>> Changes since v2:
>>>>> (https://lkml.org/lkml/2014/7/17/431)
>>>>> - added board-specific fixes for device tree sources of Trats2 board,
>>>>> - rebased on next-20140826 of linux-next tree.
>>>>>
>>>>> Changes since v1:
>>>>> - dropped outer_resume() - will be handled in assembly in further
>>>>> patches,
>>>>> as support for L2C in non-secure mode gets added,
>>>>> - moved CP15 resume to assembly as it needs to be done before MMU
>>>>> is enabled,
>>>>> - surrounded CP15 save with a check for cpuid part, because it is
>>>>> valid only
>>>>> on Cortex A9,
>>>>> - rebased on next-20140717 tag of linux-next tree.
>>>>>
>>>>> Tomasz Figa (5):
>>>>> ARM: firmware: Introduce suspend and resume operations
>>>>> ARM: EXYNOS: Add support for firmware-assisted suspend/resume
>>>>> ARM: dts: exynos4412-trats2: Keep eMMC regulators soft-disabled
>>>>> ARM: dts: exynos4x12: Add utility macro to define pin sleep states
>>>>> ARM: dts: exynos4412-trats2: Add sleep mode pin configuration
>>>>>
>>>>> Documentation/arm/firmware.txt | 28 +--
>>>>> arch/arm/boot/dts/exynos4412-trats2.dts | 320
>>>>> +++++++++++++++++++++++++++++-
>>>>> arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 16 ++
>>>>> arch/arm/include/asm/firmware.h | 8 +
>>>>> arch/arm/mach-exynos/Makefile | 1 +
>>>>> arch/arm/mach-exynos/common.h | 4 +
>>>>> arch/arm/mach-exynos/firmware.c | 45 +++++
>>>>> arch/arm/mach-exynos/pm.c | 16 +-
>>>>> arch/arm/mach-exynos/sleep.S | 28 +++
>>>>> arch/arm/mach-exynos/smc.h | 4 +
>>>>> 10 files changed, 438 insertions(+), 32 deletions(-)
>>>>>
>>>>
>>>> Would you consider applying this series? It has been waiting on the ML
>>>> long enough (note no changes in core patches since last revision, just
>>>> few more board specific patches). Thanks in advance.
>>>>
>>> Sure, I will. Thanks for your gentle reminder.
>>>
>> I've reverted this series because of following.
>>
>> In file included from arch/arm/mach-tegra/cpuidle-tegra114.c:17:0:
>> arch/arm/mach-tegra/cpuidle-tegra114.c: In function
>> 'tegra114_idle_power_down':
>> arch/arm/include/asm/firmware.h:64:24: error: too few arguments to
>> function 'firmware_ops->do_idle'
>> ((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
>> ^
>> arch/arm/mach-tegra/cpuidle-tegra114.c:52:6: note: in expansion of
>> macro 'call_firmware_op'
>> if (call_firmware_op(do_idle) == -ENOSYS)
>> ^
>>
>> Caused by commit f5217f3b9332 ("ARM: EXYNOS: add AFTR mode support to
>> firmware do_idle method").
>>
>> Need to fix...
>
> I don't get why you have reverted the main feature of "Firmware-assisted
> suspend/resume
> of Exynos SoCs" because of an issue on the completely independent
> patchset which adds
> AFTR idle mode support. Could you please keep the "ARM: firmware:
> Introduce suspend
> and resume operations" and "ARM: EXYNOS: Add support for firmware-assisted
> suspend/resume" patches?
>
Hi Marek,

Yeah, as you said this series has no dependency and Bart's patches need 
to be fixed. I thought both should be handled together, so I reverted 
just the branch from my -next tree but the topic branch is there in my 
tree. Once it fixed, I will re-merge them.

Thanks,
Kukjin
