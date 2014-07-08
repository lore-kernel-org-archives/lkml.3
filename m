Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaGHABi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:01:38 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:56146 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaGHABf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:01:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140704123847.GA3513@sepie.suse.cz>
References: <20140702124016.GA26965@sepie.suse.cz>
	<20140702105645.17220.92338.stgit@warthog.procyon.org.uk>
	<2690.1404308050@warthog.procyon.org.uk>
	<20140704123847.GA3513@sepie.suse.cz>
Date: Mon, 7 Jul 2014 17:01:34 -0700
X-Google-Sender-Auth: B6Hko-VGhVXL95u3X4GSR5QVsOI
Message-ID: <CAD=FV=VbR8GZ7V3RfDRRt_fFXa9aZK6joGgYPOMWTSVbhyvi3A@mail.gmail.com>
Subject: Re: [PATCH] Fix compiler message generation
From: Doug Anderson <dianders@chromium.org>
To: Michal Marek <mmarek@suse.cz>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, sam@ravnborg.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>,
        Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Mike Frysinger <vapier@gentoo.org>, Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal

On Fri, Jul 4, 2014 at 5:38 AM, Michal Marek <mmarek@suse.cz> wrote:
> On Wed, Jul 02, 2014 at 02:34:10PM +0100, David Howells wrote:
>> Michal Marek <mmarek@suse.cz> wrote:
>>
>> > From 5b59dcacf358f143b9fb39d2f788142ab9ba3e00 Mon Sep 17 00:00:00 2001
>> > From: Michal Marek <mmarek@suse.cz>
>> > Date: Wed, 2 Jul 2014 14:28:26 +0200
>> > Subject: [PATCH] kbuild: Print the name of the build directory
>> >
>> > With commit 9da0763b (kbuild: Use relative path when building in a
>> > subdir of the source tree), the compiler messages include relative
>> > paths. These are however relative to the build directory, not the
>> > directory where make was started. Print the "Entering directory ..."
>> > message once, so that IDEs/editors can find the source files.
>> >
>> > Signed-off-by: Michal Marek <mmarek@suse.cz>
>> > ---
>> >  Makefile | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/Makefile b/Makefile
>> > index 97b2861..40544a0 100644
>> > --- a/Makefile
>> > +++ b/Makefile
>> > @@ -126,7 +126,10 @@ PHONY += $(MAKECMDGOALS) sub-make
>> >  $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
>> >     @:
>> >
>> > +# Fake the "Entering directory" message once, so that IDEs/editors are
>> > +# able to understand relative filenames.
>> >  sub-make: FORCE
>> > +   @echo "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
>> >     $(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
>> >     KBUILD_SRC=$(CURDIR) \
>> >     KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
>>
>> Works for me with emacs.
>>
>> Acked-by: David Howells <dhowells@redhat.com>
>
> I found a regression today... after I had sent a pull request to Linus
> yesterday :-/. The message is also printed by 'make -s', which is not
> what the user expects from a silent mode. The following patch fixes it:
>
>
> From 066b7ed9558087a7957a1128f27d7a3462ff117f Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Fri, 4 Jul 2014 14:29:30 +0200
> Subject: [PATCH] kbuild: Do not print the build directory with make -s
>
> Commit c2e28dc9 (kbuild: Print the name of the build directory) prints
> the name of the build directory for O= builds, but we should not be
> doing this in make -s mode, so that commands like
>
>   make -s O=<dir> kernelrelease
>
> can be used by scripts. This matches the behavior of make itself, where
> the -s option implies --no-print-directory.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile | 97 +++++++++++++++++++++++++++++++++-------------------------------
>  1 file changed, 50 insertions(+), 47 deletions(-)

This fixes the build error I was running into.  Our build system
effectively calls "make -s kernelrelease" and was getting tripped up.
I haven't extensively reviewed your fix but I have tested it.

Tested-by: Doug Anderson <dianders@chromium.org>
