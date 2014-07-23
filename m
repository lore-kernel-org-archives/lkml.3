Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbaGWR0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:26:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65469 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGWR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:26:23 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
References: <20140723082819.GR3935@laptop>
	<20140723092536.GO12054@laptop.lan>
	<53CF80EE.5050702@daenzer.net>
	<53CF844A.5050106@arm.com>
	<20140723111110.GT3935@laptop>
	<20140723113021.GP12054@laptop.lan>
	<20140723142454.GQ12054@laptop.lan>
	<CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
	<20140723155526.GW3935@laptop>
	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
	<20140723170324.GZ3935@laptop>
	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
Date: Wed, 23 Jul 2014 10:26:21 -0700
X-Google-Sender-Auth: D0jx-LvIQStOkD6DwuYaCzi0uOc
Message-ID: <CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
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

On Wed, Jul 23, 2014 at 10:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> sched_init() definitely does _not_ allocate a cpumask_var.

Side note: another good rule of thumb for per-cpu variables is:

 - if you use __get_cpu_var() without taking the address of it, you're
doing something wrong and stupid.

The whole - and really *only* - point of __get_cpu_var is to get the
address of a a cpu variable. If you want to read the *value* of the
variable, you should use "this_cpu_read()", which can use things like
special instructions or segments to read the percpu area.

I agree that the interface is not all that great, there's historical
baggage there. We would have been better off with
"__this_cpu_ptr(var)" instead of "&__get_cpu_var(var)". But that
"__get_cpu_var()" is the old way of doing things (predating the new
and better "this_cpu_read/write/ops()" stuff), which is why we have
that odd interface with "&__get_cpu_var()".

           Linus
