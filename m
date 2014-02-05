Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaBEKLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:11:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaBEKLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:11:50 -0500
From: Hannes Reinecke <hare@suse.de>
To: systemd-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Werner Fink <werner@suse.de>
Subject: [PATCH] tty: Set correct tty name in 'active' sysfs attribute
Date: Wed,  5 Feb 2014 11:11:46 +0100
Message-Id: <1391595106-86957-1-git-send-email-hare@suse.de>
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
Signed-off-by: Werner Fink <werner@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/tty/tty_io.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..17db8ca 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3545,9 +3545,19 @@ static ssize_t show_cons_active(struct device *dev,
 		if (i >= ARRAY_SIZE(cs))
 			break;
 	}
-	while (i--)
+	while (i--) {
+		const struct tty_driver *driver;
+		const char *name = cs[i]->name;
+		int index = cs[i]->index;
+
+		driver = cs[i]->device(cs[i], &index);
+		if (driver) {
+			index += driver->name_base;
+			name = driver->name;
+		}
 		count += sprintf(buf + count, "%s%d%c",
-				 cs[i]->name, cs[i]->index, i ? ' ':'\n');
+				 name, index, i ? ' ':'\n');
+	}
 	console_unlock();
 
 	return count;
-- 
1.7.12.4

