Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3JULow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:44:52 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42945 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab3JULov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:44:51 -0400
Subject: [PATCH 0/3] sched: Fixes for task placement in SMT threads
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 21 Oct 2013 17:14:32 +0530
Message-ID: <20131021114002.13291.31478.stgit@drishya>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102111-5140-0000-0000-00000406D858
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series fixes scheduler loadbalancing issues where we are
missing opportunity to place tasks in SMT threads optimally especially
on a POWER7 system.

PATCH 1/3, Fixes the scenario where load balancing fails to move tasks
away from the cpus in a domain which has SHARE_PKG_RESOURCES set even
under the presence of idle cpus in other domains.

PATCH 2/3, ensures lower order SMT threads are used for the
SD_ASYM_PACKING load balancing case.

PATCH 3/3, tries to fix the problem that is explained in its
changelog. The following experiment expose the scenario:

A task placement test was conducted on a POWER7 as well as multi-core
x86 system. At the beginning, tasks are pinned to all the threads
within a core and later only the tasks pinned to the secondary threads
in a core are unpinned. This leaves the primary thread with tasks that
are unmovable, while the rest are free to be moved.

Under the above setup, load balancing today does not move the unpinned
tasks away from the secondary threads of the core in the above
experiment although there are other idle cpus. The PATCH 3/3 fixes
this situation and improves task placement even if some of the tasks
in a core are pinned.

This series applies on v3.12-rc6 and tested on x86 and powerpc.

--Vaidy

---

Preeti U Murthy (2):
      sched: Fix nohz_kick_needed to consider the nr_busy of the parent domain's group
      sched: Aggressive balance in domains whose groups share package resources

Vaidyanathan Srinivasan (1):
      sched: Fix asymmetric scheduling for POWER7


 kernel/sched/fair.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

