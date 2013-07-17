Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab3GQWuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:50:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56273 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab3GQWug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 126/145] [SCSI] mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Wed, 17 Jul 2013 15:47:38 -0700
Message-Id: <1374101277-7915-127-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

commit 14be49ac965ebd3f8561d57e01ddb22f93f9b454 upstream.

Infinite loop can occur if IOCStatus is not equal to
MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value in the while loops in functions
_scsih_search_responding_sas_devices,
_scsih_search_responding_raid_devices and
_scsih_search_responding_expanders

So, Instead of checking for MPI2_IOCSTATUS_CONFIG_INVALID_PAGE value,
in this patch code is modified to check for IOCStatus not equals to
MPI2_IOCSTATUS_SUCCESS to break the while loop.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 34b229a..1d70b08 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6409,7 +6409,7 @@ _scsih_search_responding_sas_devices(struct MPT3SAS_ADAPTER *ioc)
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
@@ -6511,7 +6511,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 
@@ -6535,7 +6535,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 		    phys_disk_num))) {
 			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 			    MPI2_IOCSTATUS_MASK;
-			if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 				break;
 			phys_disk_num = pd_pg0.PhysDiskNum;
 			handle = le16_to_cpu(pd_pg0.DevHandle);
@@ -6614,7 +6614,7 @@ _scsih_search_responding_expanders(struct MPT3SAS_ADAPTER *ioc)
 
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 
 		handle = le16_to_cpu(expander_pg0.DevHandle);
@@ -6759,8 +6759,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from expander scan: " \
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6804,8 +6802,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    phys_disk_num))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan: "\
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6871,8 +6867,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6931,8 +6925,6 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from end device scan:"\
 			    " ioc_status(0x%04x), loginfo(0x%08x)\n",
-- 
1.8.1.2

