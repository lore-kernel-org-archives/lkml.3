Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3IKEao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab3IKE3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:08 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_BnwFBPNLDYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1P-qu1ancdUA:10 a=yPCof4ZbAAAA:8 a=J1Y8HTJGAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=7DSvI1NPTFQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=p_3oz7kWz44A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042900.850415374@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [051/251] 9p: fix off by one causing access violations and memory corruption
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0051-9p-fix-off-by-one-causing-access-violations-and-memo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit 110ecd69a9feea82a152bbf9b12aba57e6396883 ]

p9_release_pages() would attempt to dereference one value past the end of
pages[]. This would cause the following crashes:

[ 6293.171817] BUG: unable to handle kernel paging request at ffff8807c96f3000
[ 6293.174146] IP: [<ffffffff8412793b>] p9_release_pages+0x3b/0x60
[ 6293.176447] PGD 79c5067 PUD 82c1e3067 PMD 82c197067 PTE 80000007c96f3060
[ 6293.180060] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 6293.180060] Modules linked in:
[ 6293.180060] CPU: 62 PID: 174043 Comm: modprobe Tainted: G        W    3.10.0-next-20130710-sasha #3954
[ 6293.180060] task: ffff8807b803b000 ti: ffff880787dde000 task.ti: ffff880787dde000
[ 6293.180060] RIP: 0010:[<ffffffff8412793b>]  [<ffffffff8412793b>] p9_release_pages+0x3b/0x60
[ 6293.214316] RSP: 0000:ffff880787ddfc28  EFLAGS: 00010202
[ 6293.214316] RAX: 0000000000000001 RBX: ffff8807c96f2ff8 RCX: 0000000000000000
[ 6293.222017] RDX: ffff8807b803b000 RSI: 0000000000000001 RDI: ffffea001c7e3d40
[ 6293.222017] RBP: ffff880787ddfc48 R08: 0000000000000000 R09: 0000000000000000
[ 6293.222017] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
[ 6293.222017] R13: 0000000000000001 R14: ffff8807cc50c070 R15: ffff8807cc50c070
[ 6293.222017] FS:  00007f572641d700(0000) GS:ffff8807f3600000(0000) knlGS:0000000000000000
[ 6293.256784] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6293.256784] CR2: ffff8807c96f3000 CR3: 00000007c8e81000 CR4: 00000000000006e0
[ 6293.256784] Stack:
[ 6293.256784]  ffff880787ddfcc8 ffff880787ddfcc8 0000000000000000 ffff880787ddfcc8
[ 6293.256784]  ffff880787ddfd48 ffffffff84128be8 ffff880700000002 0000000000000001
[ 6293.256784]  ffff8807b803b000 ffff880787ddfce0 0000100000000000 0000000000000000
[ 6293.256784] Call Trace:
[ 6293.256784]  [<ffffffff84128be8>] p9_virtio_zc_request+0x598/0x630
[ 6293.256784]  [<ffffffff8115c610>] ? wake_up_bit+0x40/0x40
[ 6293.256784]  [<ffffffff841209b1>] p9_client_zc_rpc+0x111/0x3a0
[ 6293.256784]  [<ffffffff81174b78>] ? sched_clock_cpu+0x108/0x120
[ 6293.256784]  [<ffffffff84122a21>] p9_client_read+0xe1/0x2c0
[ 6293.256784]  [<ffffffff81708a90>] v9fs_file_read+0x90/0xc0
[ 6293.256784]  [<ffffffff812bd073>] vfs_read+0xc3/0x130
[ 6293.256784]  [<ffffffff811a78bd>] ? trace_hardirqs_on+0xd/0x10
[ 6293.256784]  [<ffffffff812bd5a2>] SyS_read+0x62/0xa0
[ 6293.256784]  [<ffffffff841a1a00>] tracesys+0xdd/0xe2
[ 6293.256784] Code: 66 90 48 89 fb 41 89 f5 48 8b 3f 48 85 ff 74 29 85 f6 74 25 45 31 e4 66 0f 1f 84 00 00 00 00 00 e8 eb 14 12 fd 41 ff c4 49 63 c4 <48> 8b 3c c3 48 85 ff 74 05 45 39 e5 75 e7 48 83 c4 08 5b 41 5c
[ 6293.256784] RIP  [<ffffffff8412793b>] p9_release_pages+0x3b/0x60
[ 6293.256784]  RSP <ffff880787ddfc28>
[ 6293.256784] CR2: ffff8807c96f3000
[ 6293.256784] ---[ end trace 50822ee72cd360fc ]---

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/9p/trans_common.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index de8df957..2ee3879 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -24,11 +24,11 @@
  */
 void p9_release_pages(struct page **pages, int nr_pages)
 {
-	int i = 0;
-	while (pages[i] && nr_pages--) {
-		put_page(pages[i]);
-		i++;
-	}
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		if (pages[i])
+			put_page(pages[i]);
 }
 EXPORT_SYMBOL(p9_release_pages);
 
-- 
1.7.10.4


