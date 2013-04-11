Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322Ab3DKN2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab3DKN2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 05/26] comedi: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Schleef <ds@schleef.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>, viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:28:19 +0100
Message-ID: <20130411132819.32763.72806.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: David Schleef <ds@schleef.org>
cc: Ian Abbott <abbotti@mev.co.uk>
cc: Mori Hess <fmhess@users.sourceforge.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: H Hartley Sweeten <hsweeten@visionengravers.com>
cc: devel@driverdev.osuosl.org
---

 drivers/staging/comedi/proc.c |   52 ++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/proc.c b/drivers/staging/comedi/proc.c
index f01e0cc..db790f9 100644
--- a/drivers/staging/comedi/proc.c
+++ b/drivers/staging/comedi/proc.c
@@ -31,17 +31,15 @@
 #include "comedidev.h"
 #include "comedi_internal.h"
 #include <linux/proc_fs.h>
-#include <linux/string.h>
+#include <linux/seq_file.h>
 
-static int comedi_read(char *buf, char **start, off_t offset, int len,
-		       int *eof, void *data)
+static int comedi_read(struct seq_file *m, void *v)
 {
 	int i;
 	int devices_q = 0;
-	int l = 0;
 	struct comedi_driver *driv;
 
-	l += sprintf(buf + l,
+	seq_printf(m,
 		     "comedi version " COMEDI_RELEASE "\n"
 		     "format string: %s\n",
 		     "\"%2d: %-20s %-20s %4d\", i, "
@@ -49,39 +47,51 @@ static int comedi_read(char *buf, char **start, off_t offset, int len,
 
 	for (i = 0; i < COMEDI_NUM_BOARD_MINORS; i++) {
 		struct comedi_device *dev = comedi_dev_from_minor(i);
-
 		if (!dev)
 			continue;
 
 		if (dev->attached) {
 			devices_q = 1;
-			l += sprintf(buf + l, "%2d: %-20s %-20s %4d\n",
-				     i,
-				     dev->driver->driver_name,
-				     dev->board_name, dev->n_subdevices);
+			seq_printf(m, "%2d: %-20s %-20s %4d\n",
+				   i, dev->driver->driver_name,
+				   dev->board_name, dev->n_subdevices);
 		}
 	}
 	if (!devices_q)
-		l += sprintf(buf + l, "no devices\n");
+		seq_puts(m, "no devices\n");
 
 	for (driv = comedi_drivers; driv; driv = driv->next) {
-		l += sprintf(buf + l, "%s:\n", driv->driver_name);
-		for (i = 0; i < driv->num_names; i++) {
-			l += sprintf(buf + l, " %s\n",
-				     *(char **)((char *)driv->board_name +
-						i * driv->offset));
-		}
+		seq_printf(m, "%s:\n", driv->driver_name);
+		for (i = 0; i < driv->num_names; i++)
+			seq_printf(m, " %s\n",
+				   *(char **)((char *)driv->board_name +
+					      i * driv->offset));
+
 		if (!driv->num_names)
-			l += sprintf(buf + l, " %s\n", driv->driver_name);
+			seq_printf(m, " %s\n", driv->driver_name);
 	}
 
-	return l;
+	return 0;
+}
+
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int comedi_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, comedi_read, NULL);
 }
 
+static const struct file_operations comedi_proc_fops = {
+	.open		= comedi_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 void comedi_proc_init(void)
 {
-	create_proc_read_entry("comedi", S_IFREG | S_IRUGO, NULL,
-				comedi_read, NULL);
+	proc_create("comedi", 0644, NULL, &comedi_proc_fops);
 }
 
 void comedi_proc_cleanup(void)

