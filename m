Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3IKE6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3IKE4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:52 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=gV8bDz3aHTUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=FHl0qk4nb-cA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ApK428gxEjNXGceUXy4A:9 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042930.530443582@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Terry Suereth <terry.suereth@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [230/251] libata: apply behavioral quirks to sil3826 PMP
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0230-libata-apply-behavioral-quirks-to-sil3826-PMP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Terry Suereth <terry.suereth@gmail.com>

[ Upstream commit 8ffff94d20b7eb446e848e0046107d51b17a20a8 ]

Fixing support for the Silicon Image 3826 port multiplier, by applying
to it the same quirks applied to the Silicon Image 3726.  Specifically
fixes the repeated timeout/reset process which previously afflicted
the 3726, as described from line 290.  Slightly based on notes from:

https://bugzilla.redhat.com/show_bug.cgi?id=890237

Signed-off-by: Terry Suereth <terry.suereth@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ata/libata-pmp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 1c41722..20fd337 100644
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
1.7.10.4


