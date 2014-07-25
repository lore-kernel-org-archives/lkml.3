Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbaGYCuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:50:22 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52758 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758886AbaGYCuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:50:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyHbtsrhnr9Xb8JnFfrq=0Bobb=Q819dCjMwA4apwootQ@mail.gmail.com>
References: <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
	<20140723155526.GW3935@laptop>
	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
	<20140723170324.GZ3935@laptop>
	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
	<CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
	<20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
	<20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<CA+55aFyHbtsrhnr9Xb8JnFfrq=0Bobb=Q819dCjMwA4apwootQ@mail.gmail.com>
Date: Thu, 24 Jul 2014 22:50:19 -0400
Message-ID: <CAPDOMViUrYWj_26sUbougDvWFpeOaMQc3_Po3ewHhrQYbJ6U5A@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Nick Krause <xerofoify@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jul 24, 2014 at 6:25 PM, Michel Dänzer <michel@daenzer.net> wrote:
>>
>> Attached is fair.s from Debian gcc 4.8.3-5. Does that look better? I'm
>> going to try reproducing the problem with a kernel built by that now.
>
> This looks better. For roughly that same code sequence it does
> (ignoring the debug line and cfi information):
>
>         subq    $184, %rsp      #,
>         movq    (%r12), %rax    # sd_22(D)->parent, sd_parent
>         movl    %edi, -156(%rbp)        # this_cpu, %sfp
>         movl    %ecx, -160(%rbp)        # idle, %sfp
>         movq    %r8, -184(%rbp) # continue_balancing, %sfp
>         movq    %rax, -176(%rbp)        # sd_parent, %sfp
>         movq    $load_balance_mask, %rax        #, tcp_ptr__
> #APP
>         add %gs:this_cpu_off, %rax      # this_cpu_off, tcp_ptr__
> #NO_APP
>
> so it updates the stack pointer before any spills, and it also doesn't
> spill that constant value.
>
> I still have no idea why it does the 4-byte rep stosl/movsl thing, but
> that's a whole separate guessing game and might have something to do
> with the fact that you do CONFIG_CC_OPTIMIZE_FOR_SIZE and the 4-byte
> form is one byte smaller.
>
> I'm a big believer in not blowing up the I$ footprint, and I have to
> admit to pushing that myself a few years ago, but gcc does some rather
> bad things with '-Os', so it's not actually suggested for the kernel
> any more. I wish there was some middle ground model that cared about
> size, but not to exclusion of everything else. The string instructions
> are not good for performance when it's a compile-time known small
> size.
>
>                  Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Seems better after looking at it too, seems I don't need to test this and this
bug is in gcc 4.9 related versions.
Cheers Nick
