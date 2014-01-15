Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaAOKav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:30:51 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:47718 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOKat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140106183000.GG1096@mudshark.cambridge.arm.com>
References: <1388420732-13961-1-git-send-email-jean.pihet@linaro.org>
	<1388420732-13961-2-git-send-email-jean.pihet@linaro.org>
	<20140106183000.GG1096@mudshark.cambridge.arm.com>
Date: Wed, 15 Jan 2014 11:30:48 +0100
Message-ID: <CAFrcx1=ivcoNBTSBO47zs04Ji3XZza7pH3bVFS5M0-uZTg38RA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM64: perf: add support for perf registers API
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On 6 January 2014 19:30, Will Deacon <will.deacon@arm.com> wrote:
> Hi Jean,
>
> Thanks for the updated patches. One minor comment on this one.
>
> On Mon, Dec 30, 2013 at 04:25:30PM +0000, Jean Pihet wrote:
>> From: Jean Pihet <jean.pihet@newoldbits.com>
>>
>> This patch implements the functions required for the perf registers API,
>> allowing the perf tool to interface kernel register dumps with libunwind
>> in order to provide userspace backtracing.
>> Compat mode is also supported.
>
> [...]
>
>> +u64 perf_reg_value(struct pt_regs *regs, int idx)
>> +{
>> +     if (WARN_ON_ONCE((u32)idx >= PERF_REG_ARM64_MAX))
>> +             return 0;
>
> While this is probably fine, I'd feel more comfortable if you had separate
> limit checks for native and compat...
In fact in the native and compat modes the same set of registers are
accessed, based on the native regs that are registered to the perf
event core, cf. the definition of PERF_REGS_MASK in
tools/perf/arch/arm64/include/perf_regs.h.

The regs set could be registered differently based on the binary to
trace, but unfortunately the perf core code does not allow that.

I would leave the code as is, what do you think?

Cheers,
Jean

>
>> +     /*
>> +      * Compat (i.e. 32 bit) mode:
>> +      * - PC has been set in the pt_regs struct in kernel_entry,
>> +      * - Handle SP and LR here.
>> +      */
>> +     if (compat_user_mode(regs)) {
>
> i.e. have a WARN_ON_ONCE here for the compat structure size.
>
>> +             if ((u32)idx == PERF_REG_ARM64_SP)
>> +                     return regs->compat_sp;
>> +             if ((u32)idx == PERF_REG_ARM64_LR)
>> +                     return regs->compat_lr;
>> +     }
>
> then stick an else here with the original check.
>
> Make sense?
>
> Will
