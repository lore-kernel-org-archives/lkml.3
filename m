Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaFGB1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36155 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tyler Stachecki" <tstache1@binghamton.edu>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.785157814@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 38/92] [SCSI] mpt2sas: Don't disable device twice at
 suspend.
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8166,7 +8166,6 @@ _scsih_suspend(struct pci_dev *pdev, pm_
 
 	mpt2sas_base_free_resources(ioc);
 	pci_save_state(pdev);
-	pci_disable_device(pdev);
 	pci_set_power_state(pdev, device_state);
 	return 0;
 }

