Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaBNBCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:02:33 -0500
Received: from nm10-vm3.bullet.mail.gq1.yahoo.com ([98.136.218.94]:26890 "EHLO
	nm10-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbaBNBCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:02:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=I/direJ5AZtI2HDS7T1nmnSD5dc7kC/zMPVcjL1HHAxD5Qq7+xU70wzT1612VMVExbma8ADHqQ/wh60AbY+q/L4i6hN+72qiqXFRS5G7zqBnDOOpkW5HbbxacNilohjLBw5eeN4h9YYWSeqYWWyWR91j6Qjyf9bktYK/7pBgzsI=;
X-Yahoo-Newman-Id: 648649.92642.bm@smtp207.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5grW9XwVM1l5.6TWL2EWUYulYBaZK3MCvYND55VP_wrjaTr
 H8wNEaaztADRIjZpmhdXC_ZLRnWd16iqyhrrZNTUx7TzOXgzzgTDTPKDJHQW
 _EPp9_goC9ogSmSBLnIN7TDfqslY2gr516EoqvfcSzd32niXtP18hcHYQmuV
 BPihc3kirCDLxXOlLIMTHkqq0khpAU1h1.CthkD._Bk.5Hx1mYGa1NzIma.s
 vyXW1f7cuyl1J8RW.8ziTudsG.Wh2DovRdtzZlQ2HIJtKqbsGffUUfAk53GJ
 exfGfysocKTQp8061nuL.IlhO.Sg7CviEHjLzH_Tt8qkhLZAe64CcXOitVIr
 ojTbbfwEUP6AqeOtQXjM_U8ExPSAGsyCYw6mAqnXMGxX2hwP0CurGYjn0fDj
 N1F_CIsZEqZWyCF3.hHmtSEV3zCoskbw3jXstqgmShvLnlHWDVBt79D_JILo
 I9DqR4lAw99TTtGvUahFg7tpggmHbo2xQJzxsBzXBAfqy5Gmc26bE_K1wPRn
 u4mOO1Kxt4ZZkhED.gkJwSnYJmcx3mgjdhFt0XzF7G.1F_omV
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp207.mail.gq1.yahoo.com with SMTP; 13 Feb 2014 17:02:30 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2] Staging: comedi: clean up conditional statement in addi_apci_3xxx.c
Date: Thu, 13 Feb 2014 19:02:26 -0600
Message-Id: <1392339746-3901-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392262167-4073-1-git-send-email-chase.southwood@yahoo.com>
References: <1392262167-4073-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this conditional statement, if (chan < 16), but the instruction passed
in data[0] is INSN_CONFIG_DIO_QUERY, the function does not return early,
but the else-branch does not get executed either.  As a result, mask
would be used uninitialized in the next line.  We want
comedi_dio_insn_config() to use a chan_mask based on the chanspec for the
INSN_CONFIG_DIO_QUERY instruction, so mask should be initialized to 0.
Then, if instead the instruction is INSN_CONFIG_DIO_{INPUT,OUTPUT}, we
return an error if (chan < 16) as these are invalid instructions for
ports 0 and 1, or update the mask otherwise, so all the io_bits are
modified for port 2.  This ensures that mask is always initialized by the
time it is used.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

2: Addressed all of the comments provided by Hartley regarding correct
structure of this patch.

Hopefully everything looks better!

 drivers/staging/comedi/drivers/addi_apci_3xxx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_3xxx.c b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
index ceadf8e..1f3b668 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3xxx.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3xxx.c
@@ -680,7 +680,7 @@ static int apci3xxx_dio_insn_config(struct comedi_device *dev,
 				    unsigned int *data)
 {
 	unsigned int chan = CR_CHAN(insn->chanspec);
-	unsigned int mask;
+	unsigned int mask = 0;
 	int ret;
 
 	/*
@@ -688,12 +688,13 @@ static int apci3xxx_dio_insn_config(struct comedi_device *dev,
 	 * Port 1 (channels 8-15) are always outputs
 	 * Port 2 (channels 16-23) are programmable i/o
 	 */
-	if (chan < 16) {
-		if (data[0] != INSN_CONFIG_DIO_QUERY)
+	if (data[0] != INSN_CONFIG_DIO_QUERY) {
+		/* ignore all other instructions for ports 0 and 1 */
+		if (chan < 16)
 			return -EINVAL;
-	} else {
-		/* changing any channel in port 2 changes the entire port */
-		mask = 0xff0000;
+		else
+			/* changing any channel in port 2 changes the entire port */
+			mask = 0xff0000;
 	}
 
 	ret = comedi_dio_insn_config(dev, s, insn, data, mask);
-- 
1.8.5.3

