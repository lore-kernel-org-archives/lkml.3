Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaGHR5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:57:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:54897 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362AbaGHR5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:09 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 7/7] xen/pciback: Remove tons of dereferences
Date: Tue,  8 Jul 2014 14:58:29 -0400
Message-Id: <1404845909-13563-8-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

A little cleanup. No functional difference.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index df485ec..8f74ae0 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -692,10 +692,12 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
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
@@ -716,36 +718,36 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
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
1.7.7.6

