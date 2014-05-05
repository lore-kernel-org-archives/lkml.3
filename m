Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbaEEM6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:58:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40979 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        Werner Fink <werner@suse.de>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 3.12 32/50] tty: Set correct tty name in 'active' sysfs attribute
Date: Mon,  5 May 2014 14:43:14 +0200
Message-Id: <8351a31147e36d656ce17846d38235dabbd63a5f.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 723abd87f6e536f1353c8f64f621520bc29523a3 upstream.

The 'active' sysfs attribute should refer to the currently active tty
devices the console is running on, not the currently active console. The
console structure doesn't refer to any device in sysfs, only the tty the
console is running on has. So we need to print out the tty names in
'active', not the console names.

There is one special-case, which is tty0. If the console is directed to
it, we want 'tty0' to show up in the file, so user-space knows that the
messages get forwarded to the active VT. The ->device() callback would
resolve tty0, though. Hence, treat it special and don't call into the VT
layer to resolve it (plymouth is known to depend on it).

Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00ad7add..d3448a90f0f9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1271,12 +1271,13 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
  *
  *	Locking: None
  */
-static void tty_line_name(struct tty_driver *driver, int index, char *p)
+static ssize_t tty_line_name(struct tty_driver *driver, int index, char *p)
 {
 	if (driver->flags & TTY_DRIVER_UNNUMBERED_NODE)
-		strcpy(p, driver->name);
+		return sprintf(p, "%s", driver->name);
 	else
-		sprintf(p, "%s%d", driver->name, index + driver->name_base);
+		return sprintf(p, "%s%d", driver->name,
+			       index + driver->name_base);
 }
 
 /**
@@ -3545,9 +3546,19 @@ static ssize_t show_cons_active(struct device *dev,
 		if (i >= ARRAY_SIZE(cs))
 			break;
 	}
-	while (i--)
-		count += sprintf(buf + count, "%s%d%c",
-				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
+	while (i--) {
+		int index = cs[i]->index;
+		struct tty_driver *drv = cs[i]->device(cs[i], &index);
+
+		/* don't resolve tty0 as some programs depend on it */
+		if (drv && (cs[i]->index > 0 || drv->major != TTY_MAJOR))
+			count += tty_line_name(drv, index, buf + count);
+		else
+			count += sprintf(buf + count, "%s%d",
+					 cs[i]->name, cs[i]->index);
+
+		count += sprintf(buf + count, "%c", i ? ' ':'\n');
+	}
 	console_unlock();
 
 	return count;
-- 
1.9.2

