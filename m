Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaIISOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:14:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49426 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaIISO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:14:26 -0400
Date: Tue, 9 Sep 2014 11:14:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: serport: Add compat_ioctl routine to support
 32bit inputattach in 64bit systems
Message-ID: <20140909181421.GB28774@core.coreip.homeip.net>
References: <1410240028-9377-1-git-send-email-penmount.touch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410240028-9377-1-git-send-email-penmount.touch@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, Sep 09, 2014 at 01:20:28PM +0800, John Sung wrote:
> When running a 32-bit inputattach utility in a 64-bit system, there will be error code "inputattach: can't set device type". This is caused by the serport device driver not supporting compat_ioctl, so that SPIOCSTYPE ioctl fails.
> 
> Changes in v2:
> (1) Codes of the compat_ioctl are protected by #ifdef CONFIG_COMPAT.
> (2) Add a new function serport_set_type() for common codes used by serport_ldisc_ioctl() and serport_ldisc_compat_ioctl().
> 
> Signed-off-by: John Sung <penmount.touch@gmail.com>
> ---
>  drivers/input/serio/serport.c |   57 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 46 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
> index 0cb7ef5..1decaa2 100644
> --- a/drivers/input/serio/serport.c
> +++ b/drivers/input/serio/serport.c
> @@ -22,6 +22,10 @@
>  #include <linux/serio.h>
>  #include <linux/tty.h>
>  
> +#ifdef CONFIG_COMPAT
> +#include <linux/compat.h>
> +#endif
> +
>  MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
>  MODULE_DESCRIPTION("Input device TTY line discipline");
>  MODULE_LICENSE("GPL");
> @@ -40,6 +44,30 @@ struct serport {
>  	unsigned long flags;
>  };
>  
> +#ifdef CONFIG_COMPAT
> +#define SPIOCSTYPE32 (_IOW('q', 0x01, compat_ulong_t))
> +#endif
> +
> +/*
> + * serport_set_type() is called by serport_ldisc_ioctl() and
> + * serport_ldisc_compat_ioctl() to set up the serio_device_id values
> + */
> +
> +static int serport_set_type(struct tty_struct *tty, unsigned long arg)
> +{
> +	struct serport *serport = (struct serport *) tty->disc_data;
> +	unsigned long type;
> +
> +	if (get_user(type, (unsigned long __user *) arg))
> +		return -EFAULT;

I of not think we can do this. Kernel with try to fetch 64 bits from
where userland put only 32. It probbaly works on little-endian
architectures by chance, but won't on big endian.

Does the version of the patch below work for you?

Thanks.

-- 
Dmitry


Input: serport - add compat handling for SPIOCSTYPE ioctl

From: John Sung <penmount.touch@gmail.com>

When running a 32-bit inputattach utility in a 64-bit system, there will be
error code "inputattach: can't set device type". This is caused by the
serport device driver not supporting compat_ioctl, so that SPIOCSTYPE ioctl
fails.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/serio/serport.c |   45 +++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 0cb7ef5..69175b8 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/serio.h>
 #include <linux/tty.h>
+#include <linux/compat.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Input device TTY line discipline");
@@ -198,28 +199,55 @@ static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, u
 	return 0;
 }
 
+static void serport_set_type(struct tty_struct *tty, unsigned long type)
+{
+	struct serport *serport = tty->disc_data;
+
+	serport->id.proto = type & 0x000000ff;
+	serport->id.id    = (type & 0x0000ff00) >> 8;
+	serport->id.extra = (type & 0x00ff0000) >> 16;
+}
+
 /*
  * serport_ldisc_ioctl() allows to set the port protocol, and device ID
  */
 
-static int serport_ldisc_ioctl(struct tty_struct * tty, struct file * file, unsigned int cmd, unsigned long arg)
+static int serport_ldisc_ioctl(struct tty_struct *tty, struct file *file,
+			       unsigned int cmd, unsigned long arg)
 {
-	struct serport *serport = (struct serport*) tty->disc_data;
-	unsigned long type;
-
 	if (cmd == SPIOCSTYPE) {
+		unsigned long type;
+
 		if (get_user(type, (unsigned long __user *) arg))
 			return -EFAULT;
 
-		serport->id.proto = type & 0x000000ff;
-		serport->id.id	  = (type & 0x0000ff00) >> 8;
-		serport->id.extra = (type & 0x00ff0000) >> 16;
+		serport_set_type(tty, type);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+#ifdef CONFIG_COMPAT
+#define COMPAT_SPIOCSTYPE	_IOW('q', 0x01, compat_ulong_t)
+static long serport_ldisc_compat_ioctl(struct tty_struct *tty,
+				       struct file *file,
+				       unsigned int cmd, unsigned long arg)
+{
+	if (cmd == COMPAT_SPIOCSTYPE) {
+		void __user *uarg = compat_ptr(arg);
+		compat_ulong_t compat_type;
+
+		if (get_user(compat_type, (compat_ulong_t __user *)uarg))
+			return -EFAULT;
 
+		serport_set_type(tty, compat_type);
 		return 0;
 	}
 
 	return -EINVAL;
 }
+#endif
 
 static void serport_ldisc_write_wakeup(struct tty_struct * tty)
 {
@@ -243,6 +271,9 @@ static struct tty_ldisc_ops serport_ldisc = {
 	.close =	serport_ldisc_close,
 	.read =		serport_ldisc_read,
 	.ioctl =	serport_ldisc_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl =	serport_ldisc_compat_ioctl,
+#endif
 	.receive_buf =	serport_ldisc_receive,
 	.write_wakeup =	serport_ldisc_write_wakeup
 };
