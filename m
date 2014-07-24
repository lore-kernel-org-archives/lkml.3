Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbaGXKUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:20:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54739 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaGXJrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/128] target: Fix left-over se_lun->lun_sep pointer OOPs
Date: Thu, 24 Jul 2014 10:44:44 +0100
Message-Id: <1406195177-8656-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/target_core_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2640f2c65329..8a6b0e9f526a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -614,6 +614,7 @@ void core_dev_unexport(
 	dev->export_count--;
 	spin_unlock(&hba->device_lock);
 
+	lun->lun_sep = NULL;
 	lun->lun_se_dev = NULL;
 }
 
-- 
1.9.1

