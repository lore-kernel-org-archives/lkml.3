Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaL3QXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 11:23:55 -0500
Received: from www.osadl.org ([62.245.132.105]:52220 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaL3QXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 11:23:54 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [SCIS] mpt3sas: wait_for_completion_timeout timeout not reported
Date: Tue, 30 Dec 2014 11:19:46 -0500
Message-Id: <1419956387-28252-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_timeout reaching timeout was being ignored,
this also should fail if timeout condition occurs. 

Thanks to Joe Lawrence <joe.lawrence@stratus.com> for confirmation.

this was only compile tested with
x86_64_defconfig + CONFIG_SCSI_LOWLEVEL=y + CONFIG_SCSI_MPT3SAS=m

patch is against linux-next 3.19.0-rc1 -next-20141226

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 4472c2a..04ff21b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -393,7 +393,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	mpt3sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
 	    timeout*HZ);
-	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
+	if (timeleft == 0 || !(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
 		    ioc->name, __func__);
 		_debug_dump_mf(mpi_request,
-- 
1.7.10.4

