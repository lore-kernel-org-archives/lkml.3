Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaK3WGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 17:06:13 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:33846 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaK3WGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 17:06:12 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4Qv1pukOr8ocUtE0QzLgWFEb3pT=5JXvERj98m-j9FS3Q@mail.gmail.com>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
 <CANq1E4Qv1pukOr8ocUtE0QzLgWFEb3pT=5JXvERj98m-j9FS3Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 30 Nov 2014 14:05:49 -0800
Message-ID: <CALCETrW2wRnZagYrbgHWzpn4+MZV6EcDTA-LDqrfKL2AfCbodA@mail.gmail.com>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux API <linux-api@vger.kernel.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2014 9:45 AM, "David Herrmann" <dh.herrmann@gmail.com> wrote:
>
> Hi Andy
>
> On Sat, Nov 29, 2014 at 12:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > Pid reuse is common, which means that it's difficult or impossible
> > to read information about a pid from /proc without races.
> >
> > This introduces a second number associated with each (task, pidns)
> > pair called highpid.  Highpid is a 64-bit number, and, barring
> > extremely unlikely circumstances or outright error, a (highpid, pid)
> > will never be reused.
> >
> > With just this change, a program can open /proc/PID/status, read the
> > "Highpid" field, and confirm that it has the expected value.  If the
> > pid has been reused, then highpid will be different.
> >
> > The initial implementation is straightforward: highpid is simply a
> > 64-bit counter. If a high-end system can fork every 3 ns (which
> > would be amazing, given that just allocating a pid requires at
> > atomic operation), it would take well over 1000 years for highpid to
> > wrap.
> >
> > For CRIU's benefit, the next highpid can be set by a privileged
> > user.
> >
> > NB: The sysctl stuff only works on 64-bit systems.  If the approach
> > looks good, I'll fix that somehow.
> >
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >
> > If this goes in, there's plenty of room to add new interfaces to
> > make this more useful.  For example, we could add a fancier tgkill
> > that adds and validates hightgid and highpid, and we might want to
> > add a syscall to read one's own hightgid and highpid.  These would
> > be quite useful for pidfiles.
> >
> > David, would this be useful for kdbus?
>
> Much appreciated! This would serve well as replacement for
> 'starttime'. I'd prefer if pid_t was 64bit, but I guess that ship
> sailed long ago. Though, your patch might in the end just introduce a
> new pid64, which replaces the old pid and lives in parallel.
>
> Anyway, considering that we actually want the same pid-reuse
> protection for tid, tgid, ppid and so on, we'd have to add a
> 'starttime' for all of them. Sounds ugly.. so we might just end up
> dropping 'starttime' and introduce KDBUS_ITEM_PIDS2 whenever a 'fix'
> is merged upstream.

I don't understand "we want".  Doesn't kdbus currently only think
about tid and tgid?

In any event, I just looked at the kdbus code
(https://github.com/gregkh/kdbus/blob/master/metadata.c), and I see:

meta->pid = get_pid(task_pid(current));
meta->tgid = get_pid(task_tgid(current));
meta->starttime = current->start_time,

I don't understand how that concept of starttime is particularly
useful.  Isn't that the start time associated with tid?  How can that
be useful when looking up tgid?

Regardless, my patch here associates a highpid with each struct pid,
and both tid and tgid are just struct pids, so you get both.  I agree
that adding Highppid to /proc might be useful, but that seems like a
future extension that has nothing to do with kdbus.

--Andy
