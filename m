Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaBGUJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:09:32 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:57976 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751589AbaBGUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:09:31 -0500
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH] drivers/base: fix devres handling for master device
Message-Id: <E1WBrjr-0001Jr-Hc@rmk-PC.arm.linux.org.uk>
Date: Fri, 07 Feb 2014 20:09:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We weren't handling the devres issues for the master device failing a
bind, or being unbound properly.  Add a devres group to contain these,
and release the resources at the appropriate points.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Greg, if you'd be kind enough to queue this for an -rc release, it'd
help plug a hole I discovered earlier this week in the component
helper.  Thanks.

 drivers/base/component.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index c53efe6c6d8e..c4778995cd72 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -133,9 +133,16 @@ static int try_to_bring_up_master(struct master *master,
 			goto out;
 		}
 
+		if (!devres_open_group(master->dev, NULL, GFP_KERNEL)) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		/* Found all components */
 		ret = master->ops->bind(master->dev);
 		if (ret < 0) {
+			devres_release_group(master->dev, NULL);
+			dev_info(master->dev, "master bind failed: %d\n", ret);
 			master_remove_components(master);
 			goto out;
 		}
@@ -166,6 +173,7 @@ static void take_down_master(struct master *master)
 {
 	if (master->bound) {
 		master->ops->unbind(master->dev);
+		devres_release_group(master->dev, NULL);
 		master->bound = false;
 	}
 
-- 
1.8.3.1

