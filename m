Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaKDSJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:09:38 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:50788 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbaKDSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:09:22 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: comedi: add ioctls to set per-file read and write subdevice
Date: Tue,  4 Nov 2014 18:09:01 +0000
Message-Id: <1415124541-13648-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
References: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Comedi has the structures in place to support setting the
current "read" and/or "write" subdevice on a per-file object basis, add
new ioctls to set them.  The newly chosen "read" ("write") subdevice
needs to support "read" ("write") commands, and the file cannot be busy
handling a "read" ("write") command on the previous subdevice (if any).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi.h          |  2 +
 drivers/staging/comedi/comedi_compat32.c |  2 +
 drivers/staging/comedi/comedi_fops.c     | 90 ++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index f302ce6..7455740 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -367,6 +367,8 @@ enum comedi_support_level {
 #define COMEDI_BUFCONFIG _IOR(CIO, 13, struct comedi_bufconfig)
 #define COMEDI_BUFINFO _IOWR(CIO, 14, struct comedi_bufinfo)
 #define COMEDI_POLL _IO(CIO, 15)
+#define COMEDI_SETRSUBD _IO(CIO, 16)
+#define COMEDI_SETWSUBD _IO(CIO, 17)
 
 /* structures */
 
diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 9b6f96f..5a4c74f 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -416,6 +416,8 @@ static inline int raw_ioctl(struct file *file, unsigned int cmd,
 	case COMEDI_UNLOCK:
 	case COMEDI_CANCEL:
 	case COMEDI_POLL:
+	case COMEDI_SETRSUBD:
+	case COMEDI_SETWSUBD:
 		/* No translation needed. */
 		rc = translated_ioctl(file, cmd, arg);
 		break;
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 79b852c..f143cb6 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1847,6 +1847,90 @@ static int do_poll_ioctl(struct comedi_device *dev, unsigned long arg,
 	return -EINVAL;
 }
 
+/*
+ * COMEDI_SETRSUBD ioctl
+ * sets the current "read" subdevice on a per-file basis
+ *
+ * arg:
+ *	subdevice number
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	nothing
+ */
+static int do_setrsubd_ioctl(struct comedi_device *dev, unsigned long arg,
+			     struct file *file)
+{
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_subdevice *s_old, *s_new;
+
+	if (arg >= dev->n_subdevices)
+		return -EINVAL;
+
+	s_new = &dev->subdevices[arg];
+	s_old = comedi_file_read_subdevice(file);
+	if (s_old == s_new)
+		return 0;	/* no change */
+
+	if (!(s_new->subdev_flags & SDF_CMD_READ))
+		return -EINVAL;
+
+	/*
+	 * Check the file isn't still busy handling a "read" command on the
+	 * old subdevice (if any).
+	 */
+	if (s_old && s_old->busy == file && s_old->async &&
+	    !(s_old->async->cmd.flags & CMDF_WRITE))
+		return -EBUSY;
+
+	ACCESS_ONCE(cfp->read_subdev) = s_new;
+	return 0;
+}
+
+/*
+ * COMEDI_SETWSUBD ioctl
+ * sets the current "write" subdevice on a per-file basis
+ *
+ * arg:
+ *	subdevice number
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	nothing
+ */
+static int do_setwsubd_ioctl(struct comedi_device *dev, unsigned long arg,
+			     struct file *file)
+{
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_subdevice *s_old, *s_new;
+
+	if (arg >= dev->n_subdevices)
+		return -EINVAL;
+
+	s_new = &dev->subdevices[arg];
+	s_old = comedi_file_write_subdevice(file);
+	if (s_old == s_new)
+		return 0;	/* no change */
+
+	if (!(s_new->subdev_flags & SDF_CMD_WRITE))
+		return -EINVAL;
+
+	/*
+	 * Check the file isn't still busy handling a "write" command on the
+	 * old subdevice (if any).
+	 */
+	if (s_old && s_old->busy == file && s_old->async &&
+	    (s_old->async->cmd.flags & CMDF_WRITE))
+		return -EBUSY;
+
+	ACCESS_ONCE(cfp->write_subdev) = s_new;
+	return 0;
+}
+
 static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -1941,6 +2025,12 @@ static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 	case COMEDI_POLL:
 		rc = do_poll_ioctl(dev, arg, file);
 		break;
+	case COMEDI_SETRSUBD:
+		rc = do_setrsubd_ioctl(dev, arg, file);
+		break;
+	case COMEDI_SETWSUBD:
+		rc = do_setwsubd_ioctl(dev, arg, file);
+		break;
 	default:
 		rc = -ENOTTY;
 		break;
-- 
2.1.1

