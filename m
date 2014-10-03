Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaJCWIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:08:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaJCWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.16 342/357] mmc: mmci: Reverse IRQ handling for the arm_variant
Date: Fri,  3 Oct 2014 14:32:08 -0700
Message-Id: <20141003212943.727897468@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 7878289b269d41c8e611aa6d4519feae706e49f3 upstream.

Commit "mmc: mmci: Handle CMD irq before DATA irq", caused an issue
when using the ARM model of the PL181 and running QEMU.

The bug was reported for the following QEMU version:
$ qemu-system-arm -version
QEMU emulator version 2.0.0 (Debian 2.0.0+dfsg-2ubuntu1.1), Copyright
(c) 2003-2008 Fabrice Bellard

To resolve the problem, let's restore the old behavior were the DATA
irq is handled prior the CMD irq, but only for the arm_variant, which
the problem was reported for.

Reported-by: John Stultz <john.stultz@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[kees: backported to 3.16]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmci.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -65,6 +65,7 @@ static unsigned int fmax = 515633;
  * @pwrreg_clkgate: MMCIPOWER register must be used to gate the clock
  * @busy_detect: true if busy detection on dat0 is supported
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
+ * @reversed_irq_handling: handle data irq before cmd irq.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -80,6 +81,7 @@ struct variant_data {
 	bool			pwrreg_clkgate;
 	bool			busy_detect;
 	bool			pwrreg_nopower;
+	bool			reversed_irq_handling;
 };
 
 static struct variant_data variant_arm = {
@@ -87,6 +89,7 @@ static struct variant_data variant_arm =
 	.fifohalfsize		= 8 * 4,
 	.datalength_bits	= 16,
 	.pwrreg_powerup		= MCI_PWR_UP,
+	.reversed_irq_handling	= true,
 };
 
 static struct variant_data variant_arm_extended_fifo = {
@@ -1163,8 +1166,13 @@ static irqreturn_t mmci_irq(int irq, voi
 
 		dev_dbg(mmc_dev(host->mmc), "irq0 (data+cmd) %08x\n", status);
 
-		mmci_cmd_irq(host, host->cmd, status);
-		mmci_data_irq(host, host->data, status);
+		if (host->variant->reversed_irq_handling) {
+			mmci_data_irq(host, host->data, status);
+			mmci_cmd_irq(host, host->cmd, status);
+		} else {
+			mmci_cmd_irq(host, host->cmd, status);
+			mmci_data_irq(host, host->data, status);
+		}
 
 		/* Don't poll for busy completion in irq context. */
 		if (host->busy_status)


