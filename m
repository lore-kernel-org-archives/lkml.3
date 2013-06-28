Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3F1PxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:53:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3F1PxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:53:17 -0400
Date: Fri, 28 Jun 2013 10:53:06 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Tim Hockin <thockin@hockin.org>, Mike Galbraith <bitbucket@online.de>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter <lpoetter@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>,
        workman-devel <workman-devel@redhat.com>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130628155306.GC26841@sergelap>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
 <20130628090910.GB2507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628090910.GB2507@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Daniel P. Berrange (berrange@redhat.com):
> On Thu, Jun 27, 2013 at 08:22:06AM -0500, Serge Hallyn wrote:
> > FWIW, the code is too embarassing yet to see daylight, but I'm playing
> > with a very lowlevel cgroup manager which supports nesting itself.
> > Access in this POC is low-level ("set freezer.state to THAWED for cgroup
> > /c1/c2", "Create /c3"), but the key feature is that it can run in two
> > modes - native mode in which it uses cgroupfs, and child mode where it
> > talks to a parent manager to make the changes.
> > 
> > So then the idea would be that userspace (like libvirt and lxc) would
> > talk over /dev/cgroup to its manager.  Userspace inside a container
> > (which can't actually mount cgroups itself) would talk to its own
> > manager which is talking over a passed-in socket to the host manager,
> > which in turn runs natively (uses cgroupfs, and nests "create /c1" under
> > the requestor's cgroup).
> > 
> > At some point (probably soon) we might want to talk about a standard API
> > for these things.  However I think it will have to come in the form of
> > a standard library, which knows to either send requests over dbus to
> > systemd, or over /dev/cgroup sock to the manager.
> 
> Are you also planning to actually write a new cgroup parent manager
> daemon too ? Currently my plan for libvirt is to just talk directly

I'm toying with the idea, yes.  (Right now my toy runs in either native
mode, using cgroupfs, or child mode, talking to a parent manager)  I'd
love if someone else does it, but it needs to be done.

As I've said elsewhere in the thread, I see 2 problems to be addressed:

1. The ability to nest the cgroup manager daemons, so that a daemon
running in a container can talk to a daemon running on the host.  This
is the problem my current toy is aiming to address.  But the API it
exports is just a thin layer over cgroupfs.

2. Abstract away the kernel/cgroupfs details so that userspace can
explain its cgroup needs generically.  This is IIUC what systemd is
addressing with slices and scopes.

(2) is where I'd really like to have a well thought out, community
designed API that everyone can agree on, and it might be worth getting
together (with Tejun) at plumbers or something to lay something out.

In the end, something like libvirt or lxc should not need to care
what is running underneat it.  It should be able to make its requests
the same way regardless of whether it running in fedora or ubuntu,
and whether it is running on the host or in a tightly bound container.
That's my goal anyway :)

> to systemd's new DBus APIs for all management of cgroups, and then
> fall back to writing to cgroupfs directly for cases where systemd
> is not around.  Having a library to abstract these two possible
> alternatives isn't all that compelling unless we think there will
> be multiple cgroups manager daemons. I've been somewhat assuming that
> even Ubuntu will eventually see the benefits & switch to systemd,

So far I've seen no indication of that :)

If the systemd code to manage slices could be made separately
compileable as a standalone library or daemon, then I'd advocate
using that.  But I don't see a lot of incentive for systemd to do
that, so I'd feel like a heel even asking.

> then the issue of multiple manager daemons wouldn't really exist.

True.  But I'm running under the assumption that Ubuntu will stick with
upstart, and therefore yes I'll need a separate (perhaps pair of)
management daemons.

Even if we were to switch to systemd, I'd like the API for userspace
programs to configure and use cgroups to be as generic as possible,
so that anyone who wanted to write their own daemon could do so.

-serge
