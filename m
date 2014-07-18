Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422685AbaGRNfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:35:07 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030782AbaGRNOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:22 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/170] target: Fix left-over se_lun->lun_sep pointer OOPs
Date: Fri, 18 Jul 2014 14:10:13 +0200
Message-Id: <659489c914e8f1c88a453f8b91134dab58cdf8b6.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 83ff42fcce070801a3aa1cd6a3269d7426271a8d upstream.

This patch fixes a left-over se_lun->lun_sep pointer OOPs when one
of the /sys/kernel/config/target/$FABRIC/$WWPN/$TPGT/lun/$LUN/alua*
attributes is accessed after the $DEVICE symlink has been removed.

To address this bug, go ahead and clear se_lun->lun_sep memory in
core_dev_unexport(), so that the existing checks for show/store
ALUA attributes in target_core_fabric_configfs.c work as expected.

Reported-by: Sebastian Herbszt <herbszt@gmx.de>
Tested-by: Sebastian Herbszt <herbszt@gmx.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/target_core_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e31ec5cf0c36..c7a3c5e2b1b3 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -617,6 +617,7 @@ void core_dev_unexport(
 	dev->export_count--;
 	spin_unlock(&hba->device_lock);
 
+	lun->lun_sep = NULL;
 	lun->lun_se_dev = NULL;
 }
 
-- 
2.0.0

