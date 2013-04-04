Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764921Ab3DDUcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:32:50 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51049 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764854Ab3DDUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:32:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 2/5] MEDIA: ttusbir, fix double free
Date: Thu,  4 Apr 2013 22:32:09 +0200
Message-Id: <1365107532-32721-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rc_unregister_device already calls rc_free_device to free the passed
device. But in one of ttusbir's probe fail paths, we call
rc_unregister_device _and_ rc_free_device. This is wrong and results
in a double free.

Instead, set rc to NULL resulting in rc_free_device being a noop.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/ttusbir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index cf0d47f..891762d 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -347,6 +347,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	return 0;
 out3:
 	rc_unregister_device(rc);
+	rc = NULL;
 out2:
 	led_classdev_unregister(&tt->led);
 out:
-- 
1.8.2


