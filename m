Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3HUUQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:16:32 -0400
Received: from 1wt.eu ([62.212.114.60]:35511 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3HUUQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:16:30 -0400
Date: Wed, 21 Aug 2013 22:16:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
Message-ID: <20130821201614.GJ23677@1wt.eu>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFxi-ps2f2M8xPhfbuQ0pToqupPrDsLi2+GPUK2sqdYfUw@mail.gmail.com> <CALCETrW7+LcexA6v6RQDKhni_yJAduOmiSDneCpq3v8sPDvwUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW7+LcexA6v6RQDKhni_yJAduOmiSDneCpq3v8sPDvwUQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 12:33:24PM -0700, Andy Lutomirski wrote:
> On Wed, Aug 21, 2013 at 12:29 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On my phone, sorry. Removed lists due to HTML crud..

OK no HTML from me here, so re-adding the 3 lists if that can help reaching
an end faster on this stuff.

> > If the issue is just reopening a read-only file descriptor, then why isn't
> > this an issue for just regular openat?
> >
> > Iow, I get the feeling this isn't about flink, but about AT_EMPTY_PATH in
> > general.

That's my understanding as well since it's what replaces /proc/self/fd/ which
is he difference in this case. However AT_EMPTY_PATH is currently limited to
linkat(2), fstatat(2) and name_to_handle_at(2) from what I'm seeing, so it
looks like only linkat would permit the calling process to gain more permissions
by using it when it has no /proc access.

> Dunno, since I still haven't come up with a real-world attack here.
> Maybe someone chroots, runs something in the chroot, kills that thing,
> and then expects that it hasn't somehow retained access to the file
> (by, say, linking it).

In my understanding, it does not necessarily need to klil that thing to
get an issue. Let's imagine a completely made up example. A malware
scanner on a proxy uses sandboxes to analyse suspicious contents. For
this it holds a read-only mmap to the signature database, forks and
chroots the scanner process to avoid any risk of getting fooled by the
malicious code. If the malicious code manages to execute some code in
the context of the sandboxed scanner that still has access to the
signature db, it could use linkat(AT_EMPTH_PATH) to this fd to recreate
a file in the chroot, and reopen it R/W to modify it and remove any trace
of its signature.

Sure it's a bit far-fetched, but I think that between this and the most
trivial case, there might be a few real world cases. Also I still feel
concerned by the ability for an unprivileged process to create device
nodes in a chroot using this. I don't have any immediate impact in mind
but I tend to design my chroots so that I'm sure there is no way to get
a /dev there, and this would leave me a bit of doubt.

> It may pay to consider some (opt-in) hardening of procfs's follow_link.

I agree. A mount option would be great for some constrained environments.

> Sometimes I wish that hardlinks had never been invented and that
> people had gone straight to cow links.
>
> --Andy

:-)

Willy

