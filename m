Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaGHTmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:42:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54089 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755677AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Sebastian Herbszt" <herbszt@gmx.de>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.383976994@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 103/125] target: Fix left-over se_lun->lun_sep pointer
 OOPs
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_device.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -646,6 +646,7 @@ void core_dev_unexport(
 	spin_unlock(&dev->se_port_lock);
 
 	se_dev_stop(dev);
+	lun->lun_sep = NULL;
 	lun->lun_se_dev = NULL;
 }
 

