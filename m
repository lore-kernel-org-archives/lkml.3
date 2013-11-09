Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3KIHjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:39:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab3KIGuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>,
        Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
        Daniel Mack <zonque@gmail.com>, Dylan Reid <dgreid@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        Paul Stewart <pstew@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 17/74] mwifiex: fix SDIO interrupt lost issue
Date: Fri,  8 Nov 2013 22:51:22 -0800
Message-Id: <20131109065114.754076069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

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
 


