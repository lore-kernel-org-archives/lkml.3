Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaBUEJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:09:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:28297 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752456AbaBUEJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:09:40 -0500
Date: Thu, 20 Feb 2014 23:09:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140220230938.0bf9614b@gandalf.local.home>
In-Reply-To: <87lhx59yap.fsf@rustcorp.com.au>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<877g8zg0ed.fsf@rustcorp.com.au>
	<20140213161156.3548df43@gandalf.local.home>
	<878uteecu0.fsf@rustcorp.com.au>
	<20140220103033.32860caf@gandalf.local.home>
	<87lhx59yap.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 09:39:18 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> >> comment "Do not forget to sign required modules with scripts/sign-file"
> >> 	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
> >> 
> >> Then you didn't do that.  You broke it, you get to keep both pieces.
> >
> > In this case we should fail the module load all together, and require
> > insmod to add the --force flag to load it. Why the hell are we setting
> > a FORCED_MODULE flag when no module was forced????
> 
> If this mistake of creating unsigned modules is common, then it would be
> friendly to do something about it, yes.

I just got another report about it happening again today.

> 
> Perhaps we should append UNSIGNED to vermagic, and then strip that out
> when we sign the module?  That would have this effect.

If it makes the user have to use --force, then they will be more aware
something went wrong when things are not working.

I still find it strange that things like tracepoints are not working on
a module just because it wasn't signed. I can see someone adding
something and not doing the signing, and wonder why tracepoints are
broken. Right now, I'm the one that gets the bug reports, not you :-(

Them: "Tracepoints are broken".
Me: "What do you mean tracepoints are broken?"
Them: "I enabled them, but don't see them being recorded"
Me: "Is this for tracepoints in a module?"
Them: "Yes"
Me: "Oh, this again. Do you have MODULE_SIG_FORCE & !MODULE_SIG_ALL
set, and you didn't sign your module?"
Them: "Yes"
Me: "Well that's your problem."
Them: "What does that have to do with tracepoints?"
Me: "Well, loading a non signed module into a kernel that requires
sigs, sets the FORCED_MODULE flag, and that breaks tracepoints"
Them: "Why? The module is from the same kernel and built with the same
tool chain"
Me: "it just does"
Them: "I'm just working on this module, and I want to trace it, but
don't want to keep signing it"
Me: "Oh well, that's just the way it goes"
Them: "Why?"

When honestly, just adding another taint flag and let tracepoints
still load would keep people from pestering me about it.

The only reason we don't trace FORCED_MODULE modules, is because it may
have an older data structure, or different tracepoint logic. We avoid
adding tracepoints on those because we don't want bug reports from
people using tracepoints in modules that were compiled for a different
kernel, because that could cause havoc. Ironically, having tracepoints
not added for modules with that taint is causing more bug reports due
to this signing issue. Maybe I'll just let tracepoints work with modules
that have that taint and deal with the bug reports that are caused by
people loading older modules into newer kernels.

-- Steve
