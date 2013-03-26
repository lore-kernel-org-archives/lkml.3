Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3CZRzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:55:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3CZRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:14 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yuu0lDE4XNQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1ILyzFfaRAgA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=4GEhVLJy-apUUS-8O-sA:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173607.975835481@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 50/86] tun: add a missing nf_reset() in tun_net_xmit()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0050-tun-add-a-missing-nf_reset-in-tun_net_xmit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8af75f3517a24838a36eb5797a1a3e60bf9e276 ]

Dave reported following crash :

general protection fault: 0000 [#1] SMP
CPU 2
Pid: 25407, comm: qemu-kvm Not tainted 3.7.9-205.fc18.x86_64 #1 Hewlett-Packard HP Z400 Workstation/0B4Ch
RIP: 0010:[<ffffffffa0399bd5>]  [<ffffffffa0399bd5>] destroy_conntrack+0x35/0x120 [nf_conntrack]
RSP: 0018:ffff880276913d78  EFLAGS: 00010206
RAX: 50626b6b7876376c RBX: ffff88026e530d68 RCX: ffff88028d158e00
RDX: ffff88026d0d5470 RSI: 0000000000000011 RDI: 0000000000000002
RBP: ffff880276913d88 R08: 0000000000000000 R09: ffff880295002900
R10: 0000000000000000 R11: 0000000000000003 R12: ffffffff81ca3b40
R13: ffffffff8151a8e0 R14: ffff880270875000 R15: 0000000000000002
FS:  00007ff3bce38a00(0000) GS:ffff88029fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd1430bd000 CR3: 000000027042b000 CR4: 00000000000027e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qemu-kvm (pid: 25407, threadinfo ffff880276912000, task ffff88028c369720)
Stack:
 ffff880156f59100 ffff880156f59100 ffff880276913d98 ffffffff815534f7
 ffff880276913db8 ffffffff8151a74b ffff880270875000 ffff880156f59100
 ffff880276913dd8 ffffffff8151a5a6 ffff880276913dd8 ffff88026d0d5470
Call Trace:
 [<ffffffff815534f7>] nf_conntrack_destroy+0x17/0x20
 [<ffffffff8151a74b>] skb_release_head_state+0x7b/0x100
 [<ffffffff8151a5a6>] __kfree_skb+0x16/0xa0
 [<ffffffff8151a666>] kfree_skb+0x36/0xa0
 [<ffffffff8151a8e0>] skb_queue_purge+0x20/0x40
 [<ffffffffa02205f7>] __tun_detach+0x117/0x140 [tun]
 [<ffffffffa022184c>] tun_chr_close+0x3c/0xd0 [tun]
 [<ffffffff8119669c>] __fput+0xec/0x240
 [<ffffffff811967fe>] ____fput+0xe/0x10
 [<ffffffff8107eb27>] task_work_run+0xa7/0xe0
 [<ffffffff810149e1>] do_notify_resume+0x71/0xb0
 [<ffffffff81640152>] int_signal+0x12/0x17
Code: 00 00 04 48 89 e5 41 54 53 48 89 fb 4c 8b a7 e8 00 00 00 0f 85 de 00 00 00 0f b6 73 3e 0f b7 7b 2a e8 10 40 00 00 48 85 c0 74 0e <48> 8b 40 28 48 85 c0 74 05 48 89 df ff d0 48 c7 c7 08 6a 3a a0
RIP  [<ffffffffa0399bd5>] destroy_conntrack+0x35/0x120 [nf_conntrack]
 RSP <ffff880276913d78>

This is because tun_net_xmit() needs to call nf_reset()
before queuing skb into receive_queue

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/tun.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3a16d4f..ef7710f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -421,6 +421,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 	skb_orphan(skb);
 
+	nf_reset(skb);
+
 	/* Enqueue packet */
 	skb_queue_tail(&tun->socket.sk->sk_receive_queue, skb);
 
-- 
1.7.10.4


