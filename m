Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbaGWTU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:20:57 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:45418 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735AbaGWTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140723190230.GH3935@laptop>
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
Date: Wed, 23 Jul 2014 12:20:55 -0700
X-Google-Sender-Auth: wvKm0kGepRx6mzm-WQJcqTXeH8c
Message-ID: <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
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

On Wed, Jul 23, 2014 at 12:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Here goes..

Oh. So this doesn't have CPUMASK_OFFSTACK set at all, so the pointer
has never been loaded from memory in the first place. The calculation
has been (for me) something like

        movq    $load_balance_mask, %rax
        add %gs:this_cpu_off, %rax

and then gcc is being stupid and saving it to the frame and reloading
it for no good reason (at least for me it *also* saved the value in
%rbx in order to save it into "env.cpus", and the stack spill seems to
be just moronic).

In Michel's oops, %rbx doesn't contain the pointer any more, though,
so he clearly does have a different compiler. His frame offsets are
rather different too ("-136(%rbp)" vs "-168(%rbp)") so looking at
whether possibly some stack frame got overwritten is clearly very
compiler-specific.

Michel, mind doing

    make kernel/sched/fair.s

and sending us the resulting file?

              Linus
