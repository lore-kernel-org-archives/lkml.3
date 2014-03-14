Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaCNPjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:39:47 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:37435
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755967AbaCNPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:39:44 -0400
Date: Fri, 14 Mar 2014 21:05:16 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 01/11][SCSI]mpt2sas: Added driver module parameter
 max_msix_vectors
Message-ID: <20140314153516.GA7932@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(83072002)(85852003)(46102001)(92726001)(92566001)(47976001)(4396001)(50986001)(49866001)(87266001)(47736001)(76796001)(76786001)(77096001)(87936001)(57986002)(85306002)(76176001)(81816001)(81686001)(23726002)(93136001)(86362001)(93516002)(74502001)(74662001)(47446002)(83506001)(16796002)(31966008)(59766001)(77982001)(65816001)(80022001)(6806004)(47776003)(20776003)(63696002)(97336001)(79102001)(97756001)(97186001)(50466002)(74706001)(80976001)(74366001)(44976005)(83322001)(19580405001)(19580395003)(74876001)(56776001)(54316002)(81342001)(69226001)(51856001)(95416001)(95666003)(36756003)(90146001)(76482001)(56816005)(53806001)(54356001)(94946001)(94316002)(46406003)(33656001)(81542001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB655;H:COSEXCH10.lsi.com;FPR:A49FE962.2CD0E3CE.A5F193EF.90F6E6D1.201E6;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added driver module parameter max_msix_vectors. Using this
module parameter the maximum number of MSI-X vectors could be set.

The number of MSI-X vectors used would be the minimum of MSI-X vectors
supported by the HBA, the number of CPU cores and the value set to
max_msix_vectors module parameters.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..ed810fb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -80,6 +80,10 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
+static int max_msix_vectors = -1;
+module_param(max_msix_vectors, int, 0);
+MODULE_PARM_DESC(max_msix_vectors, " max msix vectors ");
+
 static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
@@ -1420,6 +1424,16 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
 	    ioc->msix_vector_count);
 
+	if (max_msix_vectors > 0) {
+		ioc->reply_queue_count = min_t(int, max_msix_vectors,
+		    ioc->reply_queue_count);
+		ioc->msix_vector_count = ioc->reply_queue_count;
+	}
+
+	printk(MPT2SAS_INFO_FMT
+	"MSI-X vectors supported: %d, no of cores: %d, max_msix_vectors: %d\n",
+	 ioc->name, ioc->msix_vector_count, ioc->cpu_count, max_msix_vectors);
+
 	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
 	    GFP_KERNEL);
 	if (!entries) {
-- 
1.7.1

