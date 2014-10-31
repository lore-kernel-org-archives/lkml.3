Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbaJaKzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:55:33 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45666 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbaJaKza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:55:30 -0400
Subject: [PATCH perf/core 1/6] [BUGFIX] perf-probe: Fix to handle optimized
 not-inlined but has no instance
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 31 Oct 2014 14:51:36 -0400
Message-ID: <20141031185136.27889.54332.stgit@localhost.localdomain>
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain>
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to handle optimized no-inline functions which have
only function definition but no actual instance at
that point. To fix this problem, we need to find actual
instance of the function.

Without this patch:
  ----
  # perf probe -a __up
  Failed to get entry address of __up.
    Error: Failed to add events.
  # perf probe -L __up
  Specified source line is not found.
    Error: Failed to show lines.
  ----

With this patch:
  ----
  # perf probe -a __up
  Added new event:
    probe:__up           (on __up)

  You can now use it in all perf tools, such as:

          perf record -e probe:__up -aR sleep 1

  # perf probe -L __up
  <__up@/home/fedora/ksrc/linux-3/kernel/locking/semaphore.c:0>
        0  static noinline void __sched __up(struct semaphore *sem)
           {
                  struct semaphore_waiter *waiter = list_first_entry(&sem->wait_
                                                          struct semaphore_waite
        4         list_del(&waiter->list);
        5         waiter->up = true;
        6         wake_up_process(waiter->task);
        7  }
  ----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/util/dwarf-aux.c    |   15 +++++++++++++++
 tools/perf/util/dwarf-aux.h    |    3 +++
 tools/perf/util/probe-finder.c |   12 ++++--------
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index cc66c40..780b2bc 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -278,6 +278,21 @@ bool die_is_func_def(Dwarf_Die *dw_die)
 }
 
 /**
+ * die_is_func_instance - Ensure that this DIE is an instance of a subprogram
+ * @dw_die: a DIE
+ *
+ * Ensure that this DIE is an instance (which has an entry address).
+ * This returns true if @dw_die is a function instance. If not, you need to
+ * call die_walk_instances() to find actual instances.
+ **/
+bool die_is_func_instance(Dwarf_Die *dw_die)
+{
+	Dwarf_Addr tmp;
+
+	/* Actually gcc optimizes non-inline as like as inlined */
+	return !dwarf_func_inline(dw_die) && dwarf_entrypc(dw_die, &tmp) == 0;
+}
+/**
  * die_get_data_member_location - Get the data-member offset
  * @mb_die: a DIE of a member of a data structure
  * @offs: The offset of the member in the data structure
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index b4fe90c..af7dbcd 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -41,6 +41,9 @@ extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 /* Ensure that this DIE is a subprogram and definition (not declaration) */
 extern bool die_is_func_def(Dwarf_Die *dw_die);
 
+/* Ensure that this DIE is an instance of a subprogram */
+extern bool die_is_func_instance(Dwarf_Die *dw_die);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c7918f8..1914dfd 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -915,17 +915,13 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 		dwarf_decl_line(sp_die, &pf->lno);
 		pf->lno += pp->line;
 		param->retval = find_probe_point_by_line(pf);
-	} else if (!dwarf_func_inline(sp_die)) {
+	} else if (die_is_func_instance(sp_die)) {
+		/* Instances always have the entry address */
+		dwarf_entrypc(sp_die, &pf->addr);
 		/* Real function */
 		if (pp->lazy_line)
 			param->retval = find_probe_point_lazy(sp_die, pf);
 		else {
-			if (dwarf_entrypc(sp_die, &pf->addr) != 0) {
-				pr_warning("Failed to get entry address of "
-					   "%s.\n", dwarf_diename(sp_die));
-				param->retval = -ENOENT;
-				return DWARF_CB_ABORT;
-			}
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
 			param->retval = call_probe_finder(sp_die, pf);
@@ -1520,7 +1516,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 		pr_debug("New line range: %d to %d\n", lf->lno_s, lf->lno_e);
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		if (dwarf_func_inline(sp_die))
+		if (!die_is_func_instance(sp_die))
 			param->retval = die_walk_instances(sp_die,
 						line_range_inline_cb, lf);
 		else


