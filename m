Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779AbaEKTy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:54:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbaEKTWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:22:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyler Stachecki <tstache1@binghamton.edu>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 13/48] [SCSI] mpt2sas: Dont disable device twice at suspend.
Date: Sun, 11 May 2014 21:19:47 +0200
Message-Id: <20140511191949.936377344@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8174,7 +8174,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_
 
 	mpt2sas_base_free_resources(ioc);
 	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
 	return 0;
 }


