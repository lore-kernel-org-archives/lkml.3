Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaGNQTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:19:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbaGNQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:19:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 6/6] xen/pciback: Remove tons of dereferences
Date: Mon, 14 Jul 2014 12:18:56 -0400
Message-Id: <1405354736-7358-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little cleanup. No functional difference.

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 121c725..1ddd22f 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -631,10 +631,12 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
 {
 	pci_ers_result_t res = result;
 	struct xen_pcie_aer_op *aer_op;
+	struct xen_pcibk_device *pdev = psdev->pdev;
+	struct xen_pci_sharedinfo *sh_info = pdev->sh_info;
 	int ret;
 
 	/*with PV AER drivers*/
-	aer_op = &(psdev->pdev->sh_info->aer_op);
+	aer_op = &(sh_info->aer_op);
 	aer_op->cmd = aer_cmd ;
 	/*useful for error_detected callback*/
 	aer_op->err = state;
@@ -655,36 +657,36 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
 	* this flag to judge whether we need to check pci-front give aer
 	* service ack signal
 	*/
-	set_bit(_PCIB_op_pending, (unsigned long *)&psdev->pdev->flags);
+	set_bit(_PCIB_op_pending, (unsigned long *)&pdev->flags);
 
 	/*It is possible that a pcifront conf_read_write ops request invokes
 	* the callback which cause the spurious execution of wake_up.
 	* Yet it is harmless and better than a spinlock here
 	*/
 	set_bit(_XEN_PCIB_active,
-		(unsigned long *)&psdev->pdev->sh_info->flags);
+		(unsigned long *)&sh_info->flags);
 	wmb();
-	notify_remote_via_irq(psdev->pdev->evtchn_irq);
+	notify_remote_via_irq(pdev->evtchn_irq);
 
 	ret = wait_event_timeout(xen_pcibk_aer_wait_queue,
 				 !(test_bit(_XEN_PCIB_active, (unsigned long *)
-				 &psdev->pdev->sh_info->flags)), 300*HZ);
+				 &sh_info->flags)), 300*HZ);
 
 	if (!ret) {
 		if (test_bit(_XEN_PCIB_active,
-			(unsigned long *)&psdev->pdev->sh_info->flags)) {
+			(unsigned long *)&sh_info->flags)) {
 			dev_err(&psdev->dev->dev,
 				"pcifront aer process not responding!\n");
 			clear_bit(_XEN_PCIB_active,
-			  (unsigned long *)&psdev->pdev->sh_info->flags);
+			  (unsigned long *)&sh_info->flags);
 			aer_op->err = PCI_ERS_RESULT_NONE;
 			return res;
 		}
 	}
-	clear_bit(_PCIB_op_pending, (unsigned long *)&psdev->pdev->flags);
+	clear_bit(_PCIB_op_pending, (unsigned long *)&pdev->flags);
 
 	if (test_bit(_XEN_PCIF_active,
-		(unsigned long *)&psdev->pdev->sh_info->flags)) {
+		(unsigned long *)&sh_info->flags)) {
 		dev_dbg(&psdev->dev->dev,
 			"schedule pci_conf service in " DRV_NAME "\n");
 		xen_pcibk_test_and_schedule_op(psdev->pdev);
-- 
1.9.3

