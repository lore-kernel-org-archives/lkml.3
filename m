Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaEDFxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 01:53:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50151 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbaEDFxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 01:53:09 -0400
Message-ID: <1399182786.2505.42.camel@dabdike.int.hansenpartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.15-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 03 May 2014 22:53:06 -0700
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is two patches both fixing bugs in drivers (virtio-scsi and
mpt2sas) causing an oops in certain circumstances.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Fam Zheng (1):
      virtio-scsi: Skip setting affinity on uninitialized vq

Tyler Stachecki (1):
      mpt2sas: Don't disable device twice at suspend.

And diffstat:

 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 1 -
 drivers/scsi/virtio_scsi.c           | 6 +++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

With full diff below.

James

---

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
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16bfd50..db3b494 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -750,8 +750,12 @@ static void __virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
 
 		vscsi->affinity_hint_set = true;
 	} else {
-		for (i = 0; i < vscsi->num_queues; i++)
+		for (i = 0; i < vscsi->num_queues; i++) {
+			if (!vscsi->req_vqs[i].vq)
+				continue;
+
 			virtqueue_set_affinity(vscsi->req_vqs[i].vq, -1);
+		}
 
 		vscsi->affinity_hint_set = false;
 	}


