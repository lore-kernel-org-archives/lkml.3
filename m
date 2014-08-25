Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaHYHRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:17:11 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:53644 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaHYHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:17:09 -0400
Date: Mon, 25 Aug 2014 07:14:03 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] tpm: fix interrupt timeouts
Message-ID: <alpine.LNX.2.11.1408250710470.1443@localhost.localdomain>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e
    wait: fix false timeouts when using wait_event_timeout()

changed the semantics of wait_event_interruptible_timeout so that a
condition check is performed after timeout and 1 is returned if true.

The TPM chip may not send interrupts even though the tpm module is
attempting to receive interrupts. In this case, after the module
sends a command to the TPM chip it performs a blocking wait on the
interrupt queue. No interrupts are sent from the chip, the queue is
not woken up and the blocking wait times out. Despite timing out,
the command has completed and the condition check performed by
wait_event_interruptible_timeout after timeout is true, resulting in
a return value of 1. Since the expected return value on timeout is 0
the timeout is not detected.

To fix, assume a return value of 1 or less indicates an elapsed
timeout. It is possible for the return value to be 1 after receiving
an interrupt, but this should be rare. The condition is not double-
checked because of possible side effects.

Signed-off-by: Scot Doyle
---
Patch for wait_event_interruptible_timeout documentation:
https://lkml.kernel.org/g/alpine.LNX.2.11.1408241710070.6462@localhost.localdomain

 drivers/char/tpm/tpm-interface.c   | 2 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c | 2 +-
 drivers/char/tpm/tpm_tis.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 6af1700..cceda56 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -863,7 +863,7 @@ again:
 			wait_for_tpm_stat_cond(chip, mask, check_cancel,
 					       &canceled),
 			timeout);
-		if (rc > 0) {
+		if (rc > 1) {
 			if (canceled)
 				return -ECANCELED;
 			return 0;
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 7b158ef..fce0c70 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -185,7 +185,7 @@ static int i2c_nuvoton_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
 		rc = wait_event_interruptible_timeout(*queue,
 						      cur_intrs != priv->intrs,
 						      timeout);
-		if (rc > 0)
+		if (rc > 1)
 			return 0;
 		/* At this point we know that the SINT pin is asserted, so we
 		 * do not need to do i2c_nuvoton_check_status */
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..6cb0f7a 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -158,7 +158,7 @@ again:
 						      (check_locality
 						       (chip, l) >= 0),
 						      timeout);
-		if (rc > 0)
+		if (rc > 1)
 			return l;
 		if (rc == -ERESTARTSYS && freezing(current)) {
 			clear_thread_flag(TIF_SIGPENDING);
-- 
2.0.4

