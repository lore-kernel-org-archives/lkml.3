Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaJOA6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 20:58:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39363 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbaJOA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 20:58:08 -0400
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
Date: Tue, 14 Oct 2014 20:57:58 -0400
In-Reply-To: <543A1D1A.8090808@vmware.com> (Petr Vandrovec's message of "Sat,
	11 Oct 2014 23:18:02 -0700")
Message-ID: <yq1h9z687zd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Petr" == Petr Vandrovec <petr@vmware.com> writes:

Petr,

Petr> Logic (from 2011, commit 8af1954d172a46a63e5e79dae523a6d74715e458)
Petr> says that EOPNOTSUPP is returned when DISCARD request failed, as
Petr> discarding is optional, and failures can be safely ignored.  That
Petr> is definitely not true for WRITE_SAME failures, and so unsupported
Petr> WRITE_SAME should return different error code than unsupported
Petr> DISCARD.

I agree. With Lukas' change the bio batch error handling is too
permissive for the write same case. It also made the regular zeroout
error handling case a bit fishy but it is unlikely that we'd get
EOPNOTSUPP on a regular write.

So for the block portion:

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org # 3.7+

Petr> revert of blacklisting VMware's LSI (if anything, blacklist should
Petr> be for current firmware version of 'VMware Virtual SCSI Disk', as
Petr> f.e. passed-through (RDM) SCSI disks do support WRITE_SAME under
Petr> VMware) -- see attached updated diff.

If you have a better heuristic then let's by all means use it. Please
adjust the pattern matching strings to match the actual values returned
by the target.


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
index 49014a143c6a..402aebfb97dd 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -249,6 +249,7 @@ static struct {
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"Traxdata", "CDR4120", NULL, BLIST_NOLUN},	/* locks up */
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"VMware", "Virtual SCSI Disk", NULL, BLIST_NO_WRITE_SAME},
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


-- 
Martin K. Petersen	Oracle Linux Engineering
