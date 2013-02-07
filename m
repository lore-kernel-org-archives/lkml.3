Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab3BGKn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:43:28 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:64941 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3BGKn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:43:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAFbHwiTCN5sFadXX7z7Smwd17tEZ7WmfKhG_6b3psu0bx228ew@mail.gmail.com>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
 <20130129083522.GA14302@pd.tnic> <1359478014.3529.157.camel@shinybook.infradead.org>
 <20130129174249.GB25415@pd.tnic> <1359482147.3529.161.camel@shinybook.infradead.org>
 <20130129181046.GC25415@pd.tnic> <1359541333.3529.186.camel@shinybook.infradead.org>
 <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com> <20130131092801.GV23505@n2100.arm.linux.org.uk>
 <20130131145947.f62474a0600848df86548b96@freescale.com> <20130201011712.GF23505@n2100.arm.linux.org.uk>
 <1359703995.23531.6.camel@shinybook.infradead.org> <20130205210436.670c62e26d2121330e87af35@freescale.com>
 <1360141322.6066.4.camel@shinybook.infradead.org> <20130206191905.ac8eb6743e69425f30888704@freescale.com>
 <CAFbHwiTCN5sFadXX7z7Smwd17tEZ7WmfKhG_6b3psu0bx228ew@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 7 Feb 2013 10:43:03 +0000
X-Google-Sender-Auth: V-84yOVBWk4y0-fTEbHiL2YRCm8
Message-ID: <CAHkRjk4P4C_5c39ftBeGs9X+vWoKJi6Yx3B=_b5iOcc771bRiA@mail.gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
To: Will Newton <will.newton@gmail.com>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 February 2013 10:19, Will Newton <will.newton@gmail.com> wrote:
> On Thu, Feb 7, 2013 at 1:19 AM, Kim Phillips <kim.phillips@freescale.com> wrote:
>> On Wed, 6 Feb 2013 09:02:04 +0000
>> "Woodhouse, David" <david.woodhouse@intel.com> wrote:
>>
>>> On Tue, 2013-02-05 at 21:04 -0600, Kim Phillips wrote:
>>> > gcc -Os emits calls to __bswapsi2 on those platforms to save space
>>> > because they don't have the single rev byte swap instruction.
>>>
>>> Is that the right thing for GCC to do in that situation?
>>
>> if it saves space, why wouldn't it be?
>>
>> "Many of these functions are only optimized in certain cases; if they
>> are not optimized in a particular case, a call to the library
>> function is emitted." [1]
>>
>> I see "(arm_arch6 || !optimize_size)" in gcc's define_expand
>> "bswapsi2" source, so GCC considers size optimization as a
>> legitimate one of those cases.
>>
>>> If so, perhaps we should be *providing* __bswap[sd]i2 functions for it
>>> to use?
>>
>> either that, or link with libgcc - why does arch/arm64 do this and
>> arch/arm not?  It's not obvious from git log.
>
> One reason I have found, I don't know if it is the canonical one, is
> that linking with libgcc allows people to use all intrinsics e.g. soft
> float routines in the kernel without noticing it. If you limit the
> intrinsics to the ones linked into the kernel explicitly then this
> cannot happen.

For arm64 we explicitly pass -mgeneral-regs-only to avoid any floating
point generation. Soft-float is excluded by the ABI automatically. But
we use other compiler intrinsics like __ffs and while they are
currently generated inline, you can't guarantee, hence the linking
with libgcc.

> I have also seen cases where the libgcc intrinsics are improved over
> time, having the code in the kernel allows these improvements to be
> rolled into the kernel even if the user has an older toolchain.

Indeed, the gcc guys do a lot benchmarking/optimisations on a wide
range of processors, so we can take advantage of that in the kernel.
But it's much easier on arm64 since the architecture is stable. On
32-bit arm we have to cope with a range of architecture versions with
variations to the instruction set.

-- 
Catalin
