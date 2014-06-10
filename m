Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbaFJBQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:16:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989AbaFJBQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:16:01 -0400
Date: Tue, 10 Jun 2014 03:15:58 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Cameron Norman <camerontnorman@gmail.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>, luto@mit.edu,
        Keir Fraser <keir@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        Tim Deegan <tim@xen.org>, Ian Jackson <ian.jackson@eu.citrix.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        ebiederm@xmission.com, Jan Beulich <jbeulich@suse.com>,
        xen-devel@lists.xenproject.org, systemd-devel@lists.freedesktop.org,
        morgan@kernel.org
Subject: Re: [systemd-devel] [PATCH v5 12/14] autoconf: xen: enable
	explicit preference option for xenstored preference
Message-ID: <20140610011558.GC6219@wotan.suse.de>
References: <1400589095-3872-13-git-send-email-mcgrof@do-not-panic.com> <1400687040.7272.28.camel@kazak.uk.xensource.com> <20140521230233.GA13289@wotan.suse.de> <1400753147.14637.10.camel@kazak.uk.xensource.com> <20140523232031.GA26450@wotan.suse.de> <1401269449.24800.7.camel@kazak.uk.xensource.com> <20140529232918.GG26450@wotan.suse.de> <20140601061547.GC16257@tango.0pointer.de> <20140605003103.GB22052@wotan.suse.de> <CALZWFR+LQ3XK4RQ335CNqjr8zucWw4GieKwZS3N5m0w4yJXuBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZWFR+LQ3XK4RQ335CNqjr8zucWw4GieKwZS3N5m0w4yJXuBA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 07:52:56PM -0700, Cameron Norman wrote:
> On Wed, Jun 4, 2014 at 5:31 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Sun, Jun 01, 2014 at 08:15:47AM +0200, Lennart Poettering wrote:
> >> On Fri, 30.05.14 01:29, Luis R. Rodriguez (mcgrof@suse.com) wrote:
> >>
> >> > I'm cc'ing a few security folks as I'd appreciate review on the ideas here,
> >> > in particular that of a launcher idea on system to replace alternatives on the
> >> > ExecStart= line of a systemd service unit file, alternative ideas are of
> >> > course welcomed. I'm also Cc'ing systemd-devel as this subject was reviewed
> >> > a little while ago with nothing concrete being recommended but instead a few
> >> > options being now archived as possibilities. I'm looking for a bit wider
> >> > review of the approaches and recomendations.
> >> >
> >> > Some general background for non xen folks: old xen requires the launch of
> >> > a daemon which implements supports of the xenstore, which is the database
> >> > that xen uses for information about guests / dom0. There are two supported
> >> > daemons, xenstored (C version) and oxenstored (Ocaml version) but they do the
> >> > same thing. Right now old init lets you override which one you pick through
> >> > an environment variable on /etc/{sysconfig,default}/xencommons, the script
> >> > will use the appropriate on there. Systemd doesn't let you use variables on
> >> > the ExecStart line of a service unit file so alternatives are required.
> >> >
> >> > The reason I'm being very careful here this could set a precedent and at
> >> > least for the launcher idea it'd require the usage of getenv() and execve(),
> >> > and secure alternatives for these (secure_getenv(), execve_nosecurity())
> >> > have either been merged or suggested before for Linux. The systemd discussion
> >> > is only specific to Linux but if we have a launcher we could consider it for
> >> > other supported OSes. All that said I'd like proper review of the security
> >> > implications of *all* strategies but obviously in particular the launcher
> >> > idea. I want to tread carefuly before setting precedents.
> >>
> >> You can also just invoke a shell script from ExecStart=. I mean, we try
> >> to deemphesize them in the boot process, but there's nothing wrong with
> >> using shell, if you need to parse shell configuraiton fragments and just
> >> want to execute on ot another program...
> >
> > I tried this and it didn't work given that systemd expects sd_notify()
> > to be called from the parent process, in this case the shell script.
> 
> Just use exec before the daemon command. I am pretty certain it can be
> just like this:
> 
>     ExecStart=/bin/sh -c "exec $XENSTORED"
> 
> xenstored then has the same PID as the sh process, and $NOTIFY_SOCKET
> works just fine.

Actually this does work on a test unit I just built. I'll proceed with
this approach since I haven't heard back from others and I think
this is the best approach now.

  Luis
