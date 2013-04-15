Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3DOCZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:25:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3DOCZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:25:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Pawel Baldysiak <pawel.baldysiak@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 06/17] SCSI: libsas: fix handling vacant phy in sas_set_ex_phy()
Date: Sun, 14 Apr 2013 19:25:16 -0700
Message-Id: <20130415022353.096059849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415022352.616689034@linuxfoundation.org>
References: <20130415022352.616689034@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Dorau <lukasz.dorau@intel.com>

commit d4a2618fa77b5e58ec15342972bd3505a1c3f551 upstream.

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
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libsas/sas_expander.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -235,6 +235,17 @@ static void sas_set_ex_phy(struct domain
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
@@ -272,6 +283,7 @@ static void sas_set_ex_phy(struct domain
 	phy->phy->maximum_linkrate = dr->pmax_linkrate;
 	phy->phy->negotiated_linkrate = phy->linkrate;
 
+ skip:
 	if (new_phy)
 		if (sas_phy_add(phy->phy)) {
 			sas_phy_free(phy->phy);


