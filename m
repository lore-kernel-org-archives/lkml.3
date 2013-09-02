Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3IBKas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:30:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:7573 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264Ab3IBKap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:30:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="354790417"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        <stable@vger.kernel.org>, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3] mei: cancel stall timers in mei_reset
Date: Mon,  2 Sep 2013 13:29:47 +0300
Message-Id: <1378117787-11528-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
References: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Unset init_clients_timer and amthif_stall_timers
in mei_reset in order to cancel timer ticking and hence
avoid recursive reset calls.

Cc:  <stable@vger.kernel.org> # 3.9+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 1 +
 drivers/misc/mei/init.c   | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index d0fdc13..f6ff711 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -57,6 +57,7 @@ void mei_amthif_reset_params(struct mei_device *dev)
 	dev->iamthif_ioctl = false;
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 	dev->iamthif_timer = 0;
+	dev->iamthif_stall_timer = 0;
 }
 
 /**
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 92c7311..6197018 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -175,6 +175,9 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
 	}
 
+	/* we're already in reset, cancel the init timer */
+	dev->init_clients_timer = 0;
+
 	dev->me_clients_num = 0;
 	dev->rd_msg_hdr = 0;
 	dev->wd_pending = false;
-- 
1.8.3.1

