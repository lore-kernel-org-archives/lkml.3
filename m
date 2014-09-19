Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbaISV3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:29:48 -0400
Received: from ozlabs.org ([103.22.144.67]:43948 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728AbaISV3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:29:45 -0400
Date: Sat, 20 Sep 2014 07:29:42 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in ibmvtpm_get_data if
 driver_data is bad
Message-ID: <20140920072942.27c28768@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at an oops in tpm_ibmvtpm_get_desired_dma:

  28:	00 00 20 39 	li      r9,0
  2c:	10 00 01 e8 	ld      r0,16(r1)
  30:	28 00 69 80 	lwz     r3,40(r9)

We set r9 to 0 then load r9+40. The problem is actually in
ibmvtpm_get_data, it can return NULL but the rest of the driver
never expects it.

Add a BUG_ON in ibmvtpm_get_data. We still need to identify the root
cause but at least this makes it obvious what went wrong.

Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index af74c57..0d1eeba 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -63,9 +63,9 @@ static int ibmvtpm_send_crq(struct vio_dev *vdev, u64 w1, u64 w2)
 static struct ibmvtpm_dev *ibmvtpm_get_data(const struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if (chip)
-		return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
-	return NULL;
+
+	BUG_ON(!chip);
+	return (struct ibmvtpm_dev *)TPM_VPRIV(chip);
 }
 
 /**
