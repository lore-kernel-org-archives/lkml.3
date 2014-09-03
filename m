Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218AbaICW4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:56:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbaICW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:26:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.16 037/125] mmc: mmci: Remove redundant check of status for DATA irq
Date: Wed,  3 Sep 2014 15:06:34 -0700
Message-Id: <20140903220624.769916934@linuxfoundation.org>
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

commit 1cb9da502835dad73dda772b20c1e792f4e71589 upstream.

We don't need to verify the content of the status register twice, while
we are about to handle a DATA irq. Instead let's leave all verification
to be handled by mmci_data_irq().

Cc: Peter Maydell <peter.maydell@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Tested-by: Kees Cook <keescook@chromium.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmci.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -834,6 +834,10 @@ static void
 mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 	      unsigned int status)
 {
+	/* Make sure we have data to handle */
+	if (!data)
+		return;
+
 	/* First check for errors */
 	if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|MCI_STARTBITERR|
 		      MCI_TXUNDERRUN|MCI_RXOVERRUN)) {
@@ -1133,7 +1137,6 @@ static irqreturn_t mmci_irq(int irq, voi
 
 	do {
 		struct mmc_command *cmd;
-		struct mmc_data *data;
 
 		status = readl(host->base + MMCISTATUS);
 
@@ -1159,11 +1162,7 @@ static irqreturn_t mmci_irq(int irq, voi
 			MCI_CMDSENT|MCI_CMDRESPEND) && cmd)
 			mmci_cmd_irq(host, cmd, status);
 
-		data = host->data;
-		if (status & (MCI_DATACRCFAIL|MCI_DATATIMEOUT|MCI_STARTBITERR|
-			      MCI_TXUNDERRUN|MCI_RXOVERRUN|MCI_DATAEND|
-			      MCI_DATABLOCKEND) && data)
-			mmci_data_irq(host, data, status);
+		mmci_data_irq(host, host->data, status);
 
 		/* Don't poll for busy completion in irq context. */
 		if (host->busy_status)


