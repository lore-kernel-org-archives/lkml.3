Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaDIAv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 20:51:27 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53412
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387AbaDIAvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 20:51:24 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: hv: Eliminate the channel spinlock in the callback path
Date: Tue,  8 Apr 2014 18:45:53 -0700
Message-Id: <1397007954-13596-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1397007928-13555-1-git-send-email-kys@microsoft.com>
References: <1397007928-13555-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By ensuring that we set the callback handler to NULL in the channel close
path on the same CPU that the channel is bound to, we can eliminate this lock
acquisition and release in a performance critical path.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/channel.c      |   16 ++++++++++++----
 drivers/hv/channel_mgmt.c |   11 +++++++----
 drivers/hv/connection.c   |   11 ++++-------
 include/linux/hyperv.h    |    2 ++
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 602ca86..740edec 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -471,18 +471,26 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
 
+static void reset_channel_cb(void *arg)
+{
+	struct vmbus_channel *channel = arg;
+
+	channel->onchannel_callback = NULL;
+}
+
 static void vmbus_close_internal(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	int ret;
-	unsigned long flags;
 
 	channel->state = CHANNEL_OPEN_STATE;
 	channel->sc_creation_callback = NULL;
 	/* Stop callback and cancel the timer asap */
-	spin_lock_irqsave(&channel->inbound_lock, flags);
-	channel->onchannel_callback = NULL;
-	spin_unlock_irqrestore(&channel->inbound_lock, flags);
+	if (channel->target_cpu != smp_processor_id())
+		smp_call_function_single(channel->target_cpu, reset_channel_cb,
+					 channel, true);
+	else
+		reset_channel_cb(channel);
 
 	/* Send a closing message */
 
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index fa92046..6f7fdd9 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -365,7 +365,7 @@ static u32  next_vp;
  * performance critical channels (IDE, SCSI and Network) will be uniformly
  * distributed across all available CPUs.
  */
-static u32 get_vp_index(uuid_le *type_guid)
+static void init_vp_index(struct vmbus_channel *channel, uuid_le *type_guid)
 {
 	u32 cur_cpu;
 	int i;
@@ -387,10 +387,13 @@ static u32 get_vp_index(uuid_le *type_guid)
 		 * Also if the channel is not a performance critical
 		 * channel, bind it to cpu 0.
 		 */
-		return 0;
+		channel->target_cpu = 0;
+		channel->target_vp = 0;
+		return;
 	}
 	cur_cpu = (++next_vp % max_cpus);
-	return hv_context.vp_index[cur_cpu];
+	channel->target_cpu = cur_cpu;
+	channel->target_vp = hv_context.vp_index[cur_cpu];
 }
 
 /*
@@ -438,7 +441,7 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 				offer->connection_id;
 	}
 
-	newchannel->target_vp = get_vp_index(&offer->offer.if_type);
+	init_vp_index(newchannel, &offer->offer.if_type);
 
 	memcpy(&newchannel->offermsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index f2d7bf9..d484bad 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -274,7 +274,6 @@ struct vmbus_channel *relid2channel(u32 relid)
 static void process_chn_event(u32 relid)
 {
 	struct vmbus_channel *channel;
-	unsigned long flags;
 	void *arg;
 	bool read_state;
 	u32 bytes_to_read;
@@ -293,13 +292,12 @@ static void process_chn_event(u32 relid)
 	/*
 	 * A channel once created is persistent even when there
 	 * is no driver handling the device. An unloading driver
-	 * sets the onchannel_callback to NULL under the
-	 * protection of the channel inbound_lock. Thus, checking
-	 * and invoking the driver specific callback takes care of
-	 * orderly unloading of the driver.
+	 * sets the onchannel_callback to NULL on the same CPU
+	 * as where this interrupt is handled (in an interrupt context).
+	 * Thus, checking and invoking the driver specific callback takes
+	 * care of orderly unloading of the driver.
 	 */
 
-	spin_lock_irqsave(&channel->inbound_lock, flags);
 	if (channel->onchannel_callback != NULL) {
 		arg = channel->channel_callback_context;
 		read_state = channel->batched_reading;
@@ -324,7 +322,6 @@ static void process_chn_event(u32 relid)
 		pr_err("no channel callback for relid - %u\n", relid);
 	}
 
-	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 }
 
 /*
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index ab7359f..8b41570 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -694,6 +694,8 @@ struct vmbus_channel {
 	 * preserve the earlier behavior.
 	 */
 	u32 target_vp;
+	/* The corresponding CPUID in the guest */
+	u32 target_cpu;
 	/*
 	 * Support for sub-channels. For high performance devices,
 	 * it will be useful to have multiple sub-channels to support
-- 
1.7.4.1

