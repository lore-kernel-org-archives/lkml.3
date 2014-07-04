Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbaGDWPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:15:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956AbaGDWP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Herbszt <herbszt@gmx.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 01/66] target: Fix left-over se_lun->lun_sep pointer OOPs
Date: Fri,  4 Jul 2014 15:14:00 -0700
Message-Id: <20140704221422.885631078@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -616,6 +616,7 @@ void core_dev_unexport(
 	dev->export_count--;
 	spin_unlock(&hba->device_lock);
 
+	lun->lun_sep = NULL;
 	lun->lun_se_dev = NULL;
 }
 


