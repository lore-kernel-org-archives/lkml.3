Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3FEJmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:42:33 -0400
Received: from 1wt.eu ([62.212.114.60]:36016 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3FEJmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:42:32 -0400
Date: Wed, 5 Jun 2013 11:42:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Moritz Muehlenhoff <jmm@inutil.org>
Subject: [ 185/184] [SCSI] mpt2sas: Send default descriptor for RAID pass through in mpt2ctl
Message-ID: <20130605094227.GA27324@1wt.eu>
References: <58df134a4b98edf5b0073e2e1e988fe6@local> <20130604172137.930866926@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.
Thanks to Moritz for spotting this missing patch from the series.

------------------

From: "Kashyap, Desai" <kashyap.desai@lsi.com>

RAID_SCSI_IO_PASSTHROUGH: Driver needs to be sending the default
descriptor for RAID Passthru, currently its sending SCSI_IO descriptor.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index ddaa99c..d88e975 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -744,8 +744,11 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		    mpt2sas_base_get_sense_buffer_dma(ioc, smid);
 		priv_sense = mpt2sas_base_get_sense_buffer(ioc, smid);
 		memset(priv_sense, 0, SCSI_SENSE_BUFFERSIZE);
-		mpt2sas_base_put_smid_scsi_io(ioc, smid,
-		    le16_to_cpu(mpi_request->FunctionDependent1));
+		if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)
+			mpt2sas_base_put_smid_scsi_io(ioc, smid,
+			    le16_to_cpu(mpi_request->FunctionDependent1));
+		else
+			mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SCSI_TASK_MGMT:
-- 
1.7.12.2.21.g234cd45.dirty

