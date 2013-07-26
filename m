Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab3GZVLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:11:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974Ab3GZU6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 04/45] SCSI: zfcp: fix adapter (re)open recovery while link to SAN is down
Date: Fri, 26 Jul 2013 13:57:24 -0700
Message-Id: <20130726205655.416026242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

commit f76ccaac4f82c463a037aa4a1e4ccb85c7011814 upstream.

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
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -534,6 +534,10 @@ static void zfcp_fsf_exchange_config_dat
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		adapter->hydra_version = 0;
 
+		/* avoids adapter shutdown to be able to recognize
+		 * events such as LINK UP */
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;


