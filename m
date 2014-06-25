Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaFYOq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:46:56 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:18217 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756294AbaFYOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:46:55 -0400
Message-ID: <53AAE0D3.8030008@arm.com>
Date: Wed, 25 Jun 2014 15:46:43 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Maydell <peter.maydell@linaro.org>
CC: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <1403688530-23273-4-git-send-email-marc.zyngier@arm.com> <CAFEAcA_naeGVc+Rsec=Ds6Lzf345nzFj3Wg2RWY-6LWYv3euNQ@mail.gmail.com>
In-Reply-To: <CAFEAcA_naeGVc+Rsec=Ds6Lzf345nzFj3Wg2RWY-6LWYv3euNQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/14 15:06, Peter Maydell wrote:
> On 25 June 2014 10:28, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> For this case, the GIC architecture provides EOImode == 1, where:
>> - A write to the EOI register drops the priority of the interrupt and leaves
>> it active. Other interrupts at the same priority level can now be taken,
>> but the active interrupt cannot be taken again
>> - A write to the DIR marks the interrupt as inactive, meaning it can
>> now be taken again.
>>
>> We only enable this feature when booted in HYP mode. Also, as most device
>> trees are broken (they report the CPU interface size to be 4kB, while
>> the GICv2 CPU interface size is 8kB), output a warning if we're booted
>> in HYP mode, and disable the feature.
> 
> Does that mean you guarantee not to write to the DEACTIVATE register
> if not booted in Hyp mode? I ask because QEMU's GIC emulation doesn't
> emulate that register, so it would be useful to know if this patch
> means newer kernels are going to fall over under TCG QEMU...

So far, I only plan to support it when booted in HYP. But it may be that
the split prio-drop/deactivate is also beneficial to threaded
interrupts, saving the writes to the distributor to mask/unmask. That
would require to be a bit more subtle in identifying a GICv2
implementation (DT binding, probably).

	M.
-- 
Jazz is not dead. It just smells funny...
