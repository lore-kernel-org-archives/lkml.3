Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaGBFcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:32:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaGBFcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:32:11 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, joe.jin@oracle.com
Subject: [PATCH] block: fix reqeust->__data_len overflow
Date: Wed,  2 Jul 2014 13:32:30 +0800
Message-Id: <1404279150-9372-1-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_sectors(req) + bio_sectors(bio) > blk_rq_get_max_sectors(req)
is used to check whether a bio can be merged into an exist request.
If can, req->__data_len += bio->bio_size. Since req->__data_len is
a 32bit uint, if blk_rq_get_max_sectors(req) > (UINT_MAX >> 9),
req->__date_len may overflow when merging a new bio.
This probably happen for discard request. In xen blkfront driver,
its max_discard_sectors is set to the whole disk sector size, see
xlvbd_init_blk_queue(). So issuing discrad requests to a
xen virtual disk with a size over 4G is very possible to trigger the
overflow. This overflow will cause kernel panic in blk_end_request_all()
due to BUG() triggered.

The following is a call trace we saw in 3.0.69. Upstream kernel also suffer
this issue.

@ __end_that: dev xvdg: type=1, flags=2224441
@   sector 0, nr/cnr 8378368/4294959104
@   bio ffff8803d8cf3080, biotail ffff8803d8cf32c0, buffer           (null),
@ len 4289724416
@ blk_update_request: bio idx 0 >= vcnt 0
@ request botched: dev xvdg: type=1, flags=2224441
@   sector 0, nr/cnr 8378368/4294959104
@   bio ffff8803d8cf3080, biotail ffff8803d8cf32c0, buffer           (null),
@ len 4289724416
@ ------------[ cut here ]------------
@ kernel BUG at block/blk-core.c:2394!
@ invalid opcode: 0000 [#1] SMP
@ CPU 0
@ Modules linked in: nfs fscache auth_rpcgss nfs_acl autofs4 i2c_dev i2c_core
@ lockd sunrpc(U) ksplice_x773z34q_vmlinux_new(U) ksplice_x773z34q(U)
@ ksplice_bj7y22gc_vmlinux_new(U) ksplice_bj7y22gc_ipv6_new(U)
@ ksplice_bj7y22gc(U)
@ .
@ ksplice_i1o46065(U) ksplice_5gqtkuvt_vmlinux_new(U) ksplice_5gqtkuvt(U)
@ ksplice_2bcv8td6(U) ksplice_v5bs54bz_vmlinux_new(U) ksplice_v5bs54bz(U)
@ ksplice_l7s0dhx6(U) ksplice_aur7sgvi(U) ksplice_ckie4cpv(U)
@ nf_conntrack_netbios_ns
@ .
@ nf_conntrack_broadcast ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
@ nf_conntrack xt_comment iptable_filter ip_tables be2iscsi iscsi_boot_sysfs
@ ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic
@ uio ipv6
@ .
@ cxgb3i libcxgbi cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi
@ parport_pc lp parport snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
@ snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore
@ snd_page_alloc
@ .
@ pcspkr xen_netfront dm_snapshot dm_zero dm_mirror dm_region_hash dm_log
@ dm_mod xen_blkfront ext3 jbd mbcache sd_mod crc_t10dif [last unloaded:
@ ksplice_x773z34q_vmlinux_old]
@ .
@ Pid: 0, comm: swapper Not tainted 2.6.39-400.212.1.el5uek #1
@ RIP: e030:[<ffffffff8123757a>]  [<ffffffff8123757a>]
@ __blk_end_request_all+0x2a/0x40
@ RSP: e02b:ffff8803ffc03df8  EFLAGS: 00010002
@ RAX: 0000000000000001 RBX: ffff8803db3c8000 RCX: ffff8803d8cf32c0
@ RDX: 0000000000000001 RSI: ffff8803d8cf3080 RDI: ffff8803daed08d8
@ RBP: ffff8803ffc03df8 R08: 0000000000000000 R09: ffff8803daed08d8
@ R10: 0000000000000000 R11: 000000000000000a R12: 0000000000000000
@ R13: ffff8803dad5e3c0 R14: 0000000000000001 R15: 0000000000000029
@ FS:  00007f1f34a32940(0000) GS:ffff8803ffc00000(0000) knlGS:0000000000000000
@ CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
@ CR2: 00000000020c6148 CR3: 00000003c6492000 CR4: 0000000000002660
@ DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
@ DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
@ Process swapper (pid: 0, threadinfo ffffffff81794000, task ffffffff8179f020)
@ Stack:
@  ffff8803ffc03e48 ffffffffa005c56a ffff8803da57a8d0 00000028810d99ee
@  0000000000000000 ffff8803db1ea7c0 ffff8803db1beec0 000000000000005e
@  0000000000000001 0000000000000000 ffff8803ffc03e98 ffffffff810d735d
@ Call Trace:
@  <IRQ>
@  [<ffffffffa005c56a>] blkif_interrupt+0x20a/0x3a0 [xen_blkfront]
@  [<ffffffff810d735d>] handle_irq_event_percpu+0x5d/0x1a0
@  [<ffffffff810d74ef>] handle_irq_event+0x4f/0x80
@  [<ffffffff810d9e25>] handle_edge_irq+0xa5/0x100
@  [<ffffffff812f7cc8>] __xen_evtchn_do_upcall+0x218/0x310
@  [<ffffffff812f7e7f>] xen_evtchn_do_upcall+0x2f/0x50
@  [<ffffffff8151168e>] xen_do_hypervisor_callback+0x1e/0x30
@  <EOI>
@  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
@  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
@  [<ffffffff8100a2b0>] ? xen_safe_halt+0x10/0x20
@  [<ffffffff8101dffb>] ? default_idle+0x5b/0x170
@  [<ffffffff81014ac6>] ? cpu_idle+0xc6/0xf0
@  [<ffffffff814eab62>] ? rest_init+0x72/0x80
@  [<ffffffff819c902a>] ? start_kernel+0x2aa/0x390
@  [<ffffffff819c832a>] ? x86_64_start_reservations+0x6a/0xa0
@  [<ffffffff819cc9b5>] ? xen_start_kernel+0x315/0x440
@ Code: 00 55 48 89 e5 0f 1f 44 00 00 48 8b 87 60 01 00 00 31 c9 48 85 c0 75 0e
@ 8b 57 54 e8 91 ff ff ff 84 c0 75 07 c9 c3 8b 48 54 eb ed <0f> 0b 0f 1f 40 00
@ eb fa 0f 1f 80 00 00 00 00 0f 1f 80 00 00 00
@ RIP  [<ffffffff8123757a>] __blk_end_request_all+0x2a/0x40
@  RSP <ffff8803ffc03df8>
@ ---[ end trace b09ff97496363201 ]---

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 block/blk-merge.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b3bf0df..ae4f4c8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -325,11 +325,30 @@ no_merge:
 	return 0;
 }
 
-int ll_back_merge_fn(struct request_queue *q, struct request *req,
+static inline bool ll_allow_merge_bio(struct request *req,
 		     struct bio *bio)
 {
 	if (blk_rq_sectors(req) + bio_sectors(bio) >
-	    blk_rq_get_max_sectors(req)) {
+		min(blk_rq_get_max_sectors(req), UINT_MAX >> 9))
+		return false;
+
+	return true;
+}
+
+static inline bool ll_allow_merge_req(struct request *req,
+		     struct request *next)
+{
+	if (blk_rq_sectors(req) + blk_rq_sectors(next) >
+		min(blk_rq_get_max_sectors(req), UINT_MAX >> 9))
+		return false;
+
+	return true;
+}
+
+int ll_back_merge_fn(struct request_queue *q, struct request *req,
+		     struct bio *bio)
+{
+	if (!ll_allow_merge_bio(req, bio)) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -346,8 +365,7 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 int ll_front_merge_fn(struct request_queue *q, struct request *req,
 		      struct bio *bio)
 {
-	if (blk_rq_sectors(req) + bio_sectors(bio) >
-	    blk_rq_get_max_sectors(req)) {
+	if (!ll_allow_merge_bio(req, bio)) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -389,8 +407,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	/*
 	 * Will it become too large?
 	 */
-	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) >
-	    blk_rq_get_max_sectors(req))
+	if (!ll_allow_merge_req(req, next))
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-- 
1.7.9.5

