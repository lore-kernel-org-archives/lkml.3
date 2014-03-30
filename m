Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaC3XdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36536 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jakub Jelinek" <jakub@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Richard Henderson" <rth@twiddle.net>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Steven Noonan" <steven@uplinklabs.net>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.407981720@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 109/200] compiler/gcc4: Make quirk for asm_volatile_goto()
 unconditional
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Noonan <steven@uplinklabs.net>

commit a9f180345f5378ac87d80ed0bea55ba421d83859 upstream.

I started noticing problems with KVM guest destruction on Linux
3.12+, where guest memory wasn't being cleaned up. I bisected it
down to the commit introducing the new 'asm goto'-based atomics,
and found this quirk was later applied to those.

Unfortunately, even with GCC 4.8.2 (which ostensibly fixed the
known 'asm goto' bug) I am still getting some kind of
miscompilation. If I enable the asm_volatile_goto quirk for my
compiler, KVM guests are destroyed correctly and the memory is
cleaned up.

So make the quirk unconditional for now, until bug is found
and fixed.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/1392274867-15236-1-git-send-email-steven@uplinklabs.net
Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/compiler-gcc4.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -39,11 +39,7 @@
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
-#if GCC_VERSION <= 40801
-# define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
-#else
-# define asm_volatile_goto(x...)	do { asm goto(x); } while (0)
-#endif
+#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
 
 #if __GNUC_MINOR__ >= 5
 /*

