Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3FFRGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3FFRGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:06:05 -0400
Date: Thu, 6 Jun 2013 13:05:58 -0400
From: Kyle McMartin <kyle@redhat.com>
To: linux-kbuild@vger.kernel.org
Cc: mmarek@suse.cz, rob@landley.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH] Kbuild: pass headers to headers_install.sh on stdin
Message-ID: <20130606170557.GQ14762@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While using make V=1 to test some things, I noticed on our builders that
headers_install was failing because the argument list to /bin/sh was too
long. Working around it is slightly kludgy...

First, passing the args list to headers_install.sh via stdin instead of
as arguments.
Secondly, filtering $srctree out of $input-files to reduce the length of
the args list to the subshell.
Lastly, re-add $srctree when we loop over $input-files and pass the file
list back through to headers_install.sh.

You can reproduce the issue locally by putting your build dir in a
long path.

make[2]: execvp: /bin/sh: Argument list too long
make[2]: ***
[/home/kyle/A(lots of times)/linux/usr/include/linux/.install]
Error 127
make[1]: *** [linux] Error 2
make: *** [headers_install] Error 2

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -59,6 +59,8 @@ input-files   := $(foreach hdr, $(header-y), \
 			$(wildcard $(gendir)/$(hdr)), \
 			$(error Missing generated UAPI file $(gendir)/$(hdr)) \
 		   ))
+input-files    := $(foreach hdr, $(input-files), \
+		    $(subst $(srctree)/,,$(hdr)))
 
 # Work out what needs to be removed
 oldheaders    := $(patsubst $(installdir)/%,%,$(wildcard $(installdir)/*.h))
@@ -72,7 +74,9 @@ printdir = $(patsubst $(INSTALL_HDR_PATH)/%/,%,$(dir $@))
 quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
                             file$(if $(word 2, $(all-files)),s))
       cmd_install = \
-        $(CONFIG_SHELL) $< $(installdir) $(input-files); \
+        for f in $(input-files); do \
+                echo "$(srctree)/$$f"; \
+        done | $(CONFIG_SHELL) $< $(installdir); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(installdir)/$$F;    \
         done;                                                           \
diff --git a/scripts/headers_install.sh b/scripts/headers_install.sh
index 643764f..4e53688 100644
--- a/scripts/headers_install.sh
+++ b/scripts/headers_install.sh
@@ -2,7 +2,7 @@
 
 if [ $# -lt 1 ]
 then
-	echo "Usage: headers_install.sh OUTDIR [FILES...]
+	echo "Usage: FILES | headers_install.sh OUTDIR
 	echo
 	echo "Prepares kernel header files for use by user space, by removing"
 	echo "all compiler.h definitions and #includes, removing any"
@@ -10,7 +10,7 @@ then
 	echo "asm/inline/volatile keywords."
 	echo
 	echo "OUTDIR: directory to write each userspace header FILE to."
-	echo "FILES:  list of header files to operate on."
+	echo "FILES:  list of header files to operate on, passed stdin."
 
 	exit 1
 fi
@@ -18,13 +18,12 @@ fi
 # Grab arguments
 
 OUTDIR="$1"
-shift
 
 # Iterate through files listed on command line
 
 FILE=
 trap 'rm -f "$OUTDIR/$FILE" "$OUTDIR/$FILE.sed"' EXIT
-for i in "$@"
+while read i
 do
 	FILE="$(basename "$i")"
 	sed -r \
