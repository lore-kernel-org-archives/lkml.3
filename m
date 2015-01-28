Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147AbbA1E3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:29:47 -0500
Received: from mail.kernel.org ([198.145.29.136]:41355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934607AbbA1E0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:10 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Thomas=20K=C3=B6rper?= <thomas.koerper@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 166/177] can: dev: avoid calling kfree_skb() from interrupt context
Date: Wed, 28 Jan 2015 12:10:24 +0800
Message-Id: <1422418236-12852-257-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Körper <thomas.koerper@esd.eu>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 5247a589c24022ab34e780039cc8000c48f2035e upstream.

ikfree_skb() is Called in can_free_echo_skb(), which might be called from (TX
Error) interrupt, which triggers the folloing warning:

[ 1153.360705] ------------[ cut here ]------------
[ 1153.360715] WARNING: CPU: 0 PID: 31 at net/core/skbuff.c:563 skb_release_head_state+0xb9/0xd0()
[ 1153.360772] Call Trace:
[ 1153.360778]  [<c167906f>] dump_stack+0x41/0x52
[ 1153.360782]  [<c105bb7e>] warn_slowpath_common+0x7e/0xa0
[ 1153.360784]  [<c158b909>] ? skb_release_head_state+0xb9/0xd0
[ 1153.360786]  [<c158b909>] ? skb_release_head_state+0xb9/0xd0
[ 1153.360788]  [<c105bc42>] warn_slowpath_null+0x22/0x30
[ 1153.360791]  [<c158b909>] skb_release_head_state+0xb9/0xd0
[ 1153.360793]  [<c158be90>] skb_release_all+0x10/0x30
[ 1153.360795]  [<c158bf06>] kfree_skb+0x36/0x80
[ 1153.360799]  [<f8486938>] ? can_free_echo_skb+0x28/0x40 [can_dev]
[ 1153.360802]  [<f8486938>] can_free_echo_skb+0x28/0x40 [can_dev]
[ 1153.360805]  [<f849a12c>] esd_pci402_interrupt+0x34c/0x57a [esd402]
[ 1153.360809]  [<c10a75b5>] handle_irq_event_percpu+0x35/0x180
[ 1153.360811]  [<c10a7623>] ? handle_irq_event_percpu+0xa3/0x180
[ 1153.360813]  [<c10a7731>] handle_irq_event+0x31/0x50
[ 1153.360816]  [<c10a9c7f>] handle_fasteoi_irq+0x6f/0x120
[ 1153.360818]  [<c10a9c10>] ? handle_edge_irq+0x110/0x110
[ 1153.360822]  [<c1011b61>] handle_irq+0x71/0x90
[ 1153.360823]  <IRQ>  [<c168152c>] do_IRQ+0x3c/0xd0
[ 1153.360829]  [<c1680b6c>] common_interrupt+0x2c/0x34
[ 1153.360834]  [<c107d277>] ? finish_task_switch+0x47/0xf0
[ 1153.360836]  [<c167c27b>] __schedule+0x35b/0x7e0
[ 1153.360839]  [<c10a5334>] ? console_unlock+0x2c4/0x4d0
[ 1153.360842]  [<c13df500>] ? n_tty_receive_buf_common+0x890/0x890
[ 1153.360845]  [<c10707b6>] ? process_one_work+0x196/0x370
[ 1153.360847]  [<c167c723>] schedule+0x23/0x60
[ 1153.360849]  [<c1070de1>] worker_thread+0x161/0x460
[ 1153.360852]  [<c1090fcf>] ? __wake_up_locked+0x1f/0x30
[ 1153.360854]  [<c1070c80>] ? rescuer_thread+0x2f0/0x2f0
[ 1153.360856]  [<c1074f01>] kthread+0xa1/0xc0
[ 1153.360859]  [<c1680401>] ret_from_kernel_thread+0x21/0x30
[ 1153.360861]  [<c1074e60>] ? kthread_create_on_node+0x110/0x110
[ 1153.360863] ---[ end trace 5ff83639cbb74b35 ]---

This patch replaces the kfree_skb() by dev_kfree_skb_any().

Signed-off-by: Thomas Körper <thomas.koerper@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index c2cdefa..d4f7f95 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -359,7 +359,7 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx)
 	BUG_ON(idx >= priv->echo_skb_max);
 
 	if (priv->echo_skb[idx]) {
-		kfree_skb(priv->echo_skb[idx]);
+		dev_kfree_skb_any(priv->echo_skb[idx]);
 		priv->echo_skb[idx] = NULL;
 	}
 }
-- 
1.9.1

