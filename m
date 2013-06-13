Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab3FMWLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:11:22 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:61756 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab3FMWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:11:20 -0400
MIME-Version: 1.0
In-Reply-To: <51BA2FF4.6000604@zytor.com>
References: <1371149617-17880-1-git-send-email-yinghai@kernel.org>
	<51BA2FF4.6000604@zytor.com>
Date: Thu, 13 Jun 2013 15:11:20 -0700
X-Google-Sender-Auth: xC3WUrz6dQZMckAOq5eH0ETecWM
Message-ID: <CAE9FiQUbQg6aFA3CQWaB8bqaY0jN6mEOQ9x-3vw1H9cV3wO75w@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix /proc/mtrr with base/size more than 44bits
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 1:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/13/2013 11:53 AM, Yinghai Lu wrote:
>>
>> -     if (base & size_or_mask || size & size_or_mask) {
>> +     if (base >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT) ||
>> +         base > (base + size) ||
>> +         (base + size - 1) >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)) {
>>               pr_warning("mtrr: base or size exceeds the MTRR width\n");
>>               return -EINVAL;
>>       }
>
> Most of this patch looks good as far as being a minimal patch, but I'm
> really confused about this bit.  Could you explain the reason for why
> the original doesn't work?  (To be fair: I am not even sure the original
> does anything useful so it could just be a "this is just too broken to
> live" kind of thing.)

all because I update size_of_mask for old cpus that does not have
cpuid 80000008.
by make high 32bits to be all 1s. otherwise size = -mask trick will not work.

then check those range size_or_mask using, found that is not right.

as base and size could be all small, but base + size -1 could be big enough.
then the original will not detect that is out of boundary.

also we could even use x86_phys_bits directly.

>
> The first and third clause of the test can be simplified, however:
>
>         (base | (base + size - 1)) >> (boot_cpu_data.x86_phys_bits - PAGE_SHIFT)
>
> ... although it would be cleaner to put boot_cpu_data.x86_phys_bits -
> PAGE_SHIFT into a variable.

Yes.

also we can drop base > (base + size) checking, as
base and size are already shifted with PAGE_SHIFT to pfn.
so base+size can not be wrapped.

>
> A lot of the mask_hi/mask_lo stuff should just get removed by using
> rdmsrl/wrmsrl, but that is not stable material obviously.

yes.

will send updated version shortly.

Thanks

Yinghai
