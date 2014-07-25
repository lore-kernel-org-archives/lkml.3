Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbaGYCg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 22:36:57 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63898 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196AbaGYCg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 22:36:56 -0400
MIME-Version: 1.0
In-Reply-To: <53D1B1EF.7030603@daenzer.net>
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
Date: Thu, 24 Jul 2014 22:36:54 -0400
Message-ID: <CAPDOMVhVBr7EoyvH+14QQO5S9Ch7o80QOwhM2HPLSG+5BTGnZA@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Nick Krause <xerofoify@gmail.com>
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 9:25 PM, Michel Dänzer <michel@daenzer.net> wrote:
> [ Adding the Debian kernel and gcc teams to Cc ]
>
> On 25.07.2014 03:47, Linus Torvalds wrote:
>> On Wed, Jul 23, 2014 at 6:43 PM, Michel Dänzer <michel@daenzer.net> wrote:
>>>>
>>>> Michel, mind doing
>>>>
>>>>     make kernel/sched/fair.s
>>>>
>>>> and sending us the resulting file?
>>>
>>> Here it is, gzipped, hope that's okay.
>>>
>>> Note that my tree is now based on 3.16-rc6.
>>
>> Ok, so I'm looking at the code generation and your compiler is pure
>> and utter *shit*.
>>
>> Adding Jakub to the cc, because gcc-4.9.0 seems to be terminally broken.
>>
>> Lookie here, your compiler does some absolutely insane things with the
>> spilling, including spilling a *constant*. For chrissake, that
>> compiler shouldn't have been allowed to graduate from kindergarten.
>> We're talking "sloth that was dropped on the head as a baby" level
>> retardation levels here:
>>
>>         ...
>>         movq    $load_balance_mask, -136(%rbp)  #, %sfp
>>         subq    $184, %rsp      #,
>>         movq    (%rdx), %rax    # sd_22(D)->parent, sd_parent
>>         movl    %edi, -144(%rbp)        # this_cpu, %sfp
>>         movl    %ecx, -140(%rbp)        # idle, %sfp
>>         movq    %r8, -200(%rbp) # continue_balancing, %sfp
>>         movq    %rax, -184(%rbp)        # sd_parent, %sfp
>>         movq    -136(%rbp), %rax        # %sfp, tcp_ptr__
>> #APP
>>         add %gs:this_cpu_off, %rax      # this_cpu_off, tcp_ptr__
>> #NO_APP
>>         ...
>>
>> Note the contents of -136(%rbp). Seriously. That's an
>> _immediate_constant_ that the compiler is spilling.
>>
>> Somebody needs to raise that as a gcc bug. Because it damn well is
>> some seriously crazy shit.
>>
>> However, that constant spilling part just counts as "too stupid to
>> live". The real bug is this:
>>
>>         movq    $load_balance_mask, -136(%rbp)  #, %sfp
>>         subq    $184, %rsp      #,
>>
>> where gcc creates the stack frame *after* having already used it to
>> save that constant *deep* below the stack frame.
>>
>> The x86-64 ABI specifies a 128-byte red-zone under the stack pointer,
>> and this is ok by that limit. It looks like it's illegal (136 > 128),
>> but the fact is, we've had four "pushq"s to update %rsp since loading
>> the frame pointer, so it's just *barely* legal with the red-zoning.
>>
>> But we build the kernel with -mno-red-zone. We do *not* follow the
>> x86-64 ABI wrt redzoning, because we *cannot*: interrupts while in
>> kernel mode *will* use the stack without a redzone. So that
>> "-mno-red-zone" is not some "optional guideline". It's a hard and
>> harsh requirement for the kernel, and gcc-4.9 is a buggy piece of shit
>> for ignoring it. And your bug happens becuase you happen to hit an
>> interrupt _just_ in that single instruction window (or perhaps hit
>> some other similar case and corrupted kernel data structures earlier).
>>
>> Now, I suspect that this redzoning bug might actually be related to
>> the fact that gcc is stupid in spilling a constant. I would not be
>> surprised if there is some liveness analysis going on to decide *when*
>> to insert the stack decrement, and constants are being ignored because
>> clearly liveness isn't an issue for a constant value. So the two bugs
>> ("stupid constant spilling" and "invalid use or red zone stack") go
>> hand in hand. But who knows.
>>
>> Anyway, this is not a kernel bug. This is your compiler creating
>> completely broken code. We may need to add a warning to make sure
>> nobody compiles with gcc-4.9.0, and the Debian people should probably
>> downgrate their shiny new compiler.
>
> Attached is fair.s from Debian gcc 4.8.3-5. Does that look better? I'm
> going to try reproducing the problem with a kernel built by that now.
>
>
> --
> Earthling Michel Dänzer                           http://www.amd.com
> Libre software enthusiast                      Mesa and X developer

Hey guys,
I am new so please bear with me here but I can build test this on
Ubuntu 14.04 with gcc 4.8.1.
I am wondering through after only speed reading these messages , if
you can just give me
a one line summary of what I need to be looking for :).
Nick
