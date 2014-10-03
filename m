Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaJCF27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:28:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJCF22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:28:28 -0400
Date: Thu, 2 Oct 2014 22:27:26 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-728e5653e6fdb2a0892e94a600aef8c9a036c7eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        imammedo@redhat.com, torvalds@linux-foundation.org,
        peterz@infradead.org, jan.kiszka@siemens.com, toshi.kani@hp.com,
        tianyu.lan@intel.com, dave@sr71.net, akpm@linux-foundation.org,
        tglx@linutronix.de, dave.hansen@linux.intel.com, prarit@redhat.com,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        imammedo@redhat.com, torvalds@linux-foundation.org,
        peterz@infradead.org, jan.kiszka@siemens.com, dave@sr71.net,
        tianyu.lan@intel.com, toshi.kani@hp.com, akpm@linux-foundation.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, rientjes@google.com,
        prarit@redhat.com
In-Reply-To: <20140930214546.FD481CFF@viggo.jf.intel.com>
References: <20140930214546.FD481CFF@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/x86: Fix up typo in topology detection
Git-Commit-ID: 728e5653e6fdb2a0892e94a600aef8c9a036c7eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  728e5653e6fdb2a0892e94a600aef8c9a036c7eb
Gitweb:     http://git.kernel.org/tip/728e5653e6fdb2a0892e94a600aef8c9a036c7eb
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Tue, 30 Sep 2014 14:45:46 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 05:46:52 +0200

sched/x86: Fix up typo in topology detection

Commit:

  cebf15eb09a2 ("x86, sched: Add new topology for multi-NUMA-node CPUs")

some code to try to detect the situation where we have a NUMA node
inside of the "DIE" sched domain.

It detected this by looking for cpus which match_die() but do not match
NUMA nodes via topology_same_node().

I wrote it up as:

	if (match_die(c, o) == !topology_same_node(c, o))

which actually seemed to work some of the time, albiet
accidentally.

It should have been doing an &&, not an ==.

This code essentially chopped off the "DIE" domain on one of
Andrew Morton's systems.  He reported that this patch fixed his
issue.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Link: http://lkml.kernel.org/r/20140930214546.FD481CFF@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8de8eb7..bae9e09 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -445,7 +445,7 @@ void set_cpu_sibling_map(int cpu)
 			} else if (i != cpu && !c->booted_cores)
 				c->booted_cores = cpu_data(i).booted_cores;
 		}
-		if (match_die(c, o) == !topology_same_node(c, o))
+		if (match_die(c, o) && !topology_same_node(c, o))
 			primarily_use_numa_for_topology();
 	}
 }
