Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbaIEJXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:23:13 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:37026 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbaIEJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:23:11 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: uislib: uislib.c: sparse warning of context imbalance
Date: Fri,  5 Sep 2014 14:52:46 +0530
Message-Id: <1409908966-23148-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning : context imbalance in 'pause_device' 
			unexpected unlock
this patch will generate warning from checkpatch for 
lines over 80 character , but since those are user-visible strings
so it was not modified.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

hi , can you please review the patch and see if the approach is correct.
The functiion is still doing the same what it was doing , only the logic
is changed. if the approach is ok, then i can send a patch to fix the
other two similar warning in the file.

 drivers/staging/unisys/uislib/uislib.c | 82 ++++++++++++++++------------------
 1 file changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 8b89fe3..3a92d9f 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -548,6 +548,7 @@ pause_device(CONTROLVM_MESSAGE *msg)
 	struct bus_info *bus;
 	struct device_info *dev;
 	struct guest_msgs cmd;
+	int retval = CONTROLVM_RESP_SUCCESS;
 
 	busNo = msg->cmd.deviceChangeState.busNo;
 	devNo = msg->cmd.deviceChangeState.devNo;
@@ -559,58 +560,53 @@ pause_device(CONTROLVM_MESSAGE *msg)
 			if (devNo >= bus->deviceCount) {
 				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device(%d) >= deviceCount(%d).",
 				     devNo, bus->deviceCount);
-				read_unlock(&BusListLock);
-				return CONTROLVM_RESP_ERROR_DEVICE_INVALID;
-			}
-			/* make sure this device exists */
-			dev = bus->device[devNo];
-			if (!dev) {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device %d does not exist.",
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
-				cmd.msgtype = GUEST_PAUSE_VHBA;
-				cmd.pause_vhba.chanptr = dev->chanptr;
-			} else
-			    if (!uuid_le_cmp(dev->channelTypeGuid,
-					    UltraVnicChannelProtocolGuid)) {
-				cmd.msgtype = GUEST_PAUSE_VNIC;
-				cmd.pause_vnic.chanptr = dev->chanptr;
+				retval = CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 			} else {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: unknown channelTypeGuid.\n");
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
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: virtpci GUEST_PAUSE_[VHBA||VNIC] returned error.");
-				return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
+				/* make sure this device exists */
+				dev = bus->device[devNo];
+				if (!dev) {
+					LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device %d does not exist.",
+					     devNo);
+					retval =
+					  CONTROLVM_RESP_ERROR_ALREADY_DONE;
+				}
 			}
 			break;
 		}
 	}
-
 	if (!bus) {
 		LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: bus %d does not exist",
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
+				UltraVhbaChannelProtocolGuid)) {
+			cmd.msgtype = GUEST_PAUSE_VHBA;
+			cmd.pause_vhba.chanptr = dev->chanptr;
+		} else if (!uuid_le_cmp(dev->channelTypeGuid,
+					UltraVnicChannelProtocolGuid)) {
+			cmd.msgtype = GUEST_PAUSE_VNIC;
+			cmd.pause_vnic.chanptr = dev->chanptr;
+		} else {
+			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: unknown channelTypeGuid.\n");
+			return CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
+		}
+		if (!VirtControlChanFunc) {
+			LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered.");
+			return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
+		}
+		if (!VirtControlChanFunc(&cmd)) {
+			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: virtpci GUEST_PAUSE_[VHBA||VNIC] returned error.");
+			return
+			  CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
+		}
+	}
+	return retval;
 }
 
 static int
-- 
1.8.1.2

