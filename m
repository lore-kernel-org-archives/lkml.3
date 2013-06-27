Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3F0QSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:18:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3F0QSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:18:22 -0400
Date: Thu, 27 Jun 2013 11:18:09 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tim Hockin <thockin@hockin.org>
Cc: Mike Galbraith <bitbucket@online.de>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130627161809.GA4957@sergelap>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
 <CAAAKZwt9QdddFrEjvdBsi3sbQXScKyzY=vZpYXqTwjGUebH1Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwt9QdddFrEjvdBsi3sbQXScKyzY=vZpYXqTwjGUebH1Ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tim Hockin (thockin@hockin.org):
> On Thu, Jun 27, 2013 at 6:22 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > Quoting Mike Galbraith (bitbucket@online.de):
> >> On Wed, 2013-06-26 at 14:20 -0700, Tejun Heo wrote:
> >> > Hello, Tim.
> >> >
> >> > On Mon, Jun 24, 2013 at 09:07:47PM -0700, Tim Hockin wrote:
> >> > > I really want to understand why this is SO IMPORTANT that you have to
> >> > > break userspace compatibility?  I mean, isn't Linux supposed to be the
> >> > > OS with the stable kernel interface?  I've seen Linus rant time and
> >> > > time again about this - why is it OK now?
> >> >
> >> > What the hell are you talking about?  Nobody is breaking userland
> >> > interface.  A new version of interface is being phased in and the old
> >> > one will stay there for the foreseeable future.  It will be phased out
> >> > eventually but that's gonna take a long time and it will have to be
> >> > something hardly noticeable.  Of course new features will only be
> >> > available with the new interface and there will be efforts to nudge
> >> > people away from the old one but the existing interface will keep
> >> > working it does.
> >>
> >> I can understand some alarm.  When I saw the below I started frothing at
> >> the face and howling at the moon, and I don't even use the things much.
> >>
> >> http://lists.freedesktop.org/archives/systemd-devel/2013-June/011521.html
> >>
> >> Hierarchy layout aside, that "private property" bit says that the folks
> >> who currently own and use the cgroups interface will lose direct access
> >> to it.  I can imagine folks who have become dependent upon an on the fly
> >> management agents of their own design becoming a tad alarmed.
> >
> > FWIW, the code is too embarassing yet to see daylight, but I'm playing
> > with a very lowlevel cgroup manager which supports nesting itself.
> > Access in this POC is low-level ("set freezer.state to THAWED for cgroup
> > /c1/c2", "Create /c3"), but the key feature is that it can run in two
> > modes - native mode in which it uses cgroupfs, and child mode where it
> > talks to a parent manager to make the changes.
> 
> In this world, are users able to read cgroup files, or do they have to
> go through a central agent, too?

The agent won't itself do anything to stop access through cgroupfs, but
the idea would be that cgroupfs would only be mounted in the agent's
mntns.  My hope would be that the libcgroup commands (like cgexec,
cgcreate, etc) would know to talk to the agent when possible, and users
would use those.

> > So then the idea would be that userspace (like libvirt and lxc) would
> > talk over /dev/cgroup to its manager.  Userspace inside a container
> > (which can't actually mount cgroups itself) would talk to its own
> > manager which is talking over a passed-in socket to the host manager,
> > which in turn runs natively (uses cgroupfs, and nests "create /c1" under
> > the requestor's cgroup).
> 
> How do you handle updates of this agent?  Suppose I have hundreds of
> running containers, and I want to release a new version of the cgroupd
> ?

This may change (which is part of what I want to investigate with some
POC), but right now I'm building any controller-aware smarts into it.  I
think that's what you're asking about?  The agent doesn't do "slices"
etc.  This may turn out to be insufficient, we'll see.

So the only state which the agent stores is a list of cgroup mounts (if
in native mode) or an open socket to the parent (if in child mode), and a
list of connected children sockets.

HUPping the agent will cause it to reload the cgroupfs mounts (in case
you've mounted a new controller, living in "the old world" :).  If you
just kill it and start a new one, it shouldn't matter.

> (note: inquiries about the implementation do not denote acceptance of
> the model :)

To put it another way, the problem I'm solving (for now) is not the "I
want a daemon to ensure that requested guarantees are correctly
implemented." In that sense I'm maintaining the status quo, i.e. the
admin needs to architect the layout correctly.

The problem I'm solving is really that I want containers to be able to
handle cgroups even if they can't mount cgroupfs, and I want all
userspace to be able to behave the same whether they are in a container
or not.

This isn't meant as a poke in the eye of anyone who wants to address the
other problem.  If it turns out that we (meaning "the community of
cgroup users") really want such an agent, then we can add that.  I'm not
convinced.

What would probably be a better design, then, would be that the agent
I'm working on can plug into a resource allocation agent.  Or, I
suppose, the other way around.

> > At some point (probably soon) we might want to talk about a standard API
> > for these things.  However I think it will have to come in the form of
> > a standard library, which knows to either send requests over dbus to
> > systemd, or over /dev/cgroup sock to the manager.
> >
> > -serge
