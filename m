Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaCKEIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:08:25 -0400
Received: from mail.efficios.com ([78.47.125.74]:43101 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaCKEIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:08:24 -0400
Date: Tue, 11 Mar 2014 04:08:27 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <288254692.35226.1394510907402.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140310225820.0f02025d@gandalf.local.home>
References: <20140307150920.881849073@goodmis.org> <20140307151202.210588176@goodmis.org> <241011797.35066.1394481694124.JavaMail.zimbra@efficios.com> <y0mr469e9t0.fsf@fche.csb> <20140310225820.0f02025d@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Warn if a tracepoint is not set via debugfs
Thread-Index: YJRgyO0U/JTFwm3qSYX/40EK2MtkOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Frank Ch. Eigler" <fche@redhat.com>
> Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, "Ingo Molnar"
> <mingo@kernel.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
> "Johannes Berg" <johannes.berg@intel.com>
> Sent: Monday, March 10, 2014 10:58:20 PM
> Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not set via debugfs
> 
> On Mon, 10 Mar 2014 22:41:31 -0400
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
> > 
> > Hi -
> > 
> > 
> > >> From: Steven Rostedt <rostedt@goodmis.org>
> > >> 
> > >> Tracepoints were made to allow enabling a tracepoint in a module before
> > >> that
> > >> module was loaded. When a tracepoint is enabled and it does not exist,
> > >> the
> > >> name is stored and will be enabled when the tracepoint is created.
> > >> 
> > >> The problem with this approach is that when a tracepoint is enabled when
> > >> it expects to be there, it gives no warning that it does not exist.
> > 
> > So it is a deferred-activation kind of call, with no way of knowing
> > when or if the tracepoints will start coming in.  Why is that
> > supported at all, considering that clients could monitor modules
> > coming & going via the module_notifier chain, and update registration
> > at that time?
> 
> That's my argument.

So basically, all we'd have to do in LTTng is to add a hash table tracking the
tracepoint probes which are registered, but for which there are no
tracepoint call sites. Whenever registration of a probe would fail due to
-ENODEV (assuming we unregister the probe within tracepoint.c when we return
-ENODEV, as you initially proposed), we would put this probe in the hash table.
Upon module coming, we would iterate on the module's tracepoints and check
if any of those match the content of the hash table, and then register the
probe.

I guess I'd prefer that to the weird successful failure return value in
tracepoint.c.

Thanks,

Mathieu

> 
> > 
> > 
> > >> +	entry = get_tracepoint(name);
> > >> +	/* Make sure the entry was enabled */
> > >> +	if (!entry || !entry->enabled)
> > >> +		ret = -ENODEV;
> > 
> > For what it's worth, I agree with Mathieu that this sort of successful
> > failure result code is a problem for tracking what needs cleanup and
> > what doesn't.  (In systemtap's case, if this change gets merged, we'll
> > have to treat -ENODEV as if it were 0.)
> 
> Does systemtap enable tracepoints before they are created? That is, do
> you allow enabling of a tracepoint in a module that is not loaded yet?
> 
> If not, than you want this as an error.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
