Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaCLT6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:58:10 -0400
Received: from mail.efficios.com ([78.47.125.74]:51914 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaCLT6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:58:08 -0400
Date: Wed, 12 Mar 2014 19:58:10 +0000 (UTC)
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
        Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>
Message-ID: <1666649564.1944.1394654290265.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140312153006.7acea4a8@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <437054772.1403.1394640336308.JavaMail.zimbra@efficios.com> <20140312121813.1e0102aa@gandalf.local.home> <285520930.1511.1394642395537.JavaMail.zimbra@efficios.com> <20140312135059.2d497b58@gandalf.local.home> <1906756968.1732.1394650035535.JavaMail.zimbra@efficios.com> <20140312145802.4819511e@gandalf.local.home> <20140312153006.7acea4a8@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: jm7Hx7+7UQ7kPEwj3KGOmr8NvJfUYg==
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
> Sent: Wednesday, March 12, 2014 3:30:06 PM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> On Wed, 12 Mar 2014 14:58:02 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Two modules should not have the same name. Is there any duplicate
> > tracepoints you are aware of. Namespace collisions in tracepoints
> > should be avoided, as that would cause people to trace things they did
> > not intend on tracing.
> > 
> > That should be a new patch as well. Enforce unique tracepoint names.
> 
> This may be why you are not understanding what I want. It's the way
> things are implemented today, which I believe are wrong. I see what you
> did. You have probes that are registered, and tracepoints that are
> where the code lies. You just add and remove probes from a hash list,
> and then you loop through all the tracepoints seeing if the iter->name
> matches a probe->name.
> 
> I'm fine with keeping the probe separate, but there really should be
> no more than just a one to one mapping between probes and tracepoints.
> Have the probe point to the matching tracepoint. The probe is
> registered, it enables the tracepoint static key, when it's ref count
> goes to zero, it disables the tracepoint static key. We can get rid of
> that loop then, as well as the duplicate names between probes and
> tracepoints.

Right there, this is not possible for a few reasons, namely:

- loop unrolling performed by the compiler can duplicate a tracepoint,
  even if it is only there once in the source code,
- inlining performed by the compiler may do the same,
- LTO, whenever it will start being used for the kernel, may do the same,
  and also spread call sites across modules.

There can be no 1 to 1 mapping between a probe function and a callsite
due to those compilers optimisations, even if we enforce the strictest
coding style rules possible on their use.

Thanks,

Mathieu


> 
> Here's the steps we should take:
> 
> 1) Prevent duplicate tracepoints. They are just namespace collisions
> that we already try to avoid. How to do this? We may need to add a
> hlist_node to the tracepoint structure, and keep them in a hash by name.
> Check for collisions when the name is added to the hash.
> 
> 2) Change the way tracepoints are enabled. Do not do a loop of all
> tracepoints, but instead have the first probe of a tracepoint enable
> it, and the last one to disable it. This would require a pointer from
> the probe to the tracepoint it represents. Again, it should not
> represent more than one.
> 
> 3) On module unload, it would be the responsibility of the user to
> unload all the tracepoints that may have been enabled for a module. We
> can add a mod pointer in the probe to make this easier, as well as to
> the tp_module structure.
> 
> The way tracepoints are today are to handle two completely different
> tracepoints with the same name. That should be avoided, and will make
> things much less complex.
> 
> Then you can easily handle the accounting of modules loading and
> unloading in your module, and the tracepoint code will match what the
> rest of the kernel does for resource management.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
