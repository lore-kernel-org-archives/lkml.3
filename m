Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaIKNET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031AbaIKNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Markus Trippelsdorf" <markus@trippelsdorf.de>,
        "Michel =?UTF-8?Q?D=C3=A4nzer?=" <michel@daenzer.net>,
        "Jakub Jelinek" <jakub@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.934314136@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 024/131] Fix gcc-4.9.0 miscompilation of
 load_balance()  in scheduler
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2062afb4f804afef61cbe62a30cac9a46e58e067 upstream.

Michel Dänzer and a couple of other people reported inexplicable random
oopses in the scheduler, and the cause turns out to be gcc mis-compiling
the load_balance() function when debugging is enabled.  The gcc bug
apparently goes back to gcc-4.5, but slight optimization changes means
that it now showed up as a problem in 4.9.0 and 4.9.1.

The instruction scheduling problem causes gcc to schedule a spill
operation to before the stack frame has been created, which in turn can
corrupt the spilled value if an interrupt comes in.  There may be other
effects of this bug too, but that's the code generation problem seen in
Michel's case.

This is fixed in current gcc HEAD, but the workaround as suggested by
Markus Trippelsdorf is pretty simple: use -fno-var-tracking-assignments
when compiling the kernel, which disables the gcc code that causes the
problem.  This can result in slightly worse debug information for
variable accesses, but that is infinitely preferable to actual code
generation problems.

Doing this unconditionally (not just for CONFIG_DEBUG_INFO) also allows
non-debug builds to verify that the debug build would be identical: we
can do

    export GCC_COMPARE_DEBUG=1

to make gcc internally verify that the result of the build is
independent of the "-g" flag (it will make the compiler build everything
twice, toggling the debug flag, and compare the results).

Without the "-fno-var-tracking-assignments" option, the build would fail
(even with 4.8.3 that didn't show the actual stack frame bug) with a gcc
compare failure.

See also gcc bugzilla:

  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61801

Reported-by: Michel Dänzer <michel@daenzer.net>
Suggested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -592,6 +592,8 @@ KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 endif
 
+KBUILD_CFLAGS   += $(call cc-option, -fno-var-tracking-assignments)
+
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2

