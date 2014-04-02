Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbaDBXNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:13:31 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47720 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbaDBXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140402221212.GD16570@mguzik.redhat.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
Date: Wed, 2 Apr 2014 16:13:27 -0700
X-Google-Sender-Auth: unb6rxuPT011G5LSzuQMFNk-ErE
Message-ID: <CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 3:12 PM, Mateusz Guzik <mguzik@redhat.com> wrote:
>
> Well, parsing kernel cmdline by systemd is a bad idea

No, we very much expose /proc/cmdline for a reason. System services
are *supposed* to parse it, because it gives a unified way for people
to pass in various flags. The kernel doesn't complain about flags it
doesn't recognize, exactly because the kernel realizes that "hey,
maybe this flag is for something else".

The classic example of this is things like "charset" markers, but also
options to modules that modprobe parses etc etc.

And yes, that does include "quiet" and "debug". Parsing them and doing
something sane with them is not a bug, it's a feature.

But the problem appears when system services seem to think that they
*own* those flags, and nothing else matters, and they don't do
something "sane" any more.

And the thing is, this has never really been a problem in practice.
Because nobody minds if some kernel option like "debug" makes not only
the kernel enable debugging, but some system deamon log a bit more
too.

HOWEVER.

It does become a problem when you have a system service developer who
thinks the universe revolves around him, and nobody else matters, and
people sending him bug-reports are annoyances that should be ignored
rather than acknowledged and fixed. At that point, it's a problem.

It looks like Greg has stepped in as a baby-sitter for Kay, and things
are going to be fixed. And I'd really like to avoid adding hacky code
to the kernel because of Kay's continued bad behavior, so I hope this
works. But it's really sad that things like this get elevated to this
kind of situation, and I personally find it annoying that it's always
the same f*cking primadonna involved.

Steven, Borislav, one thing that strikes me might be a good idea is to
limit the amount of non-kernel noise in dmesg. We already have the
concept of rate-limiting various spammy internal kernel messages for
when device drivers misbehave etc. Maybe we can just add rate-limiting
to the interfaces that add messages to the kernel buffers, and work
around this problem that way instead while waiting for Gregs fix to
percolate? Or are the systemd debug messages going to so many other
places too that that wouldn't really help?

          Linus
