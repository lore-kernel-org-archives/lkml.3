Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaFJNXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:23:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaFJNXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:23:38 -0400
Date: Tue, 10 Jun 2014 15:23:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: [PATCH] tell gcc optimizer to never introduce new data races
Message-ID: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been chasing a memory corruption bug, which turned out to be 
caused by very old gcc (4.3.4), which happily turned conditional load into 
a non-conditional one, and that broke correctness (the condition was met 
only if lock was held) and corrupted memory.

This particular problem with that particular code did not happen when 
never gccs were used. I've brought this up with our gcc folks, as I wanted 
to make sure that this can't really happen again, and it turns out it 
actually can.

Quoting Martin Jambor <mjambor@suse.cz>:

====
More current GCCs are more careful when it comes to replacing a
conditional load with a non-conditional one, most notably they check
that a store happens in each iteration of _a_ loop but they assume
loops are executed.  They also perform a simple check whether the
store cannot trap which currently passes only for non-const
variables.  A simple testcase demonstrating it on an x86_64 is for
example the following:

$ cat cond_store.c

int g_1 = 1;

int g_2[1024] __attribute__((section ("safe_section"), aligned (4096)));

int c = 4;

int __attribute__ ((noinline))
foo (void)
{
  int l;
  for (l = 0; (l != 4); l++) {
    if (g_1)
      return l;
    for (g_2[0] = 0; (g_2[0] >= 26); ++g_2[0])
      ;
  }
  return 2;
}

int main (int argc, char* argv[])
{
  if (mprotect (g_2, sizeof(g_2), PROT_READ) == -1)
    {
      int e = errno;
      error (e, e, "mprotect error %i", e);
    }
  foo ();
  __builtin_printf("OK\n");
  return 0;
}
/* EOF */
$ ~/gcc/trunk/inst/bin/gcc cond_store.c -O2 --param allow-store-data-races=0
$ ./a.out
OK
$ ~/gcc/trunk/inst/bin/gcc cond_store.c -O2 --param allow-store-data-races=1
$ ./a.out
Segmentation fault

The testcase fails the same at least with 4.9, 4.8 and 4.7.  Therefore
I would suggest building kernels with this parameter set to zero. I
also agree with Jikos that the default should be changed for -O2.  I
have run most of the SPEC 2k6 CPU benchmarks (gamess and dealII
failed, at -O2, not sure why) compiled with and without this option
and did not see any real difference between respective run-times.
====

Hopefully the default will be changed in newer gccs, but let's force
it for kernel builds so that we are on a safe side even when older
gcc are used.

Cc: Martin Jambor <mjambor@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 00a933b..613367f 100644
--- a/Makefile
+++ b/Makefile
@@ -585,6 +585,9 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+# Tell gcc to never replace conditional load with a non-conditional one
+KBUILD_CFLAGS	+= $(call cc-option,--param allow-store-data-races=0)
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifdef CONFIG_READABLE_ASM

-- 
Jiri Kosina
SUSE Labs
