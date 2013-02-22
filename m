Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3BVOPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:15:35 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51130 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3BVOPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:15:32 -0500
Date: Fri, 22 Feb 2013 15:15:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Message-ID: <20130222141526.GB18149@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361522767.26780.44.camel@laptop>
 <20130222125019.GC17948@somewhere.redhat.com>
 <1361541939.26780.63.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361541939.26780.63.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 03:05:39PM +0100, Peter Zijlstra wrote:
> On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> > > Which is a problem how?
> > 
> > So here is a possible scenario, CPU 0 reads a kcpustat value, and CPU
> > 1 writes
> > it at the same time:
> > 
> >     //Initial value of "cpustat" is 0xffffffff
> >          == CPU 0 ==           == CPU 1 ==
> > 
> >        //load low part
> >        mov %eax, [cpustat]
> >                              inc [cpustat]
> >                              //Update the high part if necessary
> >                              jnc 1f
> >                              inc [cpustat + 4]
> >                              1:
> >        //load high part
> >        mov %edx, [cpustat + 4]
> > 
> > 
> > Afterward, CPU 0 will think the value is 0x1ffffffff while it's
> > actually
> > 0x100000000.
> > 
> > atomic64_read() and atomic64_set() are supposed to take care of that,
> > without
> > even the need for _inc() or _add() parts that use LOCK.
> 
> 
> Sure I get that, but again, why is that a problem,.. who relies on
> these statistics that makes it a problem?

I guess we want to provide at least some minimal reliability in /proc/stat
I mean we don't mind if the read is slightly off, reading stats from userspace
is inherently racy anyway, but if it suddenly shows a wrong increase of 4 billions
which disappear soon after, it looks like a bug to me.
