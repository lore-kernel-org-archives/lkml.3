Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBUILR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:11:17 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:35906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaBUILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:11:15 -0500
Message-ID: <1392970255.4346.14.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 21 Feb 2014 09:10:55 +0100
In-Reply-To: <20140220230938.0bf9614b@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <20140211072738.GA24232@gmail.com>
	 <20140211234534.6bc34e57@gandalf.local.home>
	 <877g8zg0ed.fsf@rustcorp.com.au>
	 <20140213161156.3548df43@gandalf.local.home>
	 <878uteecu0.fsf@rustcorp.com.au>
	 <20140220103033.32860caf@gandalf.local.home>
	 <87lhx59yap.fsf@rustcorp.com.au>
	 <20140220230938.0bf9614b@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 23:09 -0500, Steven Rostedt wrote:
> On Fri, 21 Feb 2014 09:39:18 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > >> comment "Do not forget to sign required modules with scripts/sign-file"
> > >> 	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
> > >> 
> > >> Then you didn't do that.  You broke it, you get to keep both pieces.
> > >
> > > In this case we should fail the module load all together, and require
> > > insmod to add the --force flag to load it. Why the hell are we setting
> > > a FORCED_MODULE flag when no module was forced????
> > 
> > If this mistake of creating unsigned modules is common, then it would be
> > friendly to do something about it, yes.
> 
> I just got another report about it happening again today.

Not sure if you meant me, but it was only indirectly reported to me as
well (I get to be considered the resident tracing "expert" in our team),
and my colleague spent two or three days trying to figure this out
before getting me involved, and when I couldn't figure it out either I
asked Steve ...

So yeah, there's definitely potential for confusion here, *particularly*
since there's no message, and the module shows as "forced taint" which
(as has been described elsewhere in the thread) is particularly
confusing since no forced loading was done.

> > Perhaps we should append UNSIGNED to vermagic, and then strip that out
> > when we sign the module?  That would have this effect.
> 
> If it makes the user have to use --force, then they will be more aware
> something went wrong when things are not working.

That's one way of looking at it, but why should a kernel that doesn't
require module signing require a --force flag for loading an unsigned
module? To me, that's chickening out - either you support loading
unsigned modules or you don't. Having half-baked support for it makes no
sense, IMHO. After all, given the configuration (no signature
requirement) there's nothing wrong with the module.

Additionally, it seems to me that you could still sign a module and then
--force it (ending up with a forced taint) so you can't actually tell
which one you did. Thus, if you sit in front of such a machine, you have
no way of figuring out what actually happened.

> I still find it strange that things like tracepoints are not working on
> a module just because it wasn't signed. I can see someone adding
> something and not doing the signing, and wonder why tracepoints are
> broken. Right now, I'm the one that gets the bug reports, not you :-(

> When honestly, just adding another taint flag and let tracepoints
> still load would keep people from pestering me about it.

The mere existence of a configuration to allow unsigned modules would
indicate that there are valid use cases for that (and rebuilding a
module or such for development would seem to be one of them), so why
would tracing be impacted, particularly for development.

> The only reason we don't trace FORCED_MODULE modules, is because it may
> have an older data structure, or different tracepoint logic. We avoid
> adding tracepoints on those because we don't want bug reports from
> people using tracepoints in modules that were compiled for a different
> kernel, because that could cause havoc. Ironically, having tracepoints
> not added for modules with that taint is causing more bug reports due
> to this signing issue. Maybe I'll just let tracepoints work with modules
> that have that taint and deal with the bug reports that are caused by
> people loading older modules into newer kernels.

I'd much prefer to split the taints, given that then it would also give
us a way to distinguish between
 * signed module loaded with --force
 * unsigned module loaded


Going on a tangent here - our use case is using backported upstream
kernel modules (https://backports.wiki.kernel.org/) for delivering a
driver to people who decided that they absolutely need to run with some
random kernel (e.g. 3.10) but we don't yet support all the driver
features they want/need in the kernel they picked.

We push our code upstream as soon as we can and typically only diverge
from upstream by a few patches, so saying things like "crap" or "felony
law breaker" about out-of-tree modules in general makes me furious.

johannes

