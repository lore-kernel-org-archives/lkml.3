Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919AbaH0Pdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:33:53 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63176 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934998AbaH0Pdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <CALYGNiN-SHr6YJ53_deizb1VoXTBzD7dn8hcwqd4zLjx6utCDw@mail.gmail.com>
References: <20140722153623.25088.37742.stgit@buzz>
	<20140728181224.GN15536@arm.com>
	<CALYGNiNrK1d32ecz4rw0sgn0GyN-M6hTBuTLGQV53Z4Br-bpYQ@mail.gmail.com>
	<20140728184741.GT15536@arm.com>
	<CALYGNiOd+Dy-2q_woZ9UDbMO24q58jN1Nsq7E8cJMMg_YBK9pA@mail.gmail.com>
	<CABb+yY17Y18oAivi_VxPJqDEGLTbEy_PfsdeK9jXWZ0iV3vZ=w@mail.gmail.com>
	<CALYGNiN-SHr6YJ53_deizb1VoXTBzD7dn8hcwqd4zLjx6utCDw@mail.gmail.com>
Date: Wed, 27 Aug 2014 19:33:49 +0400
Message-ID: <CALYGNiP3J15OGBe2Kn7=0x+F5GnZ2LO4j6+7=RtS4WWT4Pyfzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: LPAE: load upper bits of early TTBR0/TTBR1
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:31 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> On Wed, Aug 27, 2014 at 7:26 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>> On Tue, Jul 29, 2014 at 5:59 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>>> On Mon, Jul 28, 2014 at 10:47 PM, Will Deacon <will.deacon@arm.com> wrote:
>>>> On Mon, Jul 28, 2014 at 07:40:58PM +0100, Konstantin Khlebnikov wrote:
>>>>> On Mon, Jul 28, 2014 at 10:12 PM, Will Deacon <will.deacon@arm.com> wrote:
>>>>> > On Tue, Jul 22, 2014 at 04:36:23PM +0100, Konstantin Khlebnikov wrote:
>>>>> >> This patch fixes booting when idmap pgd lays above 4gb. Commit
>>>>> >> 4756dcbfd37 mostly had fixed this, but it'd failed to load upper bits.
>>>>> >>
>>>>> >> Also this fixes adding TTBR1_OFFSET to TTRR1: if lower part overflows
>>>>> >> carry flag must be added to the upper part.
>>>>> >>
>>>>> >> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
>>>>> >> Cc: Cyril Chemparathy <cyril@ti.com>
>>>>> >> Cc: Vitaly Andrianov <vitalya@ti.com>
>>>>> >> ---
>>>>> >>  arch/arm/mm/proc-v7-3level.S |    7 +++----
>>>>> >>  1 file changed, 3 insertions(+), 4 deletions(-)
>>>>> >>
>>>>> >> diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
>>>>> >> index 22e3ad6..f0481dd 100644
>>>>> >> --- a/arch/arm/mm/proc-v7-3level.S
>>>>> >> +++ b/arch/arm/mm/proc-v7-3level.S
>>>>> >> @@ -140,12 +140,11 @@ ENDPROC(cpu_v7_set_pte_ext)
>>>>> >>       mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>>>>> >>       mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
>>>>> >>       addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
>>>>> >> -     mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
>>>>> >> +     adcls   \tmp, \tmp, #0
>>>>> >> +     mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
>>>>> >>       mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>>>>> >>       mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
>>>>> >> -     mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
>>>>> >> -     mcrr    p15, 1, \ttbr1, \zero, c2                       @ load TTBR1
>>>>> >> -     mcrr    p15, 0, \ttbr0, \zero, c2                       @ load TTBR0
>>>>> >> +     mcrr    p15, 0, \ttbr0, \tmp, c2                        @ load TTBR0
>>>>> >
>>>>> > I must admit, the code you are removing here looks really strange. Was there
>>>>> > a badly resolved conflict somewhere along the way? It would be nice to see
>>>>> > if your fix (which seems ok to me) was actually present in the mailing list
>>>>> > posting of the patch that ended in the above mess.
>>>>>
>>>>> Nope, no merge conflicts, source in original patch
>>>>> https://lkml.org/lkml/2012/9/11/346
>>>>>
>>>>> That mess completely harmless, this code is used only once on boot.
>>>>> I don't have that email, so replying isn't trivial for me.
>>>>
>>>> How bizarre. Also, Cyril doesn't work for TI anymore (his email is
>>>> bouncing), so it's tricky to know what he meant here.
>>>>
>>>> Your patch looks better than what we currently have though. Have you managed
>>>> to test it on a keystone platform (I don't have one)?
>>>
>>> No, I don't have it too. As well as I don't have direct access to the
>>> platform where
>>> problem was found. I've debugged this in patched qemu.
>>>
>> It seems the patch wasn't tested on any real platform, I did on my
>> CA15 based platform - it breaks boot. Simply reverting the patch gets
>> it going again. I am happy to try any fix.
>>
>
> Please try to remove adcls line.
> Seems like this affects only systems where PHYS_OFFSET == PAGE_OFFSET.
>
> --- a/arch/arm/mm/proc-v7-3level.S
> +++ b/arch/arm/mm/proc-v7-3level.S
> @@ -146,7 +146,6 @@ ENDPROC(cpu_v7_set_pte_ext)
>         mov     \tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>         mov     \ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT             @ lower bits
>         addls   \ttbr1, \ttbr1, #TTBR1_OFFSET
> -       adcls   \tmp, \tmp, #0
>         mcrr    p15, 1, \ttbr1, \tmp, c2                        @ load TTBR1
>         mov     \tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)        @ upper bits
>         mov     \ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT             @ lower bits
>
>

...
I've dropped cyril@ti.com from CC, his email address is dead.


>> Thanks
>> Jassi
