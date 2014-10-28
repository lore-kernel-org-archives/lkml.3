Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbaJ1HNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:13:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaJ1Dox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Carol L. Soto" <clsoto@us.ibm.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.16 075/127] powerpc/eeh: Clear frozen device state in time
Date: Tue, 28 Oct 2014 11:35:10 +0800
Message-Id: <20141028033424.133644443@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gwshan@linux.vnet.ibm.com>

commit 22fca17924094113fe79c1db5135290e1a84ad4b upstream.

The problem was reported by Carol: In the scenario of passing mlx4
adapter to guest, EEH error could be recovered successfully. When
returning the device back to host, the driver (mlx4_core.ko)
couldn't be loaded successfully because of error number -5 (-EIO)
returned from mlx4_get_ownership(), which hits offlined PCI device.
The root cause is that we missed to put the affected devices into
normal state on clearing PE isolated state right after PE reset.

The patch fixes above issue by putting the affected devices to
normal state when clearing PE isolated state in eeh_pe_state_clear().

Reported-by: Carol L. Soto <clsoto@us.ibm.com>
Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/eeh_pe.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -570,6 +570,8 @@ static void *__eeh_pe_state_clear(void *
 {
 	struct eeh_pe *pe = (struct eeh_pe *)data;
 	int state = *((int *)flag);
+	struct eeh_dev *edev, *tmp;
+	struct pci_dev *pdev;
 
 	/* Keep the state of permanently removed PE intact */
 	if ((pe->freeze_count > EEH_MAX_ALLOWED_FREEZES) &&
@@ -578,9 +580,22 @@ static void *__eeh_pe_state_clear(void *
 
 	pe->state &= ~state;
 
-	/* Clear check count since last isolation */
-	if (state & EEH_PE_ISOLATED)
-		pe->check_count = 0;
+	/*
+	 * Special treatment on clearing isolated state. Clear
+	 * check count since last isolation and put all affected
+	 * devices to normal state.
+	 */
+	if (!(state & EEH_PE_ISOLATED))
+		return NULL;
+
+	pe->check_count = 0;
+	eeh_pe_for_each_dev(pe, edev, tmp) {
+		pdev = eeh_dev_to_pci_dev(edev);
+		if (!pdev)
+			continue;
+
+		pdev->error_state = pci_channel_io_normal;
+	}
 
 	return NULL;
 }


