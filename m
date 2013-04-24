Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3DXVvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:51:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab3DXVvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:51:13 -0400
Date: Wed, 24 Apr 2013 17:51:03 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kzak@redhat.com
Subject: Re: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130424215103.GI15272@hansolo.jdub.homelinux.org>
References: <1256775981.281402.1364864751771.JavaMail.root@redhat.com>
 <CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
 <20130409005050.GE18176@hansolo.jdub.homelinux.org>
 <20130409154820.GE32476@hansolo.jdub.homelinux.org>
 <CAGXu5jLs1ghuCwcu7crOG1OHuiaP3hmzYY410br_puc9i82-2g@mail.gmail.com>
 <CAPXgP10Vd3Ucxn77WX7wzQoaUmy-JdOBWvYv4zpGSu9qcd=GoQ@mail.gmail.com>
 <20130424175835.GF15272@hansolo.jdub.homelinux.org>
 <CAGXu5jLaQ=Amui3i5+MyG_3HOVnK-1ZoaLqw=jFDwaQCzE+4qw@mail.gmail.com>
 <20130424212112.GH15272@hansolo.jdub.homelinux.org>
 <CAGXu5jJweZVLhz0pP6=Woud=aqAKgNmG-7T5WKYdmWR4gxcw9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJweZVLhz0pP6=Woud=aqAKgNmG-7T5WKYdmWR4gxcw9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 02:36:39PM -0700, Kees Cook wrote:
> >>
> >> So, the problem here is the expectation of privileges. The /proc/kmsg
> >> usage pattern was:
> >>
> >> open /proc/kmsg with CAP_SYSLOG
> >> drop CAP_SYSLOG
> >> read /proc/kmsg forever
> >
> > This doesn't change the /proc interface at all.
> 
> Right, I meant that Kay's assertion that /proc/kmsg is "legacy" means
> he expects syslog daemons to switch to using /dev/kmsg.
> 
> >> If we change the FILE vs CALL and OPEN vs READ stuff here, we're lying
> >> to the API about what's happening. If we use this patch, then we can't
> >> use /dev/kmsg in the same way (i.e. running without privileges).
> >
> > Uh... Yes we can.  I tested it as a normal user.  It works just fine
> > running without privs and without CAP_SYSLOG, like it did before there
> > was a patch at all.  It also honors dmesg_restrict in devkmsg_read.
> > I'm confused why you think this doesn't work?
> 
> I don't think I was clear. There are two use-cases, as I see it:
> 
> - normal user running dmesg(1)
> - system daemon pulling kernel syslog and putting into userspace (e.g.
> /var/log/kern.log).

Ah.

> In the dmesg(1) case, we're fine. It was using syscalls, now it can
> use /dev/kmsg since open isn't checked, just the read action. That's
> all cool by me.

OK.

> In the daemon case, it's nice to be able to drop privileges after
> setting up resources. The past was open /proc/kmsg with CAP_SYS_ADMIN,
> then drop CAP_SYS_ADMIN and keep reading. Then later CAP_SYS_LOG was
> introduced. So if a daemon switched from /proc/kmsg to /dev/kmsg they
> wouldn't be able to drop the capability. But, it's much saner to carry
> CAP_SYS_LOG than CAP_SYS_ADMIN on a long-running daemon.

I have no idea on this front.  I'll let Kay speak to that.  On my
currently running Fedora 18 system, I actually have systemd-journald
using /dev/kmsg, and rsyslog using /proc/kmsg.  Why I have both, I have
no friggin idea.
 
> >> That said, I much prefer doing the privilege test at read time since
> >> that means passing a file descriptor to another process doesn't mean
> >> the new process can just continue reading. If we're going to be
> >> defining the new behavior for /dev/kmsg, then I think we should
> >> explicitly drop the fall-back to CAP_SYS_ADMIN. Perhaps introduce a
> >
> > I think Karel and Kay's entire point was /dev/kmsg shouldn't be getting
> > new behavior.  Aside from honoring dmesg_restrict, they see any behavior
> > change as a regression.
> 
> Is there an intention to use /dev/kmsg for the syslog management daemon?

Maybe?  I mean, systemd-journald seems to be using it for something.
Kay?

josh
