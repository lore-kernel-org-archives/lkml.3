Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3LKNbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 08:31:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3LKNbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 08:31:42 -0500
Date: Wed, 11 Dec 2013 14:31:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v4 6/6] [RFC] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
In-Reply-To: <20131203213904.5ff1794c@gandalf.local.home>
Message-ID: <alpine.LRH.2.00.1312111418550.6318@twin.jikos.cz>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal> <20131204012856.22118.91079.stgit@kbuild-fedora.novalocal> <20131203213904.5ff1794c@gandalf.local.home>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Steven Rostedt wrote:

> > To avoid a kernel crash by probing on lockdep code, call
> > kprobe_int3_handler and kprobe_debug_handler directly
> > from do_int3 and do_debug. Since there is a locking code
> > in notify_die, lockdep code can be invoked. And because
> > the lockdep involves printk() related things, theoretically,
> > we need to prohibit probing on much more code...
> > 
> > Anyway, most of the int3 handlers in the kernel are already
> > called from do_int3 directly, e.g. ftrace_int3_handler,
> > poke_int3_handler, kgdb_ll_trap. Actually only
> > kprobe_exceptions_notify is on the notifier_call_chain.
> > 
> > So I think this is not a crazy thing.
> 
> What? Oh, yeah. No, using notifiers in int3 handler is the crazy
> thing ;-)

Yeah, it's broken. Obviously, if you happen to trigger int3 before the 
notifier has been registered, it'd cause int3 exception to be unhandled. 
See

	commit 17f41571bb2c4a398785452ac2718a6c5d77180e
	Author: Jiri Kosina <jkosina@suse.cz>
	Date:   Tue Jul 23 10:09:28 2013 +0200

	    kprobes/x86: Call out into INT3 handler directly instead of using notifier

for one such issue that happened with jump labels.

> Hmm, if there's no users of the int3 notifier, should we just remove it?

Hmm, there are still uprobes, right?

-- 
Jiri Kosina
SUSE Labs

