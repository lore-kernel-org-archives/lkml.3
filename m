Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaCKTOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:14:02 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:61130 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755345AbaCKTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:14:00 -0400
Date: Tue, 11 Mar 2014 15:13:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [for-next][PATCH 08/20] tracing: Warn if a tracepoint is not
 set via debugfs
Message-ID: <20140311151357.077c5a68@gandalf.local.home>
In-Reply-To: <1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
References: <20140307150920.881849073@goodmis.org>
	<20140307151202.210588176@goodmis.org>
	<241011797.35066.1394481694124.JavaMail.zimbra@efficios.com>
	<y0mr469e9t0.fsf@fche.csb>
	<20140310225820.0f02025d@gandalf.local.home>
	<20140311142650.GB13756@redhat.com>
	<1448078225.73.1394550382164.JavaMail.zimbra@efficios.com>
	<20140311114023.02fcf639@gandalf.local.home>
	<1752080128.130.1394559263621.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 17:34:23 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
 
> > Who can load modules not as root?? That is utterly broken. As once you
> > can load a module, YOU ARE ROOT.
> 
> udevd runs as root, and listens to events such as USB hotplug, and loads modules
> in the back of users. The users don't need to be root for this to happen.

udevd may run as a proxy for users. But it is still a root user.
Sysadmins are the ones that set up udevd. If you own your own box, you
are technically the sysadmin for it. Modifications to udev require sudo
privileges.

Tracepoints should not be something a non-sysadmin can modify or
enable. If you want non root users to do so, create a proxy daemon like
udevd to do it for them. But the kernel isn't going to allow that
directly.

> 
> >  
> > > fashion and is not suitable for the user-base we are targeting. I seems to
> > > be a user experience disaster IMHO.
> > 
> > For your case only. But it is normal operation for normal uses of Linux.
> 
> AFAIK pretty much all distros use udev nowadays. Are you suggesting that all
> users using udev and distribution kernels are not "normal uses of Linux" ?

udev is root, and is modified by root users. A normal user can not just
interact with udev. And sticking in a usb stick into a computer counts
as a sysadmin operation, even if the person doesn't official have the
title.

> 
> > 
> > > 
> > > I'm OK as long as we have an elegant way forward. Ideally I would have
> > > prefered (1) to eliminate code duplication between tracers and tracepoint
> > > infrastructure (we have to reimplement a hash table similar to tracepoints
> > > within the tracer with solution (2)), but (2) technically works too.
> > 
> > Here's what I propose then. We implement 2 for now. You can "duplicate"
> > the code into your own work.
> 
> Works for me.
> 
> > Then we should be able to simplify the
> > tracepoint code as it no longer will have the requirement to enable
> > tracepoints that do not exist.
> 
> What happens for the case where we enable a tracepoint, and then the
> only module containing a callsite of that tracepoint is unloaded, and
> then reloaded ?

When a module is unloaded, it usually loses state. Is there any state
that is maintained for a module being unloaded and reloaded again?
Besides tracepoints? If not, then the module should lose its state for
tracepoints as well.

-- Steve
