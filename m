Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936375Ab3DKV0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:26:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935312Ab3DKUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:45 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2-a2xEk6zG4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mSizkdaVyx4A:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=J1Y8HTJGAAAA:8 a=NRw-oWH4PsK4AR06wwUA:9 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202613.611963220@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Jiri Pirko <jpirko@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 167/171 ] net: add a synchronize_net() in netdev_rx_handler_unregister()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0167-net-add-a-synchronize_net-in-netdev_rx_handler_unreg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 00cfec37484761a44a3b6f4675a54caa618210ae ]

commit 35d48903e97819 (bonding: fix rx_handler locking) added a race
in bonding driver, reported by Steven Rostedt who did a very good
diagnosis :

<quoting Steven>

I'm currently debugging a crash in an old 3.0-rt kernel that one of our
customers is seeing. The bug happens with a stress test that loads and
unloads the bonding module in a loop (I don't know all the details as
I'm not the one that is directly interacting with the customer). But the
bug looks to be something that may still be present and possibly present
in mainline too. It will just be much harder to trigger it in mainline.

In -rt, interrupts are threads, and can schedule in and out just like
any other thread. Note, mainline now supports interrupt threads so this
may be easily reproducible in mainline as well. I don't have the ability
to tell the customer to try mainline or other kernels, so my hands are
somewhat tied to what I can do.

But according to a core dump, I tracked down that the eth irq thread
crashed in bond_handle_frame() here:

        slave = bond_slave_get_rcu(skb->dev);
        bond = slave->bond; <--- BUG

the slave returned was NULL and accessing slave->bond caused a NULL
pointer dereference.

Looking at the code that unregisters the handler:

void netdev_rx_handler_unregister(struct net_device *dev)
{

        ASSERT_RTNL();
        RCU_INIT_POINTER(dev->rx_handler, NULL);
        RCU_INIT_POINTER(dev->rx_handler_data, NULL);
}

Which is basically:
        dev->rx_handler = NULL;
        dev->rx_handler_data = NULL;

And looking at __netif_receive_skb() we have:

        rx_handler = rcu_dereference(skb->dev->rx_handler);
        if (rx_handler) {
                if (pt_prev) {
                        ret = deliver_skb(skb, pt_prev, orig_dev);
                        pt_prev = NULL;
                }
                switch (rx_handler(&skb)) {

My question to all of you is, what stops this interrupt from happening
while the bonding module is unloading?  What happens if the interrupt
triggers and we have this:

        CPU0                    CPU1
        ----                    ----
  rx_handler = skb->dev->rx_handler

                        netdev_rx_handler_unregister() {
                           dev->rx_handler = NULL;
                           dev->rx_handler_data = NULL;

  rx_handler()
   bond_handle_frame() {
    slave = skb->dev->rx_handler;
    bond = slave->bond; <-- NULL pointer dereference!!!

What protection am I missing in the bond release handler that would
prevent the above from happening?

</quoting Steven>

We can fix bug this in two ways. First is adding a test in
bond_handle_frame() and others to check if rx_handler_data is NULL.

A second way is adding a synchronize_net() in
netdev_rx_handler_unregister() to make sure that a rcu protected reader
has the guarantee to see a non NULL rx_handler_data.

The second way is better as it avoids an extra test in fast path.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jpirko@redhat.com>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/dev.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index d283020..9509394 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3153,6 +3153,7 @@ int netdev_rx_handler_register(struct net_device *dev,
 	if (dev->rx_handler)
 		return -EBUSY;
 
+	/* Note: rx_handler_data must be set before rx_handler */
 	rcu_assign_pointer(dev->rx_handler_data, rx_handler_data);
 	rcu_assign_pointer(dev->rx_handler, rx_handler);
 
@@ -3173,6 +3174,11 @@ void netdev_rx_handler_unregister(struct net_device *dev)
 
 	ASSERT_RTNL();
 	RCU_INIT_POINTER(dev->rx_handler, NULL);
+	/* a reader seeing a non NULL rx_handler in a rcu_read_lock()
+	 * section has a guarantee to see a non NULL rx_handler_data
+	 * as well.
+	 */
+	synchronize_net();
 	RCU_INIT_POINTER(dev->rx_handler_data, NULL);
 }
 EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
-- 
1.7.10.4


