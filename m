Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbaFUIJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 04:09:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49957 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbaFUIJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 04:09:53 -0400
Message-ID: <1403338188.6766.6.camel@marge.simpson.net>
Subject: Re: [v3.10-rt / v3.12-rt] scheduling while atomic in cgroup code
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Cc: linux-rt-users@vger.kernel.org,
        "'Alexey Lugovskoy'" <lugovskoy@dev.rtsoft.ru>,
        Konstantin Kholopov <kkholopov@dev.rtsoft.ru>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Date: Sat, 21 Jun 2014 10:09:48 +0200
In-Reply-To: <53A50218.6020506@dev.rtsoft.ru>
References: <53A50218.6020506@dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-21 at 07:55 +0400, Nikita Yushchenko wrote: 
> Hi.
> 
> Call Trace:
> [e22d5a90] [c0007ea8] show_stack+0x4c/0x168 (unreliable)
> [e22d5ad0] [c0618c04] __schedule_bug+0x94/0xb0
> [e22d5ae0] [c060b9ec] __schedule+0x530/0x550
> [e22d5bf0] [c060bacc] schedule+0x30/0xbc
> [e22d5c00] [c060ca24] rt_spin_lock_slowlock+0x180/0x27c
> [e22d5c70] [c00b39dc] res_counter_uncharge_until+0x40/0xc4
> [e22d5ca0] [c013ca88] drain_stock.isra.20+0x54/0x98
> [e22d5cc0] [c01402ac] __mem_cgroup_try_charge+0x2e8/0xbac
> [e22d5d70] [c01410d4] mem_cgroup_charge_common+0x3c/0x70
> [e22d5d90] [c0117284] __do_fault+0x38c/0x510
> [e22d5df0] [c011a5f4] handle_pte_fault+0x98/0x858
> [e22d5e50] [c060ed08] do_page_fault+0x42c/0x6fc
> [e22d5f40] [c000f5b4] handle_page_fault+0xc/0x80
> 
> What happens:
> 
> - refill_stock() calls get_cpu_var() and thus disables preemption until
> matching put_cpu_var() is called,
> 
> - then it calls drain_stock() -> res_counter_uncharge() ->
> res_counter_uncharge_until()
> 
> - and here we have spin_lock(), which under RT can sleep. Thus we have 
> sleeping with preemption disabled.
> 
> 
> Any ideas how to fix?

The below should work.. though not as well as turning it off.

mm, memcg: make refill_stock()/consume_stock() use get_cpu_light()

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
@@ -2398,16 +2398,18 @@ static bool consume_stock(struct mem_cgr
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
 
@@ -2457,14 +2459,17 @@ static void __init memcg_stock_init(void
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


