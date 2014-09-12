Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaILM1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:27:44 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43494 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaILM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:27:42 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of context imbalance
Date: Fri, 12 Sep 2014 17:57:26 +0530
Message-Id: <1410524846-10732-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning : context imbalance in 'destroy_device'
                        unexpected unlock
this patch will generate warning from checkpatch for
lines over 80 character , but since those are user-visible strings
so it was not modified.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/unisys/uislib/uislib.c | 117 ++++++++++++++++-----------------
 1 file changed, 58 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index ae923c3..1823f6f 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -685,6 +685,7 @@ destroy_device(CONTROLVM_MESSAGE *msg, char *buf)
 	struct bus_info *bus;
 	struct device_info *dev;
 	struct guest_msgs cmd;
+	int retval = CONTROLVM_RESP_SUCCESS;
 
 	busNo = msg->cmd.destroyDevice.busNo;
 	devNo = msg->cmd.destroyDevice.devNo;
@@ -696,63 +697,18 @@ destroy_device(CONTROLVM_MESSAGE *msg, char *buf)
 			/* make sure the device number is valid */
 			if (devNo >= bus->deviceCount) {
 				LOGERR("CONTROLVM_DEVICE_DESTORY Failed: device(%d) >= deviceCount(%d).",
-				     devNo, bus->deviceCount);
-				read_unlock(&BusListLock);
-				return CONTROLVM_RESP_ERROR_DEVICE_INVALID;
-			}
-			/* make sure this device exists */
-			dev = bus->device[devNo];
-			if (!dev) {
-				LOGERR("CONTROLVM_DEVICE_DESTROY Failed: device %d does not exist.",
-				     devNo);
-				read_unlock(&BusListLock);
-				return CONTROLVM_RESP_ERROR_ALREADY_DONE;
-			}
-			read_unlock(&BusListLock);
-			/* the msg is bound for virtpci; send
-			 * guest_msgs struct to callback
-			 */
-			if (!uuid_le_cmp(dev->channelTypeGuid,
-					UltraVhbaChannelProtocolGuid)) {
-				cmd.msgtype = GUEST_DEL_VHBA;
-				cmd.del_vhba.chanptr = dev->chanptr;
-			} else
-			    if (!uuid_le_cmp(dev->channelTypeGuid,
-					    UltraVnicChannelProtocolGuid)) {
-				cmd.msgtype = GUEST_DEL_VNIC;
-				cmd.del_vnic.chanptr = dev->chanptr;
+				       devNo, bus->deviceCount);
+				retval = CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 			} else {
-				LOGERR("CONTROLVM_DEVICE_DESTROY Failed: unknown channelTypeGuid.\n");
-				return
-				    CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
-			}
-
-			if (!VirtControlChanFunc) {
-				LOGERR("CONTROLVM_DEVICE_DESTORY Failed: virtpci callback not registered.");
-				return
-				    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
-			}
-
-			if (!VirtControlChanFunc(&cmd)) {
-				LOGERR("CONTROLVM_DEVICE_DESTROY Failed: virtpci GUEST_DEL_[VHBA||VNIC] returned error.");
-				return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
-			}
-/* you must disable channel interrupts BEFORE you unmap the channel,
- * because if you unmap first, there may still be some activity going
- * on which accesses the channel and you will get a "unable to handle
- * kernel paging request"
- */
-			if (dev->polling) {
-				LOGINF("calling uislib_disable_channel_interrupts");
-				uislib_disable_channel_interrupts(busNo, devNo);
-			}
-			/* unmap the channel memory for the device. */
-			if (!msg->hdr.Flags.testMessage) {
-				LOGINF("destroy_device, doing iounmap");
-				uislib_iounmap(dev->chanptr);
+				/* make sure this device exists */
+				dev = bus->device[devNo];
+				if (!dev) {
+					LOGERR("CONTROLVM_DEVICE_DESTROY Failed: device %d does not exist.",
+					       devNo);
+					retval =
+					     CONTROLVM_RESP_ERROR_ALREADY_DONE;
+				}
 			}
-			kfree(dev);
-			bus->device[devNo] = NULL;
 			break;
 		}
 	}
@@ -760,11 +716,54 @@ destroy_device(CONTROLVM_MESSAGE *msg, char *buf)
 	if (!bus) {
 		LOGERR("CONTROLVM_DEVICE_DESTROY Failed: bus %d does not exist",
 		       busNo);
-		read_unlock(&BusListLock);
-		return CONTROLVM_RESP_ERROR_BUS_INVALID;
+		retval = CONTROLVM_RESP_ERROR_BUS_INVALID;
 	}
-
-	return CONTROLVM_RESP_SUCCESS;
+	read_unlock(&BusListLock);
+	if (retval == CONTROLVM_RESP_SUCCESS) {
+		/* the msg is bound for virtpci; send
+		 * guest_msgs struct to callback
+		 */
+		if (!uuid_le_cmp(dev->channelTypeGuid,
+				 UltraVhbaChannelProtocolGuid)) {
+			cmd.msgtype = GUEST_DEL_VHBA;
+			cmd.del_vhba.chanptr = dev->chanptr;
+		} else if (!uuid_le_cmp(dev->channelTypeGuid,
+					UltraVnicChannelProtocolGuid)) {
+			cmd.msgtype = GUEST_DEL_VNIC;
+			cmd.del_vnic.chanptr = dev->chanptr;
+		} else {
+			LOGERR("CONTROLVM_DEVICE_DESTROY Failed: unknown channelTypeGuid.\n");
+			return
+			    CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
+		}
+		if (!VirtControlChanFunc) {
+			LOGERR("CONTROLVM_DEVICE_DESTORY Failed: virtpci callback not registered.");
+			return
+			    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
+		}
+		if (!VirtControlChanFunc(&cmd)) {
+			LOGERR("CONTROLVM_DEVICE_DESTROY Failed: virtpci GUEST_DEL_[VHBA||VNIC] returned error.");
+			return
+			    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
+		}
+/* you must disable channel interrupts BEFORE you unmap the channel,
+ * because if you unmap first, there may still be some activity going
+ * on which accesses the channel and you will get a "unable to handle
+ * kernel paging request"
+ */
+		if (dev->polling) {
+			LOGINF("calling uislib_disable_channel_interrupts");
+			uislib_disable_channel_interrupts(busNo, devNo);
+		}
+		/* unmap the channel memory for the device. */
+		if (!msg->hdr.Flags.testMessage) {
+			LOGINF("destroy_device, doing iounmap");
+			uislib_iounmap(dev->chanptr);
+		}
+		kfree(dev);
+		bus->device[devNo] = NULL;
+	}
+	return retval;
 }
 
 static int
-- 
1.8.1.2

