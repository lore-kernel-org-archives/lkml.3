Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761394AbaJDAsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:48:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbaJCVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 049/357] i2c: rcar: fix MNR interrupt handling
Date: Fri,  3 Oct 2014 14:27:15 -0700
Message-Id: <20141003212934.927956972@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit dd318b0df27c582ac0d72a346fd6e693700be23c upstream.

Sometimes the MNR and MST interrupts happen simultaneously  (stop  automatically
follows NACK, according to the manuals) and in such case the ID_NACK flag  isn't
set since the MST interrupt handling precedes MNR and all interrupts are cleared
and disabled then, so that MNR interrupt is never noticed -- this causes NACK'ed
transfers to be falsely reported as successful. Exchanging MNR and  MST handlers
fixes this issue, however the MNR bit  somehow  gets set again even after  being
explicitly cleared, so I decided to completely suppress handling of all disabled
interrupts (which is a good thing anyway)...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rcar.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -372,18 +372,15 @@ static irqreturn_t rcar_i2c_irq(int irq,
 
 	msr = rcar_i2c_read(priv, ICMSR);
 
+	/* Only handle interrupts that are currently enabled */
+	msr &= rcar_i2c_read(priv, ICMIER);
+
 	/* Arbitration lost */
 	if (msr & MAL) {
 		rcar_i2c_flags_set(priv, (ID_DONE | ID_ARBLOST));
 		goto out;
 	}
 
-	/* Stop */
-	if (msr & MST) {
-		rcar_i2c_flags_set(priv, ID_DONE);
-		goto out;
-	}
-
 	/* Nack */
 	if (msr & MNR) {
 		/* go to stop phase */
@@ -393,6 +390,12 @@ static irqreturn_t rcar_i2c_irq(int irq,
 		goto out;
 	}
 
+	/* Stop */
+	if (msr & MST) {
+		rcar_i2c_flags_set(priv, ID_DONE);
+		goto out;
+	}
+
 	if (rcar_i2c_is_recv(priv))
 		rcar_i2c_flags_set(priv, rcar_i2c_irq_recv(priv, msr));
 	else


