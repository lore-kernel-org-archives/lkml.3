Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaJ0TDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJ0TDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris J Arges <chris.j.arges@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 048/105] mptfusion: enable no_write_same for vmware scsi disks
Date: Mon, 27 Oct 2014 11:56:23 -0700
Message-Id: <1414436240-13879-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris J Arges <chris.j.arges@canonical.com>

commit 4089b71cc820a426d601283c92fcd4ffeb5139c2 upstream.

When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
data can be improperly zeroed out using the mptfusion driver. This patch
disables write_same for this driver and the vmware subsystem_vendor which
ensures that manual zeroing out is used instead.

BugLink: http://bugs.launchpad.net/bugs/1371591
Reported-by: Bruce Lucas <bruce.lucas@mongodb.com>
Tested-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/message/fusion/mptspi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 5653e50..424f51d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1422,6 +1422,11 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_mptspi_probe;
         }
 
+	/* VMWare emulation doesn't properly implement WRITE_SAME
+	 */
+	if (pdev->subsystem_vendor == 0x15AD)
+		sh->no_write_same = 1;
+
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
-- 
1.9.1

