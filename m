Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3IKEaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3IKE3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:00 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ck3cUoquTdcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8yvceOWEQ7UA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=DHedI8HUw5tYfexO5FEA:9 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042855.955416645@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [023/251] zfcp: fix adapter (re)open recovery while link to SAN is down
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0023-zfcp-fix-adapter-re-open-recovery-while-link-to-SAN-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

[ Upstream commit f76ccaac4f82c463a037aa4a1e4ccb85c7011814 ]

FCP device remains in status ERP_FAILED when device is switched online
or adapter recovery is triggered  while link to SAN is down.

When Exchange Configuration Data command returns the FSF status
FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE it aborts the exchange process.
The only retries are done during the common error recovery procedure
(i.e. max. 3 retries with 8sec sleep between) and remains in status
ERP_FAILED with QDIO down.

This commit reverts the commit 0df138476c8306478d6e726f044868b4bccf411c
(zfcp: Fix adapter activation on link down).
When FSF status FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE is received the
adapter recovery will be finished without any retries. QDIO will be
up now and status changes such as LINK UP will be received now.

Signed-off-by: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #2.6.37+
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 48f875f..e3f4dab 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -563,6 +563,10 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
 
+		/* avoids adapter shutdown to be able to recognize
+		 * events such as LINK UP */
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
-- 
1.7.10.4


