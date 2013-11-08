Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3KHC3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:29:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34813 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab3KHCVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        Paul Stewart <pstew@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 45/91] mwifiex: fix SDIO interrupt lost issue
Date: Thu,  7 Nov 2013 18:15:00 -0800
Message-Id: <1383876946-2396-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit 453b0c3f6910672f79da354077af728d92f95c5b upstream.

601216e "mwifiex: process RX packets in SDIO IRQ thread directly"
introduced a command timeout issue which can be reproduced easily on
an AM33xx platform using a test application written by Daniel Mack:

https://gist.github.com/zonque/6579314

mwifiex_main_process() is called from both the SDIO handler and
the workqueue. In case an interrupt occurs right after the
int_status check, but before updating the mwifiex_processing flag,
this interrupt gets lost, resulting in a command timeout and
consequently a card reset.

Let main_proc_lock protect both int_status and mwifiex_processing
flag. This fixes the interrupt lost issue.

Reported-by: Sven Neumann <s.neumann@raumfeld.com>
Reported-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Tested-by: Daniel Mack <zonque@gmail.com>
Reviewed-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/mwifiex/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 6d9bc63..a3d1a89 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -270,10 +270,12 @@ process_start:
 		}
 	} while (true);
 
-	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter))
+	spin_lock_irqsave(&adapter->main_proc_lock, flags);
+	if ((adapter->int_status) || IS_CARD_RX_RCVD(adapter)) {
+		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 		goto process_start;
+	}
 
-	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 	adapter->mwifiex_processing = false;
 	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
 
-- 
1.8.1.2

