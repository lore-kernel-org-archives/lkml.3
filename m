Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbaFJURA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:17:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbaFJTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Stachecki <tstache1@binghamton.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 115/160] [SCSI] mpt2sas: Don't disable device twice at suspend.
Date: Tue, 10 Jun 2014 12:45:55 -0700
Message-Id: <1402429600-20477-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Stachecki <tstache1@binghamton.edu>

commit af61e27c3f77c7623b5335590ae24b6a5c323e22 upstream.

On suspend, _scsih_suspend calls mpt2sas_base_free_resources, which
in turn calls pci_disable_device if the device is enabled prior to
suspending. However, _scsih_suspend also calls pci_disable_device
itself.

Thus, in the event that the device is enabled prior to suspending,
pci_disable_device will be called twice. This patch removes the
duplicate call to pci_disable_device in _scsi_suspend as it is both
unnecessary and results in a kernel oops.

Signed-off-by: Tyler Stachecki <tstache1@binghamton.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7f0af4f..6fd7d40 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8293,7 +8293,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	mpt2sas_base_free_resources(ioc);
 	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
 	return 0;
 }
-- 
1.9.1

