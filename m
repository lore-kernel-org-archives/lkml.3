Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbaFYOIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:08:49 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:54357 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbaFYOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
 <1403688530-23273-4-git-send-email-marc.zyngier@arm.com> <CAAhSdy11HQtiOD6XLqQcZ+zf_Z9Mx0nPrJ0ECNNuRkZt=CfdpA@mail.gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 25 Jun 2014 09:08:27 -0500
Message-ID: <CAL_JsqL+L-pDr=ENJDj3Um_iMeYNmisd=BMW=SR8tie-_qDeeA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/9] irqchip: GIC: Convert to EOImode == 1
To: Anup Patel <anup@brainfault.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 8:56 AM, Anup Patel <anup@brainfault.org> wrote:
> Hi Marc,
>
> On Wed, Jun 25, 2014 at 2:58 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
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
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---

[...]

>> +               if (resource_size(&cpu_res) >= SZ_8K)
>> +                       supports_deactivate = true;
>> +               else
>> +                       pr_warn("GIC: CPU interface size is %x, DT is probably wrong\n", (int)resource_size(&cpu_res));
>
> This will not work on APM X-Gene because, for
> X-Gene first CPU page is at 0x78020000 and
> second CPU page is at 0x78030000.

Does 0x7802f000 for the cpu address not work? It should if X-Gene is
"SBSA compliant" for whatever that is worth.

Rob
