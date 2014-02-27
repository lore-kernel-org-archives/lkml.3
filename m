Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaB0Lba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:31:30 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48158 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaB0Lb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:31:28 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ray Strode <halfline@gmail.com>, Werner Fink <werner@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v3] tty: Set correct tty name in 'active' sysfs attribute
Date: Thu, 27 Feb 2014 12:30:51 +0100
Message-Id: <1393500651-1064-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
v2: use cs[i]->index instead of ->index
    refactor code to avoid >80 lines
    split out sprintf("%c",...);

Tested on my x86-64 machine.

David

 drivers/tty/tty_io.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..d3448a9 100644
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
1.9.0

