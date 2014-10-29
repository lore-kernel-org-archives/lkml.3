Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaJ2TgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:36:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46388 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaJ2TgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:36:07 -0400
Date: Wed, 29 Oct 2014 20:36:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on
 linux-next
Message-ID: <20141029193603.GS12706@worktop.programming.kicks-ass.net>
References: <20141029155620.GA4886@kria>
 <20141029180734.GQ12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1410291918060.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410291918060.5308@nanos>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 07:33:00PM +0100, Thomas Gleixner wrote:
> Yuck. No. You are just papering over the problem.
> 
> What happens if you add 'threadirqs' to the kernel command line? Or if
> the interrupt line is shared with a real threaded interrupt user?
> 
> The proper solution is to have a poll_lock for e1000 which serializes
> the hardware interrupt against netpoll instead of using
> disable/enable_irq().
> 
> In fact that's less expensive than the disable/enable_irq() dance and
> the chance of contention is pretty low. If done right it will be a
> NOOP for the CONFIG_NET_POLL_CONTROLLER=n case.
> 

OK a little something like so then I suppose.. But I suspect most all
the network drivers will need this and maybe more, disable_irq() is a
popular little thing and we 'just' changed semantics on them.

---
 drivers/net/ethernet/intel/e1000/e1000.h      |  2 ++
 drivers/net/ethernet/intel/e1000/e1000_main.c | 22 +++++++++++++++++-----
 kernel/irq/manage.c                           |  2 +-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index 69707108d23c..3f48609f2318 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -323,6 +323,8 @@ struct e1000_adapter {
 	struct delayed_work watchdog_task;
 	struct delayed_work fifo_stall_task;
 	struct delayed_work phy_info_task;
+
+	spinlock_t irq_lock;
 };
 
 enum e1000_state_t {
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 5f6aded512f5..d12cbffe2149 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1310,6 +1310,7 @@ static int e1000_sw_init(struct e1000_adapter *adapter)
 	e1000_irq_disable(adapter);
 
 	spin_lock_init(&adapter->stats_lock);
+	spin_lock_init(&adapter->irq_lock);
 
 	set_bit(__E1000_DOWN, &adapter->flags);
 
@@ -3748,10 +3749,8 @@ void e1000_update_stats(struct e1000_adapter *adapter)
  * @irq: interrupt number
  * @data: pointer to a network interface device structure
  **/
-static irqreturn_t e1000_intr(int irq, void *data)
+static irqreturn_t __e1000_intr(int irq, struct e1000_adapter *adapter)
 {
-	struct net_device *netdev = data;
-	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 icr = er32(ICR);
 
@@ -3793,6 +3792,19 @@ static irqreturn_t e1000_intr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t e1000_intr(int irq, void *data)
+{
+	struct net_device *netdev = data;
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	irqreturn_t ret;
+
+	spin_lock(&adapter->irq_lock);
+	ret = __e1000_intr(irq, adapter);
+	spin_unlock(&adapter->irq_lock);
+
+	return ret;
+}
+
 /**
  * e1000_clean - NAPI Rx polling callback
  * @adapter: board private structure
@@ -5217,9 +5229,9 @@ static void e1000_netpoll(struct net_device *netdev)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	disable_irq(adapter->pdev->irq);
+	spin_lock(&adapter->irq_lock)
 	e1000_intr(adapter->pdev->irq, netdev);
-	enable_irq(adapter->pdev->irq);
+	spin_unlock(&adapter->irq_lock)
 }
 #endif
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b4608b..b5a4a06bf2fd 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -427,7 +427,7 @@ EXPORT_SYMBOL(disable_irq_nosync);
  *	to complete before returning. If you use this function while
  *	holding a resource the IRQ handler may need you will deadlock.
  *
- *	This function may be called - with care - from IRQ context.
+ *	This function may _NOT_ be called from IRQ context.
  */
 void disable_irq(unsigned int irq)
 {
