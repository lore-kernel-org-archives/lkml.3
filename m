Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab3IBJEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:04:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab3IBIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Terry Suereth <terry.suereth@gmail.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 39/58] libata: apply behavioral quirks to sil3826 PMP
Date: Mon,  2 Sep 2013 09:54:24 +0100
Message-Id: <1378112083-9475-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Suereth <terry.suereth@gmail.com>

commit 8ffff94d20b7eb446e848e0046107d51b17a20a8 upstream.

Fixing support for the Silicon Image 3826 port multiplier, by applying
to it the same quirks applied to the Silicon Image 3726.  Specifically
fixes the repeated timeout/reset process which previously afflicted
the 3726, as described from line 290.  Slightly based on notes from:

https://bugzilla.redhat.com/show_bug.cgi?id=890237

Signed-off-by: Terry Suereth <terry.suereth@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-pmp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index f63a588..f5c35be 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -289,24 +289,24 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 
 	/* Disable sending Early R_OK.
 	 * With "cached read" HDD testing and multiple ports busy on a SATA
-	 * host controller, 3726 PMP will very rarely drop a deferred
+	 * host controller, 3x26 PMP will very rarely drop a deferred
 	 * R_OK that was intended for the host. Symptom will be all
 	 * 5 drives under test will timeout, get reset, and recover.
 	 */
-	if (vendor == 0x1095 && devid == 0x3726) {
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
 		u32 reg;
 
 		err_mask = sata_pmp_read(&ap->link, PMP_GSCR_SII_POL, &reg);
 		if (err_mask) {
 			rc = -EIO;
-			reason = "failed to read Sil3726 Private Register";
+			reason = "failed to read Sil3x26 Private Register";
 			goto fail;
 		}
 		reg &= ~0x1;
 		err_mask = sata_pmp_write(&ap->link, PMP_GSCR_SII_POL, reg);
 		if (err_mask) {
 			rc = -EIO;
-			reason = "failed to write Sil3726 Private Register";
+			reason = "failed to write Sil3x26 Private Register";
 			goto fail;
 		}
 	}
@@ -383,8 +383,8 @@ static void sata_pmp_quirks(struct ata_port *ap)
 	u16 devid = sata_pmp_gscr_devid(gscr);
 	struct ata_link *link;
 
-	if (vendor == 0x1095 && devid == 0x3726) {
-		/* sil3726 quirks */
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
+		/* sil3x26 quirks */
 		ata_for_each_link(link, ap, EDGE) {
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;
-- 
1.8.3.2

