Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbaHHUqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:46:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900AbaHHUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jakub Jelinek <jakub@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 177/259] Fix gcc-4.9.0 miscompilation of load_balance()  in scheduler
Date: Fri,  8 Aug 2014 13:40:00 -0700
Message-Id: <1407530482-4483-178-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index e1fa2a4..3ad2dc5 100644
--- a/Makefile
+++ b/Makefile
@@ -617,6 +617,8 @@ KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 endif
 
+KBUILD_CFLAGS   += $(call cc-option, -fno-var-tracking-assignments)
+
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2
-- 
1.9.1

