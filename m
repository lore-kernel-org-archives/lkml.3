Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3H3PSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:18:50 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53852 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3H3PSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:18:48 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] tools: perf: Fix liblk not built when using perf_install target
Date: Fri, 30 Aug 2013 17:18:36 +0200
Message-Id: <1377875916-5208-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a successful Linux-kernel build I wanted to build only perf
as a linux-tools to do some benchmarking of the spinlock-lockref
changes together with a test-case from Linus.

I followed the advices in "tools/Makefile".

[ tools/Makefile ]
...
        @echo 'You can do:'
        @echo ' $$ make -C tools/ <tool>_install' <--- NOTE THIS ONE!
        @echo ''
        @echo '  from the kernel command line to build and install one of'
        @echo '  the tools above'
...

So, I tried to build perf the "official" way:

   $ make -C tools/ perf_install

Unfortunately, my build breaks like this:
...
make[2]: Entering directory
`~/src/linux-kernel/linux/tools/lib/traceevent'
make[2]: Leaving directory
`~/src/linux-kernel/linux/tools/lib/traceevent'
    LINK perf
gcc: error: ~/src/linux-kernel/linux/tools/lib/lk/liblk.a: No such file or directory
make[1]: *** [perf] Error 1
make[1]: Leaving directory `~/src/linux-kernel/linux/tools/perf'
make: *** [perf_install] Error 2

After some discussion on IRC with peterz and acme and a closer look at
the targets in "tools/Makefile", I have noticed that the perf_install
target misses liblk to be built beforehand.
On the contrary the perf_clean target invokes to clean liblk when perf
is cleaned.

[ tools/Makefile ]
...
perf_clean: liblk_clean
	$(call descend,$(@:_clean=),clean)
...

Fix this by adding liblk target to perf_install target.

For more details see this thread in [1]:
"[3.11-rc7] Building perf-only the "official" way seems to be BROKEN?"

[1] http://marc.info/?t=137786599400001&r=1&w=2

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 tools/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/Makefile b/tools/Makefile
index 41067f3..c15f0e7 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -53,7 +53,10 @@ turbostat x86_energy_perf_policy: FORCE
 cpupower_install:
 	$(call descend,power/$(@:_install=),install)
 
-cgroup_install firewire_install lguest_install perf_install usb_install virtio_install vm_install net_install:
+cgroup_install firewire_install lguest_install usb_install virtio_install vm_install net_install:
+	$(call descend,$(@:_install=),install)
+
+perf_install: liblk
 	$(call descend,$(@:_install=),install)
 
 selftests_install:
-- 
1.8.4

