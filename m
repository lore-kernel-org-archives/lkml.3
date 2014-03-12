Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaCLQSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:18:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:43743 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755224AbaCLQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:18:16 -0400
Date: Wed, 12 Mar 2014 12:18:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140312121813.1e0102aa@gandalf.local.home>
In-Reply-To: <437054772.1403.1394640336308.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
	<20140311114023.02fcf639@gandalf.local.home>
	<1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
	<20140311151357.077c5a68@gandalf.local.home>
	<1501695915.977.1394634294978.JavaMail.zimbra@efficios.com>
	<20140312111100.42ea41c2@gandalf.local.home>
	<20140312114611.43547df7@gandalf.local.home>
	<437054772.1403.1394640336308.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 16:05:36 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> > Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> > <johannes.berg@intel.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Peter Zijlstra"
> > <peterz@infradead.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> > "lttng-dev" <lttng-dev@lists.lttng.org>, "Rusty Russell" <rusty@rustcorp.com.au>
> > Sent: Wednesday, March 12, 2014 11:46:11 AM
> > Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> > 
> > 
> > To sum up this thread, and get the signal vs noise ratio up.
> > 
> > On Wed, 12 Mar 2014 11:11:00 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > 
> > > The solution I like the most that I believe will work for both of us,
> > > is to to move this magic "enable tracepoint in the future" to your
> > > LTTng module. Have your module register a module load and unload handler
> > > to be able to see the tracepoints that exist in the module, and you can
> > > enable them then. When a module is unloaded, your module can do the
> > > accounting to record that, and the state of its tracepoints.
> > 
> > This is my final proposal.
> > 
> > I'll add the patch that removes the tracepoint on failure along with
> > returning -ENODEV. That way, there will be no registered tracepoints
> > that do not exist.
> > 
> > I'll also make sure that on module unload, the tracepoints are disabled
> > for the module as well.
> 
> Do you mean that the tracepoint probe will be unregistered from within
> tracepoint.c whenever all modules containing tracepoint call sites are
> unloaded ? If so, how do you plan to handle ownership of the "name",
> "probe" and "data" pointer ? They belong to the tracer. Would they simply
> leak ?

Are you telling me it's not possible to delete the entire probe?

What I'm proposing is to do what the trace events do. Delete everything
associated to the tracepoints associated to the module.

> 
> > 
> > Then, you can simply add a module notifier that does the work that you
> > like, and save and restore the state of named tracepoints and enabled
> > them on module load. Just set the priority of the notifier to 1
> > so that it runs after the tracepoint notifier that adds the new
> > tracepoints to the system.
> 
> I don't mind the extra work on the LTTng side at all. What I am concerned
> about are changes that would make the tracepoint API sloppy.

I believe they are currently sloppy.

-- Steve
