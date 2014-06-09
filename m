Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbaFIJLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:11:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58434 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 057/146] USB: OHCI: fix problem with global suspend on ATI controllers
Date: Mon,  9 Jun 2014 10:49:52 +0200
Message-Id: <ccc5443b40dfe652e86edd421e2164179b5da959.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c1db30a2a79eb59997b13b8cabf2a50bea9f04e1 upstream.

Some OHCI controllers from ATI/AMD seem to have difficulty with
"global" USB suspend, that is, suspending an entire USB bus without
setting the suspend feature for each port connected to a device.  When
we try to resume the child devices, the controller gives timeout
errors on the unsuspended ports, requiring resets, and can even cause
ohci-hcd to hang; see

	http://marc.info/?l=linux-usb&m=139514332820398&w=2

and the following messages.

This patch fixes the problem by adding a new quirk flag to ohci-hcd.
The flag causes the ohci_rh_suspend() routine to suspend each
unsuspended, enabled port before suspending the root hub.  This
effectively converts the "global" suspend to an ordinary root-hub
suspend.  There is no need to unsuspend these ports when the root hub
is resumed, because the child devices will be resumed anyway in the
course of a normal system resume ("global" suspend is never used for
runtime PM).

This patch should be applied to all stable kernels which include
commit 0aa2832dd0d9 (USB: use "global suspend" for system sleep on
USB-2 buses) or a backported version thereof.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Peter Münster <pmlists@free.fr>
Tested-by: Peter Münster <pmlists@free.fr>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ohci-hub.c | 18 ++++++++++++++++++
 drivers/usb/host/ohci-pci.c |  1 +
 drivers/usb/host/ohci.h     |  2 ++
 3 files changed, 21 insertions(+)

diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
index 2347ab83f046..dcf570862502 100644
--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -90,6 +90,24 @@ __acquires(ohci->lock)
 	dl_done_list (ohci);
 	finish_unlinks (ohci, ohci_frame_no(ohci));
 
+	/*
+	 * Some controllers don't handle "global" suspend properly if
+	 * there are unsuspended ports.  For these controllers, put all
+	 * the enabled ports into suspend before suspending the root hub.
+	 */
+	if (ohci->flags & OHCI_QUIRK_GLOBAL_SUSPEND) {
+		__hc32 __iomem	*portstat = ohci->regs->roothub.portstatus;
+		int		i;
+		unsigned	temp;
+
+		for (i = 0; i < ohci->num_ports; (++i, ++portstat)) {
+			temp = ohci_readl(ohci, portstat);
+			if ((temp & (RH_PS_PES | RH_PS_PSS)) ==
+					RH_PS_PES)
+				ohci_writel(ohci, RH_PS_PSS, portstat);
+		}
+	}
+
 	/* maybe resume can wake root hub */
 	if (ohci_to_hcd(ohci)->self.root_hub->do_remote_wakeup || autostop) {
 		ohci->hc_control |= OHCI_CTRL_RWE;
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index 659cde1ed1ea..fd9f77bcd499 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -160,6 +160,7 @@ static int ohci_quirk_amd700(struct usb_hcd *hcd)
 		ohci_dbg(ohci, "enabled AMD prefetch quirk\n");
 	}
 
+	ohci->flags |= OHCI_QUIRK_GLOBAL_SUSPEND;
 	return 0;
 }
 
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index e2e5faa5a402..0b2e58c2dfef 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -405,6 +405,8 @@ struct ohci_hcd {
 #define	OHCI_QUIRK_HUB_POWER	0x100			/* distrust firmware power/oc setup */
 #define	OHCI_QUIRK_AMD_PLL	0x200			/* AMD PLL quirk*/
 #define	OHCI_QUIRK_AMD_PREFETCH	0x400			/* pre-fetch for ISO transfer */
+#define	OHCI_QUIRK_GLOBAL_SUSPEND	0x800		/* must suspend ports */
+
 	// there are also chip quirks/bugs in init logic
 
 	struct work_struct	nec_work;	/* Worker for NEC quirk */
-- 
1.9.3

