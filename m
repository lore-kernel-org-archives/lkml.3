Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaILMUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:20:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaILMUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:20:36 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH] usb: hub: wrong order of putting interfaces when processing hub events
Date: Fri, 12 Sep 2014 14:20:21 +0200
Message-Id: <1410524421-15191-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_autopm_put_interface() must be called only when usb_autopm_get_interface()
succeeded before. There was wrong ordering of the goto targets.

The funny thing is that the names of the goto targets and the related comments
were correct.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d481c99a20d7..6afd79ee3340 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5132,12 +5132,12 @@ static void hub_events(void)
 
  loop_autopm:
 		/* Balance the usb_autopm_get_interface() above */
-		usb_autopm_put_interface_no_suspend(intf);
+		usb_autopm_put_interface(intf);
  loop:
 		/* Balance the usb_autopm_get_interface_no_resume() in
 		 * kick_khubd() and allow autosuspend.
 		 */
-		usb_autopm_put_interface(intf);
+		usb_autopm_put_interface_no_suspend(intf);
  loop_disconnected:
 		usb_unlock_device(hdev);
 		usb_put_dev(hdev);
-- 
1.8.4

