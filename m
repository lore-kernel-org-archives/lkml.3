Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab3HMVWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:22:34 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40980 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759180Ab3HMVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:22:33 -0400
Date: Tue, 13 Aug 2013 17:22:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Francis Giraldeau <francis.giraldeau@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>
Cc: "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [lttng-dev] Building out-of-tree tracepoint modules on Ubuntu
Message-ID: <20130813212226.GA14924@Krystal>
References: <520A893E.4070300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A893E.4070300@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing LKML on this module signature tainting discussion.

* Francis Giraldeau (francis.giraldeau@gmail.com) wrote:
> The lttng-modules addons stopped working on Ubuntu 12.10 with Linux 3.8.
> Tracepoints defined in these modules were listed by "lttng list -k", no
> error was return when enabling, but events were not written to the trace.
> 
> This problem is caused by the option CONFIG_MODULE_SIG=y on Ubuntu
> kernels. Because the signing key is not available, it's not possible to
> sign LTTng modules, and they are flagged as TAINT_FORCED. This flag is
> checked on tracepoints registration [1].
> 
> /*
>  * We skip modules that taint the kernel, especially those with
>  * different module headers (for forced load), to make sure we don't
>  * cause a crash. Staging and out-of-tree GPL modules are fine.

We should probably add non-signed modules to the exception list of
tainted modules considered by tracepoints.

>  */
> if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
> 	return 0;
> 
> In consequence, it's not possible to have out-of-tree tracepoint module
> with the default Ubuntu kernel.
> 
> What about generating a new x.509 certificate and sign modules with it?
> I tried to use keyctl to add a signing key, but I didn't found a way to
> add the key to the special ".module_sign" keyring [2]. It seems internal
> and inaccessible, but if somebody knows how to deal with this, that
> would be the best solution.
> 
> As a last resort solution, I did a small module that embed the
> certificate and loads it. Then, signed modules loaded after this one are
> not marked as TAINTE_FORCED, and thus works correctly [3].
> 
> $ cat /proc/modules
> [...]
> lttng_addons 14418 0 - Live 0x0000000000000000 (O)
> lttng_modsign 12623 0 - Live 0x0000000000000000 (OF)
> 
> $ lttng create
> $ lttng enable-event -k inet_sock_create
> $ lttng start
> $ echo bidon | netcat localhost 1234
> $ lttng stop
> $ lttng view
> $ [15:03:40.850792507] (+?.?????????) ubuntu inet_sock_create: { cpu_id
> = 0 }, { sk = 0xFFFF88003C670E00 }
> 
> So, even if this is a dirty hack, it works ;-)

Oh, wow. So a non-signed module can simply add a trusted signature, just
like that ? This seems like a nice hack indeed!

> 
> Could it be possible to relax checks to add tracepoint module if they
> are not signed? Then a new flag TAINT_UNTRUSTED (or something) shall be
> added to distinguish such situation from the more general TAINT_FORCED.
> At least, there should be some warning message when inserting the module
> and enabling such event should be failing.

Indeed, it looks like we should make tracepoint.c more specific wrt what
modules it rejects. Rejecting tracepoints from non-signed modules seems
more strict than what should be required, but this would require that we
introduce a new TAINT_UNTRUSTED flag to distinguish between a non-signed
module and a module which has been forcefully loaded.

Thoughts ?

Thanks,

Mathieu


> 
> Thoughts?
> 
> Thanks!
> 
> Francis Giraldeau
> 
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/kernel/tracepoint.c#n634
> [2]
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/kernel/modsign_pubkey.c#n33
> [3]
> https://github.com/giraldeau/lttng-modules/blob/addons-modsign/lttng-signature.c
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
