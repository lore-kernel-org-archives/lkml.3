Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBYJwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:52:10 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51234 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbaBYJwH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:52:07 -0500
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 20/22] qla2xxx: Use pci_enable_msix_range()
Thread-Topic: [PATCH 20/22] qla2xxx: Use pci_enable_msix_range()
Thread-Index: AQHPMg87iD1LWGzPO067X063mCiHIg==
Date: Tue, 25 Feb 2014 09:52:02 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D89867332@AVMB1.qlogic.org>
References: <cover.1391512266.git.agordeev@redhat.com>
 <36da37b8ca3a13e24a3363ed19d6a08061c85970.1391512266.git.agordeev@redhat.com>
In-Reply-To: <36da37b8ca3a13e24a3363ed19d6a08061c85970.1391512266.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.35.7.64]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B0CACDB358679F4DADA7A77C27A9DB10@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7359 signatures=668944
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1402250019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

>As result of deprecation of MSI-X/MSI enablement functions
>pci_enable_msix() and pci_enable_msi_block() all drivers
>using these two interfaces need to be updated to use the
>new pci_enable_msi_range() and pci_enable_msix_range()
>interfaces.
>
>Log message code 0x00c6 preserved, although it is reported
>after successful call to pci_enable_msix_range(), not before
>possibly unsuccessful call to pci_enable_msix(). Consumers
>of the error code should not notice the difference.
>
>Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>Cc: qla2xxx-upstream@qlogic.com
>Cc: linux-scsi@vger.kernel.org
>Cc: linux-pci@vger.kernel.org
>---
> drivers/scsi/qla2xxx/qla_isr.c |   27 +++++++++++----------------
> 1 files changed, 11 insertions(+), 16 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_isr.c
>b/drivers/scsi/qla2xxx/qla_isr.c
>index 9bc86b9..b2dcfa4 100644
>--- a/drivers/scsi/qla2xxx/qla_isr.c
>+++ b/drivers/scsi/qla2xxx/qla_isr.c
>@@ -2896,27 +2896,22 @@ qla24xx_enable_msix(struct qla_hw_data *ha,
>struct rsp_que *rsp)
> 	for (i = 0; i < ha->msix_count; i++)
> 		entries[i].entry = i;
> 
>-	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
>-	if (ret) {
>-		if (ret < MIN_MSIX_COUNT)
>-			goto msix_failed;
>-
>+	ret = pci_enable_msix_range(ha->pdev,
>+				    entries, MIN_MSIX_COUNT, ha->msix_count);
>+	if (ret < 0) {
>+		ql_log(ql_log_fatal, vha, 0x00c7,
>+		    "MSI-X: Failed to enable support, "
>+		    "giving   up -- %d/%d.\n",
>+		    ha->msix_count, ret);
>+		goto msix_out;
>+	} else if (ret < ha->msix_count) {
> 		ql_log(ql_log_warn, vha, 0x00c6,
> 		    "MSI-X: Failed to enable support "
> 		    "-- %d/%d\n Retry with %d vectors.\n",
> 		    ha->msix_count, ret, ret);
>-		ha->msix_count = ret;
>-		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
>-		if (ret) {
>-msix_failed:
>-			ql_log(ql_log_fatal, vha, 0x00c7,
>-			    "MSI-X: Failed to enable support, "
>-			    "giving   up -- %d/%d.\n",
>-			    ha->msix_count, ret);
>-			goto msix_out;
>-		}
>-		ha->max_rsp_queues = ha->msix_count - 1;
> 	}
>+	ha->msix_count = ret;
>+	ha->max_rsp_queues = ha->msix_count - 1;
> 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
> 				ha->msix_count, GFP_KERNEL);
> 	if (!ha->msix_entries) {
>-- 
>1.7.7.6
>

