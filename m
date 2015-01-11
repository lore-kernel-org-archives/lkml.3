Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbbAKDJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 22:09:12 -0500
Received: from smtprelay0245.hostedemail.com ([216.40.44.245]:43845 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751048AbbAKDJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 22:09:09 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:69:355:379:541:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:2693:2828:2892:2899:2915:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4605:5007:6261:7875:7903:8603:8660:8957:9010:9121:9201:9901:10004:10226:10394:10848:11026:11232:11233:11657:11876:11914:12043:12294:12296:12438:12517:12519:12555:12679:13141:13148:13230:13868:13972:14394:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: patch78_6c59a455d073e
X-Filterd-Recvd-Size: 84774
Message-ID: <1420945742.16787.12.camel@perches.com>
Subject: [PATCH] staging: unisys: Convert direct LOGERR uses to pr_err
From: Joe Perches <joe@perches.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 10 Jan 2015 19:09:02 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal logging facility instead of a new macro.

Miscellanea:

o Realign arguments
o Remove unnecessary alloc error messages as alloc failures
  already emits a generic OOM message with a dump_stack
o Add missing newlines to these messages to avoid interleaving
o Spelling/typo fixes in those messages

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/unisys/include/uisutils.h          |   4 +-
 drivers/staging/unisys/uislib/uislib.c             | 169 ++++++++++-----------
 drivers/staging/unisys/uislib/uisqueue.c           |   4 +-
 drivers/staging/unisys/uislib/uisthread.c          |   4 +-
 drivers/staging/unisys/uislib/uisutils.c           |  34 ++---
 drivers/staging/unisys/virthba/virthba.c           | 119 +++++++--------
 drivers/staging/unisys/virtpci/virtpci.c           |  71 +++++----
 drivers/staging/unisys/visorchipset/file.c         |   2 +-
 .../unisys/visorchipset/visorchipset_main.c        | 159 ++++++++++---------
 9 files changed, 276 insertions(+), 290 deletions(-)

diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
index 7414220..f937892 100644
--- a/drivers/staging/unisys/include/uisutils.h
+++ b/drivers/staging/unisys/include/uisutils.h
@@ -206,10 +206,10 @@ wait_for_valid_guid(uuid_le __iomem *guid)
 			      (void __iomem *)guid, sizeof(uuid_le));
 		if (uuid_le_cmp(tmpguid, NULL_UUID_LE) != 0)
 			break;
-		LOGERR("Waiting for non-0 GUID (why???)...\n");
+		pr_err("Waiting for non-0 GUID (why???)...\n");
 		UIS_THREAD_WAIT_SEC(5);
 	}
-	LOGERR("OK... GUID is non-0 now\n");
+	pr_err("OK... GUID is non-0 now\n");
 }
 
 /* CopyFragsInfoFromSkb returns the number of entries added to frags array
diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 7c87452..3050591 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -136,9 +136,9 @@ init_vbus_channel(u64 channelAddr, u32 channelBytes)
 	void __iomem *pChan = uislib_ioremap_cache(channelAddr, channelBytes);
 
 	if (!pChan) {
-		LOGERR("CONTROLVM_BUS_CREATE error: ioremap_cache of channelAddr:%Lx for channelBytes:%llu failed",
-		     (unsigned long long) channelAddr,
-		     (unsigned long long) channelBytes);
+		pr_err("CONTROLVM_BUS_CREATE error: ioremap_cache of channelAddr:%Lx for channelBytes:%llu failed\n",
+		       (unsigned long long)channelAddr,
+		       (unsigned long long)channelBytes);
 		rc = NULL;
 		goto Away;
 	}
@@ -161,8 +161,8 @@ create_bus(struct controlvm_message *msg, char *buf)
 	size_t size;
 
 	if (MaxBusCount == BusListCount) {
-		LOGERR("CONTROLVM_BUS_CREATE Failed: max buses:%d already created\n",
-		     MaxBusCount);
+		pr_err("CONTROLVM_BUS_CREATE Failed: max buses:%d already created\n",
+		       MaxBusCount);
 		POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, MaxBusCount,
 				 POSTCODE_SEVERITY_ERR);
 		return CONTROLVM_RESP_ERROR_MAX_BUSES;
@@ -179,7 +179,6 @@ create_bus(struct controlvm_message *msg, char *buf)
 	    (deviceCount * sizeof(struct device_info *));
 	bus = kzalloc(size, GFP_ATOMIC);
 	if (!bus) {
-		LOGERR("CONTROLVM_BUS_CREATE Failed: kmalloc for bus failed.\n");
 		POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
@@ -214,7 +213,7 @@ create_bus(struct controlvm_message *msg, char *buf)
 		/* found a bus already in the list with same busNo -
 		 * reject add
 		 */
-		LOGERR("CONTROLVM_BUS_CREATE Failed: bus %d already exists.\n",
+		pr_err("CONTROLVM_BUS_CREATE Failed: bus %d already exists\n",
 		       bus->bus_no);
 		POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus->bus_no,
 				 POSTCODE_SEVERITY_ERR);
@@ -239,14 +238,14 @@ create_bus(struct controlvm_message *msg, char *buf)
 		cmd.add_vbus.bus_uuid = msg->cmd.create_bus.bus_data_type_uuid;
 		cmd.add_vbus.instance_uuid = msg->cmd.create_bus.bus_inst_uuid;
 		if (!virt_control_chan_func) {
-			LOGERR("CONTROLVM_BUS_CREATE Failed: virtpci callback not registered.");
+			pr_err("CONTROLVM_BUS_CREATE Failed: virtpci callback not registered\n");
 			POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus->bus_no,
 					 POSTCODE_SEVERITY_ERR);
 			kfree(bus);
 			return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
 		}
 		if (!virt_control_chan_func(&cmd)) {
-			LOGERR("CONTROLVM_BUS_CREATE Failed: virtpci GUEST_ADD_VBUS returned error.");
+			pr_err("CONTROLVM_BUS_CREATE Failed: virtpci GUEST_ADD_VBUS returned error\n");
 			POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus->bus_no,
 					 POSTCODE_SEVERITY_ERR);
 			kfree(bus);
@@ -292,7 +291,7 @@ destroy_bus(struct controlvm_message *msg, char *buf)
 	}
 
 	if (!bus) {
-		LOGERR("CONTROLVM_BUS_DESTROY Failed: failed to find bus %d.\n",
+		pr_err("CONTROLVM_BUS_DESTROY Failed: failed to find bus %d\n",
 		       busNo);
 		read_unlock(&BusListLock);
 		return CONTROLVM_RESP_ERROR_ALREADY_DONE;
@@ -301,8 +300,8 @@ destroy_bus(struct controlvm_message *msg, char *buf)
 	/* verify that this bus has no devices. */
 	for (i = 0; i < bus->device_count; i++) {
 		if (bus->device[i] != NULL) {
-			LOGERR("CONTROLVM_BUS_DESTROY Failed: device %i attached to bus %d.",
-			     i, busNo);
+			pr_err("CONTROLVM_BUS_DESTROY Failed: device %i attached to bus %d\n",
+			       i, busNo);
 			read_unlock(&BusListLock);
 			return CONTROLVM_RESP_ERROR_BUS_DEVICE_ATTACHED;
 		}
@@ -317,11 +316,11 @@ destroy_bus(struct controlvm_message *msg, char *buf)
 	cmd.msgtype = GUEST_DEL_VBUS;
 	cmd.del_vbus.bus_no = busNo;
 	if (!virt_control_chan_func) {
-		LOGERR("CONTROLVM_BUS_DESTROY Failed: virtpci callback not registered.");
+		pr_err("CONTROLVM_BUS_DESTROY Failed: virtpci callback not registered\n");
 		return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
 	}
 	if (!virt_control_chan_func(&cmd)) {
-		LOGERR("CONTROLVM_BUS_DESTROY Failed: virtpci GUEST_DEL_VBUS returned error.");
+		pr_err("CONTROLVM_BUS_DESTROY Failed: virtpci GUEST_DEL_VBUS returned error\n");
 		return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
 	}
 
@@ -362,7 +361,6 @@ create_device(struct controlvm_message *msg, char *buf)
 
 	dev = kzalloc(sizeof(struct device_info), GFP_ATOMIC);
 	if (!dev) {
-		LOGERR("CONTROLVM_DEVICE_CREATE Failed: kmalloc for dev failed.\n");
 		POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		return CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
@@ -386,9 +384,9 @@ create_device(struct controlvm_message *msg, char *buf)
 			 */
 			minSize = pReqHandler->min_channel_bytes;
 		if (minSize > msg->cmd.create_device.channel_bytes) {
-			LOGERR("CONTROLVM_DEVICE_CREATE Failed: channel size is too small, channel size:0x%lx, required size:0x%lx",
-			     (ulong) msg->cmd.create_device.channel_bytes,
-			     (ulong) minSize);
+			pr_err("CONTROLVM_DEVICE_CREATE Failed: channel size is too small, channel size:0x%lx, required size:0x%lx\n",
+			       (ulong)msg->cmd.create_device.channel_bytes,
+			       (ulong)minSize);
 			POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 					 POSTCODE_SEVERITY_ERR);
 			result = CONTROLVM_RESP_ERROR_CHANNEL_SIZE_TOO_SMALL;
@@ -398,9 +396,9 @@ create_device(struct controlvm_message *msg, char *buf)
 		    uislib_ioremap_cache(dev->channel_addr,
 					 msg->cmd.create_device.channel_bytes);
 		if (!dev->chanptr) {
-			LOGERR("CONTROLVM_DEVICE_CREATE Failed: ioremap_cache of channelAddr:%Lx for channelBytes:%llu failed",
-			     dev->channel_addr,
-			     msg->cmd.create_device.channel_bytes);
+			pr_err("CONTROLVM_DEVICE_CREATE Failed: ioremap_cache of channelAddr:%Lx for channelBytes:%llu failed\n",
+			       dev->channel_addr,
+			       msg->cmd.create_device.channel_bytes);
 			result = CONTROLVM_RESP_ERROR_IOREMAP_FAILED;
 			POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 					 POSTCODE_SEVERITY_ERR);
@@ -415,8 +413,8 @@ create_device(struct controlvm_message *msg, char *buf)
 		if (bus->bus_no == busNo) {
 			/* make sure the device number is valid */
 			if (devNo >= bus->device_count) {
-				LOGERR("CONTROLVM_DEVICE_CREATE Failed: device (%d) >= deviceCount (%d).",
-				     devNo, bus->device_count);
+				pr_err("CONTROLVM_DEVICE_CREATE Failed: device (%d) >= deviceCount (%d)\n",
+				       devNo, bus->device_count);
 				result = CONTROLVM_RESP_ERROR_MAX_DEVICES;
 				POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC,
 						 devNo, busNo,
@@ -426,8 +424,8 @@ create_device(struct controlvm_message *msg, char *buf)
 			}
 			/* make sure this device is not already set */
 			if (bus->device[devNo]) {
-				LOGERR("CONTROLVM_DEVICE_CREATE Failed: device %d is already exists.",
-				     devNo);
+				pr_err("CONTROLVM_DEVICE_CREATE Failed: device %d is already exists\n",
+				       devNo);
 				POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC,
 						 devNo, busNo,
 						 POSTCODE_SEVERITY_ERR);
@@ -451,8 +449,8 @@ create_device(struct controlvm_message *msg, char *buf)
 							    chtype);
 					if (!SPAR_VHBA_CHANNEL_OK_CLIENT
 					    (dev->chanptr)) {
-						LOGERR("CONTROLVM_DEVICE_CREATE Failed:[CLIENT]VHBA dev %d chan invalid.",
-						     devNo);
+						pr_err("CONTROLVM_DEVICE_CREATE Failed:[CLIENT]VHBA dev %d chan invalid\n",
+						       devNo);
 						POSTCODE_LINUX_4
 						    (DEVICE_CREATE_FAILURE_PC,
 						     devNo, busNo,
@@ -477,8 +475,8 @@ create_device(struct controlvm_message *msg, char *buf)
 							    chtype);
 					if (!SPAR_VNIC_CHANNEL_OK_CLIENT
 					    (dev->chanptr)) {
-						LOGERR("CONTROLVM_DEVICE_CREATE Failed: VNIC[CLIENT] dev %d chan invalid.",
-						     devNo);
+						pr_err("CONTROLVM_DEVICE_CREATE Failed: VNIC[CLIENT] dev %d chan invalid\n",
+						       devNo);
 						POSTCODE_LINUX_4
 						    (DEVICE_CREATE_FAILURE_PC,
 						     devNo, busNo,
@@ -494,7 +492,7 @@ create_device(struct controlvm_message *msg, char *buf)
 					    dev->instance_uuid;
 					cmd.add_vhba.intr = dev->intr;
 				} else {
-					LOGERR("CONTROLVM_DEVICE_CREATE Failed: unknown channelTypeGuid.\n");
+					    pr_err("CONTROLVM_DEVICE_CREATE Failed: unknown channelTypeGuid\n");
 					POSTCODE_LINUX_4
 					    (DEVICE_CREATE_FAILURE_PC, devNo,
 					     busNo, POSTCODE_SEVERITY_ERR);
@@ -503,7 +501,7 @@ create_device(struct controlvm_message *msg, char *buf)
 				}
 
 				if (!virt_control_chan_func) {
-					LOGERR("CONTROLVM_DEVICE_CREATE Failed: virtpci callback not registered.");
+					pr_err("CONTROLVM_DEVICE_CREATE Failed: virtpci callback not registered\n");
 					POSTCODE_LINUX_4
 					    (DEVICE_CREATE_FAILURE_PC, devNo,
 					     busNo, POSTCODE_SEVERITY_ERR);
@@ -512,7 +510,7 @@ create_device(struct controlvm_message *msg, char *buf)
 				}
 
 				if (!virt_control_chan_func(&cmd)) {
-					LOGERR("CONTROLVM_DEVICE_CREATE Failed: virtpci GUEST_ADD_[VHBA||VNIC] returned error.");
+					pr_err("CONTROLVM_DEVICE_CREATE Failed: virtpci GUEST_ADD_[VHBA||VNIC] returned error\n");
 					POSTCODE_LINUX_4
 					    (DEVICE_CREATE_FAILURE_PC, devNo,
 					     busNo, POSTCODE_SEVERITY_ERR);
@@ -528,7 +526,8 @@ create_device(struct controlvm_message *msg, char *buf)
 	}
 	read_unlock(&BusListLock);
 
-	LOGERR("CONTROLVM_DEVICE_CREATE Failed: failed to find bus %d.", busNo);
+	pr_err("CONTROLVM_DEVICE_CREATE Failed: failed to find bus %d\n",
+	       busNo);
 	POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 			 POSTCODE_SEVERITY_ERR);
 	result = CONTROLVM_RESP_ERROR_BUS_INVALID;
@@ -560,15 +559,15 @@ pause_device(struct controlvm_message *msg)
 		if (bus->bus_no == busNo) {
 			/* make sure the device number is valid */
 			if (devNo >= bus->device_count) {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device(%d) >= deviceCount(%d).",
-				     devNo, bus->device_count);
+				pr_err("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device(%d) >= deviceCount(%d)\n",
+				       devNo, bus->device_count);
 				retval = CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 			} else {
 				/* make sure this device exists */
 				dev = bus->device[devNo];
 				if (!dev) {
-					LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device %d does not exist.",
-					     devNo);
+					pr_err("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: device %d does not exist\n",
+					       devNo);
 					retval =
 					  CONTROLVM_RESP_ERROR_ALREADY_DONE;
 				}
@@ -577,8 +576,8 @@ pause_device(struct controlvm_message *msg)
 		}
 	}
 	if (!bus) {
-		LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: bus %d does not exist",
-		     busNo);
+		pr_err("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: bus %d does not exist\n",
+		       busNo);
 		retval = CONTROLVM_RESP_ERROR_BUS_INVALID;
 	}
 	read_unlock(&BusListLock);
@@ -595,15 +594,15 @@ pause_device(struct controlvm_message *msg)
 			cmd.msgtype = GUEST_PAUSE_VNIC;
 			cmd.pause_vnic.chanptr = dev->chanptr;
 		} else {
-			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: unknown channelTypeGuid.\n");
+			pr_err("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: unknown channelTypeGuid\n");
 			return CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
 		}
 		if (!virt_control_chan_func) {
-			LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered.");
+			pr_err("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered\n");
 			return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
 		}
 		if (!virt_control_chan_func(&cmd)) {
-			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: virtpci GUEST_PAUSE_[VHBA||VNIC] returned error.");
+			pr_err("CONTROLVM_DEVICE_CHANGESTATE:pause Failed: virtpci GUEST_PAUSE_[VHBA||VNIC] returned error\n");
 			return
 			  CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
 		}
@@ -628,15 +627,15 @@ resume_device(struct controlvm_message *msg)
 		if (bus->bus_no == busNo) {
 			/* make sure the device number is valid */
 			if (devNo >= bus->device_count) {
-				LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device(%d) >= deviceCount(%d).",
-				     devNo, bus->device_count);
+				pr_err("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device(%d) >= deviceCount(%d)\n",
+				       devNo, bus->device_count);
 				retval = CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 			} else {
 				/* make sure this device exists */
 				dev = bus->device[devNo];
 				if (!dev) {
-					LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device %d does not exist.",
-					     devNo);
+					pr_err("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: device %d does not exist\n",
+					       devNo);
 					retval =
 					  CONTROLVM_RESP_ERROR_ALREADY_DONE;
 				}
@@ -646,8 +645,8 @@ resume_device(struct controlvm_message *msg)
 	}
 
 	if (!bus) {
-		LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: bus %d does not exist",
-		     busNo);
+		pr_err("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: bus %d does not exist\n",
+		       busNo);
 		retval = CONTROLVM_RESP_ERROR_BUS_INVALID;
 	}
 	read_unlock(&BusListLock);
@@ -664,15 +663,15 @@ resume_device(struct controlvm_message *msg)
 			cmd.msgtype = GUEST_RESUME_VNIC;
 			cmd.resume_vnic.chanptr = dev->chanptr;
 		} else {
-			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: unknown channelTypeGuid.\n");
+			pr_err("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: unknown channelTypeGuid\n");
 			return CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
 		}
 		if (!virt_control_chan_func) {
-			LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered.");
+			pr_err("CONTROLVM_DEVICE_CHANGESTATE Failed: virtpci callback not registered\n");
 			return CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
 		}
 		if (!virt_control_chan_func(&cmd)) {
-			LOGERR("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: virtpci GUEST_RESUME_[VHBA||VNIC] returned error.");
+			pr_err("CONTROLVM_DEVICE_CHANGESTATE:resume Failed: virtpci GUEST_RESUME_[VHBA||VNIC] returned error\n");
 			return
 			  CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
 		}
@@ -698,14 +697,14 @@ destroy_device(struct controlvm_message *msg, char *buf)
 		if (bus->bus_no == busNo) {
 			/* make sure the device number is valid */
 			if (devNo >= bus->device_count) {
-				LOGERR("CONTROLVM_DEVICE_DESTORY Failed: device(%d) >= deviceCount(%d).",
+				pr_err("CONTROLVM_DEVICE_DESTROY Failed: device(%d) >= deviceCount(%d)\n",
 				       devNo, bus->device_count);
 				retval = CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 			} else {
 				/* make sure this device exists */
 				dev = bus->device[devNo];
 				if (!dev) {
-					LOGERR("CONTROLVM_DEVICE_DESTROY Failed: device %d does not exist.",
+					pr_err("CONTROLVM_DEVICE_DESTROY Failed: device %d does not exist\n",
 					       devNo);
 					retval =
 					     CONTROLVM_RESP_ERROR_ALREADY_DONE;
@@ -716,7 +715,7 @@ destroy_device(struct controlvm_message *msg, char *buf)
 	}
 
 	if (!bus) {
-		LOGERR("CONTROLVM_DEVICE_DESTROY Failed: bus %d does not exist",
+		pr_err("CONTROLVM_DEVICE_DESTROY Failed: bus %d does not exist\n",
 		       busNo);
 		retval = CONTROLVM_RESP_ERROR_BUS_INVALID;
 	}
@@ -734,17 +733,17 @@ destroy_device(struct controlvm_message *msg, char *buf)
 			cmd.msgtype = GUEST_DEL_VNIC;
 			cmd.del_vnic.chanptr = dev->chanptr;
 		} else {
-			LOGERR("CONTROLVM_DEVICE_DESTROY Failed: unknown channelTypeGuid.\n");
+			pr_err("CONTROLVM_DEVICE_DESTROY Failed: unknown channelTypeGuid\n");
 			return
 			    CONTROLVM_RESP_ERROR_CHANNEL_TYPE_UNKNOWN;
 		}
 		if (!virt_control_chan_func) {
-			LOGERR("CONTROLVM_DEVICE_DESTORY Failed: virtpci callback not registered.");
+			pr_err("CONTROLVM_DEVICE_DESTROY Failed: virtpci callback not registered\n");
 			return
 			    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_FAILURE;
 		}
 		if (!virt_control_chan_func(&cmd)) {
-			LOGERR("CONTROLVM_DEVICE_DESTROY Failed: virtpci GUEST_DEL_[VHBA||VNIC] returned error.");
+			pr_err("CONTROLVM_DEVICE_DESTROY Failed: virtpci GUEST_DEL_[VHBA||VNIC] returned error\n");
 			return
 			    CONTROLVM_RESP_ERROR_VIRTPCI_DRIVER_CALLBACK_ERROR;
 		}
@@ -801,7 +800,7 @@ delete_bus_glue(u32 busNo)
 	init_msg_header(&msg, CONTROLVM_BUS_DESTROY, 0, 0);
 	msg.cmd.destroy_bus.bus_no = busNo;
 	if (destroy_bus(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("destroy_bus failed. busNo=0x%x\n", busNo);
+		pr_err("destroy_bus failed. busNo=0x%x\n", busNo);
 		return 0;
 	}
 	return 1;
@@ -816,8 +815,8 @@ delete_device_glue(u32 busNo, u32 devNo)
 	msg.cmd.destroy_device.bus_no = busNo;
 	msg.cmd.destroy_device.dev_no = devNo;
 	if (destroy_device(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("destroy_device failed. busNo=0x%x devNo=0x%x\n", busNo,
-		       devNo);
+		pr_err("destroy_device failed. busNo=0x%x devNo=0x%x\n",
+		       busNo, devNo);
 		return 0;
 	}
 	return 1;
@@ -846,7 +845,7 @@ uislib_client_inject_add_bus(u32 bus_no, uuid_le inst_uuid,
 		msg.cmd.init_chipset.bus_count = 23;
 		msg.cmd.init_chipset.switch_count = 0;
 		if (init_chipset(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-			LOGERR("init_chipset failed.\n");
+			pr_err("init_chipset failed\n");
 			return 0;
 		}
 		LOGINF("chipset initialized\n");
@@ -863,7 +862,7 @@ uislib_client_inject_add_bus(u32 bus_no, uuid_le inst_uuid,
 	msg.cmd.create_bus.channel_addr = channel_addr;
 	msg.cmd.create_bus.channel_bytes = n_channel_bytes;
 	if (create_bus(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("create_bus failed.\n");
+		pr_err("create_bus failed\n");
 		POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, bus_no,
 				 POSTCODE_SEVERITY_ERR);
 		return 0;
@@ -894,7 +893,7 @@ uislib_client_inject_pause_vhba(u32 bus_no, u32 dev_no)
 	msg.cmd.device_change_state.state = segment_state_standby;
 	rc = pause_device(&msg);
 	if (rc != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("VHBA pause_device failed. busNo=0x%x devNo=0x%x\n",
+		pr_err("VHBA pause_device failed. busNo=0x%x devNo=0x%x\n",
 		       bus_no, dev_no);
 		return rc;
 	}
@@ -914,7 +913,7 @@ uislib_client_inject_resume_vhba(u32 bus_no, u32 dev_no)
 	msg.cmd.device_change_state.state = segment_state_running;
 	rc = resume_device(&msg);
 	if (rc != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("VHBA resume_device failed. busNo=0x%x devNo=0x%x\n",
+		pr_err("VHBA resume_device failed. busNo=0x%x devNo=0x%x\n",
 		       bus_no, dev_no);
 		return rc;
 	}
@@ -955,8 +954,8 @@ uislib_client_inject_add_vhba(u32 bus_no, u32 dev_no,
 		       sizeof(struct irq_info));
 	msg.cmd.create_device.channel_addr = phys_chan_addr;
 	if (chan_bytes < MIN_IO_CHANNEL_SIZE) {
-		LOGERR("wrong channel size.chan_bytes = 0x%x IO_CHANNEL_SIZE= 0x%x\n",
-		     chan_bytes, (unsigned int) MIN_IO_CHANNEL_SIZE);
+		pr_err("wrong channel size.chan_bytes = 0x%x IO_CHANNEL_SIZE= 0x%x\n",
+		       chan_bytes, (unsigned int)MIN_IO_CHANNEL_SIZE);
 		POSTCODE_LINUX_4(VHBA_CREATE_FAILURE_PC, chan_bytes,
 				 MIN_IO_CHANNEL_SIZE, POSTCODE_SEVERITY_ERR);
 		return 0;
@@ -964,7 +963,7 @@ uislib_client_inject_add_vhba(u32 bus_no, u32 dev_no,
 	msg.cmd.create_device.channel_bytes = chan_bytes;
 	msg.cmd.create_device.data_type_uuid = spar_vhba_channel_protocol_uuid;
 	if (create_device(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("VHBA create_device failed.\n");
+		pr_err("VHBA create_device failed\n");
 		POSTCODE_LINUX_4(VHBA_CREATE_FAILURE_PC, dev_no, bus_no,
 				 POSTCODE_SEVERITY_ERR);
 		return 0;
@@ -1014,8 +1013,8 @@ uislib_client_inject_add_vnic(u32 bus_no, u32 dev_no,
 		       sizeof(struct irq_info));
 	msg.cmd.create_device.channel_addr = phys_chan_addr;
 	if (chan_bytes < MIN_IO_CHANNEL_SIZE) {
-		LOGERR("wrong channel size.chan_bytes = 0x%x IO_CHANNEL_SIZE= 0x%x\n",
-		     chan_bytes, (unsigned int) MIN_IO_CHANNEL_SIZE);
+		pr_err("wrong channel size.chan_bytes = 0x%x IO_CHANNEL_SIZE = 0x%x\n",
+		       chan_bytes, (unsigned int)MIN_IO_CHANNEL_SIZE);
 		POSTCODE_LINUX_4(VNIC_CREATE_FAILURE_PC, chan_bytes,
 				 MIN_IO_CHANNEL_SIZE, POSTCODE_SEVERITY_ERR);
 		return 0;
@@ -1023,7 +1022,7 @@ uislib_client_inject_add_vnic(u32 bus_no, u32 dev_no,
 	msg.cmd.create_device.channel_bytes = chan_bytes;
 	msg.cmd.create_device.data_type_uuid = spar_vnic_channel_protocol_uuid;
 	if (create_device(&msg, NULL) != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("VNIC create_device failed.\n");
+		pr_err("VNIC create_device failed\n");
 		POSTCODE_LINUX_4(VNIC_CREATE_FAILURE_PC, dev_no, bus_no,
 				 POSTCODE_SEVERITY_ERR);
 		return 0;
@@ -1047,7 +1046,7 @@ uislib_client_inject_pause_vnic(u32 bus_no, u32 dev_no)
 	msg.cmd.device_change_state.state = segment_state_standby;
 	rc = pause_device(&msg);
 	if (rc != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("VNIC pause_device failed. busNo=0x%x devNo=0x%x\n",
+		pr_err("VNIC pause_device failed. busNo=0x%x devNo=0x%x\n",
 		       bus_no, dev_no);
 		return -1;
 	}
@@ -1067,7 +1066,7 @@ uislib_client_inject_resume_vnic(u32 bus_no, u32 dev_no)
 	msg.cmd.device_change_state.state = segment_state_running;
 	rc = resume_device(&msg);
 	if (rc != CONTROLVM_RESP_SUCCESS) {
-		LOGERR("VNIC resume_device failed. busNo=0x%x devNo=0x%x\n",
+		pr_err("VNIC resume_device failed. busNo=0x%x devNo=0x%x\n",
 		       bus_no, dev_no);
 		return -1;
 	}
@@ -1094,7 +1093,7 @@ uislib_cache_alloc(struct kmem_cache *cur_pool, char *fn, int ln)
 	void *p = kmem_cache_alloc(cur_pool, GFP_ATOMIC | __GFP_NORETRY);
 
 	if (p == NULL) {
-		LOGERR("uislib_malloc failed to alloc uiscmdrsp @%s:%d",
+		pr_err("uislib_malloc failed to alloc uiscmdrsp @%s:%d\n",
 		       fn, ln);
 		return NULL;
 	}
@@ -1106,7 +1105,7 @@ void
 uislib_cache_free(struct kmem_cache *cur_pool, void *p, char *fn, int ln)
 {
 	if (p == NULL) {
-		LOGERR("uislib_free NULL pointer @%s:%d", fn, ln);
+		pr_err("uislib_free NULL pointer @%s:%d\n", fn, ln);
 		return;
 	}
 	kmem_cache_free(cur_pool, p);
@@ -1194,7 +1193,7 @@ info_debugfs_read(struct file *file, char __user *buf,
 		ProcReadBuffer = vmalloc(PROC_READ_BUFFER_SIZE);
 
 		if (ProcReadBuffer == NULL) {
-			LOGERR("failed to allocate buffer to provide proc data.\n");
+			pr_err("failed to allocate buffer to provide proc data\n");
 			return -ENOMEM;
 		}
 	}
@@ -1224,16 +1223,14 @@ find_dev(u32 busNo, u32 devNo)
 		if (bus->bus_no == busNo) {
 			/* make sure the device number is valid */
 			if (devNo >= bus->device_count) {
-				LOGERR("%s bad busNo, devNo=%d,%d",
-				       __func__,
-				       (int) (busNo), (int) (devNo));
+				pr_err("%s bad busNo, devNo=%d,%d\n",
+				       __func__, (int)busNo, (int)devNo);
 				goto Away;
 			}
 			dev = bus->device[devNo];
 			if (!dev)
-				LOGERR("%s bad busNo, devNo=%d,%d",
-				       __func__,
-				       (int) (busNo), (int) (devNo));
+				pr_err("%s bad busNo, devNo=%d,%d\n",
+				       __func__, (int)busNo, (int)devNo);
 			goto Away;
 		}
 	}
@@ -1375,7 +1372,7 @@ Initialize_incoming_thread(void)
 		return TRUE;
 	if (!uisthread_start(&Incoming_ThreadInfo,
 			     &Process_Incoming, NULL, "dev_incoming")) {
-		LOGERR("uisthread_start Initialize_incoming_thread ****FAILED");
+		pr_err("uisthread_start Initialize_incoming_thread ****FAILED\n");
 		return FALSE;
 	}
 	Incoming_Thread_Started = TRUE;
@@ -1397,8 +1394,8 @@ uislib_enable_channel_interrupts(u32 bus_no, u32 dev_no,
 
 	dev = find_dev(bus_no, dev_no);
 	if (!dev) {
-		LOGERR("%s busNo=%d, devNo=%d", __func__, (int) (bus_no),
-		       (int) (dev_no));
+		pr_err("%s busNo=%d, devNo=%d\n",
+		       __func__, (int)bus_no, (int)dev_no);
 		return;
 	}
 	down(&Lock_Polling_Device_Channels);
@@ -1422,8 +1419,8 @@ uislib_disable_channel_interrupts(u32 bus_no, u32 dev_no)
 
 	dev = find_dev(bus_no, dev_no);
 	if (!dev) {
-		LOGERR("%s busNo=%d, devNo=%d", __func__, (int) (bus_no),
-		       (int) (dev_no));
+		pr_err("%s busNo=%d, devNo=%d\n",
+		       __func__, (int)bus_no, (int)dev_no);
 		return;
 	}
 	down(&Lock_Polling_Device_Channels);
diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
index f9f8442..b0ade86 100644
--- a/drivers/staging/unisys/uislib/uisqueue.c
+++ b/drivers/staging/unisys/uislib/uisqueue.c
@@ -107,11 +107,11 @@ uisqueue_put_cmdrsp_with_lock_client(struct uisqueue_info *queueinfo,
 					issue_irq_if_empty,
 					irq_handle, channel_id)) {
 		if (oktowait != OK_TO_WAIT) {
-			LOGERR("****FAILED visor_signal_insert failed; cannot wait; insert aborted\n");
+			pr_err("****FAILED visor_signal_insert failed; cannot wait; insert aborted\n");
 			return 0;	/* failed to queue */
 		}
 		/* try again */
-		LOGERR("****FAILED visor_signal_insert failed; waiting to try again\n");
+		pr_err("****FAILED visor_signal_insert failed; waiting to try again\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(msecs_to_jiffies(10));
 	}
diff --git a/drivers/staging/unisys/uislib/uisthread.c b/drivers/staging/unisys/uislib/uisthread.c
index c0fc812..fb7211e 100644
--- a/drivers/staging/unisys/uislib/uisthread.c
+++ b/drivers/staging/unisys/uislib/uisthread.c
@@ -70,13 +70,13 @@ uisthread_stop(struct uisthread_info *thrinfo)
 	thrinfo->should_stop = 1;
 	ret = KILL(thrinfo->id, SIGHUP, 1);
 	if (ret) {
-		LOGERR("unable to signal thread %d\n", ret);
+		pr_err("unable to signal thread %d\n", ret);
 	} else {
 		/* give up if the thread has NOT died in 1 minute */
 		if (wait_for_completion_timeout(&thrinfo->has_stopped, 60 * HZ))
 			stopped = 1;
 		else
-			LOGERR("timed out trying to signal thread\n");
+			pr_err("timed out trying to signal thread\n");
 	}
 	if (stopped) {
 		LOGINF("uisthread_stop stopped id:%d\n", thrinfo->id);
diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index 4a5b867..bd13669 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -61,7 +61,7 @@ uisutil_add_proc_line_ex(int *total, char **buffer, int *buffer_remaining,
 		*buffer += *buffer_remaining;
 		*total += *buffer_remaining;
 		*buffer_remaining = 0;
-		LOGERR("bytes remaining is too small!\n");
+		pr_err("bytes remaining is too small!\n");
 		return -1;
 	}
 	*buffer_remaining -= len;
@@ -91,7 +91,7 @@ uisctrl_register_req_handler(int type, void *fptr,
 		break;
 
 	default:
-		LOGERR("invalid type %d.\n", type);
+		pr_err("invalid type %d\n", type);
 		return 0;
 	}
 	if (chipset_driver_info)
@@ -119,17 +119,17 @@ uisctrl_register_req_handler_ex(uuid_le switch_uuid,
 	LOGINF("type=%pUL, controlfunc=0x%p.\n",
 	       &switch_uuid, controlfunc);
 	if (!controlfunc) {
-		LOGERR("%pUL: controlfunc must be supplied\n", &switch_uuid);
+		pr_err("%pUL: controlfunc must be supplied\n", &switch_uuid);
 		goto Away;
 	}
 	if (!server_channel_ok) {
-		LOGERR("%pUL: Server_Channel_Ok must be supplied\n",
-				&switch_uuid);
+		pr_err("%pUL: Server_Channel_Ok must be supplied\n",
+		       &switch_uuid);
 		goto Away;
 	}
 	if (!server_channel_init) {
-		LOGERR("%pUL: Server_Channel_Init must be supplied\n",
-				&switch_uuid);
+		pr_err("%pUL: Server_Channel_Init must be supplied\n",
+		       &switch_uuid);
 		goto Away;
 	}
 	pReqHandlerInfo = req_handler_add(switch_uuid,
@@ -138,7 +138,7 @@ uisctrl_register_req_handler_ex(uuid_le switch_uuid,
 					min_channel_bytes,
 					server_channel_ok, server_channel_init);
 	if (!pReqHandlerInfo) {
-		LOGERR("failed to add %pUL to server list\n", &switch_uuid);
+		pr_err("failed to add %pUL to server list\n", &switch_uuid);
 		goto Away;
 	}
 
@@ -150,7 +150,7 @@ Away:
 			bus_device_info_init(chipset_driver_info, "chipset",
 					   "uislib", VERSION, NULL);
 	} else
-		LOGERR("failed to register type %pUL.\n", &switch_uuid);
+		pr_err("failed to register type %pUL\n", &switch_uuid);
 
 	return rc;
 }
@@ -163,15 +163,15 @@ uisctrl_unregister_req_handler_ex(uuid_le switch_uuid)
 
 	LOGINF("type=%pUL.\n", &switch_uuid);
 	if (req_handler_del(switch_uuid) < 0) {
-		LOGERR("failed to remove %pUL from server list\n",
-				&switch_uuid);
+		pr_err("failed to remove %pUL from server list\n",
+		       &switch_uuid);
 		goto Away;
 	}
 	atomic_dec(&uisutils_registered_services);
 	rc = 1;			/* success */
 Away:
 	if (!rc)
-		LOGERR("failed to unregister type %pUL.\n", &switch_uuid);
+		pr_err("failed to unregister type %pUL\n", &switch_uuid);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(uisctrl_unregister_req_handler_ex);
@@ -207,7 +207,7 @@ uisutil_copy_fragsinfo_from_skb(unsigned char *calling_ctx, void *skb_in,
 
 	while (firstfraglen) {
 		if (count == frags_max) {
-			LOGERR("%s frags array too small: max:%d count:%d\n",
+			pr_err("%s frags array too small: max:%d count:%d\n",
 			       calling_ctx, frags_max, count);
 			return -1;	/* failure */
 		}
@@ -230,8 +230,8 @@ uisutil_copy_fragsinfo_from_skb(unsigned char *calling_ctx, void *skb_in,
 		goto dolist;
 
 	if ((count + numfrags) > frags_max) {
-		LOGERR("**** FAILED %s frags array too small: max:%d count+nr_frags:%d\n",
-		     calling_ctx, frags_max, count + numfrags);
+		pr_err("**** FAILED %s frags array too small: max:%d count+nr_frags:%d\n",
+		       calling_ctx, frags_max, count + numfrags);
 		return -1;	/* failure */
 	}
 
@@ -244,7 +244,7 @@ uisutil_copy_fragsinfo_from_skb(unsigned char *calling_ctx, void *skb_in,
 					size, count, frags_max,
 					frags);
 		if (count == 0) {
-			LOGERR("**** FAILED to add physinfo entries\n");
+			pr_err("**** FAILED to add physinfo entries\n");
 			return -1;	/* failure */
 		}
 	}
@@ -262,7 +262,7 @@ dolist: if (skb_shinfo(skb)->frag_list) {
 				frags_max - count,
 				&frags[count]);
 			if (c == -1) {
-				LOGERR("**** FAILED recursive call failed\n");
+				pr_err("**** FAILED recursive call failed\n");
 				return -1;
 			}
 			count += c;
diff --git a/drivers/staging/unisys/virthba/virthba.c b/drivers/staging/unisys/virthba/virthba.c
index d7a629b..2532ee6 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -261,8 +261,8 @@ add_scsipending_entry(struct virthba_info *vhbainfo, char cmdtype, void *new)
 	while (vhbainfo->pending[insert_location].sent != NULL) {
 		insert_location = (insert_location + 1) % MAX_PENDING_REQUESTS;
 		if (insert_location == (int) vhbainfo->nextinsert) {
-			LOGERR("Queue should be full. insert_location<<%d>>  Unable to find open slot for pending commands.\n",
-			     insert_location);
+			pr_err("Queue should be full. insert_location<<%d>>  Unable to find open slot for pending commands\n",
+			       insert_location);
 			spin_unlock_irqrestore(&vhbainfo->privlock, flags);
 			return -1;
 		}
@@ -283,7 +283,7 @@ add_scsipending_entry_with_wait(struct virthba_info *vhbainfo, char cmdtype,
 	int insert_location = add_scsipending_entry(vhbainfo, cmdtype, new);
 
 	while (insert_location == -1) {
-		LOGERR("Failed to find empty queue slot.  Waiting to try again\n");
+		pr_err("Failed to find empty queue slot.  Waiting to try again.\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(msecs_to_jiffies(10));
 		insert_location = add_scsipending_entry(vhbainfo, cmdtype, new);
@@ -299,14 +299,14 @@ del_scsipending_entry(struct virthba_info *vhbainfo, uintptr_t del)
 	void *sent = NULL;
 
 	if (del >= MAX_PENDING_REQUESTS) {
-		LOGERR("Invalid queue position <<%lu>> given to delete. MAX_PENDING_REQUESTS <<%d>>\n",
-		     (unsigned long) del, MAX_PENDING_REQUESTS);
+		pr_err("Invalid queue position <<%lu>> given to delete. MAX_PENDING_REQUESTS <<%d>>\n",
+		       (unsigned long)del, MAX_PENDING_REQUESTS);
 	} else {
 		spin_lock_irqsave(&vhbainfo->privlock, flags);
 
 		if (vhbainfo->pending[del].sent == NULL)
-			LOGERR("Deleting already cleared queue entry at <<%lu>>.\n",
-			     (unsigned long) del);
+			pr_err("Deleting already cleared queue entry at <<%lu>>\n",
+			       (unsigned long)del);
 
 		sent = vhbainfo->pending[del].sent;
 
@@ -355,11 +355,11 @@ SendDiskAddRemove(struct diskaddremove *dar)
 		    scsi_add_device(dar->shost, dar->channel, dar->id,
 				    dar->lun);
 		if (error)
-			LOGERR("Failed scsi_add_device: host_no=%d[chan=%d:id=%d:lun=%d]\n",
-			     dar->shost->host_no, dar->channel, dar->id,
-			     dar->lun);
+			pr_err("Failed scsi_add_device: host_no=%d[chan=%d:id=%d:lun=%d]\n",
+			       dar->shost->host_no, dar->channel, dar->id,
+			       dar->lun);
 	} else
-		LOGERR("Failed scsi_device_lookup:[chan=%d:id=%d:lun=%d]\n",
+		pr_err("Failed scsi_device_lookup:[chan=%d:id=%d:lun=%d]\n",
 		       dar->channel, dar->id, dar->lun);
 	kfree(dar);
 }
@@ -406,9 +406,9 @@ process_disk_notify(struct Scsi_Host *shost, struct uiscmdrsp *cmdrsp)
 		dar->lun = cmdrsp->disknotify.lun;
 		QUEUE_DISKADDREMOVE(dar);
 	} else {
-		LOGERR("kmalloc failed for dar. host_no=%d[chan=%d:id=%d:lun=%d]\n",
-		     shost->host_no, cmdrsp->disknotify.channel,
-		     cmdrsp->disknotify.id, cmdrsp->disknotify.lun);
+		pr_err("kmalloc failed for dar. host_no=%d[chan=%d:id=%d:lun=%d]\n",
+		       shost->host_no, cmdrsp->disknotify.channel,
+		       cmdrsp->disknotify.id, cmdrsp->disknotify.lun);
 	}
 }
 
@@ -535,7 +535,7 @@ virthba_probe(struct virtpci_dev *virtpcidev, const struct pci_device_id *id)
 	 */
 	error = scsi_add_host(scsihost, &virtpcidev->generic_dev);
 	if (error) {
-		LOGERR("scsi_add_host ****FAILED 0x%x  TBD - RECOVER\n", error);
+		pr_err("scsi_add_host ****FAILED 0x%x  TBD - RECOVER\n", error);
 		POSTCODE_LINUX_2(VHBA_PROBE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		/* decr refcount on scsihost which was incremented by
 		 * scsi_add_host so the scsi_host gets deleted
@@ -593,7 +593,7 @@ virthba_probe(struct virtpci_dev *virtpcidev, const struct pci_device_id *id)
 	if (!uisthread_start(&virthbainfo->chinfo.threadinfo,
 			     process_incoming_rsps,
 			     virthbainfo, "vhba_incoming")) {
-		LOGERR("uisthread_start rsp ****FAILED\n");
+		pr_err("uisthread_start rsp ****FAILED\n");
 		/* decr refcount on scsihost which was incremented by
 		 * scsi_add_host so the scsi_host gets deleted
 		 */
@@ -615,14 +615,14 @@ virthba_probe(struct virtpci_dev *virtpcidev, const struct pci_device_id *id)
 	rsp = request_irq(virthbainfo->interrupt_vector, handler, IRQF_SHARED,
 			  scsihost->hostt->name, virthbainfo);
 	if (rsp != 0) {
-		LOGERR("request_irq(%d) uislib_virthba_ISR request failed with rsp=%d\n",
+		pr_err("request_irq(%d) uislib_virthba_ISR request failed with rsp=%d\n",
 		       virthbainfo->interrupt_vector, rsp);
 		virthbainfo->interrupt_vector = -1;
 		POSTCODE_LINUX_2(VHBA_PROBE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 	} else {
 		u64 __iomem *Features_addr =
 		    &virthbainfo->chinfo.queueinfo->chan->features;
-		LOGERR("request_irq(%d) uislib_virthba_ISR request succeeded\n",
+		pr_err("request_irq(%d) uislib_virthba_ISR request succeeded\n",
 		       virthbainfo->interrupt_vector);
 		mask = ~(ULTRA_IO_CHANNEL_IS_POLLING |
 			 ULTRA_IO_DRIVER_DISABLES_INTS);
@@ -692,10 +692,8 @@ forward_vdiskmgmt_command(enum vdisk_mgmt_types vdiskcmdtype,
 	}
 
 	cmdrsp = kzalloc(SIZEOF_CMDRSP, GFP_ATOMIC);
-	if (cmdrsp == NULL) {
-		LOGERR("kmalloc of cmdrsp failed.\n");
+	if (cmdrsp == NULL)
 		return FAILED;	/* reject */
-	}
 
 	init_waitqueue_head(&notifyevent);
 
@@ -755,10 +753,8 @@ forward_taskmgmt_command(enum task_mgmt_types tasktype,
 	}
 
 	cmdrsp = kzalloc(SIZEOF_CMDRSP, GFP_ATOMIC);
-	if (cmdrsp == NULL) {
-		LOGERR("kmalloc of cmdrsp failed.\n");
+	if (cmdrsp == NULL)
 		return FAILED;	/* reject */
-	}
 
 	init_waitqueue_head(&notifyevent);
 
@@ -879,7 +875,7 @@ static int
 virthba_host_reset_handler(struct scsi_cmnd *scsicmd)
 {
 	/* issue TASK_MGMT_TARGET_RESET for each target on each bus for host */
-	LOGERR("virthba_host_reset_handler Not yet implemented\n");
+	pr_err("virthba_host_reset_handler Not yet implemented\n");
 	return SUCCESS;
 }
 
@@ -926,10 +922,8 @@ virthba_queue_command_lck(struct scsi_cmnd *scsicmd,
 	}
 
 	cmdrsp = kzalloc(SIZEOF_CMDRSP, GFP_ATOMIC);
-	if (cmdrsp == NULL) {
-		LOGERR("kmalloc of cmdrsp failed.\n");
+	if (cmdrsp == NULL)
 		return 1;	/* reject the command */
-	}
 
 	/* now saving everything we need from scsi_cmd into cmdrsp
 	 * before we queue cmdrsp set type to command - as opposed to
@@ -944,7 +938,7 @@ virthba_queue_command_lck(struct scsi_cmnd *scsicmd,
 	if (insert_location != -1) {
 		cmdrsp->scsi.scsicmd = (void *) (uintptr_t) insert_location;
 	} else {
-		LOGERR("Queue is full. Returning busy.\n");
+		pr_err("Queue is full. Returning busy.\n");
 		kfree(cmdrsp);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
@@ -965,7 +959,7 @@ virthba_queue_command_lck(struct scsi_cmnd *scsicmd,
 		MaxBuffLen = cmdrsp->scsi.bufflen;
 
 	if (scsi_sg_count(scsicmd) > MAX_PHYS_INFO) {
-		LOGERR("scsicmd use_sg:%d greater than MAX:%d\n",
+		pr_err("scsicmd use_sg:%d greater than MAX:%d\n",
 		       scsi_sg_count(scsicmd), MAX_PHYS_INFO);
 		del_scsipending_entry(virthbainfo, (uintptr_t) insert_location);
 		kfree(cmdrsp);
@@ -979,7 +973,7 @@ virthba_queue_command_lck(struct scsi_cmnd *scsicmd,
 	/* convert buffer to phys information */
 	if (scsi_sg_count(scsicmd) == 0) {
 		if (scsi_bufflen(scsicmd) > 0) {
-			LOGERR("**** FAILED No scatter list for bufflen > 0\n");
+			pr_err("**** FAILED No scatter list for bufflen > 0\n");
 			BUG_ON(scsi_sg_count(scsicmd) == 0);
 		}
 		DBGINF("No sg; buffer:0x%p bufflen:%d\n",
@@ -998,15 +992,15 @@ virthba_queue_command_lck(struct scsi_cmnd *scsicmd,
 		}
 
 		if (sg_failed) {
-			LOGERR("Start sg_list dump (entries %d, bufflen %d)...\n",
-			     scsi_sg_count(scsicmd), cmdrsp->scsi.bufflen);
+			pr_err("Start sg_list dump (entries %d, bufflen %d)...\n",
+			       scsi_sg_count(scsicmd), cmdrsp->scsi.bufflen);
 			for_each_sg(sgl, sg, scsi_sg_count(scsicmd), i) {
-				LOGERR("   Entry(%d): page->[0x%p], phys->[0x%Lx], off(%d), len(%d)\n",
-				     i, sg_page(sg),
-				     (unsigned long long) sg_phys(sg),
-				     sg->offset, sg->length);
+				pr_err("   Entry(%d): page->[0x%p], phys->[0x%Lx], off(%d), len(%d)\n",
+				       i, sg_page(sg),
+				       (unsigned long long)sg_phys(sg),
+				       sg->offset, sg->length);
 			}
-			LOGERR("Done sg_list dump.\n");
+			pr_err("Done sg_list dump\n");
 			/* BUG(); ***** For now, let it fail in uissd
 			 * if it is a problem, as it might just
 			 * work
@@ -1025,7 +1019,7 @@ virthba_queue_command_lck(struct scsi_cmnd *scsicmd,
 						 (u64) NULL, DONT_WAIT, "vhba");
 	if (i == 0) {
 		/* queue must be full - and we said don't wait - return busy */
-		LOGERR("uisqueue_put_cmdrsp_with_lock ****FAILED\n");
+		pr_err("uisqueue_put_cmdrsp_with_lock ****FAILED\n");
 		kfree(cmdrsp);
 		del_scsipending_entry(virthbainfo, (uintptr_t) insert_location);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
@@ -1051,7 +1045,7 @@ virthba_slave_alloc(struct scsi_device *scsidev)
 
 	virthbainfo = (struct virthba_info *) scsihost->hostdata;
 	if (!virthbainfo) {
-		LOGERR("Could not find virthba_info for scsihost\n");
+		pr_err("Could not find virthba_info for scsihost\n");
 		return 0;	/* even though we errored, treat as success */
 	}
 	for (vdisk = &virthbainfo->head; vdisk->next; vdisk = vdisk->next) {
@@ -1062,10 +1056,8 @@ virthba_slave_alloc(struct scsi_device *scsidev)
 			return 0;
 	}
 	tmpvdisk = kzalloc(sizeof(struct virtdisk_info), GFP_ATOMIC);
-	if (!tmpvdisk) {	/* error allocating */
-		LOGERR("Could not allocate memory for disk\n");
+	if (!tmpvdisk)		/* error allocating */
 		return 0;
-	}
 
 	tmpvdisk->channel = scsidev->channel;
 	tmpvdisk->id = scsidev->id;
@@ -1093,7 +1085,7 @@ virthba_slave_destroy(struct scsi_device *scsidev)
 
 	virthbainfo = (struct virthba_info *) scsihost->hostdata;
 	if (!virthbainfo)
-		LOGERR("Could not find virthba_info for scsihost\n");
+		pr_err("Could not find virthba_info for scsihost\n");
 	for (vdisk = &virthbainfo->head; vdisk->next; vdisk = vdisk->next) {
 		if (vdisk->next->valid &&
 		    (vdisk->next->channel == scsidev->channel) &&
@@ -1138,7 +1130,7 @@ do_scsi_linuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 
 		if (atomic_read(&vdisk->error_count) < VIRTHBA_ERROR_COUNT) {
 			atomic_inc(&vdisk->error_count);
-			LOGERR("SCSICMD ****FAILED scsicmd:0x%p op:0x%x <%d:%d:%d:%llu> 0x%x-0x%x-0x%x-0x%x-0x%x.\n",
+			pr_err("SCSICMD ****FAILED scsicmd:0x%p op:0x%x <%d:%d:%d:%llu> 0x%x-0x%x-0x%x-0x%x-0x%x\n",
 			       scsicmd, cmdrsp->scsi.cmnd[0],
 			       scsidev->host->host_no, scsidev->id,
 			       scsidev->channel, scsidev->lun,
@@ -1147,9 +1139,9 @@ do_scsi_linuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 			       sd->additional_sense_code_qualifier);
 			if (atomic_read(&vdisk->error_count) ==
 			    VIRTHBA_ERROR_COUNT) {
-				LOGERR("Throtling SCSICMD errors disk <%d:%d:%d:%llu>\n",
-				     scsidev->host->host_no, scsidev->id,
-				     scsidev->channel, scsidev->lun);
+				pr_err("Throttling SCSICMD errors disk <%d:%d:%d:%llu>\n",
+				       scsidev->host->host_no, scsidev->id,
+				       scsidev->channel, scsidev->lun);
 			}
 			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
 		}
@@ -1186,7 +1178,7 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 
 		if (scsi_sg_count(scsicmd) == 0) {
 			if (scsi_bufflen(scsicmd) > 0) {
-				LOGERR("**** FAILED No scatter list for bufflen > 0\n");
+				pr_err("**** FAILED No scatter list for bufflen > 0\n");
 				BUG_ON(scsi_sg_count(scsicmd) ==
 				       0);
 			}
@@ -1218,7 +1210,7 @@ do_scsi_nolinuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
 			if (atomic_read(&vdisk->ios_threshold) > 0) {
 				atomic_dec(&vdisk->ios_threshold);
 				if (atomic_read(&vdisk->ios_threshold) == 0) {
-					LOGERR("Resetting error count for disk\n");
+					pr_err("Resetting error count for disk\n");
 					atomic_set(&vdisk->error_count, 0);
 				}
 			}
@@ -1317,7 +1309,7 @@ drain_queue(struct virthba_info *virthbainfo, struct chaninfo *dc,
 				break;
 			complete_vdiskmgmt_command(cmdrsp);
 		} else
-			LOGERR("Invalid cmdtype %d\n", cmdrsp->cmdtype);
+			pr_err("Invalid cmdtype %d\n", cmdrsp->cmdtype);
 		/* cmdrsp is now available for reuse */
 	}
 }
@@ -1339,7 +1331,6 @@ process_incoming_rsps(void *v)
 	/* alloc once and reuse */
 	cmdrsp = kmalloc(SZ, GFP_ATOMIC);
 	if (cmdrsp == NULL) {
-		LOGERR("process_incoming_rsps ****FAILED to malloc - thread exiting\n");
 		complete_and_exit(&dc->threadinfo.has_stopped, 0);
 		return 0;
 	}
@@ -1433,16 +1424,16 @@ static ssize_t enable_ints_write(struct file *file,
 
 	buf[count] = '\0';
 	if (copy_from_user(buf, buffer, count)) {
-		LOGERR("copy_from_user failed. buf<<%.*s>> count<<%lu>>\n",
-		       (int) count, buf, count);
+		pr_err("copy_from_user failed. buf<<%.*s>> count<<%lu>>\n",
+		       (int)count, buf, count);
 		return -EFAULT;
 	}
 
 	i = kstrtoint(buf, 10 , &new_value);
 
 	if (i != 0) {
-		LOGERR("Failed to scan value for enable_ints, buf<<%.*s>>",
-		       (int) count, buf);
+		pr_err("Failed to scan value for enable_ints, buf<<%.*s>>\n",
+		       (int)count, buf);
 		return -EFAULT;
 	}
 
@@ -1488,7 +1479,7 @@ virthba_serverup(struct virtpci_dev *virtpcidev)
 		return 1;
 	}
 	if (virthbainfo->serverchangingstate) {
-		LOGERR("Server already processing change state message\n");
+		pr_err("Server already processing change state message\n");
 		return 0;
 	}
 
@@ -1504,7 +1495,7 @@ virthba_serverup(struct virtpci_dev *virtpcidev)
 	if (!uisthread_start(&virthbainfo->chinfo.threadinfo,
 			     process_incoming_rsps,
 			     virthbainfo, "vhba_incoming")) {
-		LOGERR("uisthread_start rsp ****FAILED\n");
+		pr_err("uisthread_start rsp ****FAILED\n");
 		return 0;
 	}
 	virthbainfo->serverdown = false;
@@ -1561,8 +1552,8 @@ virthba_serverdown_complete(struct work_struct *work)
 			break;
 		default:
 			if (pendingdel->sent != NULL)
-				LOGERR("Unknown command type: 0x%x.  Only freeing list structure.\n",
-				     pendingdel->cmdtype);
+				pr_err("Unknown command type: 0x%x.  Only freeing list structure.\n",
+				       pendingdel->cmdtype);
 		}
 		pendingdel->cmdtype = 0;
 		pendingdel->sent = NULL;
@@ -1597,10 +1588,10 @@ virthba_serverdown(struct virtpci_dev *virtpcidev, u32 state)
 		queue_work(virthba_serverdown_workqueue,
 			   &virthbainfo->serverdown_completion);
 	} else if (virthbainfo->serverchangingstate) {
-		LOGERR("Server already processing change state message\n");
+		pr_err("Server already processing change state message\n");
 		return 0;
 	} else
-		LOGERR("Server already down, but another server down message received.");
+		pr_err("Server already down, but another server down message received\n");
 
 	return 1;
 }
@@ -1651,7 +1642,7 @@ virthba_mod_init(void)
 
 	error = virtpci_register_driver(&virthba_driver);
 	if (error < 0) {
-		LOGERR("register ****FAILED 0x%x\n", error);
+		pr_err("register ****FAILED 0x%x\n", error);
 		POSTCODE_LINUX_3(VHBA_CREATE_FAILURE_PC, error,
 				 POSTCODE_SEVERITY_ERR);
 	} else {
@@ -1676,7 +1667,7 @@ virthba_mod_init(void)
 		virthba_serverdown_workqueue =
 		    create_singlethread_workqueue("virthba_serverdown");
 		if (virthba_serverdown_workqueue == NULL) {
-			LOGERR("**** FAILED virthba_serverdown_workqueue creation\n");
+			pr_err("**** FAILED virthba_serverdown_workqueue creation\n");
 			POSTCODE_LINUX_2(VHBA_CREATE_FAILURE_PC,
 					 POSTCODE_SEVERITY_ERR);
 			error = -1;
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 39b828d..fe881fa 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -192,12 +192,12 @@ static int write_vbus_chp_info(struct spar_vbus_channel_protocol *chan,
 	int off;
 
 	if (!chan) {
-		LOGERR("vbus channel not present");
+		pr_err("vbus channel not present\n");
 		return -1;
 	}
 	off = sizeof(struct channel_header) + chan->hdr_info.chp_info_offset;
 	if (chan->hdr_info.chp_info_offset == 0) {
-		LOGERR("vbus channel not used, because chp_info_offset == 0");
+		pr_err("vbus channel not used, because chp_info_offset == 0\n");
 		return -1;
 	}
 	memcpy(((u8 *)(chan)) + off, info, sizeof(*info));
@@ -211,12 +211,12 @@ static int write_vbus_bus_info(struct spar_vbus_channel_protocol *chan,
 	int off;
 
 	if (!chan) {
-		LOGERR("vbus channel not present");
+		pr_err("vbus channel not present\n");
 		return -1;
 	}
 	off = sizeof(struct channel_header) + chan->hdr_info.bus_info_offset;
 	if (chan->hdr_info.bus_info_offset == 0) {
-		LOGERR("vbus channel not used, because bus_info_offset == 0");
+		pr_err("vbus channel not used, because bus_info_offset == 0\n");
 		return -1;
 	}
 	memcpy(((u8 *)(chan)) + off, info, sizeof(*info));
@@ -233,7 +233,7 @@ write_vbus_dev_info(struct spar_vbus_channel_protocol *chan,
 	int off;
 
 	if (!chan) {
-		LOGERR("vbus channel not present");
+		pr_err("vbus channel not present\n");
 		return -1;
 	}
 	off =
@@ -241,7 +241,7 @@ write_vbus_dev_info(struct spar_vbus_channel_protocol *chan,
 	     chan->hdr_info.dev_info_offset) +
 	    (chan->hdr_info.device_info_struct_bytes * devix);
 	if (chan->hdr_info.dev_info_offset == 0) {
-		LOGERR("vbus channel not used, because dev_info_offset == 0");
+		pr_err("vbus channel not used, because dev_info_offset == 0\n");
 		return -1;
 	}
 	memcpy(((u8 *)(chan)) + off, info, sizeof(*info));
@@ -275,7 +275,7 @@ static int add_vbus(struct add_vbus_guestpart *addparams)
 	 */
 	ret = device_register(vbus);
 	if (ret) {
-		LOGERR("device_register FAILED:%d\n", ret);
+		pr_err("device_register FAILED:%d\n", ret);
 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		return 0;
 	}
@@ -316,7 +316,7 @@ static int add_vhba(struct add_virt_guestpart *addparams)
 	POSTCODE_LINUX_2(VPCI_CREATE_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 	if (!WAIT_FOR_IO_CHANNEL
 	    ((struct spar_io_channel_protocol __iomem *)addparams->chanptr)) {
-		LOGERR("Timed out.  Channel not ready\n");
+		pr_err("Timed out.  Channel not ready.\n");
 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		return 0;
 	}
@@ -328,7 +328,7 @@ static int add_vhba(struct add_virt_guestpart *addparams)
 	vbus = bus_find_device(&virtpci_bus_type, NULL,
 			       (void *)busid, match_busid);
 	if (!vbus) {
-		LOGERR("**** FAILED to find vbus %s\n", busid);
+		pr_err("**** FAILED to find vbus %s\n", busid);
 		return 0;
 	}
 
@@ -379,7 +379,7 @@ add_vnic(struct add_virt_guestpart *addparams)
 	POSTCODE_LINUX_2(VPCI_CREATE_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 	if (!WAIT_FOR_IO_CHANNEL
 	    ((struct spar_io_channel_protocol __iomem *)addparams->chanptr)) {
-		LOGERR("Timed out, channel not ready\n");
+		pr_err("Timed out, channel not ready\n");
 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		return 0;
 	}
@@ -391,7 +391,7 @@ add_vnic(struct add_virt_guestpart *addparams)
 	vbus = bus_find_device(&virtpci_bus_type, NULL,
 			       (void *)busid, match_busid);
 	if (!vbus) {
-		LOGERR("**** FAILED to find vbus %s\n", busid);
+		pr_err("**** FAILED to find vbus %s\n", busid);
 		return 0;
 	}
 
@@ -425,7 +425,7 @@ delete_vbus(struct del_vbus_guestpart *delparams)
 	vbus = bus_find_device(&virtpci_bus_type, NULL,
 			       (void *)busid, match_busid);
 	if (!vbus) {
-		LOGERR("**** FAILED to find vbus %s\n", busid);
+		pr_err("**** FAILED to find vbus %s\n", busid);
 		return 0;
 	}
 
@@ -619,7 +619,7 @@ static void delete_all(void)
 	/* now delete each vbus */
 	if (bus_for_each_dev
 	    (&virtpci_bus_type, NULL, (void *)1, delete_vbus_device))
-		LOGERR("delete of all vbus failed\n");
+		pr_err("delete of all vbus failed\n");
 }
 
 /* deletes all vnics or vhbas
@@ -637,12 +637,12 @@ static int delete_all_virt(enum virtpci_dev_type devtype,
 	vbus = bus_find_device(&virtpci_bus_type, NULL,
 			       (void *)busid, match_busid);
 	if (!vbus) {
-		LOGERR("**** FAILED to find vbus %s\n", busid);
+		pr_err("**** FAILED to find vbus %s\n", busid);
 		return 0;
 	}
 
 	if ((devtype != VIRTHBA_TYPE) && (devtype != VIRTNIC_TYPE)) {
-		LOGERR("**** FAILED to delete all devices; devtype:%d not vhba:%d or vnic:%d\n",
+		pr_err("**** FAILED to delete all devices; devtype:%d not vhba:%d or vnic:%d\n",
 		       devtype, VIRTHBA_TYPE, VIRTNIC_TYPE);
 		return 0;
 	}
@@ -688,7 +688,7 @@ static int virtpci_ctrlchan_func(struct guest_msgs *msg)
 	case GUEST_RESUME_VNIC:
 		return resume_vnic(&msg->resume_vnic);
 	default:
-		LOGERR("invalid message type %d.\n", msg->msgtype);
+		pr_err("invalid message type %d\n", msg->msgtype);
 		return 0;
 	}
 }
@@ -783,21 +783,21 @@ static void fix_vbus_dev_info(struct device *dev, int dev_no, int dev_type,
 	const char *stype;
 
 	if (!dev) {
-		LOGERR("%s dev is NULL", __func__);
+		pr_err("%s dev is NULL\n", __func__);
 		return;
 	}
 	if (!virtpcidrv) {
-		LOGERR("%s driver is NULL", __func__);
+		pr_err("%s driver is NULL\n", __func__);
 		return;
 	}
 	vbus = dev->parent;
 	if (!vbus) {
-		LOGERR("%s dev has no parent bus", __func__);
+		pr_err("%s dev has no parent bus\n", __func__);
 		return;
 	}
 	chan = vbus->platform_data;
 	if (!chan) {
-		LOGERR("%s dev bus has no channel", __func__);
+		pr_err("%s dev bus has no channel\n", __func__);
 		return;
 	}
 	switch (dev_type) {
@@ -937,7 +937,7 @@ static int virtpci_device_add(struct device *parentbus, int devtype,
 	POSTCODE_LINUX_2(VPCI_CREATE_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 
 	if ((devtype != VIRTHBA_TYPE) && (devtype != VIRTNIC_TYPE)) {
-		LOGERR("**** FAILED to add device; devtype:%d not vhba:%d or vnic:%d\n",
+		pr_err("**** FAILED to add device; devtype:%d not vhba:%d or vnic:%d\n",
 		       devtype, VIRTHBA_TYPE, VIRTNIC_TYPE);
 		POSTCODE_LINUX_3(VPCI_CREATE_FAILURE_PC, devtype,
 				 POSTCODE_SEVERITY_ERR);
@@ -947,7 +947,6 @@ static int virtpci_device_add(struct device *parentbus, int devtype,
 	/* add a Virtual Device */
 	virtpcidev = kzalloc(sizeof(*virtpcidev), GFP_ATOMIC);
 	if (virtpcidev == NULL) {
-		LOGERR("can't add device - malloc FALLED\n");
 		POSTCODE_LINUX_2(MALLOC_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		return 0;
 	}
@@ -1009,7 +1008,7 @@ static int virtpci_device_add(struct device *parentbus, int devtype,
 		 */
 		write_unlock_irqrestore(&vpcidev_list_lock, flags);
 		kfree(virtpcidev);
-		LOGERR("**** FAILED vhba/vnic already exists in the list\n");
+		pr_err("**** FAILED vhba/vnic already exists in the list\n");
 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		return 0;
 	}
@@ -1053,7 +1052,7 @@ static int virtpci_device_add(struct device *parentbus, int devtype,
 	 * virtpci_device_probe is successful
 	 */
 	if (ret) {
-		LOGERR("device_register returned %d\n", ret);
+		pr_err("device_register returned %d\n", ret);
 		dev = &virtpcidev->generic_dev;
 		SPAR_CHANNEL_CLIENT_TRANSITION(addparams->chanptr,
 					       BUS_ID(dev),
@@ -1097,7 +1096,7 @@ static int virtpci_device_serverdown(struct device *parentbus,
 	int rc = 0;
 
 	if ((devtype != VIRTHBA_TYPE) && (devtype != VIRTNIC_TYPE)) {
-		LOGERR("**** FAILED to pause device; devtype:%d not vhba:%d or vnic:%d\n",
+		pr_err("**** FAILED to pause device; devtype:%d not vhba:%d or vnic:%d\n",
 		       devtype, VIRTHBA_TYPE, VIRTNIC_TYPE);
 		return 0;
 	}
@@ -1136,7 +1135,7 @@ static int virtpci_device_serverdown(struct device *parentbus,
 	write_unlock_irqrestore(&vpcidev_list_lock, flags);
 
 	if (!found) {
-		LOGERR("**** FAILED to find vhba/vnic in the list\n");
+		pr_err("**** FAILED to find vhba/vnic in the list\n");
 		return 0;
 	}
 
@@ -1156,7 +1155,7 @@ static int virtpci_device_serverup(struct device *parentbus,
 	int rc = 0;
 
 	if ((devtype != VIRTHBA_TYPE) && (devtype != VIRTNIC_TYPE)) {
-		LOGERR("**** FAILED to resume device; devtype:%d not vhba:%d or vnic:%d\n",
+		pr_err("**** FAILED to resume device; devtype:%d not vhba:%d or vnic:%d\n",
 		       devtype, VIRTHBA_TYPE, VIRTNIC_TYPE);
 		return 0;
 	}
@@ -1204,7 +1203,7 @@ static int virtpci_device_serverup(struct device *parentbus,
 	write_unlock_irqrestore(&vpcidev_list_lock, flags);
 
 	if (!found) {
-		LOGERR("**** FAILED to find vhba/vnic in the list\n");
+		pr_err("**** FAILED to find vhba/vnic in the list\n");
 		return 0;
 	}
 
@@ -1226,7 +1225,7 @@ static int virtpci_device_del(struct device *parentbus,
 }
 
 	if ((devtype != VIRTHBA_TYPE) && (devtype != VIRTNIC_TYPE)) {
-		LOGERR("**** FAILED to delete device; devtype:%d not vhba:%d or vnic:%d\n",
+		pr_err("**** FAILED to delete device; devtype:%d not vhba:%d or vnic:%d\n",
 		       devtype, VIRTHBA_TYPE, VIRTNIC_TYPE);
 		return 0;
 	}
@@ -1297,7 +1296,7 @@ static int virtpci_device_del(struct device *parentbus,
 	write_unlock_irqrestore(&vpcidev_list_lock, flags);
 
 	if (!all && (count == 0)) {
-		LOGERR("**** FAILED to find vhba/vnic in the list\n");
+		pr_err("**** FAILED to find vhba/vnic in the list\n");
 		return 0;
 	}
 
@@ -1385,7 +1384,7 @@ int virtpci_register_driver(struct virtpci_driver *drv)
 	DBGINF("In virtpci_register_driver\n");
 
 	if (drv->id_table == NULL) {
-		LOGERR("id_table missing\n");
+		pr_err("id_table missing\n");
 		return 1;
 	}
 	/* initialize core driver fields needed to call driver_register */
@@ -1471,7 +1470,7 @@ static ssize_t info_debugfs_read(struct file *file, char __user *buf,
 	printparam.len = &len;
 	if (bus_for_each_dev(&virtpci_bus_type, NULL,
 			     (void *)&printparam, print_vbus))
-		LOGERR("Failed to find bus\n");
+		pr_err("Failed to find bus\n");
 
 	str_pos += scnprintf(vbuf + str_pos, len - str_pos,
 			"\n Virtual PCI devices\n");
@@ -1534,7 +1533,7 @@ static int __init virtpci_mod_init(void)
 	 * drivers directory
 	 */
 	if (ret) {
-		LOGERR("bus_register ****FAILED:%d\n", ret);
+		pr_err("bus_register ****FAILED:%d\n", ret);
 		POSTCODE_LINUX_3(VPCI_CREATE_FAILURE_PC, ret,
 				 POSTCODE_SEVERITY_ERR);
 		return ret;
@@ -1546,7 +1545,7 @@ static int __init virtpci_mod_init(void)
 	/* create a root bus used to parent all the virtpci buses. */
 	ret = device_register(&virtpci_rootbus_device);
 	if (ret) {
-		LOGERR("device_register FAILED:%d\n", ret);
+		pr_err("device_register FAILED:%d\n", ret);
 		bus_unregister(&virtpci_bus_type);
 		POSTCODE_LINUX_3(VPCI_CREATE_FAILURE_PC, ret,
 				 POSTCODE_SEVERITY_ERR);
@@ -1556,7 +1555,7 @@ static int __init virtpci_mod_init(void)
 
 	if (!uisctrl_register_req_handler(2, (void *)&virtpci_ctrlchan_func,
 					  &chipset_driver_info)) {
-		LOGERR("uisctrl_register_req_handler ****FAILED.\n");
+		pr_err("uisctrl_register_req_handler ****FAILED\n");
 		POSTCODE_LINUX_2(VPCI_CREATE_FAILURE_PC, POSTCODE_SEVERITY_ERR);
 		device_unregister(&virtpci_rootbus_device);
 		bus_unregister(&virtpci_bus_type);
@@ -1580,7 +1579,7 @@ static void __exit virtpci_mod_exit(void)
 
 	/* unregister the callback function */
 	if (!uisctrl_register_req_handler(2, NULL, NULL))
-		LOGERR("uisctrl_register_req_handler ****FAILED.\n");
+		pr_err("uisctrl_register_req_handler ****FAILED\n");
 
 	device_unregister(&virtpci_rootbus_device);
 	bus_unregister(&virtpci_bus_type);
diff --git a/drivers/staging/unisys/visorchipset/file.c b/drivers/staging/unisys/visorchipset/file.c
index 373fa36..d5dea8d 100644
--- a/drivers/staging/unisys/visorchipset/file.c
+++ b/drivers/staging/unisys/visorchipset/file.c
@@ -217,7 +217,7 @@ visorchipset_ioctl(struct inode *inode, struct file *file,
 		rc = issue_vmcall_update_physical_time(adjustment);
 		break;
 	default:
-		LOGERR("visorchipset_ioctl received invalid command");
+		pr_err("visorchipset_ioctl received invalid command\n");
 		rc = -EFAULT;
 		break;
 	}
diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 7e6be32..0277810 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -665,7 +665,7 @@ chipset_init(struct controlvm_message *inmsg)
 
 	POSTCODE_LINUX_2(CHIPSET_INIT_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 	if (chipset_inited) {
-		LOGERR("CONTROLVM_CHIPSET_INIT Failed: Already Done.");
+		pr_err("CONTROLVM_CHIPSET_INIT Failed: Already Done\n");
 		rc = -CONTROLVM_RESP_ERROR_ALREADY_DONE;
 		goto Away;
 	}
@@ -725,7 +725,7 @@ controlvm_respond(struct controlvm_message_header *msgHdr, int response)
 	}
 	if (!visorchannel_signalinsert(ControlVm_channel,
 				       CONTROLVM_QUEUE_REQUEST, &outmsg)) {
-		LOGERR("signalinsert failed!");
+		pr_err("signalinsert failed!\n");
 		return;
 	}
 }
@@ -741,7 +741,7 @@ controlvm_respond_chipset_init(struct controlvm_message_header *msgHdr,
 	outmsg.cmd.init_chipset.features = features;
 	if (!visorchannel_signalinsert(ControlVm_channel,
 				       CONTROLVM_QUEUE_REQUEST, &outmsg)) {
-		LOGERR("signalinsert failed!");
+		pr_err("signalinsert failed!\n");
 		return;
 	}
 }
@@ -757,7 +757,7 @@ static void controlvm_respond_physdev_changestate(
 	outmsg.cmd.device_change_state.flags.phys_device = 1;
 	if (!visorchannel_signalinsert(ControlVm_channel,
 				       CONTROLVM_QUEUE_REQUEST, &outmsg)) {
-		LOGERR("signalinsert failed!");
+		pr_err("signalinsert failed!\n");
 		return;
 	}
 }
@@ -774,14 +774,14 @@ visorchipset_save_message(struct controlvm_message *msg,
 			      offsetof(struct spar_controlvm_channel_protocol,
 				       saved_crash_message_count),
 			      &localSavedCrashMsgCount, sizeof(u16)) < 0) {
-		LOGERR("failed to get Saved Message Count");
+		pr_err("failed to get Saved Message Count\n");
 		POSTCODE_LINUX_2(CRASH_DEV_CTRL_RD_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
 	}
 
 	if (localSavedCrashMsgCount != CONTROLVM_CRASHMSG_MAX) {
-		LOGERR("Saved Message Count incorrect %d",
+		pr_err("Saved Message Count incorrect %d\n",
 		       localSavedCrashMsgCount);
 		POSTCODE_LINUX_3(CRASH_DEV_COUNT_FAILURE_PC,
 				 localSavedCrashMsgCount,
@@ -794,7 +794,7 @@ visorchipset_save_message(struct controlvm_message *msg,
 			      offsetof(struct spar_controlvm_channel_protocol,
 				       saved_crash_message_offset),
 			      &localSavedCrashMsgOffset, sizeof(u32)) < 0) {
-		LOGERR("failed to get Saved Message Offset");
+		pr_err("failed to get Saved Message Offset\n");
 		POSTCODE_LINUX_2(CRASH_DEV_CTRL_RD_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -805,7 +805,7 @@ visorchipset_save_message(struct controlvm_message *msg,
 				       localSavedCrashMsgOffset,
 				       msg,
 				       sizeof(struct controlvm_message)) < 0) {
-			LOGERR("SAVE_MSG_BUS_FAILURE: Failed to write CrashCreateBusMsg!");
+			pr_err("SAVE_MSG_BUS_FAILURE: Failed to write CrashCreateBusMsg!\n");
 			POSTCODE_LINUX_2(SAVE_MSG_BUS_FAILURE_PC,
 					 POSTCODE_SEVERITY_ERR);
 			return;
@@ -815,7 +815,7 @@ visorchipset_save_message(struct controlvm_message *msg,
 				       localSavedCrashMsgOffset +
 				       sizeof(struct controlvm_message), msg,
 				       sizeof(struct controlvm_message)) < 0) {
-			LOGERR("SAVE_MSG_DEV_FAILURE: Failed to write CrashCreateDevMsg!");
+			pr_err("SAVE_MSG_DEV_FAILURE: Failed to write CrashCreateDevMsg!\n");
 			POSTCODE_LINUX_2(SAVE_MSG_DEV_FAILURE_PC,
 					 POSTCODE_SEVERITY_ERR);
 			return;
@@ -832,7 +832,7 @@ bus_responder(enum controlvm_id cmdId, ulong busNo, int response)
 
 	p = findbus(&BusInfoList, busNo);
 	if (!p) {
-		LOGERR("internal error busNo=%lu", busNo);
+		pr_err("internal error busNo=%lu\n", busNo);
 		return;
 	}
 	if (response < 0) {
@@ -848,11 +848,11 @@ bus_responder(enum controlvm_id cmdId, ulong busNo, int response)
 	}
 
 	if (p->pending_msg_hdr.id == CONTROLVM_INVALID) {
-		LOGERR("bus_responder no pending msg");
+		pr_err("bus_responder no pending msg\n");
 		return;		/* no controlvm response needed */
 	}
 	if (p->pending_msg_hdr.id != (u32) cmdId) {
-		LOGERR("expected=%d, found=%d", cmdId, p->pending_msg_hdr.id);
+		pr_err("expected=%d, found=%d\n", cmdId, p->pending_msg_hdr.id);
 		return;
 	}
 	controlvm_respond(&p->pending_msg_hdr, response);
@@ -873,15 +873,15 @@ device_changestate_responder(enum controlvm_id cmdId,
 
 	p = finddevice(&DevInfoList, busNo, devNo);
 	if (!p) {
-		LOGERR("internal error; busNo=%lu, devNo=%lu", busNo, devNo);
+		pr_err("internal error; busNo=%lu, devNo=%lu\n", busNo, devNo);
 		return;
 	}
 	if (p->pending_msg_hdr.id == CONTROLVM_INVALID) {
-		LOGERR("device_responder no pending msg");
+		pr_err("device_responder no pending msg\n");
 		return;		/* no controlvm response needed */
 	}
 	if (p->pending_msg_hdr.id != cmdId) {
-		LOGERR("expected=%d, found=%d", cmdId, p->pending_msg_hdr.id);
+		pr_err("expected=%d, found=%d\n", cmdId, p->pending_msg_hdr.id);
 		return;
 	}
 
@@ -893,7 +893,7 @@ device_changestate_responder(enum controlvm_id cmdId,
 
 	if (!visorchannel_signalinsert(ControlVm_channel,
 				       CONTROLVM_QUEUE_REQUEST, &outmsg)) {
-		LOGERR("signalinsert failed!");
+		pr_err("signalinsert failed!\n");
 		return;
 	}
 
@@ -909,7 +909,7 @@ device_responder(enum controlvm_id cmdId, ulong busNo, ulong devNo,
 
 	p = finddevice(&DevInfoList, busNo, devNo);
 	if (!p) {
-		LOGERR("internal error; busNo=%lu, devNo=%lu", busNo, devNo);
+		pr_err("internal error; busNo=%lu, devNo=%lu\n", busNo, devNo);
 		return;
 	}
 	if (response >= 0) {
@@ -920,11 +920,11 @@ device_responder(enum controlvm_id cmdId, ulong busNo, ulong devNo,
 	}
 
 	if (p->pending_msg_hdr.id == CONTROLVM_INVALID) {
-		LOGERR("device_responder no pending msg");
+		pr_err("device_responder no pending msg\n");
 		return;		/* no controlvm response needed */
 	}
 	if (p->pending_msg_hdr.id != (u32) cmdId) {
-		LOGERR("expected=%d, found=%d", cmdId, p->pending_msg_hdr.id);
+		pr_err("expected=%d, found=%d\n", cmdId, p->pending_msg_hdr.id);
 		return;
 	}
 	controlvm_respond(&p->pending_msg_hdr, response);
@@ -943,7 +943,7 @@ bus_epilog(u32 busNo,
 	struct visorchipset_bus_info *pBusInfo = findbus(&BusInfoList, busNo);
 
 	if (!pBusInfo) {
-		LOGERR("HUH? bad busNo=%d", busNo);
+		pr_err("HUH? bad busNo=%d\n", busNo);
 		return;
 	}
 	if (needResponse) {
@@ -1016,7 +1016,7 @@ device_epilog(u32 busNo, u32 devNo, struct spar_segment_state state, u32 cmd,
 	};
 
 	if (!pDevInfo) {
-		LOGERR("HUH? bad busNo=%d, devNo=%d", busNo, devNo);
+		pr_err("HUH? bad busNo=%d, devNo=%d\n", busNo, devNo);
 		return;
 	}
 	if (for_visorbus)
@@ -1110,7 +1110,7 @@ bus_create(struct controlvm_message *inmsg)
 
 	pBusInfo = findbus(&BusInfoList, busNo);
 	if (pBusInfo && (pBusInfo->state.created == 1)) {
-		LOGERR("CONTROLVM_BUS_CREATE Failed: bus %lu already exists",
+		pr_err("CONTROLVM_BUS_CREATE Failed: bus %lu already exists\n",
 		       busNo);
 		POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, busNo,
 				 POSTCODE_SEVERITY_ERR);
@@ -1119,8 +1119,6 @@ bus_create(struct controlvm_message *inmsg)
 	}
 	pBusInfo = kzalloc(sizeof(struct visorchipset_bus_info), GFP_KERNEL);
 	if (pBusInfo == NULL) {
-		LOGERR("CONTROLVM_BUS_CREATE Failed: bus %lu kzalloc failed",
-		       busNo);
 		POSTCODE_LINUX_3(BUS_CREATE_FAILURE_PC, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
@@ -1164,13 +1162,14 @@ bus_destroy(struct controlvm_message *inmsg)
 
 	pBusInfo = findbus(&BusInfoList, busNo);
 	if (!pBusInfo) {
-		LOGERR("CONTROLVM_BUS_DESTROY Failed: bus %lu invalid", busNo);
+		pr_err("CONTROLVM_BUS_DESTROY Failed: bus %lu invalid\n",
+		       busNo);
 		rc = -CONTROLVM_RESP_ERROR_BUS_INVALID;
 		goto Away;
 	}
 	if (pBusInfo->state.created == 0) {
-		LOGERR("CONTROLVM_BUS_DESTROY Failed: bus %lu already destroyed",
-		     busNo);
+		pr_err("CONTROLVM_BUS_DESTROY Failed: bus %lu already destroyed\n",
+		       busNo);
 		rc = -CONTROLVM_RESP_ERROR_ALREADY_DONE;
 		goto Away;
 	}
@@ -1194,7 +1193,7 @@ bus_configure(struct controlvm_message *inmsg, PARSER_CONTEXT *parser_ctx)
 
 	pBusInfo = findbus(&BusInfoList, busNo);
 	if (!pBusInfo) {
-		LOGERR("CONTROLVM_BUS_CONFIGURE Failed: bus %lu invalid",
+		pr_err("CONTROLVM_BUS_CONFIGURE Failed: bus %lu invalid\n",
 		       busNo);
 		POSTCODE_LINUX_3(BUS_CONFIGURE_FAILURE_PC, busNo,
 				 POSTCODE_SEVERITY_ERR);
@@ -1202,8 +1201,8 @@ bus_configure(struct controlvm_message *inmsg, PARSER_CONTEXT *parser_ctx)
 		goto Away;
 	}
 	if (pBusInfo->state.created == 0) {
-		LOGERR("CONTROLVM_BUS_CONFIGURE Failed: Invalid bus %lu - not created yet",
-		     busNo);
+		pr_err("CONTROLVM_BUS_CONFIGURE Failed: Invalid bus %lu - not created yet\n",
+		       busNo);
 		POSTCODE_LINUX_3(BUS_CONFIGURE_FAILURE_PC, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_BUS_INVALID;
@@ -1211,8 +1210,8 @@ bus_configure(struct controlvm_message *inmsg, PARSER_CONTEXT *parser_ctx)
 	}
 	/* TBD - add this check to other commands also... */
 	if (pBusInfo->pending_msg_hdr.id != CONTROLVM_INVALID) {
-		LOGERR("CONTROLVM_BUS_CONFIGURE Failed: bus %lu MsgId=%u outstanding",
-		     busNo, (uint) pBusInfo->pending_msg_hdr.id);
+		pr_err("CONTROLVM_BUS_CONFIGURE Failed: bus %lu MsgId=%u outstanding\n",
+		       busNo, (uint) pBusInfo->pending_msg_hdr.id);
 		POSTCODE_LINUX_3(BUS_CONFIGURE_FAILURE_PC, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_MESSAGE_ID_INVALID_FOR_CLIENT;
@@ -1243,8 +1242,8 @@ my_device_create(struct controlvm_message *inmsg)
 
 	pDevInfo = finddevice(&DevInfoList, busNo, devNo);
 	if (pDevInfo && (pDevInfo->state.created == 1)) {
-		LOGERR("CONTROLVM_DEVICE_CREATE Failed: busNo=%lu, devNo=%lu already exists",
-		     busNo, devNo);
+		pr_err("CONTROLVM_DEVICE_CREATE Failed: busNo=%lu, devNo=%lu already exists\n",
+		       busNo, devNo);
 		POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_ALREADY_DONE;
@@ -1252,16 +1251,16 @@ my_device_create(struct controlvm_message *inmsg)
 	}
 	pBusInfo = findbus(&BusInfoList, busNo);
 	if (!pBusInfo) {
-		LOGERR("CONTROLVM_DEVICE_CREATE Failed: Invalid bus %lu - out of range",
-		     busNo);
+		pr_err("CONTROLVM_DEVICE_CREATE Failed: Invalid bus %lu - out of range\n",
+		       busNo);
 		POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_BUS_INVALID;
 		goto Away;
 	}
 	if (pBusInfo->state.created == 0) {
-		LOGERR("CONTROLVM_DEVICE_CREATE Failed: Invalid bus %lu - not created yet",
-		     busNo);
+		pr_err("CONTROLVM_DEVICE_CREATE Failed: Invalid bus %lu - not created yet\n",
+		       busNo);
 		POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_BUS_INVALID;
@@ -1269,8 +1268,8 @@ my_device_create(struct controlvm_message *inmsg)
 	}
 	pDevInfo = kzalloc(sizeof(struct visorchipset_device_info), GFP_KERNEL);
 	if (pDevInfo == NULL) {
-		LOGERR("CONTROLVM_DEVICE_CREATE Failed: busNo=%lu, devNo=%lu kmaloc failed",
-		     busNo, devNo);
+		pr_err("CONTROLVM_DEVICE_CREATE Failed: busNo=%lu, devNo=%lu kmaloc failed\n",
+		       busNo, devNo);
 		POSTCODE_LINUX_4(DEVICE_CREATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_KMALLOC_FAILED;
@@ -1323,16 +1322,16 @@ my_device_changestate(struct controlvm_message *inmsg)
 
 	pDevInfo = finddevice(&DevInfoList, busNo, devNo);
 	if (!pDevInfo) {
-		LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: busNo=%lu, devNo=%lu invalid (doesn't exist)",
-		     busNo, devNo);
+		pr_err("CONTROLVM_DEVICE_CHANGESTATE Failed: busNo=%lu, devNo=%lu invalid (doesn't exist)\n",
+		       busNo, devNo);
 		POSTCODE_LINUX_4(DEVICE_CHANGESTATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 		goto Away;
 	}
 	if (pDevInfo->state.created == 0) {
-		LOGERR("CONTROLVM_DEVICE_CHANGESTATE Failed: busNo=%lu, devNo=%lu invalid (not created)",
-		     busNo, devNo);
+		pr_err("CONTROLVM_DEVICE_CHANGESTATE Failed: busNo=%lu, devNo=%lu invalid (not created)\n",
+		       busNo, devNo);
 		POSTCODE_LINUX_4(DEVICE_CHANGESTATE_FAILURE_PC, devNo, busNo,
 				 POSTCODE_SEVERITY_ERR);
 		rc = -CONTROLVM_RESP_ERROR_DEVICE_INVALID;
@@ -1357,14 +1356,14 @@ my_device_destroy(struct controlvm_message *inmsg)
 
 	pDevInfo = finddevice(&DevInfoList, busNo, devNo);
 	if (!pDevInfo) {
-		LOGERR("CONTROLVM_DEVICE_DESTROY Failed: busNo=%lu, devNo=%lu invalid",
-		     busNo, devNo);
+		pr_err("CONTROLVM_DEVICE_DESTROY Failed: busNo=%lu, devNo=%lu invalid\n",
+		       busNo, devNo);
 		rc = -CONTROLVM_RESP_ERROR_DEVICE_INVALID;
 		goto Away;
 	}
 	if (pDevInfo->state.created == 0) {
-		LOGERR("CONTROLVM_DEVICE_DESTROY Failed: busNo=%lu, devNo=%lu already destroyed",
-		     busNo, devNo);
+		pr_err("CONTROLVM_DEVICE_DESTROY Failed: busNo=%lu, devNo=%lu already destroyed\n",
+		       busNo, devNo);
 		rc = -CONTROLVM_RESP_ERROR_ALREADY_DONE;
 	}
 
@@ -1391,22 +1390,22 @@ initialize_controlvm_payload_info(HOSTADDRESS phys_addr, u64 offset, u32 bytes,
 	int rc = CONTROLVM_RESP_SUCCESS;
 
 	if (info == NULL) {
-		LOGERR("HUH ? CONTROLVM_PAYLOAD_INIT Failed : Programmer check at %s:%d",
-		     __FILE__, __LINE__);
+		pr_err("HUH ? CONTROLVM_PAYLOAD_INIT Failed : Programmer check at %s:%d\n",
+		       __FILE__, __LINE__);
 		rc = -CONTROLVM_RESP_ERROR_PAYLOAD_INVALID;
 		goto Away;
 	}
 	memset(info, 0, sizeof(CONTROLVM_PAYLOAD_INFO));
 	if ((offset == 0) || (bytes == 0)) {
-		LOGERR("CONTROLVM_PAYLOAD_INIT Failed: request_payload_offset=%llu request_payload_bytes=%llu!",
-		     (u64) offset, (u64) bytes);
+		pr_err("CONTROLVM_PAYLOAD_INIT Failed: request_payload_offset=%llu request_payload_bytes=%llu!\n",
+		       (u64)offset, (u64)bytes);
 		rc = -CONTROLVM_RESP_ERROR_PAYLOAD_INVALID;
 		goto Away;
 	}
 	payload = ioremap_cache(phys_addr + offset, bytes);
 	if (payload == NULL) {
-		LOGERR("CONTROLVM_PAYLOAD_INIT Failed: ioremap_cache %llu for %llu bytes failed",
-		     (u64) offset, (u64) bytes);
+		pr_err("CONTROLVM_PAYLOAD_INIT Failed: ioremap_cache %llu for %llu bytes failed\n",
+		       (u64)offset, (u64)bytes);
 		rc = -CONTROLVM_RESP_ERROR_IOREMAP_FAILED;
 		goto Away;
 	}
@@ -1448,7 +1447,7 @@ initialize_controlvm_payload(void)
 			      offsetof(struct spar_controlvm_channel_protocol,
 				       request_payload_offset),
 			      &payloadOffset, sizeof(payloadOffset)) < 0) {
-		LOGERR("CONTROLVM_PAYLOAD_INIT Failed to read controlvm channel!");
+		pr_err("CONTROLVM_PAYLOAD_INIT Failed to read controlvm channel!\n");
 		POSTCODE_LINUX_2(CONTROLVM_INIT_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -1457,7 +1456,7 @@ initialize_controlvm_payload(void)
 			      offsetof(struct spar_controlvm_channel_protocol,
 				       request_payload_bytes),
 			      &payloadBytes, sizeof(payloadBytes)) < 0) {
-		LOGERR("CONTROLVM_PAYLOAD_INIT Failed to read controlvm channel!");
+		pr_err("CONTROLVM_PAYLOAD_INIT Failed to read controlvm channel!\n");
 		POSTCODE_LINUX_2(CONTROLVM_INIT_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -1552,7 +1551,7 @@ read_controlvm_event(struct controlvm_message *msg)
 				      CONTROLVM_QUEUE_EVENT, msg)) {
 		/* got a message */
 		if (msg->hdr.flags.test_message == 1) {
-			LOGERR("ignoring bad CONTROLVM_QUEUE_EVENT msg with controlvm_msg_id=0x%x because Flags.testMessage is nonsensical (=1)",
+			pr_err("ignoring bad CONTROLVM_QUEUE_EVENT msg with controlvm_msg_id=0x%x because Flags.testMessage is nonsensical (=1)\n",
 			       msg->hdr.id);
 			return FALSE;
 		}
@@ -1740,7 +1739,7 @@ parahotplug_process_message(struct controlvm_message *inmsg)
 	req = parahotplug_request_create(inmsg);
 
 	if (req == NULL) {
-		LOGERR("parahotplug_process_message: couldn't allocate request");
+		pr_err("parahotplug_process_message: couldn't allocate request\n");
 		return;
 	}
 
@@ -1797,7 +1796,7 @@ handle_command(struct controlvm_message inmsg, HOSTADDRESS channel_addr)
 	/* create parsing context if necessary */
 	isLocalAddr = (inmsg.hdr.flags.test_message == 1);
 	if (channel_addr == 0) {
-		LOGERR("HUH? channel_addr is 0!");
+		pr_err("HUH? channel_addr is 0!\n");
 		return TRUE;
 	}
 	parametersAddr = channel_addr + inmsg.hdr.payload_vm_offset;
@@ -1909,7 +1908,7 @@ handle_command(struct controlvm_message inmsg, HOSTADDRESS channel_addr)
 		chipset_notready(&inmsg.hdr);
 		break;
 	default:
-		LOGERR("unrecognized controlvm cmd=%d", (int) inmsg.hdr.id);
+		pr_err("unrecognized controlvm cmd=%d\n", (int)inmsg.hdr.id);
 		if (inmsg.hdr.flags.response_expected)
 			controlvm_respond(&inmsg.hdr,
 					  -CONTROLVM_RESP_ERROR_MESSAGE_ID_UNKNOWN);
@@ -1978,10 +1977,10 @@ controlvm_periodic_work(struct work_struct *work)
 					 CONTROLVM_QUEUE_RESPONSE,
 					 &inmsg)) {
 		if (inmsg.hdr.payload_max_bytes != 0) {
-			LOGERR("Payload of size %lu returned @%lu with unexpected message id %d.",
-			     (ulong) inmsg.hdr.payload_max_bytes,
-			     (ulong) inmsg.hdr.payload_vm_offset,
-			     inmsg.hdr.id);
+			pr_err("Payload of size %lu returned @%lu with unexpected message id %d\n",
+			       (ulong)inmsg.hdr.payload_max_bytes,
+			       (ulong)inmsg.hdr.payload_vm_offset,
+			       inmsg.hdr.id);
 		}
 	}
 	if (!gotACommand) {
@@ -2077,14 +2076,14 @@ setup_crash_devices_work_queue(struct work_struct *work)
 			      offsetof(struct spar_controlvm_channel_protocol,
 				       saved_crash_message_count),
 			      &localSavedCrashMsgCount, sizeof(u16)) < 0) {
-		LOGERR("failed to get Saved Message Count");
+		pr_err("failed to get Saved Message Count\n");
 		POSTCODE_LINUX_2(CRASH_DEV_CTRL_RD_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
 	}
 
 	if (localSavedCrashMsgCount != CONTROLVM_CRASHMSG_MAX) {
-		LOGERR("Saved Message Count incorrect %d",
+		pr_err("Saved Message Count incorrect %d\n",
 		       localSavedCrashMsgCount);
 		POSTCODE_LINUX_3(CRASH_DEV_COUNT_FAILURE_PC,
 				 localSavedCrashMsgCount,
@@ -2097,7 +2096,7 @@ setup_crash_devices_work_queue(struct work_struct *work)
 			      offsetof(struct spar_controlvm_channel_protocol,
 				       saved_crash_message_offset),
 			      &localSavedCrashMsgOffset, sizeof(u32)) < 0) {
-		LOGERR("failed to get Saved Message Offset");
+		pr_err("failed to get Saved Message Offset\n");
 		POSTCODE_LINUX_2(CRASH_DEV_CTRL_RD_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -2108,7 +2107,7 @@ setup_crash_devices_work_queue(struct work_struct *work)
 			      localSavedCrashMsgOffset,
 			      &localCrashCreateBusMsg,
 			      sizeof(struct controlvm_message)) < 0) {
-		LOGERR("CRASH_DEV_RD_BUS_FAIULRE: Failed to read CrashCreateBusMsg!");
+		pr_err("CRASH_DEV_RD_BUS_FAIULRE: Failed to read CrashCreateBusMsg!\n");
 		POSTCODE_LINUX_2(CRASH_DEV_RD_BUS_FAIULRE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -2120,7 +2119,7 @@ setup_crash_devices_work_queue(struct work_struct *work)
 			      sizeof(struct controlvm_message),
 			      &localCrashCreateDevMsg,
 			      sizeof(struct controlvm_message)) < 0) {
-		LOGERR("CRASH_DEV_RD_DEV_FAIULRE: Failed to read CrashCreateDevMsg!");
+		pr_err("CRASH_DEV_RD_DEV_FAIULRE: Failed to read CrashCreateDevMsg!\n");
 		POSTCODE_LINUX_2(CRASH_DEV_RD_DEV_FAIULRE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -2130,7 +2129,7 @@ setup_crash_devices_work_queue(struct work_struct *work)
 	if (localCrashCreateBusMsg.cmd.create_bus.channel_addr != 0)
 		bus_create(&localCrashCreateBusMsg);
 	else {
-		LOGERR("CrashCreateBusMsg is null, no dump will be taken");
+		pr_err("CrashCreateBusMsg is null, no dump will be taken\n");
 		POSTCODE_LINUX_2(CRASH_DEV_BUS_NULL_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -2140,7 +2139,7 @@ setup_crash_devices_work_queue(struct work_struct *work)
 	if (localCrashCreateDevMsg.cmd.create_device.channel_addr != 0)
 		my_device_create(&localCrashCreateDevMsg);
 	else {
-		LOGERR("CrashCreateDevMsg is null, no dump will be taken");
+		pr_err("CrashCreateDevMsg is null, no dump will be taken\n");
 		POSTCODE_LINUX_2(CRASH_DEV_DEV_NULL_FAILURE_PC,
 				 POSTCODE_SEVERITY_ERR);
 		return;
@@ -2205,7 +2204,7 @@ visorchipset_get_bus_info(ulong bus_no, struct visorchipset_bus_info *bus_info)
 	void *p = findbus(&BusInfoList, bus_no);
 
 	if (!p) {
-		LOGERR("(%lu) failed", bus_no);
+		pr_err("(%lu) failed\n", bus_no);
 		return FALSE;
 	}
 	memcpy(bus_info, p, sizeof(struct visorchipset_bus_info));
@@ -2219,7 +2218,7 @@ visorchipset_set_bus_context(ulong bus_no, void *context)
 	struct visorchipset_bus_info *p = findbus(&BusInfoList, bus_no);
 
 	if (!p) {
-		LOGERR("(%lu) failed", bus_no);
+		pr_err("(%lu) failed\n", bus_no);
 		return FALSE;
 	}
 	p->bus_driver_context = context;
@@ -2234,7 +2233,7 @@ visorchipset_get_device_info(ulong bus_no, ulong dev_no,
 	void *p = finddevice(&DevInfoList, bus_no, dev_no);
 
 	if (!p) {
-		LOGERR("(%lu,%lu) failed", bus_no, dev_no);
+		pr_err("(%lu,%lu) failed\n", bus_no, dev_no);
 		return FALSE;
 	}
 	memcpy(dev_info, p, sizeof(struct visorchipset_device_info));
@@ -2249,7 +2248,7 @@ visorchipset_set_device_context(ulong bus_no, ulong dev_no, void *context)
 			finddevice(&DevInfoList, bus_no, dev_no);
 
 	if (!p) {
-		LOGERR("(%lu,%lu) failed", bus_no, dev_no);
+		pr_err("(%lu,%lu) failed\n", bus_no, dev_no);
 		return FALSE;
 	}
 	p->bus_driver_context = context;
@@ -2280,7 +2279,7 @@ visorchipset_cache_alloc(struct kmem_cache *pool, BOOL ok_to_block,
 	gfp |= __GFP_NORETRY;
 	p = kmem_cache_alloc(pool, gfp);
 	if (!p) {
-		LOGERR("kmem_cache_alloc failed early @%s:%d\n", fn, ln);
+		pr_err("kmem_cache_alloc failed early @%s:%d\n", fn, ln);
 		return NULL;
 	}
 	atomic_inc(&Visorchipset_cache_buffers_in_use);
@@ -2293,7 +2292,7 @@ void
 visorchipset_cache_free(struct kmem_cache *pool, void *p, char *fn, int ln)
 {
 	if (!p) {
-		LOGERR("NULL pointer @%s:%d\n", fn, ln);
+		pr_err("NULL pointer @%s:%d\n", fn, ln);
 		return;
 	}
 	atomic_dec(&Visorchipset_cache_buffers_in_use);
@@ -2400,13 +2399,13 @@ visorchipset_init(void)
 			       visorchannel_id(ControlVm_channel, s));
 			initialize_controlvm_payload();
 		} else {
-			LOGERR("controlvm channel is invalid");
+			pr_err("controlvm channel is invalid\n");
 			visorchannel_destroy(ControlVm_channel);
 			ControlVm_channel = NULL;
 			return -ENODEV;
 		}
 	} else {
-		LOGERR("no controlvm channel discovered");
+		pr_err("no controlvm channel discovered\n");
 		return -ENODEV;
 	}
 
@@ -2480,7 +2479,7 @@ visorchipset_init(void)
 	rc = 0;
 Away:
 	if (rc) {
-		LOGERR("visorchipset_init failed");
+		pr_err("visorchipset_init failed\n");
 		POSTCODE_LINUX_3(CHIPSET_INIT_FAILURE_PC, rc,
 				 POSTCODE_SEVERITY_ERR);
 	}


