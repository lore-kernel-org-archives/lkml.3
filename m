Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaBAMR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 07:17:28 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65265 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaBAMR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 07:17:27 -0500
Message-ID: <52ECE5D8.6090209@gmail.com>
Date: Sat, 01 Feb 2014 20:17:28 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com
CC: hskinnemoen@gmail.com, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        egtvedt@samfundet.no
Subject: [PATCH] kernel/kprobes.c: move cleanup_rp_inst() to where CONFIG_KRETPROBES
 enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_KRETPROBES disabled, cleanup_rp_inst() is useless too. It
is only called by unregister_kretprobes() which is in CONFIG_KRETPROBES
enabled area.

The related warning (allmodconfig under avr32):

  kernel/kprobes.c:1181: warning: 'cleanup_rp_inst' defined but not used


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 kernel/kprobes.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..18a520d 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1178,26 +1178,6 @@ static inline void free_rp_inst(struct kretprobe *rp)
 	}
 }
 
-static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
-{
-	unsigned long flags, hash;
-	struct kretprobe_instance *ri;
-	struct hlist_node *next;
-	struct hlist_head *head;
-
-	/* No race here */
-	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
-		kretprobe_table_lock(hash, &flags);
-		head = &kretprobe_inst_table[hash];
-		hlist_for_each_entry_safe(ri, next, head, hlist) {
-			if (ri->rp == rp)
-				ri->rp = NULL;
-		}
-		kretprobe_table_unlock(hash, &flags);
-	}
-	free_rp_inst(rp);
-}
-
 /*
 * Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
@@ -1885,6 +1865,26 @@ void __kprobes unregister_kretprobe(struct kretprobe *rp)
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
 
+static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+{
+	unsigned long flags, hash;
+	struct kretprobe_instance *ri;
+	struct hlist_node *next;
+	struct hlist_head *head;
+
+	/* No race here */
+	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
+		kretprobe_table_lock(hash, &flags);
+		head = &kretprobe_inst_table[hash];
+		hlist_for_each_entry_safe(ri, next, head, hlist) {
+			if (ri->rp == rp)
+				ri->rp = NULL;
+		}
+		kretprobe_table_unlock(hash, &flags);
+	}
+	free_rp_inst(rp);
+}
+
 void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
 {
 	int i;
-- 
1.7.11.7
