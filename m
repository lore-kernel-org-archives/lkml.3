Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaIIKlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:41:25 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50368 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbaIIKlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:41:22 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of context imbalance
Date: Tue,  9 Sep 2014 16:11:09 +0530
Message-Id: <1410259269-27397-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning : context imbalance in 'resume_device'
                        unexpected unlock
this patch will generate warning from checkpatch for
lines over 80 character , but since those are user-visible strings
so it was not modified.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/unisys/uislib/uislib.c | 81 ++++++++++++++++------------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index c4d6cae..ae923c3 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -616,6 +616,7 @@ resume_device(CONTROLVM_MESSAGE *msg)
 	struct bus_info *bus;
 	struct device_info *dev;
 	struct guest_msgs cmd;
+	int retval = CONTROLVM_RESP_SUCCESS;
 
 	busNo = msg->cmd.deviceChangeState.busNo;
 	devNo = msg->cmd.deviceChangeState.devNo;
@@ -627,45 +628,16 @@ resume_device(CONTROLVM_MESSAGE *msg)
 			if (devNo >= bus->deviceCount) {
 				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device(%d) >= deviceCount(%d).",
 				     devNo, bus->deviceCount);
-				read_unlock(&BusListLock);
-				return CONTROLVM_RESP_ERROR_DEVICE_INVALID;
-			}
-			/* make sure this device exists */
-			dev = bus->device[devNo];
-			if (!dev) {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device %d does not exist.",
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
-				cmd.msgtype = GUEST_RESUME_VHBA;
-				cmd.resume_vhba.chanptr = dev->chanptr;
-			} else
-			    if (!uuid_le_cmp(dev->channelTypeGuid,
-					    UltraVnicChannelProtocolGuid)) {
-				cmd.msgtype = GUEST_RESUME_VNIC;
-				cmd.resume_vnic.chanptr = dev->chanptr;
+				retval = CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 			} else {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: unknown channelTypeGuid.\n");
-				return
-				    CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
-			}
-
-			if (!VirtControlChanFunc) {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered.");
-				return
-				    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
-			}
-
-			if (!VirtControlChanFunc(&cmd)) {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: virtpci GUEST_RESUME_[VHBA||VNIC] returned error.");
-				return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
+				/* make sure this device exists */
+				dev = bus->device[devNo];
+				if (!dev) {
+					LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device %d does not exist.",
+					     devNo);
+					retval =
+					  CONTROLVM_RESP_ERROR_ALREADY_DONE;
+				}
 			}
 			break;
 		}
@@ -674,11 +646,36 @@ resume_device(CONTROLVM_MESSAGE *msg)
 	if (!bus) {
 		LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: bus %d does not exist",
 		     busNo);
-		read_unlock(&BusListLock);
-		return CONTROLVM_RESP_ERROR_BUS_INVALID;
+		retval = CONTROLVM_RESP_ERROR_BUS_INVALID;
 	}
-
-	return CONTROLVM_RESP_SUCCESS;
+	read_unlock(&BusListLock);
+	/* the msg is bound for virtpci; send
+	 * guest_msgs struct to callback
+	 */
+	if (retval == CONTROLVM_RESP_SUCCESS) {
+		if (!uuid_le_cmp(dev->channelTypeGuid,
+				 UltraVhbaChannelProtocolGuid)) {
+			cmd.msgtype = GUEST_RESUME_VHBA;
+			cmd.resume_vhba.chanptr = dev->chanptr;
+		} else if (!uuid_le_cmp(dev->channelTypeGuid,
+					UltraVnicChannelProtocolGuid)) {
+			cmd.msgtype = GUEST_RESUME_VNIC;
+			cmd.resume_vnic.chanptr = dev->chanptr;
+		} else {
+			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: unknown channelTypeGuid.\n");
+			return CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
+		}
+		if (!VirtControlChanFunc) {
+			LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered.");
+			return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
+		}
+		if (!VirtControlChanFunc(&cmd)) {
+			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: virtpci GUEST_RESUME_[VHBA||VNIC] returned error.");
+			return
+			  CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
+		}
+	}
+	return retval;
 }
 
 static int
-- 
1.8.1.2

