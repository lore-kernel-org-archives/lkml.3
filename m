Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3F3BzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 21:55:22 -0400
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:35581
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3F3BzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 21:55:14 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jun 2013 21:55:14 EDT
To: linux-kernel@vger.kernel.org
Subject: trouble building 'perf' for 3.9.7
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
Date: Sat, 29 Jun 2013 19:47:00 -0600
Message-ID: <g38s0l697.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.101 (Gnus v5.10.10) XEmacs/21.5-b33 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greetings.

I'm working on an embedded project (developing on x86-64, targeting ppc32).

My build system goes through and builds targets in a certain order:

  u-boot
  kernel (uImage, modules, headers)
  elftools
  perf
  ... lots more ...

(Yes, if I had understood how all the parts fit together 4 years ago,
I would use open embedded or yocto or something else.  Oh well.)

Anyway, this worked fine for 2.6.late, as well as 3.0 stable and 3.4
stable.  However, I wanted the improvements to 'usbip', so I switched
to 3.9; currently I'm using 3.9.7.

Using exactly the same scripts (see below), perf now fails to build:

    In file included from util/include/linux/list.h:4:0,
                     from util/parse-events.h:7,
                     from perf.c:15:
    util/include/../../../../include/linux/list.h:24:42: error: 'struct list_head' declared inside parameter list [-Werror]
    util/include/../../../../include/linux/list.h:24:42: error: its scope is only this definition or declaration, which is probably not what you want [-Werror]

This seems to be fallout from the UAPI split, which came in about 3.7 or so:

    commit 607ca46e97a1b6594b29647d98a32d545c24bdff
    Author: David Howells <dhowells@redhat.com>
    Date:   Sat Oct 13 10:46:48 2012 +0100

        UAPI: (Scripted) Disintegrate include/linux
        
        Signed-off-by: David Howells <dhowells@redhat.com>
        Acked-by: Arnd Bergmann <arnd@arndb.de>
        Acked-by: Thomas Gleixner <tglx@linutronix.de>
        Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
        Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
        Acked-by: Dave Jones <davej@redhat.com>

Looking through the preprocessed source, the problem seems to be that
'perf' eventually asks for <linux/types.h>.  Before the UAPI split,
this file included the list_head structure; aftwerwards, it didn't.

I've tried various combinations of cpp flags to get the code to look
in the unpacked source first, before looking in the installed headers,
but I can't seem to make that work, either.

(Among other issues is that I need to use the elfutils built for this
project; if I try to move my project's include directory to the end of
the search list with "-idirafter", then the elfutils for the
cross-compiler itself are caught; if the include directory is any
earlier, perf picks up the sanitized linux/ directory.)

There are other reports of similar breakage:

  http://marc.info/?l=linux-kernel&m=135095162403283
  Re: tools/vm build fails

  http://lkml.indiana.edu/hypermail/linux/kernel/1212.1/02045.html
  Commit 607ca46e97a1b6594b29647d98a32d545c24bdff breaks building tools/hv/hv_kvp_daemon.c

And it has similar pattern (although for not exactly the same reasons) as 

  http://lkml.indiana.edu/hypermail/linux/kernel/1008.1/00601.html
  perf build broke by list_head changes...

Anyway, my scripts are fairly straightforward.  After my cross-compile
toolchain is built, I have the following environment variables:

  TARGET_TUPLE=powerpc-e300c3-linux-gnu
  PLATFORM_STAGE=/opt/cross/stage
  PLATFORM_BOOT=/opt/cross/boot

I build the kernel like so, and this works fine:

    version=3.9.7-ajf-mumble
    build=$( cd ../build ; pwd )
    arch=${TARGET_TUPLE%%-*}
 
    yes "" | make O="$build" ARCH="$arch" CROSS_COMPILE="$TARGET_TUPLE"- \
         oldconfig || exit $?
 
    rm -rf "$PLATFORM_STAGE"/lib/modules
    make O="$build" ARCH="$arch" CROSS_COMPILE="$TARGET_TUPLE"- \
         $MAKE_PARALLEL_ARGS uImage modules || exit $?

    cp "$build/arch/$arch/boot/uImage" "$PLATFORM_BOOT" || exit $?
    cp "$build/vmlinux"                "$PLATFORM_BOOT" || exit $?
    make O="$build" ARCH="$arch" CROSS_COMPILE="$TARGET_TUPLE"- \
         INSTALL_MOD_PATH="$PLATFORM_STAGE" \
         INSTALL_HDR_PATH="$PLATFORM_STAGE/include/linux-$version" \
         headers_install modules_install || exit $?

    ( cd "$PLATFORM_STAGE/include"
        rmdir linux
        ln -sf "linux-$version"/include/* . )

(Yes, I'm aware I should be using 'olddefconfig' and 'set -e'.  The
joys of hindsight.)

To build perf, I do something similar (but in a freshly-unpacked copy
of the kernel tree -- an artifact of my desire to be able to restart
the build process at any stage):

    build=$( cd ../build ; pwd )
    arch=${TARGET_TUPLE%%-*}
 
    yes "" | make O="$build" ARCH="$arch" CROSS_COMPILE="$TARGET_TUPLE"- \
         oldconfig || exit $?
 
    (
        cd tools/perf
        make O="$build" ARCH="$arch" CROSS_COMPILE="$TARGET_TUPLE"- V=1 \
             EXTRA_CFLAGS="-I $PLATFORM_STAGE/include -I $PLATFORM_STAGE/include/elfutils" \
             LDFLAGS="-L$PLATFORM_STAGE/lib -lz -lbz2" \
             DESTDIR="$PLATFORM_STAGE" \
             install || exit $?
    )

Again, this all worked fine for 3.4.

Is there an obvious fix for 3.9?

Many thanks in advance.

Best regards,
Anthony Foiani
