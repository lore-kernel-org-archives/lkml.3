Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbaICXPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:15:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbaICWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.16 038/125] mmc: mmci: Move all CMD irq handling to mmci_cmd_irq()
Date: Wed,  3 Sep 2014 15:06:35 -0700
Message-Id: <20140903220624.798512785@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit ad82bfea44835da9633548e2031a1af4a9965c14 upstream.

This patch won't change the behavior of how mmci deals with CMD irqs.
By moving code from mmci_irq() to mmci_cmd_irq(), we getter a better
overview of what going on.

Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmci.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -906,9 +906,17 @@ mmci_cmd_irq(struct mmci_host *host, str
 	     unsigned int status)
 {
 	void __iomem *base = host->base;
-	bool sbc = (cmd == host->mrq->sbc);
-	bool busy_resp = host->variant->busy_detect &&
-			(cmd->flags & MMC_RSP_BUSY);
+	bool sbc, busy_resp;
+
+	if (!cmd)
+		return;
+
+	sbc = (cmd == host->mrq->sbc);
+	busy_resp = host->variant->busy_detect && (cmd->flags & MMC_RSP_BUSY);
+
+	if (!((status|host->busy_status) & (MCI_CMDCRCFAIL|MCI_CMDTIMEOUT|
+		MCI_CMDSENT|MCI_CMDRESPEND)))
+		return;
 
 	/* Check if we need to wait for busy completion. */
 	if (host->busy_status && (status & MCI_ST_CARDBUSY))
@@ -1136,8 +1144,6 @@ static irqreturn_t mmci_irq(int irq, voi
 	spin_lock(&host->lock);
 
 	do {
-		struct mmc_command *cmd;
-
 		status = readl(host->base + MMCISTATUS);
 
 		if (host->singleirq) {
@@ -1157,11 +1163,7 @@ static irqreturn_t mmci_irq(int irq, voi
 
 		dev_dbg(mmc_dev(host->mmc), "irq0 (data+cmd) %08x\n", status);
 
-		cmd = host->cmd;
-		if ((status|host->busy_status) & (MCI_CMDCRCFAIL|MCI_CMDTIMEOUT|
-			MCI_CMDSENT|MCI_CMDRESPEND) && cmd)
-			mmci_cmd_irq(host, cmd, status);
-
+		mmci_cmd_irq(host, host->cmd, status);
 		mmci_data_irq(host, host->data, status);
 
 		/* Don't poll for busy completion in irq context. */


