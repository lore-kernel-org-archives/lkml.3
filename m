Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaBMVMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:12:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbaBMVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:12:05 -0500
Date: Thu, 13 Feb 2014 16:11:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140213161156.3548df43@gandalf.local.home>
In-Reply-To: <877g8zg0ed.fsf@rustcorp.com.au>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<877g8zg0ed.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014 13:54:42 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:


> I'm ambivalent towards out-of-tree modules, so not tempted unless I see
> a bug report indicating a concrete problem.  Then we can discuss...

As I replied in another email, this is a concrete problem, and affects
in-tree kernel modules.

If you have the following in your .config:

CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set

Modules will not be signed at build, and they can be loaded with a
simple modprobe or insmod with no --force flag set. You may get an
error message like:

  sunrpc: module verification failed: signature and/or required key missing - tainting kernel

But nothing else that indicates a problem.

In the module code, the above was printed by:

#ifdef CONFIG_MODULE_SIG
	mod->sig_ok = info->sig_ok;
	if (!mod->sig_ok) {
		pr_notice_once("%s: module verification failed: signature "
			       "and/or  required key missing - tainting "
			       "kernel\n", mod->name);
		add_taint_module(mod, TAINT_FORCED_MODULE, LOCKDEP_STILL_OK);
	}
#endif

Now in the tracepoint code, we have:

in tracepoint_module_coming():

	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
		return 0;

If the module is tainted as other than out-of-tree or crap (staging),
the module is ignored with respect to tracepoints. No error, no nothing.

This means that all modules loaded with the config will not have their
tracepoints enabled.

I highly doubt this is the expected result. I think Mathieu's patch is
a fix to this problem (and my patch fixes the problem where tracepoints
do not give any feedback that they failed to be enabled).

Are you fine with his fix, if so, please ack it, and I'll apply it.

Although, is "N" the best letter to use for this taint? Not sure, but
everything else I can think of looks to be already taken. Maybe "X"?
You know. When you sign your name and don't know how to spell it, you
just simply use an "X". :-)

Thanks!

-- Steve
