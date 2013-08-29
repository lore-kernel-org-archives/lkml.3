Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3H2H63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:58:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57832 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3H2H62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:58:28 -0400
Date: Thu, 29 Aug 2013 09:58:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
Message-ID: <20130829075818.GW10002@twins.programming.kicks-ass.net>
References: <20130828193457.140443630@linux.com>
 <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 07:48:14PM +0000, Christoph Lameter wrote:
> Transformations done to __get_cpu_var()
> 
> 
> 1. Determine the address of the percpu instance of the current processor.
> 
> 	DEFINE_PER_CPU(int, y);
> 	int *x = &__get_cpu_var(y);
> 
>     Converts to
> 
> 	int *x = this_cpu_ptr(&y);
> 
> 
> 2. Same as #1 but this time an array structure is involved.
> 
> 	DEFINE_PER_CPU(int, y[20]);
> 	int *x = __get_cpu_var(y);
> 
>     Converts to
> 
> 	int *x = this_cpu_ptr(y);
> 
> 
> 3. Retrieve the content of the current processors instance of a per cpu variable.
> 
> 	DEFINE_PER_CPU(int, u);
> 	int x = __get_cpu_var(y)
> 
>    Converts to
> 
> 	int x = __this_cpu_read(y);
> 

This looses a preemption debug check, so NAK

> 4. Retrieve the content of a percpu struct
> 
> 	DEFINE_PER_CPU(struct mystruct, y);
> 	struct mystruct x = __get_cpu_var(y);
> 
>    Converts to
> 
> 	memcpy(this_cpu_ptr(&x), y, sizeof(x));
> 
> 5. Assignment to a per cpu variable
> 
> 	DEFINE_PER_CPU(int, y)
> 	__get_cpu_var(y) = x;
> 
>    Converts to
> 
> 	this_cpu_write(y, x);
> 

This too looses a preemption debug check, NAK

> 6. Increment/Decrement etc of a per cpu variable
> 
> 	DEFINE_PER_CPU(int, y);
> 	__get_cpu_var(y)++
> 
>    Converts to
> 
> 	this_cpu_inc(y)
> 

Lo and behold.. no preemption checks again.


Seriously first fix the debug and validation bits of the *this_cpu*
stuff.
