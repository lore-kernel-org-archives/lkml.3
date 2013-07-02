Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3GBX5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:57:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:34138 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3GBX5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:57:19 -0400
Date: Wed, 3 Jul 2013 01:57:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lennart Poettering <lpoetter@redhat.com>
cc: Tim Hockin <thockin@hockin.org>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>, Mike Galbraith <bitbucket@online.de>,
        Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
In-Reply-To: <51D08976.6040005@redhat.com>
Message-ID: <alpine.DEB.2.02.1307030021480.4013@ionos.tec.linutronix.de>
References: <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com> <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com> <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org> <1372391198.5989.110.camel@marge.simpson.net> <20130628040930.GC2500@htj.dyndns.org> <1372394950.5989.128.camel@marge.simpson.net> <20130628050138.GD2500@htj.dyndns.org> <20130628150513.GD5125@dhcp22.suse.cz>
 <CAAAKZwtqYe-c0bfkgHFbzsOKVHifjTwkqcpci=uS1JwqS9TJHQ@mail.gmail.com> <51CE3CE0.9010506@redhat.com> <CAAAKZwuzhSzPj99HZW=KD4emGXZbcsjsUu=+TCpafhs9MKD2JA@mail.gmail.com> <51D08976.6040005@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart,

On Sun, 30 Jun 2013, Lennart Poettering wrote:
> On 29.06.2013 05:05, Tim Hockin wrote:
> > But that's not my point.  It seems pretty easy to make this cgroup
> > management (in "native mode") a library that can have either a thin
> > veneer of a main() function, while also being usable by systemd.  The
> > point is to solve all of the problems ONCE.  I'm trying to make the
> > case that systemd itself should be focusing on features and policies
> > and awesome APIs.
> 
> You know, getting this all right isn't easy. If you want to do things
> properly, then you need to propagate attribute changes between the units you
> manage. You also need something like a scheduler, since a number of
> controllers can only be configured under certain external conditions (for
> example: the blkio or devices controller use major/minor parameters for
> configuring per-device limits. Since major/minor assignments are pretty much
> unpredictable these days -- and users probably want to configure things with
> friendly and stable /dev/disk/by-id/* symlinks anyway -- this requires us to
> wait for devices to show up before we can configure the parameters.) Soo...
> you need a graph of units, where you can propagate things, and schedule things
> based on some execution/event queue. And the propagation and scheduling are
> closely intermingled.

you are confusing policy and mechanisms.

    The access to cgroupfs is mechanism.

    The propagation of changes, the scheduling of cgroupfs access and
    the correlation to external conditions are policy.

What Tim is asking for is to have a common interface, i.e. a library
which implements the low level access to the cgroupfs mechanism
without imposing systemd defined policies to it (It might implement a
set of common useful policies, but that's a different discussion).

That's definitely not an unreasonable request, because he wants to
implement his own set of policies which are not necessarily the same
as those which are implemented by systemd.

You are simply ignoring the fact, that Linux is used in other ways
than those which you are focussed on. That's true for Google's way to
manage its gazillion machines and that's equally true for the other
end of the spectrum which is deep embedded or any other specialized
use case. Just face it: running Linux on your laptop and on some RHT
lab machines is covering about 1% of the use cases.

Nevertheless you repeatedly claim, that systemd is the only way to
deal with system startup and system management, is covering _ALL_ use
cases and the interfaces you expose are sufficient.

Did you ever work on specialized embedded or big data use cases? I
really doubt that, but I might be wrong as usual.

So I invite you to prove that you can beat an existing setup for an
automotive use case with your magic systemd foo. I refund you fully,
if you can beat the mark of a functional system less than 800ms after
reset release on a 200MHz ARM machine. Functional is defined by the
use case requirements and means:

    - Basic cgroups management working
    - GUI up and running
    - Main communication interface (CAN bus) up and running

The rest of the system is starting up after that including a more
complex cgroup management.

According to your claim that systemd is covering everything and some
more, this should take you a few hours. I grant you a full week to
work on that.

The use case Tim is talking about is different, but has similar
constraints which are completely driven by his particular use case
scenario. I'm sure, that Tim can persuade his management to setup a
similar contest to prove your expertise on the other extreme of the
Linux world.

Before answering please think about the relevance of your statements
"getting this all right isn't easy", "something like a scheduler",
"users probably want ..."  and "stable /dev/disk/by-id/* symlinks" in
those contexts.

Thanks,

	tglx
