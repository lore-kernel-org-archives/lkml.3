Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3LWCxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:53:23 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54289 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab3LWCxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:53:22 -0500
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] mei_me: Ratelimit several error messages
Date: Mon, 23 Dec 2013 13:53:17 +1100
Message-Id: <1387767158-sup-501@delenn.ozlabs.ibm.com>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122302-0260-0000-0000-00000420A074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm unsure of the cause, but I found irq/40-mei_me consuming 100% CPU
and my disk full due to kern.log, syslog and messages rapidly growing in
size filled with these messages:

Dec 23 12:29:57 dukhat kernel: [336224.363138] mei_me 0000:00:16.0: reset: wrong host start response
Dec 23 12:29:57 dukhat kernel: [336224.363140] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Dec 23 12:29:57 dukhat kernel: [336224.363152] mei_me 0000:00:16.0: reset: unexpected enumeration response hbm.
Dec 23 12:29:57 dukhat kernel: [336224.363155] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Dec 23 12:29:57 dukhat kernel: [336224.363185] mei_me 0000:00:16.0: reset: wrong host start response
Dec 23 12:29:57 dukhat kernel: [336224.363187] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Dec 23 12:29:57 dukhat kernel: [336224.363199] mei_me 0000:00:16.0: reset: unexpected enumeration response hbm.
Dec 23 12:29:57 dukhat kernel: [336224.363201] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING

This patch rate-limits those specific messages to reduce the impact if
this problem ever recurs.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/mei/hbm.c  | 4 ++--
 drivers/misc/mei/init.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 9b3a0fb..2ab8b1d 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -613,7 +613,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			dev->init_clients_timer = 0;
 			mei_hbm_enum_clients_req(dev);
 		} else {
-			dev_err(&dev->pdev->dev, "reset: wrong host start response\n");
+			dev_err_ratelimited(&dev->pdev->dev, "reset: wrong host start response\n");
 			mei_reset(dev, 1);
 			return;
 		}
@@ -690,7 +690,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 				/* first property reqeust */
 				mei_hbm_prop_req(dev);
 		} else {
-			dev_err(&dev->pdev->dev, "reset: unexpected enumeration response hbm.\n");
+			dev_err_ratelimited(&dev->pdev->dev, "reset: unexpected enumeration response hbm.\n");
 			mei_reset(dev, 1);
 			return;
 		}
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index f7f3abb..edd3bb6 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -148,7 +148,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 			dev->dev_state != MEI_DEV_POWER_UP);
 
 	if (unexpected)
-		dev_warn(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
+		dev_warn_ratelimited(&dev->pdev->dev, "unexpected reset: dev_state = %s\n",
 			 mei_dev_state_str(dev->dev_state));
 
 	ret = mei_hw_reset(dev, interrupts_enabled);
-- 
1.8.4.rc3

