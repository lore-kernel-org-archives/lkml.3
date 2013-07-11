Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3GKOsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:48:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3GKOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 24/98] libata: skip SRST for all SIMG [34]7x port-multipliers
Date: Thu, 11 Jul 2013 15:23:54 +0100
Message-Id: <1373552708-15235-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 7a87718d92760fc688628ad6a430643dafa16f1f upstream.

For some reason, a lot of port-multipliers have issues with softreset.
SIMG [34]7x series port-multipliers have been quite erratic in this
regard.  I recall that it was better with some firmware revisions and
the current list of quirks worked fine for a while.  I think it got
worse with later firmwares or maybe my test coverage wasn't good
enough.  Anyways, HPA is reporting that his 3726 setup suffers SRST
failures and then the PMP gets confused and fails to probe the last
port.

The hope was that we try to stick to the standard as much as possible
and soonish the PMPs and their firmwares will improve in quality, so
the quirk list was kept to minimum.  Well, it seems like that's never
gonna happen.

Let's set NO_SRST for all [34]7x PMPs so that whatever remaining
userbase of the device suffer the least.  Maybe we should do the same
for 57xx's but unfortunately I don't have any device left to test and
I'm not even sure 57xx's have ever been made widely available, so
let's leave those alone for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-pmp.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 21b80c5..f63a588 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -389,9 +389,13 @@ static void sata_pmp_quirks(struct ata_port *ap)
 			/* link reports offline after LPM */
 			link->flags |= ATA_LFLAG_NO_LPM;
 
-			/* Class code report is unreliable. */
+			/*
+			 * Class code report is unreliable and SRST times
+			 * out under certain configurations.
+			 */
 			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
+				link->flags |= ATA_LFLAG_NO_SRST |
+					       ATA_LFLAG_ASSUME_ATA;
 
 			/* port 5 is for SEMB device and it doesn't like SRST */
 			if (link->pmp == 5)
@@ -399,20 +403,17 @@ static void sata_pmp_quirks(struct ata_port *ap)
 					       ATA_LFLAG_ASSUME_SEMB;
 		}
 	} else if (vendor == 0x1095 && devid == 0x4723) {
-		/* sil4723 quirks */
-		ata_for_each_link(link, ap, EDGE) {
-			/* link reports offline after LPM */
-			link->flags |= ATA_LFLAG_NO_LPM;
-
-			/* class code report is unreliable */
-			if (link->pmp < 2)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
-
-			/* the config device at port 2 locks up on SRST */
-			if (link->pmp == 2)
-				link->flags |= ATA_LFLAG_NO_SRST |
-					       ATA_LFLAG_ASSUME_ATA;
-		}
+		/*
+		 * sil4723 quirks
+		 *
+		 * Link reports offline after LPM.  Class code report is
+		 * unreliable.  SIMG PMPs never got SRST reliable and the
+		 * config device at port 2 locks up on SRST.
+		 */
+		ata_for_each_link(link, ap, EDGE)
+			link->flags |= ATA_LFLAG_NO_LPM |
+				       ATA_LFLAG_NO_SRST |
+				       ATA_LFLAG_ASSUME_ATA;
 	} else if (vendor == 0x1095 && devid == 0x4726) {
 		/* sil4726 quirks */
 		ata_for_each_link(link, ap, EDGE) {
-- 
1.8.1.2

