Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaCJUTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:19:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:36946 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754094AbaCJUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:19:29 -0400
Date: Mon, 10 Mar 2014 16:19:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140310161927.3e78e5c4@gandalf.local.home>
In-Reply-To: <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<20140307151202.210588176@goodmis.org>
	<241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 20:01:34 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
 
> >  	mutex_lock(&tracepoints_mutex);
> >  	old = tracepoint_add_probe(name, probe, data);
> > @@ -388,9 +393,13 @@ int tracepoint_probe_register(const char *name, void
> > *probe, void *data)
> >  		return PTR_ERR(old);
> >  	}
> >  	tracepoint_update_probes();		/* may update entry */
> > +	entry = get_tracepoint(name);
> > +	/* Make sure the entry was enabled */
> > +	if (!entry || !entry->enabled)
> > +		ret = -ENODEV;
> 
> Hi Steven,
> 
> Returning -ENODEV when the probe is still registered might come as a
> surprise to the caller. For instance, a caller may dynamically allocate
> name, probe, and/or data, it may want to free them when
> tracepoint_probe_register returns an error. But this "-ENODEV" return value
> is not really an error, and the parameters passed are still used.

It's an error when you wanted to enable a probe and the probe doesn't
exist. There are no in tree users of this call that expect it to work
when the probe does not exist.

> 
> If we go down this route, we might want at the very least to add documentation
> of tracepoint_probe_register() return values and their meaning
> in a comment on top of this function (perhaps also in the header). But
> even if we do so, this weird return value semantic with respect to use of the
> received parameters will likely cause memory corruption at some point.
> 
> Thoughts ?

Send a patch to document the return values. Your module can expect this
return value when it doesn't expect the probe to exist.

Again, it's really strange when you go to enable a probe, and there is
no probe to enable.

Note, I was nice. I removed the logic to unregister the probe in this
case.

Anyway, this should even help you. Before there was no way to enable a
probe and know if it was enabled or not. That is, if it didn't exist,
there was no feedback letting you know that.

If you expect to enable a probe that doesn't exist, then you can expect
this return value.

-- Steve
