Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3F0T4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:56:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42562 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3F0T4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:56:19 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 03/45] Documentation,
 CPU hotplug: Recommend usage of get/put_online_cpus_atomic()
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        David.Laight@aculab.com
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, sbw@mit.edu, fweisbec@gmail.com,
        zhong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Fri, 28 Jun 2013 01:22:52 +0530
Message-ID: <20130627195252.29830.17952.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
References: <20130627195136.29830.10445.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062719-5490-0000-0000-000003BA3092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able
to depend on disabling preemption to prevent CPUs from going offline
from under us.

So add documentation to recommend using the new get/put_online_cpus_atomic()
APIs to prevent CPUs from going offline, while invoking from atomic context.

Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/cpu-hotplug.txt |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 9f40135..7b3ca60 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -113,13 +113,18 @@ Never use anything other than cpumask_t to represent bitmap of CPUs.
 	#include <linux/cpu.h>
 	get_online_cpus() and put_online_cpus():
 
-The above calls are used to inhibit cpu hotplug operations. While the
+The above calls are used to inhibit cpu hotplug operations, when invoked from
+non-atomic contexts (because the above functions can sleep). While the
 cpu_hotplug.refcount is non zero, the cpu_online_mask will not change.
-If you merely need to avoid cpus going away, you could also use
-preempt_disable() and preempt_enable() for those sections.
-Just remember the critical section cannot call any
-function that can sleep or schedule this process away. The preempt_disable()
-will work as long as stop_machine_run() is used to take a cpu down.
+
+However, if you are executing in atomic context (ie., you can't afford to
+sleep), and you merely need to avoid cpus going offline, you can use
+get_online_cpus_atomic() and put_online_cpus_atomic() for those sections.
+Just remember the critical section cannot call any function that can sleep or
+schedule this process away. Using preempt_disable() will also work, as long
+as stop_machine() is used to take a CPU down. But we are going to get rid of
+stop_machine() in the CPU offline path soon, so it is strongly recommended
+to use the APIs mentioned above.
 
 CPU Hotplug - Frequently Asked Questions.
 
@@ -360,6 +365,9 @@ A: There are two ways.  If your code can be run in interrupt context, use
 		return err;
 	}
 
+   If my_func_on_cpu() itself cannot block, use get/put_online_cpus_atomic()
+   instead of get/put_online_cpus(), to prevent CPUs from going offline.
+
 Q: How do we determine how many CPUs are available for hotplug.
 A: There is no clear spec defined way from ACPI that can give us that
    information today. Based on some input from Natalie of Unisys,

