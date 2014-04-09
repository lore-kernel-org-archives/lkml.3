Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaDIAv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:51:26 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34152
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380AbaDIAvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:51:24 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: hv: vmbus: Implement per-CPU mapping of relid to channel
Date: Tue,  8 Apr 2014 18:45:54 -0700
Message-Id: <1397007954-13596-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1397007954-13596-1-git-send-email-kys@microsoft.com>
References: <1397007928-13555-1-git-send-email-kys@microsoft.com>
 <1397007954-13596-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the mapping of the relID to channel is done under the protection of a
single spin lock. Starting with ws2012, each channel is bound to a specific VCPU
in the guest. Use this binding to eliminate the spin lock by setting up
per-cpu state for mapping relId to the channel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel_mgmt.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 drivers/hv/connection.c   |   24 +++++++++++++++++++++++-
 drivers/hv/hv.c           |    2 ++
 drivers/hv/hyperv_vmbus.h |    5 +++++
 include/linux/hyperv.h    |    5 +++++
 5 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 6f7fdd9..6c8b032c 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -149,6 +149,7 @@ static struct vmbus_channel *alloc_channel(void)
 	spin_lock_init(&channel->sc_lock);
 
 	INIT_LIST_HEAD(&channel->sc_list);
+	INIT_LIST_HEAD(&channel->percpu_list);
 
 	channel->controlwq = create_workqueue("hv_vmbus_ctl");
 	if (!channel->controlwq) {
@@ -188,7 +189,20 @@ static void free_channel(struct vmbus_channel *channel)
 	queue_work(vmbus_connection.work_queue, &channel->work);
 }
 
+static void percpu_channel_enq(void *arg)
+{
+	struct vmbus_channel *channel = arg;
+	int cpu = smp_processor_id();
+
+	list_add_tail(&channel->percpu_list, &hv_context.percpu_list[cpu]);
+}
 
+static void percpu_channel_deq(void *arg)
+{
+	struct vmbus_channel *channel = arg;
+
+	list_del(&channel->percpu_list);
+}
 
 /*
  * vmbus_process_rescind_offer -
@@ -210,6 +224,12 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
 	vmbus_post_msg(&msg, sizeof(struct vmbus_channel_relid_released));
 
+	if (channel->target_cpu != smp_processor_id())
+		smp_call_function_single(channel->target_cpu,
+					 percpu_channel_deq, channel, true);
+	else
+		percpu_channel_deq(channel);
+
 	if (channel->primary_channel == NULL) {
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 		list_del(&channel->listentry);
@@ -245,6 +265,7 @@ static void vmbus_process_offer(struct work_struct *work)
 							work);
 	struct vmbus_channel *channel;
 	bool fnew = true;
+	bool enq = false;
 	int ret;
 	unsigned long flags;
 
@@ -264,12 +285,22 @@ static void vmbus_process_offer(struct work_struct *work)
 		}
 	}
 
-	if (fnew)
+	if (fnew) {
 		list_add_tail(&newchannel->listentry,
 			      &vmbus_connection.chn_list);
+		enq = true;
+	}
 
 	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
+	if (enq) {
+		if (newchannel->target_cpu != smp_processor_id())
+			smp_call_function_single(newchannel->target_cpu,
+						 percpu_channel_enq,
+						 newchannel, true);
+		else
+			percpu_channel_enq(newchannel);
+	}
 	if (!fnew) {
 		/*
 		 * Check to see if this is a sub-channel.
@@ -282,6 +313,14 @@ static void vmbus_process_offer(struct work_struct *work)
 			spin_lock_irqsave(&channel->sc_lock, flags);
 			list_add_tail(&newchannel->sc_list, &channel->sc_list);
 			spin_unlock_irqrestore(&channel->sc_lock, flags);
+
+			if (newchannel->target_cpu != smp_processor_id())
+				smp_call_function_single(newchannel->target_cpu,
+							 percpu_channel_enq,
+							 newchannel, true);
+			else
+				percpu_channel_enq(newchannel);
+
 			newchannel->state = CHANNEL_OPEN_STATE;
 			if (channel->sc_creation_callback != NULL)
 				channel->sc_creation_callback(newchannel);
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index d484bad..3589236 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -231,6 +231,28 @@ cleanup:
 	return ret;
 }
 
+/*
+ * Map the given relid to the corresponding channel based on the
+ * per-cpu list of channels that have been affinitized to this CPU.
+ * This will be used in the channel callback path as we can do this
+ * mapping in a lock-free fashion.
+ */
+static struct vmbus_channel *pcpu_relid2channel(u32 relid)
+{
+	struct vmbus_channel *channel;
+	struct vmbus_channel *found_channel  = NULL;
+	int cpu = smp_processor_id();
+	struct list_head *pcpu_head = &hv_context.percpu_list[cpu];
+
+	list_for_each_entry(channel, pcpu_head, percpu_list) {
+		if (channel->offermsg.child_relid == relid) {
+			found_channel = channel;
+			break;
+		}
+	}
+
+	return found_channel;
+}
 
 /*
  * relid2channel - Get the channel object given its
@@ -282,7 +304,7 @@ static void process_chn_event(u32 relid)
 	 * Find the channel based on this relid and invokes the
 	 * channel callback to process the event
 	 */
-	channel = relid2channel(relid);
+	channel = pcpu_relid2channel(relid);
 
 	if (!channel) {
 		pr_err("channel not found for relid - %u\n", relid);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index bcb4950..edfc848 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -383,6 +383,8 @@ void hv_synic_init(void *arg)
 	 */
 	rdmsrl(HV_X64_MSR_VP_INDEX, vp_index);
 	hv_context.vp_index[cpu] = (u32)vp_index;
+
+	INIT_LIST_HEAD(&hv_context.percpu_list[cpu]);
 	return;
 }
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 860134d..18d1a84 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -510,6 +510,11 @@ struct hv_context {
 	 * basis.
 	 */
 	struct tasklet_struct *event_dpc[NR_CPUS];
+	/*
+	 * To optimize the mapping of relid to channel, maintain
+	 * per-cpu list of the channels based on their CPU affinity.
+	 */
+	struct list_head percpu_list[NR_CPUS];
 };
 
 extern struct hv_context hv_context;
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 8b41570..ebd0441 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -732,6 +732,11 @@ struct vmbus_channel {
 	 * Support per-channel state for use by vmbus drivers.
 	 */
 	void *per_channel_state;
+	/*
+	 * To support per-cpu lookup mapping of relid to channel,
+	 * link up channels based on their CPU affinity.
+	 */
+	struct list_head percpu_list;
 };
 
 static inline void set_channel_read_state(struct vmbus_channel *c, bool state)
-- 
1.7.4.1

