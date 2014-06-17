Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbaFQQrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:47:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039AbaFQQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Stachecki <tstache1@binghamton.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 099/121] [SCSI] mpt2sas: Don't disable device twice at suspend.
Date: Tue, 17 Jun 2014 09:17:57 -0700
Message-Id: <1403021899-16708-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
index c78216c..5588487 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8286,7 +8286,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	mpt2sas_base_free_resources(ioc);
 	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
 	return 0;
 }
-- 
1.9.1

