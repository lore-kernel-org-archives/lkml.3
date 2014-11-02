Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaKBHbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:31:18 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44421 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaKBHbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:31:13 -0500
Message-ID: <1414913469.5380.113.camel@marge.simpson.net>
Subject: 3.14.23-rt20 - mm,memcg: make refill_stock()/consume_stock() use
 get_cpu_light()
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Sun, 02 Nov 2014 08:31:09 +0100
In-Reply-To: <1414910967.5380.81.camel@marge.simpson.net>
References: <20141031170326.1491a63f@gandalf.local.home>
	 <1414910967.5380.81.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikita reported the following memcg scheduling while atomic bug:

Call Trace:
[e22d5a90] [c0007ea8] show_stack+0x4c/0x168 (unreliable)
[e22d5ad0] [c0618c04] __schedule_bug+0x94/0xb0
[e22d5ae0] [c060b9ec] __schedule+0x530/0x550
[e22d5bf0] [c060bacc] schedule+0x30/0xbc
[e22d5c00] [c060ca24] rt_spin_lock_slowlock+0x180/0x27c
[e22d5c70] [c00b39dc] res_counter_uncharge_until+0x40/0xc4
[e22d5ca0] [c013ca88] drain_stock.isra.20+0x54/0x98
[e22d5cc0] [c01402ac] __mem_cgroup_try_charge+0x2e8/0xbac
[e22d5d70] [c01410d4] mem_cgroup_charge_common+0x3c/0x70
[e22d5d90] [c0117284] __do_fault+0x38c/0x510
[e22d5df0] [c011a5f4] handle_pte_fault+0x98/0x858
[e22d5e50] [c060ed08] do_page_fault+0x42c/0x6fc
[e22d5f40] [c000f5b4] handle_page_fault+0xc/0x80

What happens:

   refill_stock()
      get_cpu_var()
      drain_stock()
         res_counter_uncharge()
            res_counter_uncharge_until()
               spin_lock() <== boom

Fix it by replacing get/put_cpu_var() with get/put_cpu_light().

Reported-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 mm/memcontrol.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2438,16 +2438,18 @@ static bool consume_stock(struct mem_cgr
 {
 	struct memcg_stock_pcp *stock;
 	bool ret = true;
+	int cpu;
 
 	if (nr_pages > CHARGE_BATCH)
 		return false;
 
-	stock = &get_cpu_var(memcg_stock);
+	cpu = get_cpu_light();
+	stock = &per_cpu(memcg_stock, cpu);
 	if (memcg == stock->cached && stock->nr_pages >= nr_pages)
 		stock->nr_pages -= nr_pages;
 	else /* need to call res_counter_charge */
 		ret = false;
-	put_cpu_var(memcg_stock);
+	put_cpu_light();
 	return ret;
 }
 
@@ -2497,14 +2499,17 @@ static void __init memcg_stock_init(void
  */
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
-	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
+	struct memcg_stock_pcp *stock;
+	int cpu = get_cpu_light();
+
+	stock = &per_cpu(memcg_stock, cpu);
 
 	if (stock->cached != memcg) { /* reset if necessary */
 		drain_stock(stock);
 		stock->cached = memcg;
 	}
 	stock->nr_pages += nr_pages;
-	put_cpu_var(memcg_stock);
+	put_cpu_light();
 }
 
 /*





