Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3IRVBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:01:16 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53770 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3IRVBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:01:13 -0400
Date: Wed, 18 Sep 2013 14:01:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, dan.carpenter@oracle.com,
        linux-input@vger.kernel.org, vojtech@suse.cz
Subject: Re: [PATCH V2 1/1] Drivers: input: serio: New driver to support
 Hyper-V synthetic keyboard
Message-ID: <20130918210107.GA32320@core.coreip.homeip.net>
References: <1379460418-1523-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379460418-1523-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi K.Y.,

On Tue, Sep 17, 2013 at 04:26:58PM -0700, K. Y. Srinivasan wrote:
> Add a new driver to support synthetic keyboard. On the next generation
> Hyper-V guest firmware, many legacy devices will not be emulated and this
> driver will be required.
> 
> I would like to thank Vojtech Pavlik <vojtech@suse.cz> for helping me with the
> details of the AT keyboard driver. I would also like to thank
> Dan Carpenter <dan.carpenter@oracle.com> and
> Dmitry Torokhov <dmitry.torokhov@gmail.com> for their detailed review of this
> driver.
> 
> I have addressed all the comments of Dan and Dmitry in this version of
> the patch

This looks much better. Could you tell me if the patch below (on top of
yours) still works?

Thanks.

-- 
Dmitry

Input: hyperv-keyboard - misc changes

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/serio/Kconfig           |    3 
 drivers/input/serio/hyperv-keyboard.c |  378 ++++++++++++++++++---------------
 2 files changed, 208 insertions(+), 173 deletions(-)

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index f3996e7..a5f342e 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -274,4 +274,7 @@ config HYPERV_KEYBOARD
 	help
 	  Select this option to enable the Hyper-V Keyboard driver.
 
+	  To compile this driver as a module, choose M here: the module will
+	  be called hyperv_keyboard.
+
 endif
diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
index c327a18..401fbdd 100644
--- a/drivers/input/serio/hyperv-keyboard.c
+++ b/drivers/input/serio/hyperv-keyboard.c
@@ -10,6 +10,7 @@
  *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
  *  more details.
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -42,20 +43,16 @@ enum synth_kbd_msg_type {
  * Basic message structures.
  */
 struct synth_kbd_msg_hdr {
-	u32 type;
+	__le32 type;
 };
 
 struct synth_kbd_msg {
 	struct synth_kbd_msg_hdr header;
-	char data[1]; /* Enclosed message */
+	char data[]; /* Enclosed message */
 };
 
 union synth_kbd_version {
-	struct {
-		u16 minor_version;
-		u16 major_version;
-	};
-	u32 version;
+	__le32 version;
 };
 
 /*
@@ -78,8 +75,8 @@ struct synth_kbd_protocol_response {
 #define IS_E1		BIT(3)
 struct synth_kbd_keystroke {
 	struct synth_kbd_msg_hdr header;
-	u16 make_code;
-	u16 reserved0;
+	__le16 make_code;
+	__le16 reserved0;
 	__le32 info; /* Additional information */
 };
 
@@ -98,58 +95,27 @@ struct synth_kbd_keystroke {
  * Represents a keyboard device
  */
 struct hv_kbd_dev {
-	struct hv_device	*device;
+	struct hv_device *hv_dev;
+	struct serio *hv_serio;
 	struct synth_kbd_protocol_request protocol_req;
 	struct synth_kbd_protocol_response protocol_resp;
 	/* Synchronize the request/response if needed */
-	struct completion	wait_event;
-	struct serio		*hv_serio;
+	struct completion wait_event;
+	spinlock_t lock; /* protects 'started' field */
+	bool started;
 };
 
-
-static struct hv_kbd_dev *hv_kbd_alloc_device(struct hv_device *device)
-{
-	struct hv_kbd_dev *kbd_dev;
-	struct serio *hv_serio;
-
-	kbd_dev = kzalloc(sizeof(struct hv_kbd_dev), GFP_KERNEL);
-	if (!kbd_dev)
-		return NULL;
-	hv_serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
-	if (hv_serio == NULL) {
-		kfree(kbd_dev);
-		return NULL;
-	}
-	hv_serio->id.type = SERIO_8042_XL;
-	strlcpy(hv_serio->name, dev_name(&device->device),
-		sizeof(hv_serio->name));
-	strlcpy(hv_serio->phys, dev_name(&device->device),
-		sizeof(hv_serio->phys));
-	hv_serio->dev.parent  = &device->device;
-	kbd_dev->device = device;
-	kbd_dev->hv_serio = hv_serio;
-	hv_set_drvdata(device, kbd_dev);
-	init_completion(&kbd_dev->wait_event);
-
-	return kbd_dev;
-}
-
-static void hv_kbd_free_device(struct hv_kbd_dev *device)
-{
-	serio_unregister_port(device->hv_serio);
-	hv_set_drvdata(device->device, NULL);
-	kfree(device);
-}
-
-static void hv_kbd_on_receive(struct hv_device *device,
-				struct synth_kbd_msg *msg, u32 msg_length)
+static void hv_kbd_on_receive(struct hv_device *hv_dev,
+			      struct synth_kbd_msg *msg, u32 msg_length)
 {
-	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(device);
+	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(hv_dev);
 	struct synth_kbd_keystroke *ks_msg;
-	u16 scan_code;
+	unsigned long flags;
+	u32 msg_type = __le32_to_cpu(msg->header.type);
 	u32 info;
+	u16 scan_code;
 
-	switch (msg->header.type) {
+	switch (msg_type) {
 	case SYNTH_KBD_PROTOCOL_RESPONSE:
 		/*
 		 * Validate the information provided by the host.
@@ -158,13 +124,17 @@ static void hv_kbd_on_receive(struct hv_device *device,
 		 * goes away).
 		 */
 		if (msg_length < sizeof(struct synth_kbd_protocol_response)) {
-			pr_err("Illegal protocol response packet\n");
+			dev_err(&hv_dev->device,
+				"Illegal protocol response packet (len: %d)\n",
+				msg_length);
 			break;
 		}
+
 		memcpy(&kbd_dev->protocol_resp, msg,
 			sizeof(struct synth_kbd_protocol_response));
 		complete(&kbd_dev->wait_event);
 		break;
+
 	case SYNTH_KBD_EVENT:
 		/*
 		 * Validate the information provided by the host.
@@ -173,105 +143,122 @@ static void hv_kbd_on_receive(struct hv_device *device,
 		 * goes away).
 		 */
 		if (msg_length < sizeof(struct  synth_kbd_keystroke)) {
-			pr_err("Illegal keyboard event  packet\n");
+			dev_err(&hv_dev->device,
+				"Illegal keyboard event packet (len: %d)\n",
+				msg_length);
 			break;
 		}
+
 		ks_msg = (struct synth_kbd_keystroke *)msg;
-		scan_code = ks_msg->make_code;
 		info = __le32_to_cpu(ks_msg->info);
 
 		/*
 		 * Inject the information through the serio interrupt.
 		 */
-		if (info & IS_E0)
-			serio_interrupt(kbd_dev->hv_serio, XTKBD_EMUL0, 0);
-		serio_interrupt(kbd_dev->hv_serio,
-				scan_code | ((info & IS_BREAK) ?
-				XTKBD_RELEASE : 0),
-				0);
+		spin_lock_irqsave(&kbd_dev->lock, flags);
+		if (kbd_dev->started) {
+			if (info & IS_E0)
+				serio_interrupt(kbd_dev->hv_serio,
+						XTKBD_EMUL0, 0);
+
+			scan_code = __le16_to_cpu(ks_msg->make_code);
+			if (info & IS_BREAK)
+				scan_code |= XTKBD_RELEASE;
+
+			serio_interrupt(kbd_dev->hv_serio, scan_code, 0);
+		}
+		spin_unlock_irqrestore(&kbd_dev->lock, flags);
+		break;
+
+	default:
+		dev_err(&hv_dev->device,
+			"unhandled message type %d\n", msg_type);
+	}
+}
+
+static void hv_kbd_handle_received_packet(struct hv_device *hv_dev,
+					  struct vmpacket_descriptor *desc,
+					  u32 bytes_recvd,
+					  u64 req_id)
+{
+	struct synth_kbd_msg *msg;
+	u32 msg_sz;
+
+	switch (desc->type) {
+	case VM_PKT_COMP:
+		break;
+
+	case VM_PKT_DATA_INBAND:
+		/*
+		 * We have a packet that has "inband" data. The API used
+		 * for retrieving the packet guarantees that the complete
+		 * packet is read. So, minimally, we should be able to
+		 * parse the payload header safely (assuming that the host
+		 * can be trusted.  Trusting the host seems to be a
+		 * reasonable assumption because in a virtualized
+		 * environment there is not whole lot you can do if you
+		 * don't trust the host.
+		 *
+		 * Nonetheless, let us validate if the host can be trusted
+		 * (in a trivial way).  The interesting aspect of this
+		 * validation is how do you recover if we discover that the
+		 * host is not to be trusted? Simply dropping the packet, I
+		 * don't think is an appropriate recovery.  In the interest
+		 * of failing fast, it may be better to crash the guest.
+		 * For now, I will just drop the packet!
+		 */
+
+		msg_sz = bytes_recvd - (desc->offset8 << 3);
+		if (msg_sz <= sizeof(struct synth_kbd_msg_hdr)) {
+			/*
+			 * Drop the packet and hope
+			 * the problem magically goes away.
+			 */
+			dev_err(&hv_dev->device,
+				"Illegal packet (type: %d, tid: %llx, size: %d)\n",
+				desc->type, req_id, msg_sz);
+			break;
+		}
+
+		msg = (void *)desc + (desc->offset8 << 3);
+		hv_kbd_on_receive(hv_dev, msg, msg_sz);
 		break;
+
 	default:
-		pr_err("unhandled message type %d\n", msg->header.type);
+		dev_err(&hv_dev->device,
+			"unhandled packet type %d, tid %llx len %d\n",
+			desc->type, req_id, bytes_recvd);
+		break;
 	}
 }
 
 static void hv_kbd_on_channel_callback(void *context)
 {
-	const int packet_size = 0x100;
-	int ret;
-	struct hv_device *device = context;
+	struct hv_device *hv_dev = context;
+	void *buffer;
+	int bufferlen = 0x100; /* Start with sensible size */
 	u32 bytes_recvd;
 	u64 req_id;
-	struct vmpacket_descriptor *desc;
-	struct synth_kbd_msg *msg;
-	int hdr_sz = sizeof(struct synth_kbd_msg);
-	int msg_sz;
-	unsigned char	*buffer;
-	int	bufferlen = packet_size;
+	int error;
 
 	buffer = kmalloc(bufferlen, GFP_ATOMIC);
 	if (!buffer)
 		return;
 
 	while (1) {
-		ret = vmbus_recvpacket_raw(device->channel, buffer,
-					bufferlen, &bytes_recvd, &req_id);
-
-		switch (ret) {
+		error = vmbus_recvpacket_raw(hv_dev->channel, buffer, bufferlen,
+					     &bytes_recvd, &req_id);
+		switch (error) {
 		case 0:
 			if (bytes_recvd == 0) {
 				kfree(buffer);
 				return;
 			}
-			desc = (struct vmpacket_descriptor *)buffer;
-			switch (desc->type) {
-			case VM_PKT_COMP:
-				break;
-			case VM_PKT_DATA_INBAND:
-				/*
-				 * We have a packet that has "inband"
-				 * data. The API used for retrieving the
-				 * packet guarantees that the complete
-				 * packet is read. So, minimally, we should
-				 * be able to parse the payload header
-				 * safely (assuming that the host can be
-				 * trusted. Trusting the host seems to be a
-				 * reasonable assumption because in a
-				 * virtualized environment there is not whole
-				 * lot you can do if you don't trust the host.
-				 *
-				 * Nonetheless, let us validate if the host can
-				 * be trusted (in a trivial way).
-				 * The intresting aspect of this
-				 * validation is how do you recover if we
-				 * discover that the host is not to be
-				 * trusted? Simply dropping the packet, I
-				 * don't think is an appropriate recovery.
-				 * In the interest of failing fast, it may
-				 * be better to crash the guest. For now,
-				 * I will just drop the packet!
-				 */
-				msg_sz = bytes_recvd - (desc->offset8 << 3);
-				if (msg_sz < hdr_sz) {
-					/*
-					 * Drop the packet and hope
-					 * the problem magically goes away.
-					 */
-					pr_err("Illegal packet\n");
-					break;
-				}
-
-				msg = (struct synth_kbd_msg *)
-					((unsigned long)desc +
-					(desc->offset8 << 3));
-				hv_kbd_on_receive(device, msg, (u32)msg_sz);
-				break;
-			default:
-				pr_err("unhandled packet type %d, tid %llx len %d\n",
-					desc->type, req_id, bytes_recvd);
-				break;
-			}
+
+			hv_kbd_handle_received_packet(hv_dev, buffer,
+						      bytes_recvd, req_id);
 			break;
+
 		case -ENOBUFS:
 			kfree(buffer);
 			/* Handle large packet */
@@ -284,83 +271,128 @@ static void hv_kbd_on_channel_callback(void *context)
 	}
 }
 
-static int hv_kbd_connect_to_vsp(struct hv_device *device)
+static int hv_kbd_connect_to_vsp(struct hv_device *hv_dev)
 {
-	int ret;
-	int t;
-	u32 proto_status;
-	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(device);
+	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(hv_dev);
 	struct synth_kbd_protocol_request *request;
 	struct synth_kbd_protocol_response *response;
+	u32 proto_status;
+	int error;
 
 	request = &kbd_dev->protocol_req;
 	memset(request, 0, sizeof(struct synth_kbd_protocol_request));
-	request->header.type = SYNTH_KBD_PROTOCOL_REQUEST;
-	request->version_requested.version = SYNTH_KBD_VERSION;
-
-	ret = vmbus_sendpacket(device->channel, request,
-				sizeof(struct synth_kbd_protocol_request),
-				(unsigned long)request,
-				VM_PKT_DATA_INBAND,
-				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret)
-		return ret;
-
-	t = wait_for_completion_timeout(&kbd_dev->wait_event, 10 * HZ);
-	if (!t)
+	request->header.type = cpu_to_le32(SYNTH_KBD_PROTOCOL_REQUEST);
+	request->version_requested.version = cpu_to_le32(SYNTH_KBD_VERSION);
+
+	error = vmbus_sendpacket(hv_dev->channel, request,
+				 sizeof(struct synth_kbd_protocol_request),
+				 (unsigned long)request,
+				 VM_PKT_DATA_INBAND,
+				 VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+	if (error)
+		return error;
+
+	if (!wait_for_completion_timeout(&kbd_dev->wait_event, 10 * HZ))
 		return -ETIMEDOUT;
 
 	response = &kbd_dev->protocol_resp;
 	proto_status = __le32_to_cpu(response->proto_status);
 	if (!(proto_status & PROTOCOL_ACCEPTED)) {
-		pr_err("synth_kbd protocol request failed (version %d)\n",
-		       SYNTH_KBD_VERSION);
+		dev_err(&hv_dev->device,
+			"synth_kbd protocol request failed (version %d)\n",
+		        SYNTH_KBD_VERSION);
 		return -ENODEV;
 	}
+
+	return 0;
+}
+
+static int hv_kbd_start(struct serio *serio)
+{
+	struct hv_kbd_dev *kbd_dev = serio->port_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_dev->lock, flags);
+	kbd_dev->started = true;
+	spin_unlock_irqrestore(&kbd_dev->lock, flags);
+
 	return 0;
 }
 
-static int hv_kbd_probe(struct hv_device *device,
+static void hv_kbd_stop(struct serio *serio)
+{
+	struct hv_kbd_dev *kbd_dev = serio->port_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kbd_dev->lock, flags);
+	kbd_dev->started = false;
+	spin_unlock_irqrestore(&kbd_dev->lock, flags);
+}
+
+static int hv_kbd_probe(struct hv_device *hv_dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
-	int ret;
 	struct hv_kbd_dev *kbd_dev;
+	struct serio *hv_serio;
+	int error;
 
-	kbd_dev = hv_kbd_alloc_device(device);
-	if (!kbd_dev)
-		return -ENOMEM;
-	ret = vmbus_open(device->channel,
-		KBD_VSC_SEND_RING_BUFFER_SIZE,
-		KBD_VSC_RECV_RING_BUFFER_SIZE,
-		NULL,
-		0,
-		hv_kbd_on_channel_callback,
-		device
-		);
-
-	if (ret)
-		goto probe_open_err;
-	ret = hv_kbd_connect_to_vsp(device);
-	if (ret)
-		goto probe_connect_err;
-	serio_register_port(kbd_dev->hv_serio);
-	return ret;
+	kbd_dev = kzalloc(sizeof(struct hv_kbd_dev), GFP_KERNEL);
+	hv_serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
+	if (!kbd_dev || !hv_serio) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
 
-probe_connect_err:
-	vmbus_close(device->channel);
+	kbd_dev->hv_dev = hv_dev;
+	kbd_dev->hv_serio = hv_serio;
+	spin_lock_init(&kbd_dev->lock);
+	init_completion(&kbd_dev->wait_event);
+	hv_set_drvdata(hv_dev, kbd_dev);
 
-probe_open_err:
-	hv_kbd_free_device(kbd_dev);
+	hv_serio->dev.parent  = &hv_dev->device;
+	hv_serio->id.type = SERIO_8042_XL;
+	strlcpy(hv_serio->name, dev_name(&hv_dev->device),
+		sizeof(hv_serio->name));
+	strlcpy(hv_serio->phys, dev_name(&hv_dev->device),
+		sizeof(hv_serio->phys));
+
+	hv_serio->start = hv_kbd_start;
+	hv_serio->stop = hv_kbd_stop;
+
+	error = vmbus_open(hv_dev->channel,
+			   KBD_VSC_SEND_RING_BUFFER_SIZE,
+			   KBD_VSC_RECV_RING_BUFFER_SIZE,
+			   NULL, 0,
+			   hv_kbd_on_channel_callback,
+			   hv_dev);
+	if (error)
+		goto err_free_mem;
+
+	error = hv_kbd_connect_to_vsp(hv_dev);
+	if (error)
+		goto err_close_vmbus;
 
-	return ret;
+	serio_register_port(kbd_dev->hv_serio);
+	return 0;
+
+err_close_vmbus:
+	vmbus_close(hv_dev->channel);
+err_free_mem:
+	kfree(hv_serio);
+	kfree(kbd_dev);
+	return error;
 }
 
-static int hv_kbd_remove(struct hv_device *dev)
+static int hv_kbd_remove(struct hv_device *hv_dev)
 {
-	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(dev);
+	struct hv_kbd_dev *kbd_dev = hv_get_drvdata(hv_dev);
+
+	serio_unregister_port(kbd_dev->hv_serio);
+	vmbus_close(hv_dev->channel);
+	kfree(kbd_dev);
+
+	hv_set_drvdata(hv_dev, NULL);
 
-	vmbus_close(dev->channel);
-	hv_kbd_free_device(kbd_dev);
 	return 0;
 }
 
