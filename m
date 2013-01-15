Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663Ab3APAC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:02:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:43397 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab3AOWfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 180/221] USB: ehci: make debug port in-use detection functional again
Date: Tue, 15 Jan 2013 10:51:47 -0800
Message-Id: <20130115185011.009417386@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 75e1a2ae1f61ce1ae640410ba757bba84bd9fefe upstream.

Debug port in-use determination must be done before the controller gets
reset the first time, i.e. before the call to ehci_setup() as of commit
1a49e2ac9651df7349867a5cf44e2c83de1046af. That commit effectively
rendered commit 9fa5780beea1274d498a224822397100022da7d4 useless.

While moving that code around, also fix the BAR determination - the
respective capability field is a 3- rather than a 2-bit one -, and use
PCI_CAP_ID_DBG instead of the literal 0x0a.

It's unclear to me whether the debug port functionality is important
enough to warrant fixing this in stable kernels too.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-pci.c |   39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -192,6 +192,26 @@ static int ehci_pci_setup(struct usb_hcd
 		break;
 	}
 
+	/* optional debug port, normally in the first BAR */
+	temp = pci_find_capability(pdev, PCI_CAP_ID_DBG);
+	if (temp) {
+		pci_read_config_dword(pdev, temp, &temp);
+		temp >>= 16;
+		if (((temp >> 13) & 7) == 1) {
+			u32 hcs_params = ehci_readl(ehci,
+						    &ehci->caps->hcs_params);
+
+			temp &= 0x1fff;
+			ehci->debug = hcd->regs + temp;
+			temp = ehci_readl(ehci, &ehci->debug->control);
+			ehci_info(ehci, "debug port %d%s\n",
+				  HCS_DEBUG_PORT(hcs_params),
+				  (temp & DBGP_ENABLED) ? " IN USE" : "");
+			if (!(temp & DBGP_ENABLED))
+				ehci->debug = NULL;
+		}
+	}
+
 	retval = ehci_setup(hcd);
 	if (retval)
 		return retval;
@@ -226,25 +246,6 @@ static int ehci_pci_setup(struct usb_hcd
 		break;
 	}
 
-	/* optional debug port, normally in the first BAR */
-	temp = pci_find_capability(pdev, 0x0a);
-	if (temp) {
-		pci_read_config_dword(pdev, temp, &temp);
-		temp >>= 16;
-		if ((temp & (3 << 13)) == (1 << 13)) {
-			temp &= 0x1fff;
-			ehci->debug = hcd->regs + temp;
-			temp = ehci_readl(ehci, &ehci->debug->control);
-			ehci_info(ehci, "debug port %d%s\n",
-				HCS_DEBUG_PORT(ehci->hcs_params),
-				(temp & DBGP_ENABLED)
-					? " IN USE"
-					: "");
-			if (!(temp & DBGP_ENABLED))
-				ehci->debug = NULL;
-		}
-	}
-
 	/* at least the Genesys GL880S needs fixup here */
 	temp = HCS_N_CC(ehci->hcs_params) * HCS_N_PCC(ehci->hcs_params);
 	temp &= 0x0f;


