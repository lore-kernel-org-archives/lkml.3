Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbaGXDnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:43:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45008 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934076AbaGXDnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:43:22 -0400
Date: Wed, 23 Jul 2014 20:43:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/16] rcu: Check for spurious wakeup using return value
Message-ID: <20140724034315.GJ11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-12-git-send-email-bobby.prani@gmail.com>
 <20140723122608.GL11241@linux.vnet.ibm.com>
 <CAJhHMCC7_GLmBroGhKWMJJKuWqhojQGf=9So1_x4nb2adQvqFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCC7_GLmBroGhKWMJJKuWqhojQGf=9So1_x4nb2adQvqFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072403-6688-0000-0000-00000384A9D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:36:19PM -0400, Pranith Kumar wrote:
> On Wed, Jul 23, 2014 at 8:26 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 23, 2014 at 01:09:48AM -0400, Pranith Kumar wrote:
> >> When the gp_kthread wakes up from the wait event, it returns 0 if the wake up is
> >> due to the condition having been met. This commit checks this return value
> >> for a spurious wake up before calling rcu_gp_init().
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >
> > How does this added check help?  I don't see that it does.  If the flag
> > is set, we want to wake up.  If we get a spurious wakeup, but then the
> > flag gets set before we actually wake up, we still want to wake up.
> 
> So I took a look at the docs again, and using the return value is the
> recommended way to check for spurious wakeups.
> 
> The condition in wait_event_interruptible() is checked when the task
> is woken up (either due to stray signals or explicitly) and it returns
> true if condition evaluates to true.
> 
> In the current scenario, if we get a spurious wakeup, we take the
> costly path of checking this condition again (with a barrier and lock)
> before going back to wait.
> 
> The scenario of getting an actual wakeup after getting a spurious
> wakeup exists even today, this is the window after detecting a
> spurious wakeup and before going back to wait. I am not sure if using
> the return value enlarges that window as we are going back to sleep
> immediately.
> 
> Thoughts?

If the flag is set, why should we care whether or not the wakeup was
spurious?  If the flag is not set, why should we care whether or not
wait_event_interruptible() thought that the wakeup was not spurious?

							Thanx, Paul

