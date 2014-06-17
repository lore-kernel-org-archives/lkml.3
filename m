Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967618AbaFQW14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:27:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54257 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966464AbaFQVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/212] net: cdc_mbim: __vlan_find_dev_deep need rcu_read_lock
Date: Tue, 17 Jun 2014 14:42:18 -0700
Message-Id: <1403041506-13646-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 4f4178f3bb1f470d7fb863ec531e08e20a0fd51c ]

Fixes this warning introduced by commit 5b8f15f78e6f
("net: cdc_mbim: handle IPv6 Neigbor Solicitations"):

===============================
[ INFO: suspicious RCU usage. ]
3.15.0-rc3 #213 Tainted: G        W  O
-------------------------------
net/8021q/vlan_core.c:69 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 1
no locks held by ksoftirqd/0/3.

stack backtrace:
CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G        W  O  3.15.0-rc3 #213
Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
 0000000000000001 ffff880232533bf0 ffffffff813a5ee6 0000000000000006
 ffff880232530090 ffff880232533c20 ffffffff81076b94 0000000000000081
 0000000000000000 ffff8802085ac000 ffff88007fc8ea00 ffff880232533c50
Call Trace:
 [<ffffffff813a5ee6>] dump_stack+0x4e/0x68
 [<ffffffff81076b94>] lockdep_rcu_suspicious+0xfa/0x103
 [<ffffffff813978a6>] __vlan_find_dev_deep+0x54/0x94
 [<ffffffffa04a1938>] cdc_mbim_rx_fixup+0x379/0x66a [cdc_mbim]
 [<ffffffff813ab76f>] ? _raw_spin_unlock_irqrestore+0x3a/0x49
 [<ffffffff81079671>] ? trace_hardirqs_on_caller+0x192/0x1a1
 [<ffffffffa059bd10>] usbnet_bh+0x59/0x287 [usbnet]
 [<ffffffff8104067d>] tasklet_action+0xbb/0xcd
 [<ffffffff81040057>] __do_softirq+0x14c/0x30d
 [<ffffffff81040237>] run_ksoftirqd+0x1f/0x50
 [<ffffffff8105f13e>] smpboot_thread_fn+0x172/0x18e
 [<ffffffff8105efcc>] ? SyS_setgroups+0xdf/0xdf
 [<ffffffff810594b0>] kthread+0xb5/0xbd
 [<ffffffff813a84b1>] ? __wait_for_common+0x13b/0x170
 [<ffffffff810593fb>] ? __kthread_parkme+0x5c/0x5c
 [<ffffffff813b147c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810593fb>] ? __kthread_parkme+0x5c/0x5c

Fixes: 5b8f15f78e6f ("net: cdc_mbim: handle IPv6 Neigbor Solicitations")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/cdc_mbim.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c9f3281..13f7705 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -204,17 +204,23 @@ static void do_neigh_solicit(struct usbnet *dev, u8 *buf, u16 tci)
 		return;
 
 	/* need to send the NA on the VLAN dev, if any */
-	if (tci)
+	rcu_read_lock();
+	if (tci) {
 		netdev = __vlan_find_dev_deep(dev->net, htons(ETH_P_8021Q),
 					      tci);
-	else
+		if (!netdev) {
+			rcu_read_unlock();
+			return;
+		}
+	} else {
 		netdev = dev->net;
-	if (!netdev)
-		return;
+	}
+	dev_hold(netdev);
+	rcu_read_unlock();
 
 	in6_dev = in6_dev_get(netdev);
 	if (!in6_dev)
-		return;
+		goto out;
 	is_router = !!in6_dev->cnf.forwarding;
 	in6_dev_put(in6_dev);
 
@@ -224,6 +230,8 @@ static void do_neigh_solicit(struct usbnet *dev, u8 *buf, u16 tci)
 				 true /* solicited */,
 				 false /* override */,
 				 true /* inc_opt */);
+out:
+	dev_put(netdev);
 }
 
 static bool is_neigh_solicit(u8 *buf, size_t len)
-- 
1.9.1

