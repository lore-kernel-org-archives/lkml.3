Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaHUMsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbaHUMsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:48:38 -0400
Subject: [PATCH] Fix ELF e_flags propagation through built-in.o construction
From: David Howells <dhowells@redhat.com>
To: mmarek@suse.cz
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Thu, 21 Aug 2014 13:48:32 +0100
Message-ID: <20140821124832.22445.27923.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The built-in.o files are constructed in one of two ways:

 (1) If there are contributory .o files, an incremental link (ld -r) is
     performed to generate built-in.o.

 (2) If there are _no_ contributory .o files, an empty archive file (ar) is
     generated as built-in.o.

Unfortunately, with (2), if this is then incrementally linked into another
built-in.o file, the e_flags field in the ELF header may not have been set.
For instance, compare:

	>sh64-linux-gnu-ar rcsD a.o
	>sh64-linux-gnu-ld -r -EL -mshlelf64 -belf64-sh64l -o b.o a.o
	>sh64-linux-gnu-readelf -h b.o | grep Flags
	Flags:                             0x0

to:

	>sh64-linux-gnu-gcc -x c -c - -o zero.o </dev/null
	>sh64-linux-gnu-readelf -h zero.o | grep Flags
	Flags:                             0xa, sh5

Attempting to further incrementally link b.o generated above gets an error
because e_flags is not set.

	>sh64-linux-gnu-ld -r -EL -mshlelf64 -belf64-sh64l -o c.o b.o
	sh64-linux-gnu-ld: unknown architecture of input file `b.o' is incompatible with sh5 output

Further, but probably not relevant to the kernel, if an archive file is
constructed that has some constituent object files in it, passing that to an
incremental link, eg:

	#!/bin/sh -x
	CROSS=sh64-linux-gnu-
	LDFLAGS="-EL -mshlelf64 -belf64-sh64l"
	#LDARFLAGS=--whole-archive
	CFLAGS="-m5-64media-nofpu -ml"
	rm -f hello.o wibble.o foo.o bar.o
	echo 'int hello(int i) {return i + 42;}' |
	    ${CROSS}gcc $CFLAGS -x c -c - -o hello.o || exit $?
	${CROSS}readelf -h hello.o | grep Flags
	${CROSS}ar rcsD wibble.o hello.o || exit $?
	${CROSS}ld $LDFLAGS $LDARFLAGS -r -o foo.o wibble.o || exit $?
	${CROSS}readelf -h foo.o | grep Flags
	${CROSS}ld $LDFLAGS -r -o bar.o foo.o || exit $?
	${CROSS}readelf -h bar.o | grep Flags

won't propagate e_flags _unless_ --whole-archive is also passed to the linker.

	+ CROSS=sh64-linux-gnu-
	+ LDFLAGS='-EL -mshlelf64'
	+ CFLAGS='-m5-64media-nofpu -ml'
	+ rm -f hello.o wibble.o foo.o bar.o
	+ echo 'int hello(int i) {return i + 42;}'
	+ sh64-linux-gnu-gcc -m5-64media-nofpu -ml -x c -c - -o hello.o
	+ sh64-linux-gnu-readelf -h hello.o
	+ grep Flags
	  Flags:                             0xa, sh5
	+ sh64-linux-gnu-ar rcsD wibble.o hello.o
	+ sh64-linux-gnu-ld -EL -mshlelf64 -r -o foo.o wibble.o
	+ sh64-linux-gnu-readelf -h foo.o
	+ grep Flags
	  Flags:                             0x0
	+ sh64-linux-gnu-ld -EL -mshlelf64 -r -o bar.o foo.o
	sh64-linux-gnu-ld: unknown architecture of input file `foo.o' is incompatible with sh5 output

To this end, change the construction of empty built-in.o files (case (2)
above) to use gcc on an empty file.

There is a binutils bug logged for this:

	https://sourceware.org/bugzilla/show_bug.cgi?id=17288

Signed-off-by: David Howells <dhowells@redhat.com>
---
 0 files changed

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e6778cd71..5bd80ef22866 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -330,7 +330,7 @@ quiet_cmd_link_o_target = LD      $@
 cmd_link_o_target = $(if $(strip $(obj-y)),\
 		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^) \
 		      $(cmd_secanalysis),\
-		      rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@)
+		      $(CC) $(c_flags) -x c -c - -o $@ </dev/null)
 
 $(builtin-target): $(obj-y) FORCE
 	$(call if_changed,link_o_target)

