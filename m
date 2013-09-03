Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab3ICGON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:14:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45593 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3ICGOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:14:11 -0400
Subject: [PATCH] uprobes: Fix limiting un-nested return probes
To: linux-kernel@vger.kernel.org
From: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Cc: Mikhail.Kulemin@ru.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Date: Tue, 03 Sep 2013 11:44:00 +0530
Message-ID: <20130903060959.1351.16587.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090306-7014-0000-0000-0000038DCEBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a sample program which shows a problem in uretprobes:
#include <stdlib.h>

int some_work(int num)
{
        while (num != 0)
                num--;
        return 0;
};

int main(int argc, char **argv)
{
        if (argc != 2)
                return EXIT_FAILURE;

        int num = atoi(argv[1]);
        while(num != 0) {
                some_work(100);
                num--;
        };
        return EXIT_SUCCESS;
}


$ gcc -o sample sample.c

- Add probe for returning from some_work():
$ sudo perf probe -x ./sample -a ret=some_work%return

Added new event:
     probe_sample:ret     (on 0x530%return)

You can now use it in all perf tools, such as:

       perf record -e probe_sample:ret -aR sleep 1

- Record events :
$ sudo perf record -e probe_sample:ret -aR ./sample 134

- View report :
$ sudo perf report --stdio

# captured on: Wed Aug 14 17:03:42 2013
# hostname : hemant-fedora
# os release : 3.11.0-rc3+
# perf version : 3.9.4-200.fc18.x86_64
# arch : x86_64
# nrcpus online : 2
# nrcpus avail : 2
# cpudesc : QEMU Virtual CPU version 1.2.2
# cpuid : GenuineIntel,6,2,3
# total memory : 2051912 kB
# cmdline : /usr/bin/perf record -e probe_sample:ret -aR ./sample 134
# event : name = probe_sample:ret, type = 2, config = 0x38c, config1 =
0x0, config2 = 0x0,
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: software = 1, tracepoint = 2, breakpoint = 5
# ========
#
# Samples: 64  of event 'probe_sample:ret'
# Event count (approx.): 64
#
# Overhead  Command  Shared Object    Symbol
# ........  .......  .............  ........
#
      100.00%   sample  sample         [.] main


#
# (For a higher level overview, try: perf report --sort comm,dso)
#


>From report we can see that there were only 64 return events, but
actually it should be 134. It looks like uprobes identified return
events as recursive events and used restrictions for number of such events.
So, here is a patch which fixes this issue.

--->8---

There exists a limit to the number of nested return probes. The current limit is 64.
However this limit is getting enforced on even non nested return probes.
Hence, registering 64 independent non nested return probes results in failure of
return probes on the same task. The problem is utask->depth is getting incremented
unconditionally but decremented only if chained. So, utask->depth should be 
incremented only if chained. This should fix the issue.

Signed-off-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Reported-by: Mikhail Kulemin <Mikhail.Kulemin@ru.ibm.com>
---
 kernel/events/uprobes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f356974..4fb20fe 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1442,7 +1442,8 @@ static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
 	ri->orig_ret_vaddr = orig_ret_vaddr;
 	ri->chained = chained;
 
-	utask->depth++;
+	if (chained)
+		utask->depth++;
 
 	/* add instance to the stack */
 	ri->next = utask->return_instances;

