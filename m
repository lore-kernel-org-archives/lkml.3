Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaG3MUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36809 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 93/94] Fix gcc-4.9.0 miscompilation of load_balance() in scheduler
Date: Wed, 30 Jul 2014 14:15:22 +0200
Message-Id: <36131eb14e40a71fc2e8b9be7b94a8fdd4596ad6.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 4d25b56bf81c..c1a2ffa1e010 100644
--- a/Makefile
+++ b/Makefile
@@ -614,6 +614,8 @@ KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 endif
 
+KBUILD_CFLAGS   += $(call cc-option, -fno-var-tracking-assignments)
+
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -gdwarf-2
-- 
2.0.1

