Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaAQP0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:26:06 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:46517 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbaAQPSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:18:41 -0500
Message-Id: <20140117151835.721256087@linux.com>
Date: Fri, 17 Jan 2014 09:18:25 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 13/41] drivers/net/ethernet/tile: Replace __get_cpu_var uses for address calculation
References: <20140117151812.770437629@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_driver_net_ethernet_tile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace with this_cpu_ptr.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilegx.c	2013-12-02 16:07:54.574500726 -0600
+++ linux/drivers/net/ethernet/tile/tilegx.c	2013-12-02 16:07:54.564501002 -0600
@@ -427,7 +427,7 @@ static void tile_net_pop_all_buffers(int
 /* Provide linux buffers to mPIPE. */
 static void tile_net_provide_needed_buffers(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int instance, kind;
 	for (instance = 0; instance < NR_MPIPE_MAX &&
 		     info->mpipe[instance].has_iqueue; instance++)	{
@@ -653,7 +653,7 @@ drop:
  */
 static int tile_net_poll(struct napi_struct *napi, int budget)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned int work = 0;
 	gxio_mpipe_idesc_t *idesc;
 	int instance, i, n;
@@ -699,7 +699,7 @@ done:
 /* Handle an ingress interrupt from an instance on the current cpu. */
 static irqreturn_t tile_net_handle_ingress_irq(int irq, void *id)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	napi_schedule(&info->mpipe[(uint64_t)id].napi);
 	return IRQ_HANDLED;
 }
@@ -762,7 +762,7 @@ static enum hrtimer_restart tile_net_han
 /* Make sure the egress timer is scheduled. */
 static void tile_net_schedule_egress_timer(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 
 	if (!info->egress_timer_scheduled) {
 		hrtimer_start(&info->egress_timer,
@@ -779,7 +779,7 @@ static void tile_net_schedule_egress_tim
  */
 static enum hrtimer_restart tile_net_handle_egress_timer(struct hrtimer *t)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned long irqflags;
 	bool pending = false;
 	int i, instance;
@@ -1933,7 +1933,7 @@ static void tso_egress(struct net_device
  */
 static int tile_net_tx_tso(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int channel = priv->echannel;
 	int instance = priv->instance;
@@ -2002,7 +2002,7 @@ static unsigned int tile_net_tx_frags(st
 /* Help the kernel transmit a packet. */
 static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int instance = priv->instance;
 	struct mpipe_data *md = &mpipe_data[instance];
@@ -2141,7 +2141,7 @@ static int tile_net_set_mac_address(stru
 static void tile_net_netpoll(struct net_device *dev)
 {
 	int instance = mpipe_instance(dev);
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct mpipe_data *md = &mpipe_data[instance];
 
 	disable_percpu_irq(md->ingress_irq);
@@ -2248,7 +2248,7 @@ static void tile_net_dev_init(const char
 /* Per-cpu module initialization. */
 static void tile_net_init_module_percpu(void *unused)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int my_cpu = smp_processor_id();
 	int instance;
 
Index: linux/drivers/net/ethernet/tile/tilepro.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilepro.c	2013-12-02 16:07:54.574500726 -0600
+++ linux/drivers/net/ethernet/tile/tilepro.c	2013-12-02 16:07:54.564501002 -0600
@@ -993,13 +993,13 @@ static void tile_net_register(void *dev_
 	PDEBUG("tile_net_register(queue_id %d)\n", queue_id);
 
 	if (!strcmp(dev->name, "xgbe0"))
-		info = &__get_cpu_var(hv_xgbe0);
+		info = this_cpu_ptr(&hv_xgbe0);
 	else if (!strcmp(dev->name, "xgbe1"))
-		info = &__get_cpu_var(hv_xgbe1);
+		info = this_cpu_ptr(&hv_xgbe1);
 	else if (!strcmp(dev->name, "gbe0"))
-		info = &__get_cpu_var(hv_gbe0);
+		info = this_cpu_ptr(&hv_gbe0);
 	else if (!strcmp(dev->name, "gbe1"))
-		info = &__get_cpu_var(hv_gbe1);
+		info = this_cpu_ptr(&hv_gbe1);
 	else
 		BUG();
 

