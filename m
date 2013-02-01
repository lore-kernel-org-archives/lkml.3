Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422867Ab3BAKxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:53:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:39601 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422873Ab3BAKwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:52:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 33/33] target: fix regression with dev_link_magic in target_fabric_port_link
Date: Fri,  1 Feb 2013 11:49:38 +0100
Message-Id: <20130201104727.000499554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

This is to fix a regression that only affect the stable (not for the mainline)
that the stable commit fdf9d86 was incorrectly placed dev->dev_link_magic check
before the *dev assignment in target_fabric_port_link() due to fuzzy automatically
context adjustment during the back-porting.

Reported-by: Chris Boot <bootc@bootc.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_fabric_configfs.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -752,12 +752,6 @@ static int target_fabric_port_link(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	if (dev->dev_link_magic != SE_DEV_LINK_MAGIC) {
-		pr_err("Bad dev->dev_link_magic, not a valid se_dev_ci pointer:"
-			" %p to struct se_device: %p\n", se_dev_ci, dev);
-		return -EFAULT;
-	}
-
 	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
 	se_tpg = container_of(to_config_group(tpg_ci),
 				struct se_portal_group, tpg_group);
@@ -775,6 +769,11 @@ static int target_fabric_port_link(
 		ret = -ENODEV;
 		goto out;
 	}
+	if (dev->dev_link_magic != SE_DEV_LINK_MAGIC) {
+		pr_err("Bad dev->dev_link_magic, not a valid se_dev_ci pointer:"
+			" %p to struct se_device: %p\n", se_dev_ci, dev);
+		return -EFAULT;
+	}
 
 	lun_p = core_dev_add_lun(se_tpg, dev->se_hba, dev,
 				lun->unpacked_lun);


