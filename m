Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaBXPy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:54:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60702 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752260AbaBXPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:54:57 -0500
Date: Mon, 24 Feb 2014 10:54:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new
 TAINT_UNSIGNED_MODULE
Message-ID: <20140224105454.3e1981ba@gandalf.local.home>
In-Reply-To: <1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
	<20140211072738.GA24232@gmail.com>
	<20140211234534.6bc34e57@gandalf.local.home>
	<1583293363.24361.1392304214094.JavaMail.zimbra@efficios.com>
	<20140213102817.4bfd5eac@gandalf.local.home>
	<2127052721.24380.1392306090965.JavaMail.zimbra@efficios.com>
	<20140213154507.4040fb06@gandalf.local.home>
	<1828346046.24803.1392349744601.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 03:49:04 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >  
> >  	mutex_lock(&tracepoints_mutex);
> >  	old = tracepoint_add_probe(name, probe, data);
> > @@ -388,9 +393,15 @@ int tracepoint_probe_register(const char *name, void
> > *probe, void *data)
> >  		return PTR_ERR(old);
> >  	}
> >  	tracepoint_update_probes();		/* may update entry */
> > +	entry = get_tracepoint(name);
> > +	/* Make sure the entry was enabled */
> > +	if (!entry || !entry->enabled) {
> > +		tracepoint_entry_remove_probe(entry, probe, data);
> 
> I'm OK with returning some kind of feedback about whether the tracepoint is
> enabled or not, but there is one use-case I care about this change breaks:
> registering a tracepoint probe for a module that is not yet loaded. The change
> you propose here removes the probe if no tracepoint is found when the probe is
> registered.

The thing is, there's no in-tree user of that interface.

I was thinking of adding a tracepoint_probe_register_future() that
wouldn't remove the probe, but this storing of a tracepoint that does
not exist (and may never exist), is IMHO a broken design.

The real answer to this is to enabled the tracepoints on module load,
with a module parameter. We've talked about this before, and I also
think there's some patches out there that do this. (I remember creating
something myself). I'll have to go dig them out and we can work to get
them in 3.15.

> 
> Another way to do this, without requiring changes to the existing
> tracepoint_probe_register() API, is to simply add e.g. (better function
> names welcome):
> 
> int tracepoint_has_callsites(const char *name)
> {
>     struct tracepoint_entry *entry;
>     int ret = 0;
> 
>     mutex_lock(&tracepoints_mutex);
>     entry = get_tracepoint(name);
>     if (entry && entry->refcount) {
>         ret = 1;
>     }
>     mutex_unlock(&tracepoints_mutex);
>     return ret;
> }

No, I'm not about to change the interface for something that is broken.
tracepoint_probe_register() should fail if it does not register a
tracepoint. It should not store it off for later. I'm not aware of any
other "register" function in the kernel that does such a thing. Is
there one that you know of?

> 
> So tools which care about providing feedback to their users about the
> fact that tracepoint callsites are not there can call this new function.
> The advantage is that it would not change the return values of the existing
> API. Also, it would be weird to have tracepoint_probe_register() return
> an error value but leave the tracepoint in a registered state. Moving this
> into a separate query function seems more consistent IMHO.

Again, the existing API is not a user interface. It is free to change,
and this change wont break any existing in-tree uses. In fact, the fact
that you had this stupid way of doing it, *broke* the in-tree users!
That is, no error messages were ever displayed when the probe was not
registered. This is why I consider this a broken design.

If you want LTTng to enable tracepoints before loading, then have your
module save off these these tracepoints and register a handler to
be called when a module is loaded and enable them yourself.

For now, I'm going to push this in, and also mark it for stable.

-- Steve
