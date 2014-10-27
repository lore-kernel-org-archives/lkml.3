Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaJ0Tuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:50:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37338 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaJ0Tuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:50:44 -0400
Message-ID: <544EA212.7030401@codeaurora.org>
Date: Mon, 27 Oct 2014 12:50:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: vfp: Fix VFPv3 hwcap detection on CPUID based
 cpus
References: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org> <1413294539-22069-3-git-send-email-sboyd@codeaurora.org> <20141027103118.GA8768@arm.com>
In-Reply-To: <20141027103118.GA8768@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 03:31 AM, Will Deacon wrote:
> Hi Stephen,
>
> On Tue, Oct 14, 2014 at 02:48:58PM +0100, Stephen Boyd wrote:
>> The subarchitecture field in the fpsid register is 7 bits wide on
>> ARM CPUs using the CPUID identification scheme, spanning bits 22
>> to 16. The topmost bit is used to designate that the
>> subarchitecture designer is not ARM when it is set to 1. On
>> non-CPUID scheme CPUs the subarchitecture field is only 4 bits
>> wide and the higher bits are used to indicate no double precision
>> support (bit 20) and the FTSMX/FLDMX format (bits 21-22).
>>
>> The VFP support code only looks at bits 19-16 to determine the
>> VFP version. On Qualcomm's processors (Krait and Scorpion) we
>> should see that we have HWCAP_VFPv3 but we don't because bit 22
>> is set to 1 to indicate that the subarchitecture is not
>> implemented by ARM and the rest of the bits are left as 0 because
>> this is the first subarchitecture that Qualcomm has designed.
>> Unfortunately we can't just widen the FPSID subarchitecture
>> bitmask to consider all the bits on a CPUID scheme because there
>> may be CPUs without the CPUID scheme that have VFP without double
>> precision support and then the version would be a very wrong and
>> large number. Instead, update the version detection logic to
>> consider if the CPU is using the CPUID scheme.
>>
>> If the CPU is using CPUID scheme, use the MVFR registers to
>> determine what version of VFP is supported. We already do this
>> for VFPv4, so do something similar for VFPv3 and look for single
>> or double precision support in MVFR0. Otherwise fall back to
>> using FPSID to detect VFP suppport on non-CPUID scheme CPUs. We
>> know that VFPv3 is only present in CPUs that have support for the
>> CPUID scheme so this should be equivalent.
> This looks correct to me, but it raises a bigger question about the
> suitability of hwcaps for describing features of the instruction set.

Great. Can I get your reviewed-by on this patch please?

>
> With the extended CPUID scheme, there are a whole bunch of different
> instruction set features that are reported and bundling arbitrary subsets of
> them into hwcaps such as `VFPv4' doesn't feel like the right thing to do in
> the long run. It also doesn't seem to match where the architecture is going.
>
> Perhaps it would be better to consider exposing the ID registers to
> userspace in some manner? This could be done either via an undef handler, or
> using the vdso. We would add a (final) hwcap advertising this cpuid support.
> For big/little systems, the kernel would need to expose a suitable subset of
> the features (we already have the sanity checking code from Rutland).
>
> I'd certainly like to explore that route for arm64, before we start adding a
> bunch of fine-grained capabilities.

I have an RFC for the undef handler written up, except for the
big/little thing. Let me post it. Is there anyone from the userspace
side that can be on Cc?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

