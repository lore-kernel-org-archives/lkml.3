Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbbAVP6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:58:04 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:50716 "EHLO
	19.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbbAVP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:58:00 -0500
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 10:58:00 EST
From: clement.perrochaud@effinnov.com
To: linux-nfc@ml01.01.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= <clement.perrochaud@nxp.com>,
        sunil.jogi@nxp.com, jerome.pele@nxp.com,
        Charles.Gorand-Effinnov@nxp.com, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        davem@davemloft.net, grant.likely@linaro.org, lefrique@marvell.com,
        christophe.ricard@gmail.com, cuissard@marvell.com, bzhao@marvell.com,
        hirent@marvell.com, akarwar@marvell.com,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?= 
	<clement.perrochaud@effinnov.com>
Subject: [PATCH 4/4] NFC: nxp-nci: Allow module removal during download
Date: Thu, 22 Jan 2015 16:27:40 +0100
Message-Id: <1421940460-14049-5-git-send-email-clement.perrochaud@effinnov.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
References: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 1854357146893871917
X-Ovh-Remote: 109.190.171.176 (176-171-190-109.dsl.ovh.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clément Perrochaud <clement.perrochaud@nxp.com>

Signed-off-by: Clément Perrochaud <clement.perrochaud@nxp.com>
Signed-off-by: Clément Perrochaud <clement.perrochaud@effinnov.com>
---
 drivers/nfc/nxp-nci/core.c     | 7 +++----
 drivers/nfc/nxp-nci/firmware.c | 9 ++++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index d3643ef..c15606d 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -165,12 +165,11 @@ void nxp_nci_remove(struct nci_dev *ndev)
 {
 	struct nxp_nci_info *info = nci_get_drvdata(ndev);
 
-	mutex_lock(&info->info_lock);
-
-	cancel_work_sync(&info->fw_info.work);
-
 	if (info->mode == NXP_NCI_MODE_FW)
 		nxp_nci_fw_work_complete(info, -ESHUTDOWN);
+	cancel_work_sync(&info->fw_info.work);
+
+	mutex_lock(&info->info_lock);
 
 	if (info->phy_ops->disable)
 		info->phy_ops->disable(info->phy_id);
diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
index 1814e9f..de136e1 100644
--- a/drivers/nfc/nxp-nci/firmware.c
+++ b/drivers/nfc/nxp-nci/firmware.c
@@ -166,7 +166,8 @@ static int nxp_nci_fw_send(struct nxp_nci_info *info)
 
 	if (*fw_info->data == NXP_NCI_FW_CMD_RESET) {
 		fw_info->cmd_result = 0;
-		schedule_work(&fw_info->work);
+		if (fw_info->fw)
+			schedule_work(&fw_info->work);
 	} else {
 		completion_rc = wait_for_completion_interruptible_timeout(
 			&fw_info->cmd_completion, NXP_NCI_FW_ANSWER_TIMEOUT);
@@ -244,7 +245,8 @@ int nxp_nci_fw_download(struct nci_dev *ndev, const char *firmware_name)
 	fw_info->frame_size = 0;
 	fw_info->cmd_result = 0;
 
-	schedule_work(&fw_info->work);
+	if (fw_info->fw)
+		schedule_work(&fw_info->work);
 
 fw_download_exit:
 	mutex_unlock(&info->info_lock);
@@ -316,6 +318,7 @@ void nxp_nci_fw_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
 		fw_info->cmd_result = -EIO;
 	}
 
-	schedule_work(&fw_info->work);
+	if (fw_info->fw)
+		schedule_work(&fw_info->work);
 }
 EXPORT_SYMBOL(nxp_nci_fw_recv_frame);
-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com

