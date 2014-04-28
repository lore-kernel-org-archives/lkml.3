Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaD1BcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42994 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hannes Reinecke" <hare@suse.de>,
        "Werner Fink" <werner@suse.de>,
        "David Herrmann" <dh.herrmann@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Kay Sievers" <kay@vrfy.org>,
        "Lennart Poettering" <lennart@poettering.net>,
        "Jiri Slaby" <jslaby@suse.cz>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.248632447@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 34/94] tty: Set correct tty name in 'active' sysfs
 attribute
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: no TTY_DRIVER_UNNUMBERED_NODE case in tty_line_name()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/tty_io.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1222,9 +1222,9 @@ static void pty_line_name(struct tty_dri
  *
  *	Locking: None
  */
-static void tty_line_name(struct tty_driver *driver, int index, char *p)
+static ssize_t tty_line_name(struct tty_driver *driver, int index, char *p)
 {
-	sprintf(p, "%s%d", driver->name, index + driver->name_base);
+	return sprintf(p, "%s%d", driver->name, index + driver->name_base);
 }
 
 /**
@@ -3321,9 +3321,19 @@ static ssize_t show_cons_active(struct d
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

