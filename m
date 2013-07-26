Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3GZVd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:33:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759906Ab3GZUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 55/79] SCSI: mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned
Date: Fri, 26 Jul 2013 13:47:45 -0700
Message-Id: <20130726204728.404596092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6392,7 +6392,7 @@ _scsih_search_responding_sas_devices(str
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(sas_device_pg0.DevHandle);
 		device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
@@ -6494,7 +6494,7 @@ _scsih_search_responding_raid_devices(st
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 		handle = le16_to_cpu(volume_pg1.DevHandle);
 
@@ -6518,7 +6518,7 @@ _scsih_search_responding_raid_devices(st
 		    phys_disk_num))) {
 			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 			    MPI2_IOCSTATUS_MASK;
-			if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 				break;
 			phys_disk_num = pd_pg0.PhysDiskNum;
 			handle = le16_to_cpu(pd_pg0.DevHandle);
@@ -6597,7 +6597,7 @@ _scsih_search_responding_expanders(struc
 
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
 			break;
 
 		handle = le16_to_cpu(expander_pg0.DevHandle);
@@ -6742,8 +6742,6 @@ _scsih_scan_for_devices_after_reset(stru
 	    MPI2_SAS_EXPAND_PGAD_FORM_GET_NEXT_HNDL, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from expander scan: " \
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6787,8 +6785,6 @@ _scsih_scan_for_devices_after_reset(stru
 	    phys_disk_num))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from phys disk scan: "\
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6854,8 +6850,6 @@ _scsih_scan_for_devices_after_reset(stru
 	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from volume scan: " \
 			    "ioc_status(0x%04x), loginfo(0x%08x)\n",
@@ -6914,8 +6908,6 @@ _scsih_scan_for_devices_after_reset(stru
 	    handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 			pr_info(MPT3SAS_FMT "\tbreak from end device scan:"\
 			    " ioc_status(0x%04x), loginfo(0x%08x)\n",


