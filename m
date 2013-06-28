Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3F1QcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:32:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3F1QcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:32:05 -0400
Date: Fri, 28 Jun 2013 11:31:54 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tim Hockin <thockin@hockin.org>
Cc: Mike Galbraith <bitbucket@online.de>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>, vrigo@google.com
Subject: Re: cgroup access daemon
Message-ID: <20130628163154.GA4989@sergelap>
References: <CAAAKZwuKxxYoVRn6Ye72Vs7vSd_T4cbvEwiU6Q3j4D-Z+VAPrw@mail.gmail.com>
 <20130627181108.GA26334@sergelap>
 <CAAAKZwvXYBznJ5uiWaEV7fNCHbciwLa6U+E5RUJkz1ioMu=cRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwvXYBznJ5uiWaEV7fNCHbciwLa6U+E5RUJkz1ioMu=cRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tim Hockin (thockin@hockin.org):
> On Thu, Jun 27, 2013 at 11:11 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > Quoting Tim Hockin (thockin@hockin.org):
> >
> >> For our use case this is a huge problem.  We have people who access
> >> cgroup files in a fairly tight loops, polling for information.  We
> >> have literally hundeds of jobs running on sub-second frequencies -
> >> plumbing all of that through a daemon is going to be a disaster.
> >> Either your daemon becomes a bottleneck, or we have to build something
> >> far more scalable than you really want to.  Not to mention the
> >> inefficiency of inserting a layer.
> >
> > Currently you can trivially create a container which has the
> > container's cgroups bind-mounted to the expected places
> > (/sys/fs/cgroup/$controller) by uncommenting two lines in the
> > configuration file, and handle cgroups through cgroupfs there.
> > (This is what the management agent wants to be an alternative
> > for)  The main deficiency there is that /proc/self/cgroups is
> > not filtered, so it will show /lxc/c1 for init's cgroup, while
> > the host's /sys/fs/cgroup/devices/lxc/c1/c1.real will be what
> > is seen under the container's /sys/fs/cgroup/devices (for
> > instance).  Not ideal.
> 
> I'm really saying that if your daemon is to provide a replacement for
> cgroupfs direct access, it needs to be designed to be scalable.  If
> we're going to get away from bind mounting cgroupfs into user
> namespaces, then let's try to solve ALL the problems.
> 
> >> We also need the ability to set up eventfds for users or to let them
> >> poll() on the socket from this daemon.
> >
> > So you'd want to be able to request updates when any cgroup value
> > is changed, right?
> 
> Not necessarily ANY, but that's the terminus of this API facet.
> 
> > That's currently not in my very limited set of commands, but I can
> > certainly add it, and yes it would be a simple unix sock so you can
> > set up eventfd, select/poll, etc.
> 
> Assuming the protocol is basically a pass-through to basic filesystem
> ops, it should be pretty easy.  You just need to add it to your
> protocol.
> 
> But it brings up another point - access control.  How do you decide
> which files a child agent should have access to?  Does that ever
> change based on the child's configuration? In our world, the answer is
> almost certainly yes.

Could you give examples?

If you have a white/academic paper I should go read, that'd be great.

At the moment I'm going on the naive belief that proper hierarchy
controls will be enforced (eventually) by the kernel - i.e. if
a task in cgroup /lxc/c1 is not allowed to mknod /dev/sda1, then it
won't be possible for /lxc/c1/lxc/c2 to take that access.

The native cgroup manager (the one using cgroupfs) will be checking
the credentials of the requesting child manager for access(2) to
the cgroup files.

> >> >> > So then the idea would be that userspace (like libvirt and lxc) would
> >> >> > talk over /dev/cgroup to its manager.  Userspace inside a container
> >> >> > (which can't actually mount cgroups itself) would talk to its own
> >> >> > manager which is talking over a passed-in socket to the host manager,
> >> >> > which in turn runs natively (uses cgroupfs, and nests "create /c1" under
> >> >> > the requestor's cgroup).
> >> >>
> >> >> How do you handle updates of this agent?  Suppose I have hundreds of
> >> >> running containers, and I want to release a new version of the cgroupd
> >> >> ?
> >> >
> >> > This may change (which is part of what I want to investigate with some
> >> > POC), but right now I'm building any controller-aware smarts into it.  I
> >> > think that's what you're asking about?  The agent doesn't do "slices"
> >> > etc.  This may turn out to be insufficient, we'll see.
> >>
> >> No, what I am asking is a release-engineering problem.  Suppose we
> >> need to roll out a new version of this daemon (some new feature or a
> >> bug or something).  We have hundreds of these "child" agents running
> >> in the job containers.
> >
> > When I say "container" I mean an lxc container, with it's own isolated
> > rootfs and mntns.  I'm not sure what your "containers" are, but I if
> > they're not that, then they shouldn't need to run a child agent.  They
> > can just talk over the host cgroup agent's socket.
> 
> If they talk over the host agent's socket, where is the access control
> and restriction done?  Who decides how deep I can nest groups?  Who
> says which files I may access?  Who stops me from modifying someone
> else's container?
> 
> Our containers are somewhat thinner and more managed than LXC, but not
> that much.  If we're running a system agent in a user container, we
> need to manage that software.  We can't just start up a version and
> leave it running until the user decides to upgrade - we force
> upgrades.
> 
> >> How do I bring down all these children, and then bring them back up on
> >> a new version in a way that does not disrupt user jobs (much)?
> >>
> >> Similarly, what happens when one of these child agents crashes?  Does
> >> someone restart it?  Do user jobs just stop working?
> >
> > An upstart^W$init_system job will restart it...
> 
> What happens when the main agent crashes?  All those children on UNIX
> sockets need to reconnect, I guess.  This means your UNIX socket needs
> to be a named socket, not just a socketpair(),  making your auth model
> more complicated.

It is a named socket.

> What happens when the main agent hangs?  Is someone health-checking
> it?  How about all the child daemons?
> 
> I guess my main point is that this SOUNDS like a simple project, but

I guess it's not "simple".  It just focuses on one specific problem.

> if you just do the simple obvious things, it will be woefully
> inadequate for anything but simple use-cases.  If we get forced into
> such a model (and there are some good reasons to do it, even
> disregarding all the other chatter), we'd rather use the same thing
> that the upstream world uses, and not re-invent the whole thing
> ourselves.
> 
> Do you have a design spec, or a requirements list, or even a prototype
> that we can look at?

The readme at https://github.com/hallyn/cgroup-mgr/blob/master/README
shows what I have in mind.  It (and the sloppy code next to it)
represent a few hours' work over the last few days while waiting
for compiles and in between emails...

But again, it is completely predicated on my goal to have libvirt
and lxc (and other cgroup users) be able to use the same library
or API to make their requests whether they are on host or in a
container, and regardless of the distro they're running under.

-serge
