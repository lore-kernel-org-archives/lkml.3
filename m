Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3FELNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:13:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36323 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3FELNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:13:37 -0400
From: Yaniv Gardi <ygardi@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, ygardi@codeaurora.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] mmc: card: fixing an false identification of SANITIZE command
Date: Wed,  5 Jun 2013 14:13:08 +0300
Message-Id: <1370430804-5663-1-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inside the routine mmc_blk_ioctl_cmd() the sanitize command is
identified according to the value of bits 16-23 of the argument.

but what happens if a different command is sent, and only by chance,
bits 16-23 contain the value of SANITIZE command ?
In that case a SANITIZE command will be falsely identified.
In order to prevent such a case, the condition is expanded and
now it also checks the opcode itself, and verifies that it is an
MMC_SWITCH opcode.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
---
 drivers/mmc/card/block.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c900d28..9775ae7 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -542,7 +542,9 @@ static int mmc_blk_ioctl_cmd(struct block_device *bdev,
 			goto cmd_rel_host;
 	}
 
-	if (MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_SANITIZE_START) {
+	if ((MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_SANITIZE_START) &&
+	     (cmd.opcode == MMC_SWITCH)) {
+
 		err = ioctl_do_sanitize(card);
 
 		if (err)
-- 
1.7.6

