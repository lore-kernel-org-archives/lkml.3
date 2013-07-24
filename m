Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3GXOGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:06:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45757 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab3GXOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Daniel Hansel" <daniel.hansel@linux.vnet.ibm.com>,
        "Steffen Maier" <maier@linux.vnet.ibm.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.55470673@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [03/85] [SCSI] zfcp: fix adapter (re)open recovery while link to
 SAN is down
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_fsf.c | 4 ++++
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

