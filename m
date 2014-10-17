Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaJQXqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 19:46:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33907 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaJQXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 19:46:50 -0400
To: Petr Vandrovec <petr@vmware.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not silently discard WRITE_SAME requests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141011063053.GB18215@petr-dev3.eng.vmware.com>
	<yq1lhomahwt.fsf@sermon.lab.mkp.net> <543A1D1A.8090808@vmware.com>
	<yq1h9z687zd.fsf@sermon.lab.mkp.net> <543E1407.7020509@vmware.com>
Date: Fri, 17 Oct 2014 19:46:38 -0400
In-Reply-To: <543E1407.7020509@vmware.com> (Petr Vandrovec's message of "Tue,
	14 Oct 2014 23:28:23 -0700")
Message-ID: <yq1a94u2ra9.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Petr" == Petr Vandrovec <petr@vmware.com> writes:

Petr> is there any reason to do blacklisting?  Why not let first request
Petr> fail, and switch to non-write-same code path once that happens?

Well, we do. But we try to avoid confusing users with error messages if
we can avoid it. And if we know it's not going to work we might as avoid
trying.


SCSI: Only blacklist WRITE SAME for VMware virtual disks

Commit 4089b71cc820 blacklisted WRITE SAME for all VMware disks.
However, the WRITE SAME commands are supported for passthrough
disks. Change the heuristic so we only blacklist virtual disks.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Petr Vandrovec <petr@vmware.com>


diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 613231c16194..787933d43d32 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1419,11 +1419,6 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_mptspi_probe;
         }
 
-	/* VMWare emulation doesn't properly implement WRITE_SAME
-	 */
-	if (pdev->subsystem_vendor == 0x15AD)
-		sh->no_write_same = 1;
-
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a143c6a..8c228e049bb6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -249,6 +249,8 @@ static struct {
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"Traxdata", "CDR4120", NULL, BLIST_NOLUN},	/* locks up */
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"VMware", "Virtual disk", "1.0", BLIST_NO_WRITE_SAME }, /* ESX */
+	{"VMware,", "VMware Virtual S", "1.0", BLIST_NO_WRITE_SAME }, /* WS,Fusion */
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ba3f1e8d0d57..c57daffe57af 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -955,6 +955,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_DIF)
 		sdev->no_dif = 1;
 
+	if (*bflags & BLIST_NO_WRITE_SAME)
+		sdev->no_write_same = 1;
+
 	sdev->eh_timeout = SCSI_DEFAULT_EH_TIMEOUT;
 
 	if (*bflags & BLIST_TRY_VPD_PAGES)
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 183eaab7c380..1a24efb4b1d6 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -36,5 +36,6 @@
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+#define BLIST_NO_WRITE_SAME	0x40000000 /* don't try to issue WRITE SAME */
 
 #endif
