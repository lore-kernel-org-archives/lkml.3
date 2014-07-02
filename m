Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaGBMkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:40:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaGBMkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:40:20 -0400
Date: Wed, 2 Jul 2014 14:40:16 +0200
From: Michal Marek <mmarek@suse.cz>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH] Fix compiler message generation
Message-ID: <20140702124016.GA26965@sepie.suse.cz>
References: <20140702105645.17220.92338.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702105645.17220.92338.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 11:56:46AM +0100, David Howells wrote:
> The following commit:
> 
> 	commit 9da0763bdd82572be243fcf5161734f11568960f
> 	Author: Michal Marek <mmarek@suse.cz>
> 	Date:   Fri Apr 25 23:25:18 2014 +0200
> 	Subject: kbuild: Use relative path when building in a subdir of the source tree
> 
> makes compiler messages relative to the *build* tree if the build tree is a
> subdirectory at the root of the source tree.
> 
> This is the wrong thing to do since the make command is issued in the *source*
> tree and so any editor or IDE that issues the make command will likely expect
> paths in warnings and errors to be relative either to the current directory at
> the time the make was issued or to the directory in which make was run.
> 
> Certainly, this is something I'm seeing with emacs.  I do:
> 
> 	LANG=C nice -19 make O=build -C /data/fs/linux-2.6-fscache -j4
> 
> And then I get error messages that look like:
> 
> 	../fs/namei.c: In function 'SYSC_linkat':
> 	../fs/namei.c:4836:57: error: expected declaration specifiers before 'x'
> 		int, newdfd, const char __user *, newname, int, flags)x
> 
> which emacs can't find the source for because it doesn't relate to anything
> emacs knows about.
> 
> As a temporary measure, fix this by substituting the full path of the source
> as make knows it.

Boaz Harrosh hit the same problem with kdevelop and posted a patch that
adds a variable to turn off relative paths:
https://lkml.org/lkml/2014/6/19/295. This has the downside that one has
to remember to set the variable.

However, VPATH builds are not that uncommon, so I guess the editors and
IDEs can actually handle them if make prints the "Entering directory
`blah/blah'" messages. We disable this in kbuild to not pollute the log,
but how about the following patch? I tried it with vim and it worked:


>From 5b59dcacf358f143b9fb39d2f788142ab9ba3e00 Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Wed, 2 Jul 2014 14:28:26 +0200
Subject: [PATCH] kbuild: Print the name of the build directory

With commit 9da0763b (kbuild: Use relative path when building in a
subdir of the source tree), the compiler messages include relative
paths. These are however relative to the build directory, not the
directory where make was started. Print the "Entering directory ..."
message once, so that IDEs/editors can find the source files.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 97b2861..40544a0 100644
--- a/Makefile
+++ b/Makefile
@@ -126,7 +126,10 @@ PHONY += $(MAKECMDGOALS) sub-make
 $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 	@:
 
+# Fake the "Entering directory" message once, so that IDEs/editors are
+# able to understand relative filenames.
 sub-make: FORCE
+	@echo "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
 	KBUILD_SRC=$(CURDIR) \
 	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
-- 
1.8.4.5



> I suspect the correct fix from make's point of view is to issue the build
> command in the build tree and use VPATH to refer to the source, but that would
> likely involve making a lot of Makefiles and would involve a step equivalent
> to autoconf - which is probably not what we want.

The build does run in the build tree with VPATH = $(srctree). The first
make just passes over to a make -C $(objtree).

Michal
