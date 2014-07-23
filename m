Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086AbaGWSfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:35:10 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:38319 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbaGWSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:35:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140723182518.GD3935@laptop>
References: <53CF844A.5050106@arm.com>
	<20140723111110.GT3935@laptop>
	<20140723113021.GP12054@laptop.lan>
	<20140723142454.GQ12054@laptop.lan>
	<CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
	<20140723155526.GW3935@laptop>
	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
	<20140723170324.GZ3935@laptop>
	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
	<CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
	<20140723182518.GD3935@laptop>
Date: Wed, 23 Jul 2014 11:35:06 -0700
X-Google-Sender-Auth: rsQVOudldHoWMFLU_aVO-J_Pqqw
Message-ID: <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 23, 2014 at 10:26:21AM -0700, Linus Torvalds wrote:
>>
>> The whole - and really *only* - point of __get_cpu_var is to get the
>> address of a a cpu variable. If you want to read the *value* of the
>> variable, you should use "this_cpu_read()", which can use things like
>> special instructions or segments to read the percpu area.
>
> I think this code predates all the this_cpu* magic. But yes, agreed.

It turns out - now that I've stared at the code for much too long for
my own sanity - that this code actually depends very subtly on
"__get_cpu_var()".

And not in good ways.

So what happens is that the games that "cpumask_var_t" plays in order
to make code work correctly with both on-stack and off-stack
configurations are really toxic to good per-cpu use.

For the off-stack case, a cpumask_var_t is a pointer to the real
allocation, and using "__get_cpu_var()" is very suboptimal, because it
gets that pointer by following the percpu offset explicitly. So we
load the percpu offset, then we load the offset to "load_balance_mask"
within that, and then we load the pointer off that. We'd be much
better off using "this_cpu_read()", which can just use the percpu area
directly to read the pointer.

HOWEVER.

For the direct case, a "cpumask_var_t" is an array, exactly so that
accessing it will just return the address of it, so that you can get
the "struct cpumask *" directly.  And there the whole dance with
adding the percpu offset is actually the right thing, because what you
want is the address to the percpu area. And you cannot use
"this_cpu_read()", because that wants to read the _value_, which is
not what we want at all.

Ugh. So it's not just the initialization that is subtle, the use of
those per-cpu "cpumask_var_t" is sadly suboptimal too.

But the code does appear to be correct. It just is messy, avoids the
proper abstractions, and generates suboptimal code for the off-stack
case.

               Linus
