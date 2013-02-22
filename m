Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3BVOFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:05:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36030 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3BVOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:05:44 -0500
Message-ID: <1361541939.26780.63.camel@laptop>
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Date: Fri, 22 Feb 2013 15:05:39 +0100
In-Reply-To: <20130222125019.GC17948@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	 <1361522767.26780.44.camel@laptop>
	 <20130222125019.GC17948@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> > Which is a problem how?
> 
> So here is a possible scenario, CPU 0 reads a kcpustat value, and CPU
> 1 writes
> it at the same time:
> 
>     //Initial value of "cpustat" is 0xffffffff
>          == CPU 0 ==           == CPU 1 ==
> 
>        //load low part
>        mov %eax, [cpustat]
>                              inc [cpustat]
>                              //Update the high part if necessary
>                              jnc 1f
>                              inc [cpustat + 4]
>                              1:
>        //load high part
>        mov %edx, [cpustat + 4]
> 
> 
> Afterward, CPU 0 will think the value is 0x1ffffffff while it's
> actually
> 0x100000000.
> 
> atomic64_read() and atomic64_set() are supposed to take care of that,
> without
> even the need for _inc() or _add() parts that use LOCK.


Sure I get that, but again, why is that a problem,.. who relies on
these statistics that makes it a problem?

