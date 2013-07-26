Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab3GZV1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:27:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab3GZUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 02/59] libata: skip SRST for all SIMG [34]7x port-multipliers
Date: Fri, 26 Jul 2013 13:52:26 -0700
Message-Id: <20130726205014.040783424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-pmp.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -389,9 +389,13 @@ static void sata_pmp_quirks(struct ata_p
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
@@ -399,20 +403,17 @@ static void sata_pmp_quirks(struct ata_p
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


