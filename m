Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3HWTKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:10:31 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:50634 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756088Ab3HWTK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:10:29 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 15:10:29 EDT
Message-ID: <00000140ac8e2d12-c1b289ff-e582-4dc9-bbe0-a4a37e0a83b1-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Fri, 23 Aug 2013 19:02:13 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [guv 05/16] drivers: Convert __get_cpu_var uses
References: <20130823190135.726207430@linux.com>
X-SES-Outgoing: 2013.08.23-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/char/random.c
===================================================================
--- linux.orig/drivers/char/random.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/char/random.c	2013-08-22 14:16:11.319914096 -0500
@@ -744,7 +744,7 @@ static DEFINE_PER_CPU(struct fast_pool,
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
-	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
+	struct fast_pool	*fast_pool = this_cpu_ptr(&irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	__u32			input[4], cycles = get_cycles();
Index: linux/drivers/clocksource/metag_generic.c
===================================================================
--- linux.orig/drivers/clocksource/metag_generic.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/clocksource/metag_generic.c	2013-08-22 14:16:11.323914055 -0500
@@ -90,7 +90,7 @@ static struct clocksource clocksource_me
 
 static irqreturn_t metag_timer_interrupt(int irq, void *dummy)
 {
-	struct clock_event_device *evt = &__get_cpu_var(local_clockevent);
+	struct clock_event_device *evt = this_cpu_ptr(&local_clockevent);
 
 	evt->event_handler(evt);
 
Index: linux/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux.orig/drivers/cpuidle/governors/ladder.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/cpuidle/governors/ladder.c	2013-08-22 14:16:11.323914055 -0500
@@ -66,7 +66,7 @@ static inline void ladder_do_selection(s
 static int ladder_select_state(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
-	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
+	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	struct ladder_device_state *last_state;
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
@@ -170,7 +170,7 @@ static int ladder_enable_device(struct c
  */
 static void ladder_reflect(struct cpuidle_device *dev, int index)
 {
-	struct ladder_device *ldev = &__get_cpu_var(ladder_devices);
+	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	if (index > 0)
 		ldev->last_state_idx = index;
 }
Index: linux/drivers/cpuidle/governors/menu.c
===================================================================
--- linux.orig/drivers/cpuidle/governors/menu.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/cpuidle/governors/menu.c	2013-08-22 14:16:11.323914055 -0500
@@ -258,7 +258,7 @@ again:
  */
 static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
@@ -342,7 +342,7 @@ static int menu_select(struct cpuidle_dr
  */
 static void menu_reflect(struct cpuidle_device *dev, int index)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	data->last_state_idx = index;
 	if (index >= 0)
 		data->needs_update = 1;
@@ -355,7 +355,7 @@ static void menu_reflect(struct cpuidle_
  */
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
-	struct menu_device *data = &__get_cpu_var(menu_devices);
+	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int last_idx = data->last_state_idx;
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &drv->states[last_idx];
Index: linux/drivers/leds/trigger/ledtrig-cpu.c
===================================================================
--- linux.orig/drivers/leds/trigger/ledtrig-cpu.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/leds/trigger/ledtrig-cpu.c	2013-08-22 14:16:11.323914055 -0500
@@ -46,7 +46,7 @@ static DEFINE_PER_CPU(struct led_trigger
  */
 void ledtrig_cpu(enum cpu_led_event ledevt)
 {
-	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
+	struct led_trigger_cpu *trig = this_cpu_ptr(&cpu_trig);
 
 	/* Locate the correct CPU LED */
 	switch (ledevt) {
Index: linux/drivers/net/ethernet/tile/tilegx.c
===================================================================
--- linux.orig/drivers/net/ethernet/tile/tilegx.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/net/ethernet/tile/tilegx.c	2013-08-22 14:16:11.323914055 -0500
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
--- linux.orig/drivers/net/ethernet/tile/tilepro.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/net/ethernet/tile/tilepro.c	2013-08-22 14:16:11.327914014 -0500
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
 
Index: linux/drivers/oprofile/cpu_buffer.c
===================================================================
--- linux.orig/drivers/oprofile/cpu_buffer.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/oprofile/cpu_buffer.c	2013-08-22 14:16:11.327914014 -0500
@@ -45,7 +45,7 @@ unsigned long oprofile_get_cpu_buffer_si
 
 void oprofile_cpu_buffer_inc_smpl_lost(void)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	cpu_buf->sample_lost_overflow++;
 }
@@ -297,7 +297,7 @@ __oprofile_add_ext_sample(unsigned long
 			  unsigned long event, int is_kernel,
 			  struct task_struct *task)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 	unsigned long backtrace = oprofile_backtrace_depth;
 
 	/*
@@ -357,7 +357,7 @@ oprofile_write_reserve(struct op_entry *
 {
 	struct op_sample *sample;
 	int is_kernel = !user_mode(regs);
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	cpu_buf->sample_received++;
 
@@ -412,13 +412,13 @@ int oprofile_write_commit(struct op_entr
 
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 	log_sample(cpu_buf, pc, 0, is_kernel, event, NULL);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_cpu_buffer *cpu_buf = this_cpu_ptr(&op_cpu_buffer);
 
 	if (!cpu_buf->tracing)
 		return;
Index: linux/drivers/oprofile/timer_int.c
===================================================================
--- linux.orig/drivers/oprofile/timer_int.c	2013-08-22 14:16:11.335913933 -0500
+++ linux/drivers/oprofile/timer_int.c	2013-08-22 14:16:11.327914014 -0500
@@ -32,7 +32,7 @@ static enum hrtimer_restart oprofile_hrt
 
 static void __oprofile_hrtimer_start(void *unused)
 {
-	struct hrtimer *hrtimer = &__get_cpu_var(oprofile_hrtimer);
+	struct hrtimer *hrtimer = this_cpu_ptr(&oprofile_hrtimer);
 
 	if (!ctr_running)
 		return;

