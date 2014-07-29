Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaG2M3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:29:51 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:64705 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaG2M3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140728184741.GT15536@arm.com>
References: <20140722153623.25088.37742.stgit@buzz>
	<20140728181224.GN15536@arm.com>
	<CALYGNiNrK1d32ecz4rw0sgn0GyN-M6hTBuTLGQV53Z4Br-bpYQ@mail.gmail.com>
	<20140728184741.GT15536@arm.com>
Date: Tue, 29 Jul 2014 16:29:49 +0400
Message-ID: <CALYGNiOd+Dy-2q_woZ9UDbMO24q58jN1Nsq7E8cJMMg_YBK9pA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Cyril Chemparathy <cyril@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:47 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Jul 28, 2014 at 07:40:58PM +0100, Konstantin Khlebnikov wrote:
>> On Mon, Jul 28, 2014 at 10:12 PM, Will Deacon <will.deacon@arm.com> wrote:
>> > On Tue, Jul 22, 2014 at 04:36:23PM +0100, Konstantin Khlebnikov wrote:
>> >> This patch fixes booting when idmap pgd lays above 4gb. Commit
>> >> 4756dcbfd37 mostly had fixed this, but it'd failed to load upper bits.
>> >>
>> >> Also this fixes adding TTBR1_OFFSET to TTRR1: if lower part overflows
>> >> carry flag must be added to the upper part.
>> >>
>> >> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
>> >> Cc: Cyril Chemparathy <cyril@ti.com>
>> >> Cc: Vitaly Andrianov <vitalya@ti.com>
>> >> ---
>> >>  arch/arm/mm/proc-v7-3level.S |    7 +++----
>> >>  1 file changed, 3 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
>> >> index 22e3ad6..f0481dd 100644
>> >> --- a/arch/arm/mm/proc-v7-3level.S
>> >> +++ b/arch/arm/mm/proc-v7-3level.S
>> >> @@ -140,12 +140,11 @@ ENDPROC(cpu_v7_set_pte_ext)
>> >>       mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>> >>       mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
>> >>       addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
>> >> -     mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
>> >> +     adcls   \tmp, \tmp, #0
>> >> +     mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
>> >>       mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>> >>       mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
>> >> -     mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
>> >> -     mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
>> >> -     mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
>> >> +     mcrr    p15, 0, \ttbr0, \tmp, c2                        @ load TTBR0
>> >
>> > I must admit, the code you are removing here looks really strange. Was there
>> > a badly resolved conflict somewhere along the way? It would be nice to see
>> > if your fix (which seems ok to me) was actually present in the mailing list
>> > posting of the patch that ended in the above mess.
>>
>> Nope, no merge conflicts, source in original patch
>> https://lkml.org/lkml/2012/9/11/346
>>
>> That mess completely harmless, this code is used only once on boot.
>> I don't have that email, so replying isn't trivial for me.
>
> How bizarre. Also, Cyril doesn't work for TI anymore (his email is
> bouncing), so it's tricky to know what he meant here.
>
> Your patch looks better than what we currently have though. Have you managed
> to test it on a keystone platform (I don't have one)?

No, I don't have it too. As well as I don't have direct access to the
platform where
problem was found. I've debugged this in patched qemu.


Also this commit has wrong assumptions about idmap pgd address.
(at least in the commit message)

Probably suspend/resume path is affected too. I'll try to check it.

commit f3db3f4389dbd9a8c2b4477f37a6ebddfd670ad8
Author: Mahesh Sivasubramanian <msivasub@codeaurora.org>
Date:   Fri Nov 8 23:25:20 2013 +0100

    ARM: 7885/1: Save/Restore 64-bit TTBR registers on LPAE suspend/resume

    LPAE enabled kernels use the 64-bit version of TTBR0 and TTBR1
    registers. If we're running an LPAE kernel, fill the upper half
    of TTBR0 with 0 because we're setting it to the idmap here (the
    idmap is guaranteed to be < 4Gb) and fully restore TTBR1 instead
    of just restoring the lower 32 bits. Failure to do so can cause
    failures on resume from suspend when these registers are only
    half restored.

    Signed-off-by: Mahesh Sivasubramanian <msivasub@codeaurora.org>
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>


>
> Will
