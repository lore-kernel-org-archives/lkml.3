Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaANBQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:16:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaANA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yaju Cao <yacao@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 11/27] netvsc: dont flush peers notifying work during setting mtu
Date: Mon, 13 Jan 2014 16:26:25 -0800
Message-Id: <20140114002623.686439245@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 50dc875f2e6e2e04aed3b3033eb0ac99192d6d02 ]

There's a possible deadlock if we flush the peers notifying work during setting
mtu:

[   22.991149] ======================================================
[   22.991173] [ INFO: possible circular locking dependency detected ]
[   22.991198] 3.10.0-54.0.1.el7.x86_64.debug #1 Not tainted
[   22.991219] -------------------------------------------------------
[   22.991243] ip/974 is trying to acquire lock:
[   22.991261]  ((&(&net_device_ctx->dwork)->work)){+.+.+.}, at: [<ffffffff8108af95>] flush_work+0x5/0x2e0
[   22.991307]
but task is already holding lock:
[   22.991330]  (rtnl_mutex){+.+.+.}, at: [<ffffffff81539deb>] rtnetlink_rcv+0x1b/0x40
[   22.991367]
which lock already depends on the new lock.

[   22.991398]
the existing dependency chain (in reverse order) is:
[   22.991426]
-> #1 (rtnl_mutex){+.+.+.}:
[   22.991449]        [<ffffffff810dfdd9>] __lock_acquire+0xb19/0x1260
[   22.991477]        [<ffffffff810e0d12>] lock_acquire+0xa2/0x1f0
[   22.991501]        [<ffffffff81673659>] mutex_lock_nested+0x89/0x4f0
[   22.991529]        [<ffffffff815392b7>] rtnl_lock+0x17/0x20
[   22.991552]        [<ffffffff815230b2>] netdev_notify_peers+0x12/0x30
[   22.991579]        [<ffffffffa0340212>] netvsc_send_garp+0x22/0x30 [hv_netvsc]
[   22.991610]        [<ffffffff8108d251>] process_one_work+0x211/0x6e0
[   22.991637]        [<ffffffff8108d83b>] worker_thread+0x11b/0x3a0
[   22.991663]        [<ffffffff81095e5d>] kthread+0xed/0x100
[   22.991686]        [<ffffffff81681c6c>] ret_from_fork+0x7c/0xb0
[   22.991715]
-> #0 ((&(&net_device_ctx->dwork)->work)){+.+.+.}:
[   22.991715]        [<ffffffff810de817>] check_prevs_add+0x967/0x970
[   22.991715]        [<ffffffff810dfdd9>] __lock_acquire+0xb19/0x1260
[   22.991715]        [<ffffffff810e0d12>] lock_acquire+0xa2/0x1f0
[   22.991715]        [<ffffffff8108afde>] flush_work+0x4e/0x2e0
[   22.991715]        [<ffffffff8108e1b5>] __cancel_work_timer+0x95/0x130
[   22.991715]        [<ffffffff8108e303>] cancel_delayed_work_sync+0x13/0x20
[   22.991715]        [<ffffffffa03404e4>] netvsc_change_mtu+0x84/0x200 [hv_netvsc]
[   22.991715]        [<ffffffff815233d4>] dev_set_mtu+0x34/0x80
[   22.991715]        [<ffffffff8153bc2a>] do_setlink+0x23a/0xa00
[   22.991715]        [<ffffffff8153d054>] rtnl_newlink+0x394/0x5e0
[   22.991715]        [<ffffffff81539eac>] rtnetlink_rcv_msg+0x9c/0x260
[   22.991715]        [<ffffffff8155cdd9>] netlink_rcv_skb+0xa9/0xc0
[   22.991715]        [<ffffffff81539dfa>] rtnetlink_rcv+0x2a/0x40
[   22.991715]        [<ffffffff8155c41d>] netlink_unicast+0xdd/0x190
[   22.991715]        [<ffffffff8155c807>] netlink_sendmsg+0x337/0x750
[   22.991715]        [<ffffffff8150d219>] sock_sendmsg+0x99/0xd0
[   22.991715]        [<ffffffff8150d63e>] ___sys_sendmsg+0x39e/0x3b0
[   22.991715]        [<ffffffff8150eba2>] __sys_sendmsg+0x42/0x80
[   22.991715]        [<ffffffff8150ebf2>] SyS_sendmsg+0x12/0x20
[   22.991715]        [<ffffffff81681d19>] system_call_fastpath+0x16/0x1b

This is because we hold the rtnl_lock() before ndo_change_mtu() and try to flush
the work in netvsc_change_mtu(), in the mean time, netdev_notify_peers() may be
called from worker and also trying to hold the rtnl_lock. This will lead the
flush won't succeed forever. Solve this by not canceling and flushing the work,
this is safe because the transmission done by NETDEV_NOTIFY_PEERS was
synchronized with the netif_tx_disable() called by netvsc_change_mtu().

Reported-by: Yaju Cao <yacao@redhat.com>
Tested-by: Yaju Cao <yacao@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -321,7 +321,6 @@ static int netvsc_change_mtu(struct net_
 		return -EINVAL;
 
 	nvdev->start_remove = true;
-	cancel_delayed_work_sync(&ndevctx->dwork);
 	cancel_work_sync(&ndevctx->work);
 	netif_tx_disable(ndev);
 	rndis_filter_device_remove(hdev);


