Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbaJ1H7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:59:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaJ1DhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bruce Lucas <bruce.lucas@mongodb.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.17 034/146] mptfusion: enable no_write_same for vmware scsi disks
Date: Tue, 28 Oct 2014 11:32:56 +0800
Message-Id: <20141028033344.908922703@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/message/fusion/mptspi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1419,6 +1419,11 @@ mptspi_probe(struct pci_dev *pdev, const
 		goto out_mptspi_probe;
         }
 
+	/* VMWare emulation doesn't properly implement WRITE_SAME
+	 */
+	if (pdev->subsystem_vendor == 0x15AD)
+		sh->no_write_same = 1;
+
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure


