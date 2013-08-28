Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3H1T5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:57:47 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:14325 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab3H1T5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:57:43 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Aug 2013 15:57:43 EDT
Message-Id: <00000140c6782172-b4abbb03-14bc-411f-adb4-50f2f0b252a9-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Wed, 28 Aug 2013 19:48:16 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [gcv v3 17/35] drivers/net/ethernet/tile: Replace __get_cpu_var uses
References: <20130828193457.140443630@linux.com>
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() is used for multiple purposes in the kernel source. One of them is
address calculation via the form &__get_cpu_var(x). This calculates the address for
the instance of the percpu variable of the current processor based on an offset.

Other use cases are for storing and retrieving data from the current processors percpu area.
__get_cpu_var() can be used as an lvalue when writing data or on the right side of an assignment.

__get_cpu_var() is defined as :


#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))



__get_cpu_var() always only does an address determination. However, store and retrieve operations
could use a segment prefix (or global register on other platforms) to avoid the address calculation.

this_cpu_write() and this_cpu_read() can directly take an offset into a percpu area and use
optimized assembly code to read and write per cpu variables.


This patch converts __get_cpu_var into either an explicit address calculation using this_cpu_ptr()
or into a use of this_cpu operations that use the offset. Thereby address calcualtions are avoided
and less registers are used when code is generated.

At the end of the patchset all uses of __get_cpu_var have been removed so the macro is removed too.

The patchset includes passes over all arches as well. Once these operations are used throughout then
specialized macros can be defined in non -x86 arches as well in order to optimize per cpu access by
f.e. using a global register that may be set to the per cpu base.




Transformations done to __get_cpu_var()


1. Determine the address of the percpu instance of the current processor.

	DEFINE_PER_CPU(int, y);
	int *x = &__get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(&y);


2. Same as #1 but this time an array structure is involved.

	DEFINE_PER_CPU(int, y[20]);
	int *x = __get_cpu_var(y);

    Converts to

	int *x = this_cpu_ptr(y);


3. Retrieve the content of the current processors instance of a per cpu variable.

	DEFINE_PER_CPU(int, u);
	int x = __get_cpu_var(y)

   Converts to

	int x = __this_cpu_read(y);


4. Retrieve the content of a percpu struct

	DEFINE_PER_CPU(struct mystruct, y);
	struct mystruct x = __get_cpu_var(y);

   Converts to

	memcpy(this_cpu_ptr(&x), y, sizeof(x));


5. Assignment to a per cpu variable

	DEFINE_PER_CPU(int, y)
	__get_cpu_var(y) = x;

   Converts to

	this_cpu_write(y, x);


6. Increment/Decrement etc of a per cpu variable

	DEFINE_PER_CPU(int, y);
	__get_cpu_var(y)++

   Converts to

	this_cpu_inc(y)



Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilegx.c	2013-08-27 14:39:22.471612150 -0500
+++ linux/drivers/net/ethernet/tile/tilegx.c	2013-08-27 14:39:22.463612231 -0500
@@ -368,7 +368,7 @@ static void tile_net_pop_all_buffers(int
 /* Provide linux buffers to mPIPE. */
 static void tile_net_provide_needed_buffers(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 
 	while (info->num_needed_small_buffers != 0) {
 		if (!tile_net_provide_buffer(true))
@@ -407,7 +407,7 @@ static inline bool filter_packet(struct
 static void tile_net_receive_skb(struct net_device *dev, struct sk_buff *skb,
 				 gxio_mpipe_idesc_t *idesc, unsigned long len)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 
 	/* Encode the actual packet length. */
@@ -435,7 +435,7 @@ static void tile_net_receive_skb(struct
 /* Handle a packet.  Return true if "processed", false if "filtered". */
 static bool tile_net_handle_packet(gxio_mpipe_idesc_t *idesc)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct net_device *dev = tile_net_devs_for_channel[idesc->channel];
 	uint8_t l2_offset;
 	void *va;
@@ -498,7 +498,7 @@ static bool tile_net_handle_packet(gxio_
  */
 static int tile_net_poll(struct napi_struct *napi, int budget)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned int work = 0;
 	gxio_mpipe_idesc_t *idesc;
 	int i, n;
@@ -536,7 +536,7 @@ done:
 /* Handle an ingress interrupt on the current cpu. */
 static irqreturn_t tile_net_handle_ingress_irq(int irq, void *unused)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	napi_schedule(&info->napi);
 	return IRQ_HANDLED;
 }
@@ -597,7 +597,7 @@ static enum hrtimer_restart tile_net_han
 /* Make sure the egress timer is scheduled. */
 static void tile_net_schedule_egress_timer(void)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 
 	if (!info->egress_timer_scheduled) {
 		hrtimer_start(&info->egress_timer,
@@ -614,7 +614,7 @@ static void tile_net_schedule_egress_tim
  */
 static enum hrtimer_restart tile_net_handle_egress_timer(struct hrtimer *t)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	unsigned long irqflags;
 	bool pending = false;
 	int i;
@@ -649,7 +649,7 @@ static enum hrtimer_restart tile_net_han
  */
 static void tile_net_update_cpu(void *arg)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct net_device *dev = arg;
 
 	if (!info->has_iqueue)
@@ -1572,7 +1572,7 @@ static void tso_egress(struct net_device
  */
 static int tile_net_tx_tso(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	int channel = priv->echannel;
 	struct tile_net_egress *egress = &egress_for_echannel[channel];
@@ -1638,7 +1638,7 @@ static unsigned int tile_net_tx_frags(st
 /* Help the kernel transmit a packet. */
 static int tile_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	struct tile_net_priv *priv = netdev_priv(dev);
 	struct tile_net_egress *egress = &egress_for_echannel[priv->echannel];
 	gxio_mpipe_equeue_t *equeue = egress->equeue;
@@ -1869,7 +1869,7 @@ static void tile_net_dev_init(const char
 /* Per-cpu module initialization. */
 static void tile_net_init_module_percpu(void *unused)
 {
-	struct tile_net_info *info = &__get_cpu_var(per_cpu_info);
+	struct tile_net_info *info = this_cpu_ptr(&per_cpu_info);
 	int my_cpu = smp_processor_id();
 
 	info->has_iqueue = false;
Index: linux/drivers/net/ethernet/tile/tilepro.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilepro.c	2013-08-27 14:39:22.471612150 -0500
+++ linux/drivers/net/ethernet/tile/tilepro.c	2013-08-27 14:39:22.463612231 -0500
@@ -1078,13 +1078,13 @@ static void tile_net_register(void *dev_
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
 

