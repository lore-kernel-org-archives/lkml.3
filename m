Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbaGYEAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 00:00:41 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58482 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaGYEAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 00:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140725035527.GA30108@pg-vmw-gw1>
References: <CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
	<20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
	<20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
Date: Fri, 25 Jul 2014 00:00:39 -0400
Message-ID: <CAPDOMVg2izY4VefLQg2uomvkUg=4VmYh8TZ-6v1cTqCLtJC98w@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Nick Krause <xerofoify@gmail.com>
To: Alexei Starovoitov <ast@kernel.org>
Cc: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:55 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> On Fri, Jul 25, 2014 at 10:25:03AM +0900, Michel Dänzer wrote:
>> [ Adding the Debian kernel and gcc teams to Cc ]
>>
>> >         movq    $load_balance_mask, -136(%rbp)  #, %sfp
>> >         subq    $184, %rsp      #,
>> >
>> > Anyway, this is not a kernel bug. This is your compiler creating
>> > completely broken code. We may need to add a warning to make sure
>> > nobody compiles with gcc-4.9.0, and the Debian people should probably
>> > downgrate their shiny new compiler.
>>
>> Attached is fair.s from Debian gcc 4.8.3-5. Does that look better? I'm
>> going to try reproducing the problem with a kernel built by that now.
>
> 4.8 and 4.7 don't hit the problem on this test.
> 4.9 with -O2 compiles this file ok. 4.9 with -Os triggers it.
>
> -mno-red-zone only affected prologue emition in gcc. This part didn't
> change between the releases. So the bug is quite deep.
> What seems to be happening is that 2nd pass of instruction scheduler
> (after emit prologue and reg alloc) is ignoring barrier properties
> of 'subq $184, %rsp' and moving 'movq $.., -136(%rbp)' instruction
> ahead of it. afaik rtl sched was never aware of 'red-zone'.
> As an ex-compiler guy, I'm worried that this bug exists in earlier
> releases. rtl backend guys need to take a serious look at it.
> imo this is very serious bug, since broken red-zone is extremelly
> hard to debug.
> There are two weak test in gcc testsuite related to -mno-red-zone,
> but not a single test that actually check that it is doing
> the right thing. It is scary. I hope I'm wrong with this analysis.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Alexi,
Thanks for replying and sending this email to the Debian developers,
seems to me a very serious issue with gcc. I don't known much about
compilers but I trust your experience here.
Nick
