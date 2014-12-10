Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbaLJUYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:24:31 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55323 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374AbaLJUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:24:29 -0500
Message-ID: <1418243066.22654.19.camel@x220>
Subject: Re: [PATCH v2 0/4] kconfig: store default ARCH in .config
From: Paul Bolle <pebolle@tiscali.nl>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 10 Dec 2014 21:24:26 +0100
In-Reply-To: <CALYGNiOC7E9kPLn_+rA7Wv7AMQgzyrot9Uyd0s3DDEw+78KWGQ@mail.gmail.com>
References: <20140901065916.28909.35097.stgit@zurg>
	 <CALYGNiOC7E9kPLn_+rA7Wv7AMQgzyrot9Uyd0s3DDEw+78KWGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2014 20:24:26.0599 (UTC) FILETIME=[4B245F70:01D014B7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konstantin,

On Mon, 2014-10-27 at 21:20 +0400, Konstantin Khlebnikov wrote:
> Bump.
> 
> On Mon, Sep 1, 2014 at 11:16 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> > This is second attempt of fixing target archecture amnesia.
> > v1 patch: http://lkml.kernel.org/r/20140706080234.19520.96704.stgit@zurg
> >
> > First version saved ARCH as CONFIG_DEFAULT_ARCH and used it as defult ARCH.
> >
> > This version changes semantic of Kconfig option env="...", now it acts more
> > like the user input, except that the value comes from the environment.
> > Variable from environment overrides all defaults and value from config file.
> > If environment variable is not defined this option has no effect.
> >
> > So, now ARCH is saved as CONFIG_ARCH.
> >
> > Also this patchset links CONFIG_CROSS_COMPILE and CROSS_COMPILE in the same way.
> > Changing it in command line/environment also updates value in the config file.
> >
> > ---
> >
> > Konstantin Khlebnikov (4):
> >       kconfig: save values imported from environment into config file
> >       scripts/config: add option for changing output for undefined options
> >       kconfig: get target architecture from config file
> >       kconfig: link CONFIG_CROSS_COMPILE with environment variable
> >
> >
> >  Documentation/kbuild/kconfig-language.txt |   10 ++++------
> >  Documentation/kbuild/makefiles.txt        |    3 ++-
> >  Makefile                                  |   21 +++++++++++++++------
> >  init/Kconfig                              |    1 +
> >  scripts/config                            |   15 ++++++++++++---
> >  scripts/kconfig/confdata.c                |   26 ++++++++++++++++++++++++++
> >  scripts/kconfig/expr.h                    |    2 +-
> >  scripts/kconfig/symbol.c                  |    3 ---
> >  8 files changed, 61 insertions(+), 20 deletions(-)

It's been a few months since you submitted this series and you've
received little feedback. So I tried to review this series. That didn't
go too well. Mainly because the kconfig code makes answering questions
like "What does sym_calc_value() actually do?" harder than it should be.
(And because make and the kernel Makefiles scare me, but I don't like to
admit that.)

Anyhow, I think what you want to accomplish, is basically to save make's
ARCH as CONFIG_ARCH and, likewise, save make's CROSS_COMPILE as
CONFIG_CROSS_COMPILE. You jump through quite a few hoops to do that in
this series.

Now I'm not clear whether saving those variables should actually be
done. But I did cobble together a much smaller _hack_ that seems to
achieve what you want. I've pasted it at the end of this message. It's
lightly tested on top of today's linux-next. (Does it break building
UML?) But does it do what you basically care about?


Paul Bolle
---
diff --git a/Makefile b/Makefile
index ec2f22615d3d..a8bc3290f2e9 100644
--- a/Makefile
+++ b/Makefile
@@ -228,6 +228,9 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
 
+KCONFIG_CONFIG	?= .config
+export KCONFIG_CONFIG
+
 # Cross compiling and selecting different set of gcc/bin-utils
 # ---------------------------------------------------------------------------
 #
@@ -248,6 +251,10 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 # "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
+ARCH		?= $(shell grep -s ^CONFIG_ARCH= $(KCONFIG_CONFIG) | sed -e s/^CONFIG_ARCH=// -e s/\"//g)
+ifeq ($(ARCH),)
+        undefine ARCH
+endif
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
@@ -287,9 +294,6 @@ endif
 # Where to locate arch specific headers
 hdr-arch  := $(SRCARCH)
 
-KCONFIG_CONFIG	?= .config
-export KCONFIG_CONFIG
-
 # SHELL used by kbuild
 CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
 	  else if [ -x /bin/bash ]; then echo /bin/bash; \
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 7d09e029a779..77c8341af494 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1364,8 +1364,12 @@ static void prop_add_env(const char *env)
 	sym_env_list->right.sym = sym;
 
 	p = getenv(env);
-	if (p)
+	if (p) {
 		sym_add_default(sym, p);
-	else
+		if ((strcmp(sym->name, "ARCH") == 0) ||
+		    (strcmp(sym->name, "CROSS_COMPILE") == 0))
+			sym->flags &= ~SYMBOL_AUTO;
+	} else {
 		menu_warn(current_entry, "environment variable %s undefined", env);
+	}
 }

