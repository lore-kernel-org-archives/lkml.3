Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaFJX51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:57:27 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47572 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaFJX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:57:25 -0400
Message-ID: <53979B52.5000902@gmail.com>
Date: Wed, 11 Jun 2014 01:57:06 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: EXYNOS: Fix the sequence of secondary CPU
 boot for Exynos3250
References: <1402442827-2321-1-git-send-email-cw00.choi@samsung.com> <5397963F.30109@gmail.com> <53979871.2020903@samsung.com>
In-Reply-To: <53979871.2020903@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.06.2014 01:44, Chanwoo Choi wrote:
> On 06/11/2014 08:35 AM, Tomasz Figa wrote:
>> Hi Chanwoo,
>>
>> On 11.06.2014 01:27, Chanwoo Choi wrote:
>>> This patch set AUTOWAKEUP_EN bit to ARM_CORE_CONFIGURATION register
>>> because Exynos3250 removes WFE in secure mode so that turn on automatically
>>> after setting CORE_LOCAL_PWR_EN. Also, This patch use dbs_sev() macro
>>> to guarantee the data synchronization of command instead of IPI_WAKEUP
>>> because Exynos3250 don't have WFE mode in secue mode.
>>>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  arch/arm/mach-exynos/platsmp.c  | 9 ++++++++-
>>>  arch/arm/mach-exynos/pm.c       | 8 ++++++--
>>>  arch/arm/mach-exynos/regs-pmu.h | 4 ++++
>>>  3 files changed, 18 insertions(+), 3 deletions(-)
>>>
>>
>> This patch seems to be unneeded with Krzysztof's patch send a while ago
>> [1]. As reported by Krzysztof, that patch apparently fixes SMP support
>> on Exynos3250 and is much smaller and less invasive.
>>
>> [1] - http://thread.gmane.org/gmane.linux.kernel.samsung-soc/32809
> 
> OK,
> But Krzysztof's patch didn't include set S5P_CORE_AUTOWAKEUP_EN in EXYNOS_ARM_CORE_CONFIGURATION(cpu).
> and then use arch_send_wakeup_ipi_mask(cpumask_of(cpu)) command instead of dsb_sev(). Exynos3250 don't need
> send IPI message.

I don't know technical details about CPU boot-up on Exynos3250 as I
haven't worked too much with this platform. According to my conversation
with Krzysztof, he found S5P_CORE_AUTOWAKEUP_EN and dsb_sev() to be not
needed. Instead S5P_CORE_WAKEUP_FROM_LOCAL_CFG can be set in
EXYNOS_ARM_CORE1_STATUS and then normal arch_send_wakeup_ipi_mask()
used. He might be able to provide more details.

> 
> I'll send next patch which include only S5P_CORE_AUTOWAKEUP_EN and without sending IPI message.

I believe Krzysztof was first with this kind of patch and I'd prefer his
approach as it introduces less changes. (First version posted on 15.05
[1], with my comments addressed in v2.)

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/31614

> 
> Krzysztof's patch used of_machine_is_compatible("samsung,exynos3250") instead of soc_is_exynos3250().
> Did you agree? If you agree to use of_machine_is_compatible(), I'll use it on next patch(v2).

IMHO, there is no significant difference between those two. Both are
bad, because they bind quirks to specific SoCs and it's hard to reuse
them for new ones - every time a quirk is reused by a new SoC, a new (||
soc_is_xxx() or || of_machine_is_compatible("xxx")) must be added.

Best regards,
Tomasz
