Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3APP70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab3APP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 031/222] cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)
Date: Wed, 16 Jan 2013 13:53:51 -0200
Message-Id: <1358351822-7675-32-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit ba2d8ce9db0a61505362bb17b8899df3d3326146 upstream.

Some devices (ex Nokia C7) simply don't respond at all when data is sent
to some of their USB interfaces.  The data gets stuck in the TTYs queue
and sits there until close(2), which them blocks because closing_wait
defaults to 30 seconds (even though the fd is O_NONBLOCK).  This is
rarely desired.  Implement the standard mechanism to adjust closing_wait
and let applications handle it how they want to.

See also 02303f73373aa1da19dbec510ec5a4e2576f9610 for usb_wwan.c.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
Tested-by: Aleksander Morgado <aleksander@gnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/class/cdc-acm.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 780e0d0..d8104c4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -788,6 +788,10 @@ static int get_serial_info(struct acm *acm, struct serial_struct __user *info)
 	tmp.flags = ASYNC_LOW_LATENCY;
 	tmp.xmit_fifo_size = acm->writesize;
 	tmp.baud_base = le32_to_cpu(acm->line.dwDTERate);
+	tmp.close_delay	= acm->port.close_delay / 10;
+	tmp.closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+				ASYNC_CLOSING_WAIT_NONE :
+				acm->port.closing_wait / 10;
 
 	if (copy_to_user(info, &tmp, sizeof(tmp)))
 		return -EFAULT;
@@ -795,6 +799,37 @@ static int get_serial_info(struct acm *acm, struct serial_struct __user *info)
 		return 0;
 }
 
+static int set_serial_info(struct acm *acm,
+				struct serial_struct __user *newinfo)
+{
+	struct serial_struct new_serial;
+	unsigned int closing_wait, close_delay;
+	int retval = 0;
+
+	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
+		return -EFAULT;
+
+	close_delay = new_serial.close_delay * 10;
+	closing_wait = new_serial.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+			ASYNC_CLOSING_WAIT_NONE : new_serial.closing_wait * 10;
+
+	mutex_lock(&acm->port.mutex);
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		if ((close_delay != acm->port.close_delay) ||
+		    (closing_wait != acm->port.closing_wait))
+			retval = -EPERM;
+		else
+			retval = -EOPNOTSUPP;
+	} else {
+		acm->port.close_delay  = close_delay;
+		acm->port.closing_wait = closing_wait;
+	}
+
+	mutex_unlock(&acm->port.mutex);
+	return retval;
+}
+
 static int acm_tty_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
@@ -805,6 +840,9 @@ static int acm_tty_ioctl(struct tty_struct *tty,
 	case TIOCGSERIAL: /* gets serial port data */
 		rv = get_serial_info(acm, (struct serial_struct __user *) arg);
 		break;
+	case TIOCSSERIAL:
+		rv = set_serial_info(acm, (struct serial_struct __user *) arg);
+		break;
 	}
 
 	return rv;
-- 
1.7.9.5

