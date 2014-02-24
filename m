Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaBXOu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:50:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbaBXOuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:50:55 -0500
From: Hannes Reinecke <hare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ray Strode <halfline@gmail.com>, David Herrmann <dh.herrmann@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>
Subject: [PATCHv3] tty: Set correct tty name in 'active' sysfs attribute
Date: Mon, 24 Feb 2014 15:50:50 +0100
Message-Id: <1393253450-12217-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'active' sysfs attribute should refer to the currently
active tty devices the console is running on, not the currently
active console.
The console structure doesn't refer to any device in sysfs,
only the tty the console is running on has.
So we need to print out the tty names in 'active', not
the console names.
But we need to take care for the virtual console to always display
'tty0' so as not to break existing programs.

Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/tty/tty_io.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..96eb462 100644
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
@@ -3545,9 +3546,20 @@ static ssize_t show_cons_active(struct device *dev,
 		if (i >= ARRAY_SIZE(cs))
 			break;
 	}
-	while (i--)
-		count += sprintf(buf + count, "%s%d%c",
-				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
+	while (i--) {
+		struct tty_driver *driver;
+		const char *name = cs[i]->name;
+		int index = cs[i]->index;
+
+		driver = cs[i]->device(cs[i], &index);
+		/* Some programs rely on 'tty0' for console */
+		if (driver && (index > 0 || driver->major != TTY_MAJOR)) {
+			count += tty_line_name(driver, index, buf + count);
+			count += sprintf(buf + count, "%c", i ? ' ':'\n');
+		} else
+			count += sprintf(buf + count, "%s%d%c",
+					 name, cs[i]->index, i ? ' ':'\n');
+	}
 	console_unlock();
 
 	return count;
-- 
1.7.12.4

