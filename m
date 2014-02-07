Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBGKie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:38:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaBGKid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:38:33 -0500
From: Hannes Reinecke <hare@suse.de>
To: systemd-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Werner Fink <werner@suse.de>
Subject: [PATCHv3] tty: Set correct tty name in 'active' sysfs attribute
Date: Fri,  7 Feb 2014 11:38:30 +0100
Message-Id: <1391769510-123271-1-git-send-email-hare@suse.de>
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

Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/ABI/testing/sysfs-tty |  3 ++-
 drivers/tty/tty_io.c                | 25 ++++++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-tty b/Documentation/ABI/testing/sysfs-tty
index ad22fb0..a2ccec3 100644
--- a/Documentation/ABI/testing/sysfs-tty
+++ b/Documentation/ABI/testing/sysfs-tty
@@ -3,7 +3,8 @@ Date:		Nov 2010
 Contact:	Kay Sievers <kay.sievers@vrfy.org>
 Description:
 		 Shows the list of currently configured
-		 console devices, like 'tty1 ttyS0'.
+		 tty devices used for the console,
+		 like 'tty1 ttyS0'.
 		 The last entry in the file is the active
 		 device connected to /dev/console.
 		 The file supports poll() to detect virtual
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..bd2715a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1267,16 +1267,17 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
  *	@p: output buffer of at least 7 bytes
  *
  *	Generate a name from a driver reference and write it to the output
- *	buffer.
+ *	buffer. Return the number of bytes written.
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
+		struct tty_driver *driver;
+		const char *name = cs[i]->name;
+		int index = cs[i]->index;
+
+		driver = cs[i]->device(cs[i], &index);
+		if (driver) {
+			count += tty_line_name(driver, index, buf + count);
+			count += sprintf(buf + count, "%c", i ? ' ':'\n');
+		} else
+			count += sprintf(buf + count, "%s%d%c",
+					 name, index, i ? ' ':'\n');
+	}
 	console_unlock();
 
 	return count;
-- 
1.7.12.4

