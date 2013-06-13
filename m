Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3FMTbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:31:34 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:22350 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab3FMTbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:31:32 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2013 15:31:31 EDT
Date: Thu, 13 Jun 2013 19:16:26 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>,
        David McCullough <david_mccullough@au.securecomputing.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 0/3] Use POSIX "$((..))" instead of bashism "$[...]"
In-Reply-To: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
Message-ID: <Pine.BSM.4.64L.1306131908240.22801@herc.mirbsd.org>
References: <1371129052-31506-1-git-send-email-geert@linux-m68k.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven dixit:

>Should these be truncated to 32-bit explicitly, or is this a bug in mksh?

mksh in “mksh mode” operates specifically on 32-bit integer data
types with defined wraparound and other guarantees beyond what
POSIX does. There is an “lksh” binary in the mksh binary package
in Debian and derivates now, which is the “legacy mode” that uses
the host system’s “long” data type, as POSIX demands, and is now
(mksh_46-2) used for /bin/sh.

However, on mixed 32/64-bit systems, /bin/sh can have either bit
size. Additionally, it is not possible, in POSIX, without invoking
ISO C “Undefined Behaviour”, to find out the bitsize of the shell
arithmetics.

Furthermore, Linux can be cross-compiled, so when building kernels
for 64-bit platforms on 32-bit systems, the arithmetics used MUST
NOT overflow beyond a signed 32-bit “long”.

>  [1/3] h8300/boot: Use POSIX "$((..))" instead of bashism "$[...]"
>  [2/3] ARM: shmobile: Use POSIX "$((..))" instead of bashism "$[...]"
>  [3/3] sh/boot: Use POSIX "$((..))" instead of bashism "$[...]"

Independent of the above, I’ve verified all three and can state
that they
ⓐ are no regression relative to existing behaviour
ⓑ do not invoke any features not in POSIX $((…)) arithmetics
ⓒ do not invoke any features not in mksh $((…)) arithmetics

This means you can add my
Signed-off: Thorsten Glaser <tg@mirbsd.org>

However, I urge you to check whether any of these arithmetics
can go beyond 32 bit. If they have even the slightest chance
to do that, you MUST replace them by something different. One
method could be to use bc(1):

$(shell printf 'obase=16\nibase=16\n%s+%s\n' $(FOO) $(BAR) | bc)

Another method could be to operate on the upper half and the
lower half of the 64-bit quantities separately, assuming that
calculations do not overflow (in POSIX sh, overflow is, like
in ISO C, Undefined Behaviour; a C compiler is permitted to
compile the source code in the shell that invokes it to run
“rm -rf ~ /” instead) or carry over (e.g. if it’s known that
the first half is always 0x7FFFFFFF or the last half always
00000000 you can just add that as “string”).

bye,
//mirabilos
-- 
FWIW, I'm quite impressed with mksh interactively. I thought it was much
*much* more bare bones. But it turns out it beats the living hell out of
ksh93 in that respect. I'd even consider it for my daily use if I hadn't
wasted half my life on my zsh setup. :-) -- Frank Terbeck in #!/bin/mksh
