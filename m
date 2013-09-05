Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3IEUoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:44:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab3IEU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>,
        Jack Wang <xjtuwjp@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 09/36] SCSI: pm80xx: fix Adaptec 71605H hang
Date: Thu,  5 Sep 2013 13:27:38 -0700
Message-Id: <20130905202703.392961386@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 9504a923924d663e1953f872f0a828e6454a6cfc upstream.

The IO command size is 128 bytes for these new controllers as opposed to 64
for the old 8001 controller.

The Adaptec out-of-tree driver did this correctly. After comparing the two
this turned out to be the crucial difference.

So don't hardcode the IO command size, instead use pm8001_ha->iomb_size as
that is the correct value for both old and new controllers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Acked-by: Jack Wang <xjtuwjp@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/pm8001/pm8001_hwi.c |    4 ++--
 drivers/scsi/pm8001/pm80xx_hwi.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -221,7 +221,7 @@ static void init_default_table_values(st
 	pm8001_ha->main_cfg_tbl.pm8001_tbl.fatal_err_interrupt		= 0x01;
 	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -247,7 +247,7 @@ static void init_default_table_values(st
 	}
 	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -275,7 +275,7 @@ static void init_default_table_values(st
 
 	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
@@ -301,7 +301,7 @@ static void init_default_table_values(st
 	}
 	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
-			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
+			PM8001_MPI_QUEUE | (pm8001_ha->iomb_size << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
 			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=


