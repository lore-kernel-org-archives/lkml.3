Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab3EGEBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:01:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760371Ab3EGD65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:57 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yRoliiL3yrMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Vv6b29dir0QA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=_3C0vh1XLSoJzJ2Uw7AA:9 a=dGJ0OcVc7YAA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035848.784436254@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lukasz Dorau <lukasz.dorau@intel.com>,
        Pawel Baldysiak <pawel.baldysiak@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [047/126] libsas: fix handling vacant phy in sas_set_ex_phy()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0047-libsas-fix-handling-vacant-phy-in-sas_set_ex_phy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Lukasz Dorau <lukasz.dorau@intel.com>

[ Upstream commit d4a2618fa77b5e58ec15342972bd3505a1c3f551 ]

If a result of the SMP discover function is PHY VACANT,
the content of discover response structure (dr) is not valid.
It sometimes happens that dr->attached_sas_addr can contain
even SAS address of other phy. In such case an invalid phy
is created, what causes NULL pointer dereference during
destruction of expander's phys.

So if a result of SMP function is PHY VACANT, the content of discover
response structure (dr) must not be copied to phy structure.

This patch fixes the following bug:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff811c9002>] sysfs_find_dirent+0x12/0x90
Call Trace:
  [<ffffffff811c95f5>] sysfs_get_dirent+0x35/0x80
  [<ffffffff811cb55e>] sysfs_unmerge_group+0x1e/0xb0
  [<ffffffff813329f4>] dpm_sysfs_remove+0x24/0x90
  [<ffffffff8132b0f4>] device_del+0x44/0x1d0
  [<ffffffffa016fc59>] sas_rphy_delete+0x9/0x20 [scsi_transport_sas]
  [<ffffffffa01a16f6>] sas_destruct_devices+0xe6/0x110 [libsas]
  [<ffffffff8107ac7c>] process_one_work+0x16c/0x350
  [<ffffffff8107d84a>] worker_thread+0x17a/0x410
  [<ffffffff81081b76>] kthread+0x96/0xa0
  [<ffffffff81464944>] kernel_thread_helper+0x4/0x10

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/libsas/sas_expander.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index efc6e72..fbb8048 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -235,6 +235,17 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	linkrate  = phy->linkrate;
 	memcpy(sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 
+	/* Handle vacant phy - rest of dr data is not valid so skip it */
+	if (phy->phy_state == PHY_VACANT) {
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+		phy->attached_dev_type = NO_DEVICE;
+		if (!test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
+			phy->phy_id = phy_id;
+			goto skip;
+		} else
+			goto out;
+	}
+
 	phy->attached_dev_type = to_dev_type(dr);
 	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
 		goto out;
@@ -272,6 +283,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->phy->maximum_linkrate = dr->pmax_linkrate;
 	phy->phy->negotiated_linkrate = phy->linkrate;
 
+ skip:
 	if (new_phy)
 		if (sas_phy_add(phy->phy)) {
 			sas_phy_free(phy->phy);
-- 
1.7.10.4


