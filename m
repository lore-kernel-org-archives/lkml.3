Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaBXTKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:10:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:14794 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752184AbaBXTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:10:10 -0500
Date: Mon, 24 Feb 2014 14:10:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140224141007.68a9b5b0@gandalf.local.home>
In-Reply-To: <1588404356.29584.1393266723043.JavaMail.zimbra@efficios.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
	<20140213154507.4040fb06@gandalf.local.home>
	<1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
	<20140224105454.3e1981ba@gandalf.local.home>
	<1588404356.29584.1393266723043.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 18:32:03 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> > 
> > The real answer to this is to enabled the tracepoints on module load,
> > with a module parameter. We've talked about this before, and I also
> > think there's some patches out there that do this. (I remember creating
> > something myself). I'll have to go dig them out and we can work to get
> > them in 3.15.
> 
> For the records, I still think that requiring users of tracing to add
> module parameters specifying what tracing they need enabled is expecting
> them to interact at the wrong interface level. This might be convenient
> for kernel developers, but not for other types of kernel tracing end
> users. From a user experience perspective, I think your "real answer"
> is the wrong answer.


Why? This is not a normal activity to for the user. You seem to have a
few specific users, but those are exceptions, and this has nothing to
do with normal kernel developer view.

Tracing a module that's being loaded is far from normal user activity.

Now, for boot up, I could see enabling all tracepoints. For that, we
can add a hook to the module load that when a flag is set, we can
enable all trace events in the module as it is loaded. That would work
for boot up.

If this is such a user activity, please explain to me what scenario
that requires tracing a module being loaded that could not easily be
accomplished with a module parameter?

> 
> > 
> > > 
> > > Another way to do this, without requiring changes to the existing
> > > tracepoint_probe_register() API, is to simply add e.g. (better function
> > > names welcome):
> > > 
> > > int tracepoint_has_callsites(const char *name)
> > > {
> > >     struct tracepoint_entry *entry;
> > >     int ret = 0;
> > > 
> > >     mutex_lock(&tracepoints_mutex);
> > >     entry = get_tracepoint(name);
> > >     if (entry && entry->refcount) {
> > >         ret = 1;
> > >     }
> > >     mutex_unlock(&tracepoints_mutex);
> > >     return ret;
> > > }
> > 
> > No, I'm not about to change the interface for something that is broken.
> > tracepoint_probe_register() should fail if it does not register a
> > tracepoint. It should not store it off for later. I'm not aware of any
> > other "register" function in the kernel that does such a thing. Is
> > there one that you know of?
> 
> see include/linux/notifier.h
> 
> You can register notifier callbacks without having any notifier call sites.
> This is exactly what tracepoint.c is currently doing. The change you propose
> is the equivalent of refusing to register a notifier callback if there is
> no call site for that notifier.

WTF! That's a horrible example. Yes, notifier is the infrastructure
code (a header file), but where is there a registered list without
callback sites? Look at include/linux/module.h! Do we allow to register
module notifiers when modules are not configured in? NO!

The tracepoint code does much more than registering a notifier. It
*enables* the tracepoint. I'll reverse your example on you. If you call
a notifier that has nothing registered, it does the same work that it
would do if something was registered to it. But the loop is empty, it
just doesn't call anything.

The tracepoint code does the work to activate the call site. Here's
where your analogy is broken. If I register a handler for a notifier,
when the call site is hit, my handler will be called. Well, because of
not doing anything different for non existent modules and modules that
fail to have their call sites activated, the register returns success
in both cases. That means, if I register a probe, it wont be called at
the call site. That's a big f'ing bug.


> 
> > 
> > > 
> > > So tools which care about providing feedback to their users about the
> > > fact that tracepoint callsites are not there can call this new function.
> > > The advantage is that it would not change the return values of the existing
> > > API. Also, it would be weird to have tracepoint_probe_register() return
> > > an error value but leave the tracepoint in a registered state. Moving this
> > > into a separate query function seems more consistent IMHO.
> > 
> > Again, the existing API is not a user interface. It is free to change,
> > and this change wont break any existing in-tree uses. In fact, the fact
> > that you had this stupid way of doing it, *broke* the in-tree users!
> > That is, no error messages were ever displayed when the probe was not
> > registered. This is why I consider this a broken design.
> > 
> > If you want LTTng to enable tracepoints before loading, then have your
> > module save off these these tracepoints and register a handler to
> > be called when a module is loaded and enable them yourself.
> 
> That's a possible option.
> 
> > 
> > For now, I'm going to push this in, and also mark it for stable.
> 
> I still disagree with this change.

Of course you do ;-)

-- Steve
