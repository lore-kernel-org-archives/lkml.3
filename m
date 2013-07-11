Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3GKRQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:16:20 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38900 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3GKRQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130711135445.GA21500@sepie.suse.cz>
References: <20130710133742.GA29368@emu.suse.cz>
	<CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
	<20130711135445.GA21500@sepie.suse.cz>
Date: Thu, 11 Jul 2013 10:16:18 -0700
X-Google-Sender-Auth: ujBx3iRyniRFmPstl-lFGnqwX74
Message-ID: <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
Subject: Re: [GIT] kbuild changes for v3.11-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>, dt.tangr@gmail.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        James Hogan <james.hogan@imgtec.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        robert.richter@calxeda.com,
        "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>,
        zzs0213@gmail.com,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 6:54 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> Yeah. It also reveals another bug that we rewrite the kernel.release
> file each time. This patch should fix it, but please do not apply it
> yet:

So I think not rewriting the file is a good thing, but in this case it
would actually have hidden the real bug.

At least for most people. For me, it would have rewritten the file
anyway, because as a normal user I have

  core.abbrev=12

in my ~/.gitconfig, but when running it as root, it will take the
abbrev setting from the git defaults (which I think is 7). So the
content actually *changes* if root generates the version as opposed to
my normal user account.

Of course, that's arguably something we could fix in our localversion
script (by just forcing a particular abbreviation length), but I
actually like how a plain "git describe" (which will use the
user-specified SHA1 abbreviations) matches "uname -r" (which will
obviously take the version from the kernel version file at
build-time). So I'm not convinced that it is wrong for us to just use
the format that the user specified in their gitconfig, even if it does
result in "odd" situations like this where "make kernelrelease" will
then potentially give different output for different users.

> We also run dozens of gcc checks during every make invocation, including
> make install or make help, so there is some room for improvement. But at
> least, these do not write to the source or object tree.

It would be good to try to minimize these kinds of things, for the
simple reason that I'm not at all sure that we necessarily get all the
temporary file security issues right.

Running as little as possible as root is good practice for a very real
reason: there can be very subtle security issues. Let's not worry
about it *too* much, but keeping it in mind is good.

At least for the gcc checking scripts I looked at, we seem to be doing
things safely (ie using pipes instead of temp-files in /tmp).

              Linus
