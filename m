Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbaGWSZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:25:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaGWSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:25:28 -0400
Date: Wed, 23 Jul 2014 20:25:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723182518.GD3935@laptop>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:26:21AM -0700, Linus Torvalds wrote:
> On Wed, Jul 23, 2014 at 10:12 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > sched_init() definitely does _not_ allocate a cpumask_var.
> 
> Side note: another good rule of thumb for per-cpu variables is:
> 
>  - if you use __get_cpu_var() without taking the address of it, you're
> doing something wrong and stupid.
> 
> The whole - and really *only* - point of __get_cpu_var is to get the
> address of a a cpu variable. If you want to read the *value* of the
> variable, you should use "this_cpu_read()", which can use things like
> special instructions or segments to read the percpu area.

I think this code predates all the this_cpu* magic. But yes, agreed.

> I agree that the interface is not all that great, there's historical
> baggage there. We would have been better off with
> "__this_cpu_ptr(var)" instead of "&__get_cpu_var(var)". But that
> "__get_cpu_var()" is the old way of doing things (predating the new
> and better "this_cpu_read/write/ops()" stuff), which is why we have
> that odd interface with "&__get_cpu_var()".

I think there's a whole bunch of patches by Christoph Lameter, queued by
TJ that remove all __get_cpu_var usage and eventually the interface.
