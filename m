Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaGWSI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:08:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40929 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGWSIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:08:54 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 23 Jul 2014 20:08:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Remy Bruno <remy-fw@remy.trinnov.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: ohci: disable MSI for VIA VT6315 again
Message-ID: <20140723200812.6711af15@kant>
In-Reply-To: <20140723151310.GA29360@trinnov.com>
References: <20140123154321.GA1557@trinnov.com>
	<20140123233205.628240b5@stein>
	<20140127100932.GB1557@trinnov.com>
	<20140615011758.2817384f@kant>
	<20140715185351.GA28484@trinnov.com>
	<53C66BFC.4010500@ladisch.de>
	<20140716135959.GA11877@trinnov.com>
	<20140719134403.710f6df5@kant>
	<20140723151310.GA29360@trinnov.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert half of commit d151f9854f21:  If isochronous I/O is attempted with
packets larget than 1 kByte, VIA VT6315 rev 01 immediately stops to generate
any interrupts if MSI are used.  Fix this by going back to legacy interrupts.
[Thread "Isochronous streaming with VT6315 OHCI",
http://marc.info/?t=139049641500003]

With smaller packets, the loss of IRQs happens too but only very rarely ---
rarely eneough that it was not yet possible for me to determine whether
QUIRK_NO_MSI is an actual fix for this rare variation of this chip bug.

I am keeping QUIRK_CYCLE_TIMER off of VT6315 rev >= 1 because this has been
verified by myself with certainty.  On the other hand, I am also keeping
QUIRK_CYCLE_TIMER on for VT6315 rev 0 because I don't know at this time
whether this revision accesses Cycle Timer non-atomically like most of the
other VIA OHCIs are known to do.

Reported-by: Rémy Bruno <remy-fw@remy.trinnov.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -336,10 +336,10 @@ static const struct {
 		QUIRK_CYCLE_TIMER | QUIRK_IR_WAKE},
 
 	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT6315, 0,
-		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},
+		QUIRK_CYCLE_TIMER /* FIXME: necessary? */ | QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT6315, PCI_ANY_ID,
-		0},
+		QUIRK_NO_MSI},
 
 	{PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_ANY_ID,
 		QUIRK_CYCLE_TIMER | QUIRK_NO_MSI},


I will attempt to get this merged tomorrow or so.
-- 
Stefan Richter
-=====-====- -=== =-===
http://arcgraph.de/sr/
