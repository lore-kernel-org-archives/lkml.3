Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3C1RQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:16:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab3C1RQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:16:40 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=O9J7wxHhePYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=WCZO_3J5bzIA:10 a=0NXcx_fzVF4rnZ_rYIMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364490997.6345.237.camel@gandalf.local.home>
Subject: [BUG] Crash with NULL pointer dereference in bond_handle_frame in
 -rt (possibly mainline)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Pirko <jpirko@redhat.com>, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Thu, 28 Mar 2013 13:16:37 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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


	CPU0			CPU1
	----			----
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

Thanks!

-- Steve




