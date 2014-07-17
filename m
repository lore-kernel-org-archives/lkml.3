Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaGQRmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:42:03 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:40061 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbaGQRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:42:01 -0400
From: Khalid Aziz <khalid.aziz@oracle.com>
To: davem@davemloft.net
Cc: Khalid Aziz <khalid.aziz@oracle.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] sparc: Add support for seek and shorter read to /dev/mdesc
Date: Thu, 17 Jul 2014 11:41:50 -0600
Message-Id: <1405618910-17667-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/dev/mdesc on Linux does not support reading arbitrary number
of bytes and seeking while /dev/mdesc on Solaris does. This
causes tools that work on Solaris to break on Linux. This patch
adds these two capabilities to /dev/mdesc.

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
v2:
	- Cleaned up code in mdesc_read() and mdesc_llseek() to be
	  more readable

 arch/sparc/kernel/mdesc.c | 80 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 13 deletions(-)

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index a1a4400..be7d245 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -906,29 +906,83 @@ void mdesc_fill_in_cpu_data(cpumask_t *mask)
 	smp_fill_in_sib_core_maps();
 }
 
-static ssize_t mdesc_read(struct file *file, char __user *buf,
-			  size_t len, loff_t *offp)
+/* mdesc_open() - Grab a reference to mdesc_handle when /dev/mdesc is
+ *	opened. Hold this reference until /dev/mdesc is closed to ensure
+ *	mdesc data structure is not released underneath us. Store the
+ *	pointer to mdesc structure in private_data for read and seek to use
+ */
+static int mdesc_open(struct inode *inode, struct file *file)
 {
 	struct mdesc_handle *hp = mdesc_grab();
-	int err;
 
 	if (!hp)
 		return -ENODEV;
 
-	err = hp->handle_size;
-	if (len < hp->handle_size)
-		err = -EMSGSIZE;
-	else if (copy_to_user(buf, &hp->mdesc, hp->handle_size))
-		err = -EFAULT;
-	mdesc_release(hp);
+	file->private_data = hp;
+	return 0;
+}
 
-	return err;
+static ssize_t mdesc_read(struct file *file, char __user *buf,
+			  size_t len, loff_t *offp)
+{
+	struct mdesc_handle *hp = file->private_data;
+	unsigned char *mdesc;
+	int bytes_left, count = len;
+
+	if (*offp >= hp->handle_size)
+		return 0;
+
+	bytes_left = hp->handle_size - *offp;
+	if (count > bytes_left)
+		count = bytes_left;
+
+	mdesc = (unsigned char *)&hp->mdesc;
+	mdesc += *offp;
+	if (!copy_to_user(buf, mdesc, count)) {
+		*offp += count;
+		return count;
+	} else {
+		return -EFAULT;
+	}
+}
+
+static loff_t mdesc_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct mdesc_handle *hp;
+
+	switch (whence) {
+	case SEEK_CUR:
+		offset += file->f_pos;
+		break;
+	case SEEK_SET:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hp = file->private_data;
+	if (offset > hp->handle_size)
+		return -EINVAL;
+	else
+		file->f_pos = offset;
+	return offset;
+}
+
+/* mdesc_close() - /dev/mdesc is being closed, release the reference to
+ *	mdesc structure.
+ */
+static int mdesc_close(struct inode *inode, struct file *file)
+{
+	mdesc_release(file->private_data);
+	return 0;
 }
 
 static const struct file_operations mdesc_fops = {
-	.read	= mdesc_read,
-	.owner	= THIS_MODULE,
-	.llseek = noop_llseek,
+	.open    = mdesc_open,
+	.read	 = mdesc_read,
+	.llseek  = mdesc_llseek,
+	.release = mdesc_close,
+	.owner	 = THIS_MODULE,
 };
 
 static struct miscdevice mdesc_misc = {
-- 
1.9.1

