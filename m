Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaEPFZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 01:25:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:21398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbaEPFZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 01:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1064,1389772800"; 
   d="scan'208";a="541408531"
From: Octavian Purdila <octavian.purdila@intel.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        Octavian Purdila <octavian.purdila@intel.com>,
        Jun Tian <jun.j.tian@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH staging-next] goldfish: pipe: fix warnings for 32bit builds
Date: Fri, 16 May 2014 08:24:59 +0300
Message-Id: <1400217899-32261-2-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400217899-32261-1-git-send-email-octavian.purdila@intel.com>
References: <1400217899-32261-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_cmd_status':
drivers/platform/goldfish/goldfish_pipe.c:164:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     writel((u32)(u64)pipe, dev->base + PIPE_REG_CHANNEL);
                 ^
drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_cmd':
drivers/platform/goldfish/goldfish_pipe.c:180:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     writel((u32)(u64)pipe, dev->base + PIPE_REG_CHANNEL);
                 ^
drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_pipe_read_write':
drivers/platform/goldfish/goldfish_pipe.c:337:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       writel((u32)(u64)pipe, dev->base + PIPE_REG_CHANNEL);

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jun Tian <jun.j.tian@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/platform/goldfish/goldfish_pipe.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index c86180b..d9a09d9 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -158,7 +158,7 @@ static u32 goldfish_cmd_status(struct goldfish_pipe *pipe, u32 cmd)
 	struct goldfish_pipe_dev *dev = pipe->dev;
 
 	spin_lock_irqsave(&dev->lock, flags);
-	gf_write64((u64)pipe, dev->base + PIPE_REG_CHANNEL,
+	gf_write64((u64)(unsigned long)pipe, dev->base + PIPE_REG_CHANNEL,
 				dev->base + PIPE_REG_CHANNEL_HIGH);
 	writel(cmd, dev->base + PIPE_REG_COMMAND);
 	status = readl(dev->base + PIPE_REG_STATUS);
@@ -172,7 +172,7 @@ static void goldfish_cmd(struct goldfish_pipe *pipe, u32 cmd)
 	struct goldfish_pipe_dev *dev = pipe->dev;
 
 	spin_lock_irqsave(&dev->lock, flags);
-	gf_write64((u64)pipe, dev->base + PIPE_REG_CHANNEL,
+	gf_write64((u64)(unsigned long)pipe, dev->base + PIPE_REG_CHANNEL,
 				dev->base + PIPE_REG_CHANNEL_HIGH);
 	writel(cmd, dev->base + PIPE_REG_COMMAND);
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -327,8 +327,9 @@ static ssize_t goldfish_pipe_read_write(struct file *filp, char __user *buffer,
 		spin_lock_irqsave(&dev->lock, irq_flags);
 		if (access_with_param(dev, CMD_WRITE_BUFFER + cmd_offset,
 				address, avail, pipe, &status)) {
-			gf_write64((u64)pipe, dev->base + PIPE_REG_CHANNEL,
-					dev->base + PIPE_REG_CHANNEL_HIGH);
+			gf_write64((u64)(unsigned long)pipe,
+				   dev->base + PIPE_REG_CHANNEL,
+				   dev->base + PIPE_REG_CHANNEL_HIGH);
 			writel(avail, dev->base + PIPE_REG_SIZE);
 			gf_write64(address, dev->base + PIPE_REG_ADDRESS,
 				dev->base + PIPE_REG_ADDRESS_HIGH);
-- 
1.8.3.2

