Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaLEQnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:43:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaLEQl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:41:56 -0500
From: Michal Hocko <mhocko@suse.cz>
To: <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH -v2 4/5] sysrq: convert printk to pr_* equivalent
Date: Fri,  5 Dec 2014 17:41:46 +0100
Message-Id: <1417797707-31699-5-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417797707-31699-1-git-send-email-mhocko@suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While touching this area let's convert printk to pr_*. This also makes
the printing of continuation lines done properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 drivers/tty/sysrq.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 42bad18c66c9..0071469ecbf1 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -90,7 +90,7 @@ static void sysrq_handle_loglevel(int key)
 
 	i = key - '0';
 	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
-	printk("Loglevel set to %d\n", i);
+	pr_info("Loglevel set to %d\n", i);
 	console_loglevel = i;
 }
 static struct sysrq_key_op sysrq_loglevel_op = {
@@ -220,7 +220,7 @@ static void showacpu(void *dummy)
 		return;
 
 	spin_lock_irqsave(&show_lock, flags);
-	printk(KERN_INFO "CPU%d:\n", smp_processor_id());
+	pr_info("CPU%d:\n", smp_processor_id());
 	show_stack(NULL, NULL);
 	spin_unlock_irqrestore(&show_lock, flags);
 }
@@ -243,7 +243,7 @@ static void sysrq_handle_showallcpus(int key)
 		struct pt_regs *regs = get_irq_regs();
 
 		if (regs) {
-			printk(KERN_INFO "CPU%d:\n", smp_processor_id());
+			pr_info("CPU%d:\n", smp_processor_id());
 			show_regs(regs);
 		}
 		schedule_work(&sysrq_showallcpus);
@@ -522,7 +522,7 @@ void __handle_sysrq(int key, bool check_mask)
 	 */
 	orig_log_level = console_loglevel;
 	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
-	printk(KERN_INFO "SysRq : ");
+	pr_info("SysRq : ");
 
         op_p = __sysrq_get_key_op(key);
         if (op_p) {
@@ -531,14 +531,14 @@ void __handle_sysrq(int key, bool check_mask)
 		 * should not) and is the invoked operation enabled?
 		 */
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
-			printk("%s\n", op_p->action_msg);
+			pr_cont("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
 			op_p->handler(key);
 		} else {
-			printk("This sysrq operation is disabled.\n");
+			pr_cont("This sysrq operation is disabled.\n");
 		}
 	} else {
-		printk("HELP : ");
+		pr_cont("HELP : ");
 		/* Only print the help msg once per handler */
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {
@@ -549,10 +549,10 @@ void __handle_sysrq(int key, bool check_mask)
 					;
 				if (j != i)
 					continue;
-				printk("%s ", sysrq_key_table[i]->help_msg);
+				pr_cont("%s ", sysrq_key_table[i]->help_msg);
 			}
 		}
-		printk("\n");
+		pr_cont("\n");
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
-- 
2.1.3

