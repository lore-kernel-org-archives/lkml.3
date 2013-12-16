Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3LPKfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:35:00 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61629 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab3LPKe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:34:59 -0500
Message-ID: <1387190097.9255.31.camel@x41.thuisdomein>
Subject: [PATCH 2/2] ahci: only attach ICH6-M if it's in SATA mode
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 11:34:57 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2013 10:34:57.0464 (UTC) FILETIME=[77326B80:01CEFA4A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel's ICH6-M can operate either in IDE mode or in SATA mode. Attaching
in IDE mode is pointless (and should fail, as long as BIOS has configured
it even remotely sane). So let's only attach in SATA mode.

Note that ata_piix does the opposite: only attach if ICH6-M is in IDE
mode, so we end up with just one driver attaching in either mode.

(And since we're touching this table update a minor typo too.)

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested on an ICH6-M that always runs in IDE mode. So I'm not certain
this does the right thing for a ICH6-M running in SATA mode. 

 drivers/ata/ahci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4ba3bde..12182fd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -191,8 +191,10 @@ static const struct ata_port_info ahci_port_info[] = {
 
 static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Intel */
-	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6 */
-	{ PCI_VDEVICE(INTEL, 0x2653), board_ahci }, /* ICH6M */
+	{ PCI_VDEVICE(INTEL, 0x2652), board_ahci }, /* ICH6R */
+	/* ICH6M Attach iff the controller is in SATA mode. */
+	{ PCI_VENDOR_ID_INTEL, 0x2653, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_SATA << 8, 0xffff00, board_ahci },
 	{ PCI_VDEVICE(INTEL, 0x27c1), board_ahci }, /* ICH7 */
 	{ PCI_VDEVICE(INTEL, 0x27c5), board_ahci }, /* ICH7M */
 	{ PCI_VDEVICE(INTEL, 0x27c3), board_ahci }, /* ICH7R */
-- 
1.8.1.4

