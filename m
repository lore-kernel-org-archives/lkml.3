Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbaJ3N6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:58:03 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:50944 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871AbaJ3N6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:58:00 -0400
Date: Thu, 30 Oct 2014 13:57:49 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC V5 3/3] arm64:add bitrev.h file to support rbit instruction
Message-ID: <20141030135749.GE32589@arm.com>
References: <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:26:42PM +0000, Ard Biesheuvel wrote:
> On 30 October 2014 13:01, Will Deacon <will.deacon@arm.com> wrote:
> > On Wed, Oct 29, 2014 at 05:52:00AM +0000, Wang, Yalin wrote:
> >> This patch add bitrev.h file to support rbit instruction,
> >> so that we can do bitrev operation by hardware.
> >> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> >> ---
> >>  arch/arm64/Kconfig              |  1 +
> >>  arch/arm64/include/asm/bitrev.h | 28 ++++++++++++++++++++++++++++
> >>  2 files changed, 29 insertions(+)
> >>  create mode 100644 arch/arm64/include/asm/bitrev.h
> >>
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> index 9532f8d..b1ec1dd 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -35,6 +35,7 @@ config ARM64
> >>       select HANDLE_DOMAIN_IRQ
> >>       select HARDIRQS_SW_RESEND
> >>       select HAVE_ARCH_AUDITSYSCALL
> >> +     select HAVE_ARCH_BITREVERSE
> >>       select HAVE_ARCH_JUMP_LABEL
> >>       select HAVE_ARCH_KGDB
> >>       select HAVE_ARCH_TRACEHOOK
> >> diff --git a/arch/arm64/include/asm/bitrev.h b/arch/arm64/include/asm/bitrev.h
> >> new file mode 100644
> >> index 0000000..292a5de
> >> --- /dev/null
> >> +++ b/arch/arm64/include/asm/bitrev.h
> >> @@ -0,0 +1,28 @@
> >> +#ifndef __ASM_ARM64_BITREV_H
> >> +#define __ASM_ARM64_BITREV_H
> >> +
> >> +static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
> >> +{
> >> +     if (__builtin_constant_p(x)) {
> >> +             x = (x >> 16) | (x << 16);
> >> +             x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8);
> >> +             x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4);
> >> +             x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2);
> >> +             return ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1);
> >
> > Shouldn't this part be in the generic code?
> >
> >> +     }
> >> +     __asm__ ("rbit %w0, %w1" : "=r" (x) : "r" (x));
> >
> > You can write this more neatly as:
> >
> >   asm ("rbit %w0, %w0" : "+r" (x));
> >
> 
> This forces GCC to use the same register as input and output, which
> doesn't necessarily result in the fastest code. (e.g., if the
> un-bitrev()'ed value is reused again afterwards).
> On the other hand, the original notation does allow GCC to use the
> same register, but doesn't force it to, so I prefer the original one.

That's a good point, especially since this is __always_inline.

Will
