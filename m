Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3LRQYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:24:30 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61571 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3LRQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:24:29 -0500
Date: Wed, 18 Dec 2013 17:24:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 03/13] rcu: Exclude all potential timekeepers from
 sysidle detection
Message-ID: <20131218162415.GA19283@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-4-git-send-email-fweisbec@gmail.com>
 <20131217232714.GD19211@linux.vnet.ibm.com>
 <20131217234913.GB18689@localhost.localdomain>
 <20131218114318.GR13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218114318.GR13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:43:18PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 18, 2013 at 12:49:15AM +0100, Frederic Weisbecker wrote:
> > That's to start simple as CPU 0 can't be offlined.
> 
> Yes it can, see CONFIG_BOOTPARAM_HOTPLUG_CPU0

Yeah it can but the tick hotplug callback prevent that to happen on nohz full.
You can check out tick_nohz_cpu_down_callback() for details.

I agree that rejecting CPU_DOWN_PREPARE requests is propably not the prettiest
thing ever but that's the only solution that we have now.

There must _always_ be a timekeeper to maintain timekeeping duty as long
as there are full dynticks CPUs around. So one of these potential timekeepers has
to stay online. And CPU 0 is quite a handy candidate since rejecting any
other CPU's offlining request may block suspend.

Now if it happens to be annoying for some reason, we can certainly change that
behaviour in the future. This will involve forcing some full dynticks CPU to
carry timekeeping but heh, if user does silly things :)
