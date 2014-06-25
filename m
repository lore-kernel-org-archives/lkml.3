Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaFYNDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:03:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37401 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752609AbaFYNDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:03:30 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "eric.auger\@linaro.org" <eric.auger@linaro.org>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
In-Reply-To: <CAL_JsqLbCeiB13ajNpVQDh_Lxgn37ixJ_jYkceps07mzz5su1g@mail.gmail.com>
	(Rob Herring's message of "Wed, 25 Jun 2014 13:50:12 +0100")
Organization: ARM Ltd
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
	<1403688530-23273-4-git-send-email-marc.zyngier@arm.com>
	<CAL_JsqLbCeiB13ajNpVQDh_Lxgn37ixJ_jYkceps07mzz5su1g@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 25 Jun 2014 14:03:16 +0100
Message-ID: <86oaxhjg4r.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25 2014 at 01:50:12 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Wed, Jun 25, 2014 at 4:28 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> So far, GICv2 has been used in with EOImode == 0. The effect of this
>> mode is to perform the priority drop and the deactivation of the
>> interrupt at the same time.
>>
>> While this works perfectly for Linux (we only have a single priority),
>> it causes issues when an interrupt is forwarded to a guest, and when
>> we want the guest to perform the EOI itself.
>>
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
> Why not fix-up the size so the feature can be enabled?

Is it a bet we're willing to take? We'd end-up with a kernel that
doesn't boot if the DT was actually right. If we stay with EOImode==0,
we can still boot (KVM will probably be broken though).

	M.
-- 
Jazz is not dead. It just smells funny.
