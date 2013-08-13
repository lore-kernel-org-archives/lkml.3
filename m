Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3HMQC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:02:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab3HMP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:36 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=paoWWFANgO8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=nDe7wQNa5FYA:10 a=4K-K1uyHAAAA:8 a=VwQbUJbxAAAA:8 a=z11f-joXAAAA:8 a=-eAyMjLYeEaQEo9m6KIA:9 a=wATGTE7Z8MQA:10 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155829.274302530@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joern Engel <joern@logfs.org>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [36/88] target/iscsi: dont corrupt bh_count in
 iscsit_stop_time2retain_timer()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0036-target-iscsi-don-t-corrupt-bh_count-in-iscsit_stop_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>

[ Upstream commit 574780fd5e6ec52bd43e0bdb777a19e4c4c6aa9c ]

Here is a fun one.  Bug seems to have been introduced by commit 140854cb,
almost two years ago.  I have no idea why we only started seeing it now,
but we did.

Rough callgraph:
core_tpg_set_initiator_node_queue_depth()
`-> spin_lock_irqsave(&tpg->session_lock, flags);
`-> lio_tpg_shutdown_session()
    `-> iscsit_stop_time2retain_timer()
        `-> spin_unlock_bh(&se_tpg->session_lock);
        `-> spin_lock_bh(&se_tpg->session_lock);
`-> spin_unlock_irqrestore(&tpg->session_lock, flags);

core_tpg_set_initiator_node_queue_depth() used to call spin_lock_bh(),
but 140854cb changed that to spin_lock_irqsave().  However,
lio_tpg_shutdown_session() still claims to be called with spin_lock_bh()
held, as does iscsit_stop_time2retain_timer():
 *      Called with spin_lock_bh(&struct se_portal_group->session_lock) held

Stale documentation is mostly annoying, but in this case the dropping
the lock with the _bh variant is plain wrong.  It is also wrong to drop
locks two functions below the lock-holder, but I will ignore that bit
for now.

After some more locking and unlocking we eventually hit this backtrace:
------------[ cut here ]------------
WARNING: at kernel/softirq.c:159 local_bh_enable_ip+0xe8/0x100()
Pid: 24645, comm: lio_helper.py Tainted: G           O 3.6.11+
Call Trace:
 [<ffffffff8103e5ff>] warn_slowpath_common+0x7f/0xc0
 [<ffffffffa040ae37>] ? iscsit_inc_conn_usage_count+0x37/0x50 [iscsi_target_mod]
 [<ffffffff8103e65a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810472f8>] local_bh_enable_ip+0xe8/0x100
 [<ffffffff815b8365>] _raw_spin_unlock_bh+0x15/0x20
 [<ffffffffa040ae37>] iscsit_inc_conn_usage_count+0x37/0x50 [iscsi_target_mod]
 [<ffffffffa041149a>] iscsit_stop_session+0xfa/0x1c0 [iscsi_target_mod]
 [<ffffffffa0417fab>] lio_tpg_shutdown_session+0x7b/0x90 [iscsi_target_mod]
 [<ffffffffa033ede4>] core_tpg_set_initiator_node_queue_depth+0xe4/0x290 [target_core_mod]
 [<ffffffffa0409032>] iscsit_tpg_set_initiator_node_queue_depth+0x12/0x20 [iscsi_target_mod]
 [<ffffffffa0415c29>] lio_target_nacl_store_cmdsn_depth+0xa9/0x180 [iscsi_target_mod]
 [<ffffffffa0331b49>] target_fabric_nacl_base_attr_store+0x39/0x40 [target_core_mod]
 [<ffffffff811b857d>] configfs_write_file+0xbd/0x120
 [<ffffffff81148f36>] vfs_write+0xc6/0x180
 [<ffffffff81149251>] sys_write+0x51/0x90
 [<ffffffff815c0969>] system_call_fastpath+0x16/0x1b
---[ end trace 3747632b9b164652 ]---

As a pure band-aid, this patch drops the _bh.

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/target/iscsi/iscsi_target_erl0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 1a02016..e768bfa 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -834,11 +834,11 @@ extern int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
 		return 0;
 
 	sess->time2retain_timer_flags |= ISCSI_TF_STOP;
-	spin_unlock_bh(&se_tpg->session_lock);
+	spin_unlock(&se_tpg->session_lock);
 
 	del_timer_sync(&sess->time2retain_timer);
 
-	spin_lock_bh(&se_tpg->session_lock);
+	spin_lock(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
 	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
 			sess->sid);
-- 
1.7.10.4


