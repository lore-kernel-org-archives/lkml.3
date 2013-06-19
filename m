Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab3FSRtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:49:36 -0400
Received: from longford.logfs.org ([213.229.74.203]:59598 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3FSRte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:49:34 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Cc: Joern Engel <joern@logfs.org>, Johannes Berg <johannes@sipsolutions.net>,
        Michael Buesch <mb@bu3sch.de>,
        David Ellingsworth <david@identd.dyndns.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] softirq: weaken warning in local_bh_enable_ip()
Date: Wed, 19 Jun 2013 12:19:16 -0400
Message-Id: <1371658756-7580-1-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reliably triggers with the following backtrace:

local_bh_enable_ip+0x128/0x140
_raw_spin_unlock_bh+0x15/0x20
iscsit_inc_conn_usage_count+0x37/0x50 [iscsi_target_mod]
iscsit_stop_session+0x1db/0x280 [iscsi_target_mod]
lio_tpg_shutdown_session+0xb2/0xf0 [iscsi_target_mod]
core_tpg_set_initiator_node_queue_depth+0x119/0x2f0 [target_core_mod]
iscsit_tpg_set_initiator_node_queue_depth+0x12/0x20 [iscsi_target_mod]
lio_target_nacl_store_cmdsn_depth+0x110/0x1e0 [iscsi_target_mod]
target_fabric_nacl_base_attr_store+0x39/0x40 [target_core_mod]
configfs_write_file+0xbd/0x120
vfs_write+0xc6/0x180
sys_write+0x51/0x90
system_call_fastpath+0x16/0x1b

core_tpg_set_initiator_node_queue_depth() calls
lio_tpg_shutdown_session() inside a spin_lock_irqsave-protected block.
Calling spin_unlock_bh later in the call chain always triggers the
warning.

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: David Ellingsworth <david@identd.dyndns.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
---
 kernel/softirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 14d7758..d4ee1c6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(_local_bh_enable);
 
 static inline void _local_bh_enable_ip(unsigned long ip)
 {
-	WARN_ON_ONCE(in_irq() || irqs_disabled());
+	WARN_ON_ONCE(in_irq());
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_disable();
 #endif
-- 
1.7.10.4

