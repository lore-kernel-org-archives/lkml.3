Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab3GXOJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:09:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45769 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab3GXOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:07:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sreekanth Reddy" <Sreekanth.Reddy@lsi.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.385619676@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [36/85] [SCSI] mpt2sas: Fix for device scan following host reset
 could get stuck in a infinite loop
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

commit 6241f22ca12a26ee149cbe31b27bac97dbdc8bc4 upstream.

Modified device scan routine so each configuration page read breaks from the
while loop when the ioc_status is not equal to MPI2_IOCSTATUS_SUCCESS.

[jejb: checkpatch fixes]
Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2; adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 122 +++++++++++++++++++++++++++++++++--
 1 file changed, 117 insertions(+), 5 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7010,11 +7010,14 @@ _scsih_scan_for_devices_after_reset(stru
 	struct _sas_device *sas_device;
 	struct _sas_node *expander_device;
 	static struct _raid_device *raid_device;
+	u8 retry_count;
 
 	printk(MPT2SAS_INFO_FMT "scan devices: start\n", ioc->name);
 
 	_scsih_sas_host_refresh(ioc);
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: expanders start\n",
+		ioc->name);
 	/* expanders */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_expander_pg0(ioc, &mpi_reply, &expander_pg0,
@@ -7023,19 +7026,39 @@ _scsih_scan_for_devices_after_reset(stru
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from expander scan: "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		handle = le16_to_cpu(expander_pg0.DevHandle);
 		expander_device = mpt2sas_scsih_expander_find_by_sas_address(
 		    ioc, le64_to_cpu(expander_pg0.SASAddress));
 		if (expander_device)
 			_scsih_refresh_expander_links(ioc, expander_device,
 			    handle);
-		else
+		else {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding expander: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(expander_pg0.SASAddress));
 			_scsih_expander_add(ioc, handle);
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding expander: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(expander_pg0.SASAddress));
+		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: expanders complete\n",
+		ioc->name);
+
 	if (!ioc->ir_firmware)
 		goto skip_to_sas;
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices phys disk start\n", ioc->name);
 	/* phys disk */
 	phys_disk_num = 0xFF;
 	while (!(mpt2sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
@@ -7045,6 +7068,13 @@ _scsih_scan_for_devices_after_reset(stru
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan:"
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		phys_disk_num = pd_pg0.PhysDiskNum;
 		handle = le16_to_cpu(pd_pg0.DevHandle);
 		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
@@ -7054,17 +7084,46 @@ _scsih_scan_for_devices_after_reset(stru
 		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
 		    handle) != 0)
 			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from phys disk scan "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle,
 		    &sas_address)) {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding phys disk: "
+				" handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt2sas_transport_update_links(ioc, sas_address,
 			    handle, sas_device_pg0.PhyNum,
 			    MPI2_SAS_NEG_LINK_RATE_1_5);
 			set_bit(handle, ioc->pd_handles);
-			_scsih_add_device(ioc, handle, 0, 1);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			* _scsih_add_device() will decide on retries and
+			* return "1" when it should be retried
+			*/
+			while (_scsih_add_device(ioc, handle, retry_count++,
+				1)) {
+					ssleep(1);
+			}
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding phys disk: "
+				" handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: phys disk complete\n",
+		ioc->name);
+
+	printk(MPT2SAS_INFO_FMT "\tscan devices: volumes start\n", ioc->name);
 	/* volumes */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
@@ -7073,6 +7132,13 @@ _scsih_scan_for_devices_after_reset(stru
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 		raid_device = _scsih_raid_device_find_by_wwid(ioc,
 		    le64_to_cpu(volume_pg1.WWID));
@@ -7082,18 +7148,38 @@ _scsih_scan_for_devices_after_reset(stru
 		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
 		     sizeof(Mpi2RaidVolPage0_t)))
 			continue;
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			MPI2_IOCSTATUS_MASK;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from volume scan: "
+				"ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+			break;
+		}
 		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
 		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
 		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED) {
 			memset(&element, 0, sizeof(Mpi2EventIrConfigElement_t));
 			element.ReasonCode = MPI2_EVENT_IR_CHANGE_RC_ADDED;
 			element.VolDevHandle = volume_pg1.DevHandle;
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding volume: "
+				" handle (0x%04x)\n", ioc->name,
+				volume_pg1.DevHandle);
 			_scsih_sas_volume_add(ioc, &element);
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding volume: "
+				" handle (0x%04x)\n", ioc->name,
+				volume_pg1.DevHandle);
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: volumes complete\n",
+		ioc->name);
+
  skip_to_sas:
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: end devices start\n",
+		ioc->name);
 	/* sas devices */
 	handle = 0xFFFF;
 	while (!(mpt2sas_config_get_sas_device_pg0(ioc, &mpi_reply,
@@ -7103,6 +7189,13 @@ _scsih_scan_for_devices_after_reset(stru
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 			break;
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+			printk(MPT2SAS_INFO_FMT "\tbreak from end device scan:"
+				" ioc_status(0x%04x), loginfo(0x%08x)\n",
+				ioc->name, ioc_status,
+				le32_to_cpu(mpi_reply.IOCLogInfo));
+				break;
+		}
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		if (!(_scsih_is_end_device(
 		    le32_to_cpu(sas_device_pg0.DeviceInfo))))
@@ -7113,12 +7206,31 @@ _scsih_scan_for_devices_after_reset(stru
 			continue;
 		parent_handle = le16_to_cpu(sas_device_pg0.ParentDevHandle);
 		if (!_scsih_get_sas_address(ioc, parent_handle, &sas_address)) {
+			printk(MPT2SAS_INFO_FMT "\tBEFORE adding end device: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 			mpt2sas_transport_update_links(ioc, sas_address, handle,
 			    sas_device_pg0.PhyNum, MPI2_SAS_NEG_LINK_RATE_1_5);
-			_scsih_add_device(ioc, handle, 0, 0);
+			retry_count = 0;
+			/* This will retry adding the end device.
+			 * _scsih_add_device() will decide on retries and
+			 * return "1" when it should be retried
+			 */
+			while (_scsih_add_device(ioc, handle, retry_count++,
+				0)) {
+					ssleep(1);
+			}
+			printk(MPT2SAS_INFO_FMT "\tAFTER adding end device: "
+				"handle (0x%04x), sas_addr(0x%016llx)\n",
+				ioc->name, handle, (unsigned long long)
+				le64_to_cpu(sas_device_pg0.SASAddress));
 		}
 	}
 
+	printk(MPT2SAS_INFO_FMT "\tscan devices: end devices complete\n",
+		ioc->name);
+
 	printk(MPT2SAS_INFO_FMT "scan devices: complete\n", ioc->name);
 }
 

