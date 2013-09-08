Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab3IHDUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754734Ab3IHDSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Terry Suereth" <terry.suereth@gmail.com>,
        "Tejun Heo" <tj@kernel.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.376051758@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [079/121] libata: apply behavioral quirks to sil3826 PMP
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-pmp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -289,24 +289,24 @@ static int sata_pmp_configure(struct ata
 
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
@@ -383,8 +383,8 @@ static void sata_pmp_quirks(struct ata_p
 	u16 devid = sata_pmp_gscr_devid(gscr);
 	struct ata_link *link;
 
-	if (vendor == 0x1095 && devid == 0x3726) {
-		/* sil3726 quirks */
+	if (vendor == 0x1095 && (devid == 0x3726 || devid == 0x3826)) {
+		/* sil3x26 quirks */
 		ata_for_each_link(link, ap, EDGE) {
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;

