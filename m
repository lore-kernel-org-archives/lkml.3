Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaGBK5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:57:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbaGBK5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:57:01 -0400
Subject: [PATCH] Fix compiler message generation
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, mmarek@suse.cz, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Wed, 02 Jul 2014 11:56:46 +0100
Message-ID: <20140702105645.17220.92338.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit:

	commit 9da0763bdd82572be243fcf5161734f11568960f
	Author: Michal Marek <mmarek@suse.cz>
	Date:   Fri Apr 25 23:25:18 2014 +0200
	Subject: kbuild: Use relative path when building in a subdir of the source tree

makes compiler messages relative to the *build* tree if the build tree is a
subdirectory at the root of the source tree.

This is the wrong thing to do since the make command is issued in the *source*
tree and so any editor or IDE that issues the make command will likely expect
paths in warnings and errors to be relative either to the current directory at
the time the make was issued or to the directory in which make was run.

Certainly, this is something I'm seeing with emacs.  I do:

	LANG=C nice -19 make O=build -C /data/fs/linux-2.6-fscache -j4

And then I get error messages that look like:

	../fs/namei.c: In function 'SYSC_linkat':
	../fs/namei.c:4836:57: error: expected declaration specifiers before 'x'
		int, newdfd, const char __user *, newname, int, flags)x

which emacs can't find the source for because it doesn't relate to anything
emacs knows about.

As a temporary measure, fix this by substituting the full path of the source
as make knows it.

I suspect the correct fix from make's point of view is to issue the build
command in the build tree and use VPATH to refer to the source, but that would
likely involve making a lot of Makefiles and would involve a step equivalent
to autoconf - which is probably not what we want.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Michal Marek <mmarek@suse.cz>
cc: Sam Ravnborg <sam@ravnborg.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/Makefile b/Makefile
index 1317563..def4a75 100644
--- a/Makefile
+++ b/Makefile
@@ -155,7 +155,7 @@ ifeq ($(KBUILD_SRC),)
 else
         ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
                 # building in a subdirectory of the source tree
-                srctree := ..
+                srctree := $(realpath ..)
         else
                 srctree := $(KBUILD_SRC)
         endif

