Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab3GCRLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:11:46 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39476 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502Ab3GCRLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:11:45 -0400
Message-ID: <1372871502.3601.59.camel@dabdike>
Subject: Re: cgroup: status-quo and userland efforts
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lennart Poettering <lpoetter@redhat.com>, Tim Hockin <thockin@hockin.org>,
        Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <bitbucket@online.de>, Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 03 Jul 2013 10:11:42 -0700
In-Reply-To: <alpine.DEB.2.02.1307030021480.4013@ionos.tec.linutronix.de>
References: <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	 <20130625000118.GT1918@mtj.dyndns.org>
	 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	 <20130626212047.GB4536@htj.dyndns.org>
	 <1372311907.5871.78.camel@marge.simpson.net>
	 <20130627180143.GD5599@mtj.dyndns.org>
	 <1372391198.5989.110.camel@marge.simpson.net>
	 <20130628040930.GC2500@htj.dyndns.org>
	 <1372394950.5989.128.camel@marge.simpson.net>
	 <20130628050138.GD2500@htj.dyndns.org>
	 <20130628150513.GD5125@dhcp22.suse.cz>
	 <CAAAKZwtqYe-c0bfkgHFbzsOKVHifjTwkqcpci=uS1JwqS9TJHQ@mail.gmail.com>
	 <51CE3CE0.9010506@redhat.com>
	 <CAAAKZwuzhSzPj99HZW=KD4emGXZbcsjsUu=+TCpafhs9MKD2JA@mail.gmail.com>
	 <51D08976.6040005@redhat.com>
	 <alpine.DEB.2.02.1307030021480.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 01:57 +0200, Thomas Gleixner wrote:
> Lennart,
> 
> On Sun, 30 Jun 2013, Lennart Poettering wrote:
> > On 29.06.2013 05:05, Tim Hockin wrote:
> > > But that's not my point.  It seems pretty easy to make this cgroup
> > > management (in "native mode") a library that can have either a thin
> > > veneer of a main() function, while also being usable by systemd.  The
> > > point is to solve all of the problems ONCE.  I'm trying to make the
> > > case that systemd itself should be focusing on features and policies
> > > and awesome APIs.
> > 
> > You know, getting this all right isn't easy. If you want to do things
> > properly, then you need to propagate attribute changes between the units you
> > manage. You also need something like a scheduler, since a number of
> > controllers can only be configured under certain external conditions (for
> > example: the blkio or devices controller use major/minor parameters for
> > configuring per-device limits. Since major/minor assignments are pretty much
> > unpredictable these days -- and users probably want to configure things with
> > friendly and stable /dev/disk/by-id/* symlinks anyway -- this requires us to
> > wait for devices to show up before we can configure the parameters.) Soo...
> > you need a graph of units, where you can propagate things, and schedule things
> > based on some execution/event queue. And the propagation and scheduling are
> > closely intermingled.
> 
> you are confusing policy and mechanisms.
> 
>     The access to cgroupfs is mechanism.
> 
>     The propagation of changes, the scheduling of cgroupfs access and
>     the correlation to external conditions are policy.
> 
> What Tim is asking for is to have a common interface, i.e. a library
> which implements the low level access to the cgroupfs mechanism
> without imposing systemd defined policies to it (It might implement a
> set of common useful policies, but that's a different discussion).
> 
> That's definitely not an unreasonable request, because he wants to
> implement his own set of policies which are not necessarily the same
> as those which are implemented by systemd.

Could I just add a me too to this from Parallels.  We need the ability
to impose our own container policy on the kernel mechanisms.

Perhaps I should step back a bit and say first of all that we all use
the word "container" a lot, but if you analyse what we mean, you'll find
that a Google container is different from a Parallels/OpenVZ container
which is different from an LXC container and so on.  How we all build
our containers is a policy we impose on the various cgroup and namespace
mechanisms within the kernel.  We've spent a lot of discussion time over
the years making sure that the kernel mechanisms support all of our
different use cases, so I really don't want to see that change in the
name of simplifying the API.

I also don't think any quest for the one true container will be
successful for the simple reason that containers are best when tuned for
the job they're doing. For instance at Parallels we do IaaS containers.
That means we can take a container, boot up any old Linux OS inside it
and give you root on it in exactly the same way as you could for a
virtual machine.  Google does something more like application containers
for job control and some network companies do pure namespace containers
without any cgroup controllers at all.  There's no one container
description that would fit all use cases.

So where we are is that the current APIs may be messy, but they support
all use cases and all container structure policies.  If anyone, systemd
included, wants to do a new API, it must support all use cases as well.
Ideally, it should be agreed to and in the kernel as well rather than
having some userspace filter.

James


