Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaLPAoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:44:17 -0500
Received: from c-82-192-226-27.customer.ggaweb.ch ([82.192.226.27]:33667 "EHLO
	dizzy-6.o2s.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbaLPAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:44:09 -0500
Subject: [PATCH 1/4] mmc: sunxi: Lock fix
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Peter Griffin <peter.griffin@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>,
        =?utf-8?b?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Dec 2014 01:37:45 +0100
Message-ID: <20141216003745.15488.52305.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch>
References: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1)	Adding a comment in order to clarify the choice of the locks within
	sunxi_mmc_handle_manual_stop

2)	As 李想 has pointed out the wait_dma variable was not accessed within the spin lock
	block in sunxi_mmc_request and so (even if it should never happend) it would have
	theoretically been possible that some other function would access the variable
	at the same time as the function.
	This has been changed now and the function is using local variables outside the lock
	and copys the value over during the lock phase.

Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
Reported-by: 李想 <lixiang@allwinnertech.com>
---
 drivers/mmc/host/sunxi-mmc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 15cb8b7..25ba321 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -570,6 +570,15 @@ static irqreturn_t sunxi_mmc_handle_manual_stop(int irq, void *dev_id)
 	}
 
 	dev_err(mmc_dev(host->mmc), "data error, sending stop command\n");
+
+	/*
+	 * We will never have more than one outstanding request,
+	 * and we do not complete the request until after
+	 * we've cleared host->manual_stop_mrq so we do not need to
+	 * spin lock this function.
+	 * Additionally we have wait states within this function
+	 * so having it in a lock is a very bad idea.
+	 */
 	sunxi_mmc_send_manual_stop(host, mrq);
 
 	spin_lock_irqsave(&host->lock, iflags);
@@ -766,6 +775,7 @@ static void sunxi_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	unsigned long iflags;
 	u32 imask = SDXC_INTERRUPT_ERROR_BIT;
 	u32 cmd_val = SDXC_START | (cmd->opcode & 0x3f);
+	bool wait_dma = host->wait_dma;
 	int ret;
 
 	/* Check for set_ios errors (should never happen) */
@@ -816,7 +826,7 @@ static void sunxi_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 			if (cmd->data->flags & MMC_DATA_WRITE)
 				cmd_val |= SDXC_WRITE;
 			else
-				host->wait_dma = true;
+				wait_dma = true;
 		} else {
 			imask |= SDXC_COMMAND_DONE;
 		}
@@ -850,6 +860,7 @@ static void sunxi_mmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	}
 
 	host->mrq = mrq;
+	host->wait_dma = wait_dma;
 	mmc_writel(host, REG_IMASK, host->sdio_imask | imask);
 	mmc_writel(host, REG_CARG, cmd->arg);
 	mmc_writel(host, REG_CMDR, cmd_val);

