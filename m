Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaH2Pe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:34:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42704 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaH2Pez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:34:55 -0400
Date: Fri, 29 Aug 2014 08:33:44 -0700
From: Kees Cook <keescook@chromium.org>
To: gregkh@linuxfoundation.org
Cc: ulf.hansson@linaro.org, john.stultz@linaro.org, keescook@chromium.org,
        linux@arm.linux.org.uk, peter.maydell@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH -stable] mmc: mmci: Reverse IRQ handling for the arm_variant
Message-ID: <20140829153344.GA11448@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
This is the back-port to 3.16, in response to "FAILED: patch "[PATCH]
mmc: mmci: Reverse IRQ handling for the arm_variant" failed to apply to
3.16-stable tree"

---
 drivers/mmc/host/mmci.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 249ab80cbb45..d3f05ad33f09 100644
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
@@ -87,6 +89,7 @@ static struct variant_data variant_arm = {
 	.fifohalfsize		= 8 * 4,
 	.datalength_bits	= 16,
 	.pwrreg_powerup		= MCI_PWR_UP,
+	.reversed_irq_handling	= true,
 };
 
 static struct variant_data variant_arm_extended_fifo = {
@@ -1163,8 +1166,13 @@ static irqreturn_t mmci_irq(int irq, void *dev_id)
 
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
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
