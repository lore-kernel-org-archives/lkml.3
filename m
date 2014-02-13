Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaBMD3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:29:39 -0500
Received: from nm26-vm5.bullet.mail.gq1.yahoo.com ([98.136.216.132]:23079 "EHLO
	nm26-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbaBMD3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:29:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=Xsz47dmVevOUNWLa1cSaKvrj1ehEYmZD61W7Gaef4qRv2jFnkZLaukvsQKq+ab1Hp3kMObDUsY+d2J+sr+aTJTMovw5qJKw0czyWCZWKIZzyKu9s4cDaWEn4aow1dOjEb+DnsThw3lIF5SeFK91W+3wYcOWLv/Xb9WZYOXjO0GI=;
X-Yahoo-Newman-Id: 189589.39753.bm@smtp223.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: flxtNzsVM1mRnNb9lTSCospAge4HWebA_3bbokRdJfMDgFK
 um4CpEJ.BJgs.f0RBztS_CRxZOWhEX1iQEp6gX2Q3SPdo5PzkHhVrBTu7qmV
 pluuJzxANj9zpVocqgRrRBAmWMEIOe62oXwfkMJVhf83u6UYXjKdyeUQvTvY
 BHJ3pL5G1Sdds56zCnyu_uV1MmpFQTKxagLzn5cBNftV7ETWNnrpaRQfcZys
 bXT2.k3Ws_xbWXOk01F7CY04sI8TOMym1q28T46Fijqkrxuhp.g8Cr1GMq.v
 rGaaWxmY6TRpAKI38z4AJvZbZKdCnzHajG0QKTQjiWMgysreDQ22rYr6_J3P
 r4lHrCBISIbovWpjGq8bCQGcfy3r56ZW4WpOguRI29A31uN0sqfIC3He_YsH
 SBMo.T4Swd6fEdMZxFVpveAdKZD1Agn.EzFi9IljwdEF0dGif.USDDyE_qSR
 Nk_NAHoXDpirXpM_Pu_dver5BzRndRfeQ4ehEHwlFu7aJJ8dV.dm51brk9kM
 WguNT8vsmBbhrfd9CYjfVF00ooPf_lKMt_yl_60PIo8mgkngA
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp223.mail.gq1.yahoo.com with SMTP; 13 Feb 2014 03:29:37 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: clean up conditional statement in addi_apci_3xxx.c
Date: Wed, 12 Feb 2014 21:29:27 -0600
Message-Id: <1392262167-4073-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this if-else conditional statement, if (chan < 16), but
(data[0] == INSN_CONFIG_DIO_QUERY), the function does not return early,
but the else-branch does not get executed either.  As a result, mask
would be used uninitialized in the next line.  What we want here is if
(chan < 16) and (data[0] != INSN_CONFIG_DIO_QUERY), return an error, but
in every other case, initialize mask and then proceed.  Found by a static
checker.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/addi_apci_3xxx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index ceadf8e..04c5153 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -688,13 +688,11 @@ static int apci3xxx_dio_insn_config(struct comedi_device *dev,
 	 * Port 1 (channels 8-15) are always outputs
 	 * Port 2 (channels 16-23) are programmable i/o
 	 */
-	if (chan < 16) {
-		if (data[0] != INSN_CONFIG_DIO_QUERY)
-			return -EINVAL;
-	} else {
-		/* changing any channel in port 2 changes the entire port */
-		mask = 0xff0000;
-	}
+	if ((chan < 16) && (data[0] != INSN_CONFIG_DIO_QUERY))
+		return -EINVAL;
+
+	/* changing any channel in port 2 changes the entire port */
+	mask = 0xff0000;
 
 	ret = comedi_dio_insn_config(dev, s, insn, data, mask);
 	if (ret)
-- 
1.8.5.3

