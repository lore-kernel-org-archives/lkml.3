Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaK3Qpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:45:34 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41493 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaK3Qpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:45:32 -0500
MIME-Version: 1.0
In-Reply-To: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
Date: Sun, 30 Nov 2014 17:45:31 +0100
Message-ID: <CANq1E4Qv1pukOr8ocUtE0QzLgWFEb3pT=5JXvERj98m-j9FS3Q@mail.gmail.com>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy

On Sat, Nov 29, 2014 at 12:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Pid reuse is common, which means that it's difficult or impossible
> to read information about a pid from /proc without races.
>
> This introduces a second number associated with each (task, pidns)
> pair called highpid.  Highpid is a 64-bit number, and, barring
> extremely unlikely circumstances or outright error, a (highpid, pid)
> will never be reused.
>
> With just this change, a program can open /proc/PID/status, read the
> "Highpid" field, and confirm that it has the expected value.  If the
> pid has been reused, then highpid will be different.
>
> The initial implementation is straightforward: highpid is simply a
> 64-bit counter. If a high-end system can fork every 3 ns (which
> would be amazing, given that just allocating a pid requires at
> atomic operation), it would take well over 1000 years for highpid to
> wrap.
>
> For CRIU's benefit, the next highpid can be set by a privileged
> user.
>
> NB: The sysctl stuff only works on 64-bit systems.  If the approach
> looks good, I'll fix that somehow.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>
> If this goes in, there's plenty of room to add new interfaces to
> make this more useful.  For example, we could add a fancier tgkill
> that adds and validates hightgid and highpid, and we might want to
> add a syscall to read one's own hightgid and highpid.  These would
> be quite useful for pidfiles.
>
> David, would this be useful for kdbus?

Much appreciated! This would serve well as replacement for
'starttime'. I'd prefer if pid_t was 64bit, but I guess that ship
sailed long ago. Though, your patch might in the end just introduce a
new pid64, which replaces the old pid and lives in parallel.

Anyway, considering that we actually want the same pid-reuse
protection for tid, tgid, ppid and so on, we'd have to add a
'starttime' for all of them. Sounds ugly.. so we might just end up
dropping 'starttime' and introduce KDBUS_ITEM_PIDS2 whenever a 'fix'
is merged upstream.

Thanks a lot!
David
