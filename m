Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3EVM6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:58:45 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:50087 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752744Ab3EVM6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:58:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Vasiliy Kulikov <segooon@gmail.com>, Thomas Renninger <trenn@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH -resend 5/6] acpi: ec_sys: access user space with get_user()/put_user()
Date: Wed, 22 May 2013 14:59:11 +0200
Message-Id: <1369227552-11743-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
References: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

User space pointer may not be dereferenced. Use get_user()/put_user()
instead and check their return codes.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/ec_sys.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index 7586544..4e7b798 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -12,6 +12,7 @@
 #include <linux/acpi.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include "internal.h"
 
 MODULE_AUTHOR("Thomas Renninger <trenn@suse.de>");
@@ -34,7 +35,6 @@ static ssize_t acpi_ec_read_io(struct file *f, char __user *buf,
 	 * struct acpi_ec *ec = ((struct seq_file *)f->private_data)->private;
 	 */
 	unsigned int size = EC_SPACE_SIZE;
-	u8 *data = (u8 *) buf;
 	loff_t init_off = *off;
 	int err = 0;
 
@@ -47,9 +47,15 @@ static ssize_t acpi_ec_read_io(struct file *f, char __user *buf,
 		size = count;
 
 	while (size) {
-		err = ec_read(*off, &data[*off - init_off]);
+		u8 byte_read;
+		err = ec_read(*off, &byte_read);
 		if (err)
 			return err;
+		if (put_user(byte_read, buf + *off - init_off)) {
+			if (*off - init_off)
+				return *off - init_off; /* partial read */
+			return -EFAULT;
+		}
 		*off += 1;
 		size--;
 	}
@@ -65,7 +71,6 @@ static ssize_t acpi_ec_write_io(struct file *f, const char __user *buf,
 
 	unsigned int size = count;
 	loff_t init_off = *off;
-	u8 *data = (u8 *) buf;
 	int err = 0;
 
 	if (*off >= EC_SPACE_SIZE)
@@ -76,7 +81,12 @@ static ssize_t acpi_ec_write_io(struct file *f, const char __user *buf,
 	}
 
 	while (size) {
-		u8 byte_write = data[*off - init_off];
+		u8 byte_write;
+		if (get_user(byte_write, buf + *off - init_off)) {
+			if (*off - init_off)
+				return *off - init_off; /* partial write */
+			return -EFAULT;
+		}
 		err = ec_write(*off, byte_write);
 		if (err)
 			return err;
-- 
1.8.2.3

