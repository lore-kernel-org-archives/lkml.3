Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaBNUTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:19:48 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:52766 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbaBNUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:19:45 -0500
Message-Id: <20140214201905.699872826@linux.com>
Date: Fri, 14 Feb 2014 14:18:58 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH 17/48] drivers/net/ethernet/tile: Replace __get_cpu_var uses for address calculation
References: <20140214201841.826179349@linux.com>
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
--- linux.orig/drivers/net/ethernet/tile/tilegx.c	2014-02-03 13:55:50.504361347 -0600
+++ linux/drivers/net/ethernet/tile/tilegx.c	2014-02-03 13:57:14.172605727 -0600
@@ -423,7 +423,7 @@
 /* Provide linux buffers to mPIPE. */
 static void tile_net_provide_needed_buffers(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int instance, kind;
 	for (instance = 0; instance < NR_MPIPE_MAX &&
 		     info->mpipe[instance].has_iqueue; instance++)	{
@@ -585,7 +585,7 @@
 /* Handle a packet.  Return true if "processed", false if "filtered". */
 static bool tile_net_handle_packet(int instance, gxio_mpipe_idesc_t *idesc)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct mpipe_data *md = &mpipe_data[instance];
 	struct net_device *dev = md->tile_net_devs_for_channel[idesc->channel];
 	uint8_t l2_offset;
@@ -651,7 +651,7 @@
  */
 static int tile_net_poll(struct napi_struct *napi, int budget)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned int work = 0;
 	gxio_mpipe_idesc_t *idesc;
 	int instance, i, n;
@@ -697,7 +697,7 @@
 /* Handle an ingress interrupt from an instance on the current cpu. */
 static irqreturn_t tile_net_handle_ingress_irq(int irq, void *id)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	napi_schedule(&info->mpipe[(uint64_t)id].napi);
 	return IRQ_HANDLED;
 }
@@ -760,7 +760,7 @@
 /* Make sure the egress timer is scheduled. */
 static void tile_net_schedule_egress_timer(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 
 	if (!info->egress_timer_scheduled) {
 		hrtimer_start(&info->egress_timer,
@@ -777,7 +777,7 @@
  */
 static enum hrtimer_restart tile_net_handle_egress_timer(struct hrtimer *t)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned long irqflags;
 	bool pending = false;
 	int i, instance;
@@ -1992,7 +1992,7 @@
 /* Help the kernel transmit a packet. */
 static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int instance = priv->instance;
 	struct mpipe_data *md = &mpipe_data[instance];
@@ -2134,7 +2134,7 @@
 static void tile_net_netpoll(struct net_device *dev)
 {
 	int instance = mpipe_instance(dev);
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct mpipe_data *md = &mpipe_data[instance];
 
 	disable_percpu_irq(md->ingress_irq);
@@ -2241,7 +2241,7 @@
 /* Per-cpu module initialization. */
 static void tile_net_init_module_percpu(void *unused)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int my_cpu = smp_processor_id();
 	int instance;
 
Index: linux/drivers/net/ethernet/tile/tilepro.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilepro.c	2014-02-03 13:55:50.504361347 -0600
+++ linux/drivers/net/ethernet/tile/tilepro.c	2014-02-03 13:55:50.504361347 -0600
@@ -993,13 +993,13 @@
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
 

