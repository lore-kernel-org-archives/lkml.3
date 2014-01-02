Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaABMMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaABMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH, RFC 16/30] tty: synclink: avoid sleep_on race
Date: Thu,  2 Jan 2014 13:07:40 +0100
Message-Id: <1388664474-1710039-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DmqbBdHHFcDid4D39VTLHpUweiUTUpx2pelxLh5YGr6
 uTnhq5ygeUbw3Ps2WrtCtLDD3Nn2wjCd+Z/kHYBo/Hq8HahE3l
 +m8SEUv/dzSPQUAkVVEzkj/3tp5Vpgl0AQp5UrpXud2tlC6PcF
 L/JP8q/LsSnd6hcLwJYzufqa9eZ2odka5wOhVN7zkKYCiGBKrR
 OblNJ3hHQevp517lEK/i1+AKcRbiKZI42ykwP5HVQq9JyLZQo/
 zhReRGWZPkWzTe3pZoGifY+NIN8xPDRXsIKNgfuq+nIKXWwDla
 qhrVOfYFcnt8Fo8uQCpESg+l0FbcaYCjr3kGY7ErJzWc9uEcXF
 9HUDANhxXGI2zxmChd6632Vu6qruiT+UbHbGGBzcs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The four variants of the synclink driver use the same code in their
open() callback to wait for a port in process of being closed,
using interruptible_sleep_on, which is racy and going away soon.

Making things worse, these functions hold the BTM while doing so,
which means that if we ever enter this code path, we cannot actually
continue since the other thread that is in process of closing the
port can no longer get the BTM.

This addresses both issues by using wait_event_interruptible_tty()
instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/pcmcia/synclink_cs.c | 4 ++--
 drivers/tty/synclink.c            | 4 ++--
 drivers/tty/synclink_gt.c         | 4 ++--
 drivers/tty/synclinkmp.c          | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index d39cca6..8320abd 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2511,8 +2511,8 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 
 	/* If port is closing, signal caller to try again */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING){
-		if (port->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&port->close_wait);
+		wait_event_interruptible_tty(tty, port->close_wait,
+					     !(port->flags & ASYNC_CLOSING));
 		retval = ((port->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 		goto cleanup;
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index e1ce141..5ae14b4 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3404,8 +3404,8 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 
 	/* If port is closing, signal caller to try again */
 	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
-		if (info->port.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->port.close_wait);
+		wait_event_interruptible_tty(tty, info->port.close_wait,
+				     !(info->port.flags & ASYNC_CLOSING));
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 		goto cleanup;
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 1abf946..c359a91 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -674,8 +674,8 @@ static int open(struct tty_struct *tty, struct file *filp)
 
 	/* If port is closing, signal caller to try again */
 	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
-		if (info->port.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->port.close_wait);
+		wait_event_interruptible_tty(tty, info->port.close_wait,
+					     !(info->port.flags & ASYNC_CLOSING));
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 		goto cleanup;
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index dc6e969..144202e 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -754,8 +754,8 @@ static int open(struct tty_struct *tty, struct file *filp)
 
 	/* If port is closing, signal caller to try again */
 	if (tty_hung_up_p(filp) || info->port.flags & ASYNC_CLOSING){
-		if (info->port.flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->port.close_wait);
+		wait_event_interruptible_tty(tty, info->port.close_wait,
+					     !(info->port.flags & ASYNC_CLOSING));
 		retval = ((info->port.flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
 		goto cleanup;
-- 
1.8.3.2

