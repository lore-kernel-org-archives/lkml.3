Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaKWNR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:17:59 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33680 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbaKWNQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:16:40 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109083687"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: kernel-janitors@vger.kernel.org,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] mptfusion: fix error return code
Date: Sun, 23 Nov 2014 14:11:14 +0100
Message-Id: <1416748278-22881-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/message/fusion/mptfc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d8bf84a..629df6d 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1325,8 +1325,10 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 "mptfc_wq_%d", sh->host_no);
 	ioc->fc_rescan_work_q =
 		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
-	if (!ioc->fc_rescan_work_q)
+	if (!ioc->fc_rescan_work_q) {
+		error = -ENOMEM;
 		goto out_mptfc_probe;
+	}
 
 	/*
 	 *  Pre-fetch FC port WWN and stuff...

