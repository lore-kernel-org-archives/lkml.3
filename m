Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbaDVU2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:28:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbaDVUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:25:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lennart Poettering <lennart@poettering.net>, Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>,
        Hannes Reinecke <hare@suse.de>, David Herrmann <dh.herrmann@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 043/133] tty: Set correct tty name in 'active' sysfs attribute
Date: Tue, 22 Apr 2014 13:13:01 -0700
Message-Id: <1398197671-12786-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

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
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/tty_io.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index f34f98d..70f8c19 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1221,12 +1221,13 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
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
@@ -3472,9 +3473,19 @@ static ssize_t show_cons_active(struct device *dev,
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
1.9.1

