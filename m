Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbaE2FCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:02:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbaE2EiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jay Fenlason <fenlason@redhat.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3.10 09/86] firewire: ohci: fix probe failure with Agere/LSI controllers
Date: Wed, 28 May 2014 21:36:44 -0700
Message-Id: <20140529043514.752999888@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 0ca49345b6f489e95f8d6edeb0b092e257475b2a upstream.

Since commit bd972688eb24
"firewire: ohci: Fix 'failed to read phy reg' on FW643 rev8",
there is a high chance that firewire-ohci fails to initialize LSI née
Agere controllers.
https://bugzilla.kernel.org/show_bug.cgi?id=65151

Peter Hurley points out the reason:  IEEE 1394a:2000 clause 5A.1 (or
IEEE 1394:2008 clause 17.2.1) say:  "The PHY shall insure that no more
than 10 ms elapse from the reassertion of LPS until the interface is
reset.  The link shall not assert LReq until the reset is complete."
In other words, the link needs to give the PHY at least 10 ms to get
the interface operational.

With just the msleep(1) in bd972688eb24, the first read_phy_reg()
during ohci_enable() may happen before the phy-link interface reset was
finished, and fail.  Due to the high variability of msleep(n) with small
n, this failure was not fully reproducible, and not apparent at all with
low CONFIG_HZ setting.

On the other hand, Peter can no longer reproduce the issue with FW643
rev8.  The read phy reg failures that happened back then may have had an
unrelated cause.  So, just revert bd972688eb24, except for the valid
comment on TSB82AA2 cards.

Reported-by: Mikhail Gavrilov
Reported-by: Jay Fenlason <fenlason@redhat.com>
Reported-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firewire/ohci.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -288,7 +288,6 @@ static char ohci_driver_name[] = KBUILD_
 #define QUIRK_NO_MSI			0x10
 #define QUIRK_TI_SLLZ059		0x20
 #define QUIRK_IR_WAKE			0x40
-#define QUIRK_PHY_LCTRL_TIMEOUT		0x80
 
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
@@ -301,10 +300,7 @@ static const struct {
 		QUIRK_BE_HEADERS},
 
 	{PCI_VENDOR_ID_ATT, PCI_DEVICE_ID_AGERE_FW643, 6,
-		QUIRK_PHY_LCTRL_TIMEOUT | QUIRK_NO_MSI},
-
-	{PCI_VENDOR_ID_ATT, PCI_ANY_ID, PCI_ANY_ID,
-		QUIRK_PHY_LCTRL_TIMEOUT},
+		QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_SB1394, PCI_ANY_ID,
 		QUIRK_RESET_PACKET},
@@ -351,7 +347,6 @@ MODULE_PARM_DESC(quirks, "Chip quirks (d
 	", disable MSI = "		__stringify(QUIRK_NO_MSI)
 	", TI SLLZ059 erratum = "	__stringify(QUIRK_TI_SLLZ059)
 	", IR wake unreliable = "	__stringify(QUIRK_IR_WAKE)
-	", phy LCtrl timeout = "	__stringify(QUIRK_PHY_LCTRL_TIMEOUT)
 	")");
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -2293,9 +2288,6 @@ static int ohci_enable(struct fw_card *c
 	 * TI TSB82AA2 + TSB81BA3(A) cards signal LPS enabled early but
 	 * cannot actually use the phy at that time.  These need tens of
 	 * millisecods pause between LPS write and first phy access too.
-	 *
-	 * But do not wait for 50msec on Agere/LSI cards.  Their phy
-	 * arbitration state machine may time out during such a long wait.
 	 */
 
 	reg_write(ohci, OHCI1394_HCControlSet,
@@ -2303,11 +2295,8 @@ static int ohci_enable(struct fw_card *c
 		  OHCI1394_HCControl_postedWriteEnable);
 	flush_writes(ohci);
 
-	if (!(ohci->quirks & QUIRK_PHY_LCTRL_TIMEOUT))
+	for (lps = 0, i = 0; !lps && i < 3; i++) {
 		msleep(50);
-
-	for (lps = 0, i = 0; !lps && i < 150; i++) {
-		msleep(1);
 		lps = reg_read(ohci, OHCI1394_HCControlSet) &
 		      OHCI1394_HCControl_LPS;
 	}


