Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435Ab3DKUsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:48:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476Ab3DKUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:44 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=TYYsNB2kVJIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GPTN4gAJ1wEA:10 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202614.271498181@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Veaceslav Falico <vfalico@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 171/171 ] bonding: get netdev_rx_handler_unregister out of locks
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0171-bonding-get-netdev_rx_handler_unregister-out-of-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Veaceslav Falico <vfalico@redhat.com>

[ Upstream commit fcd99434fb5c137274d2e15dd2a6a7455f0f29ff ]

Now that netdev_rx_handler_unregister contains synchronize_net(), we need
to call it outside of bond->lock, cause it might sleep. Also, remove the
already unneded synchronize_net().

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/bonding/bond_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a9a07ce..83ae683 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1961,12 +1961,11 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 		return -EINVAL;
 	}
 
+	write_unlock_bh(&bond->lock);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
 	 */
 	netdev_rx_handler_unregister(slave_dev);
-	write_unlock_bh(&bond->lock);
-	synchronize_net();
 	write_lock_bh(&bond->lock);
 
 	if (!bond->params.fail_over_mac) {
-- 
1.7.10.4


