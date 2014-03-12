Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaCLQFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:05:36 -0400
Received: from mail.efficios.com ([78.47.125.74]:50762 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbaCLQFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:05:35 -0400
Date: Wed, 12 Mar 2014 16:05:36 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <437054772.1403.1394640336308.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140312114611.43547df7@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <1448078225.73.1394550382164.JavaMail.zimbra@efficios.com> <20140311114023.02fcf639@gandalf.local.home> <1752080128.130.1394559263621.JavaMail.zimbra@efficios.com> <20140311151357.077c5a68@gandalf.local.home> <1501695915.977.1394634294978.JavaMail.zimbra@efficios.com> <20140312111100.42ea41c2@gandalf.local.home> <20140312114611.43547df7@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: 5wTE2yhLETCYNWW6tzaZaguSLlAG4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frederic
> Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Berg"
> <johannes.berg@intel.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Thomas Gleixner" <tglx@linutronix.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
> "lttng-dev" <lttng-dev@lists.lttng.org>, "Rusty Russell" <rusty@rustcorp.com.au>
> Sent: Wednesday, March 12, 2014 11:46:11 AM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> 
> To sum up this thread, and get the signal vs noise ratio up.
> 
> On Wed, 12 Mar 2014 11:11:00 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > The solution I like the most that I believe will work for both of us,
> > is to to move this magic "enable tracepoint in the future" to your
> > LTTng module. Have your module register a module load and unload handler
> > to be able to see the tracepoints that exist in the module, and you can
> > enable them then. When a module is unloaded, your module can do the
> > accounting to record that, and the state of its tracepoints.
> 
> This is my final proposal.
> 
> I'll add the patch that removes the tracepoint on failure along with
> returning -ENODEV. That way, there will be no registered tracepoints
> that do not exist.
> 
> I'll also make sure that on module unload, the tracepoints are disabled
> for the module as well.

Do you mean that the tracepoint probe will be unregistered from within
tracepoint.c whenever all modules containing tracepoint call sites are
unloaded ? If so, how do you plan to handle ownership of the "name",
"probe" and "data" pointer ? They belong to the tracer. Would they simply
leak ?

> 
> Then, you can simply add a module notifier that does the work that you
> like, and save and restore the state of named tracepoints and enabled
> them on module load. Just set the priority of the notifier to 1
> so that it runs after the tracepoint notifier that adds the new
> tracepoints to the system.

I don't mind the extra work on the LTTng side at all. What I am concerned
about are changes that would make the tracepoint API sloppy.

> 
> > 
> > Looks like we can have it both ways. A way that works well for the
> > kernel, and a way that works well for you. But your module will need to
> > do the heavy work for what you want.
> > 
> > To me, a tracepoint should only be enabled when it exists. If it is
> > enabled in module when the module is unloaded, then it should be
> > removed after the module has left. If the module is loaded again, it is
> > up to the user (or your module) to enable that tracepoint again.
> 
> I want to point out that LTTng should not be dictating the way the
> kernel works, but it should be the other way around.

I don't care about doing extra work in LTTng, no worries about that.
I'm just trying to ensure all the corner cases are thought through
when a change such as this is proposed in a core infrastructure like
tracepoints.

Thanks,

Mathieu

> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
