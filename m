Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3B0ARz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:17:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933555Ab3B0AJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 55/86] staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
Date: Tue, 26 Feb 2013 16:08:03 -0800
Message-Id: <20130226235918.629572558@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 754ab5c0e55dd118273ca2c217c4d95e9fbc8259 upstream.

Comedi has two sorts of minor devices:
(a) normal board minor devices in the range 0 to
COMEDI_NUM_BOARD_MINORS-1 inclusive; and
(b) special subdevice minor devices in the range COMEDI_NUM_BOARD_MINORS
upwards that are used to open the same underlying comedi device as the
normal board minor devices, but with non-default read and write
subdevices for asynchronous commands.

The special subdevice minor devices get created when a board supporting
asynchronous commands is attached to a normal board minor device, and
destroyed when the board is detached from the normal board minor device.
One way to attach or detach a board is by using the COMEDI_DEVCONFIG
ioctl.  This should only be used on normal board minors as the special
subdevice minors are too ephemeral.  In particular, the change
introduced in commit 7d3135af399e92cf4c9bbc5f86b6c140aab3b88c ("staging:
comedi: prevent auto-unconfig of manually configured devices") breaks
horribly for special subdevice minor devices.

Since there's no legitimate use for the COMEDI_DEVCONFIG ioctl on a
special subdevice minor device node, disallow it and return -ENOTTY.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -136,6 +136,11 @@ static long comedi_unlocked_ioctl(struct
 	/* Device config is special, because it must work on
 	 * an unconfigured device. */
 	if (cmd == COMEDI_DEVCONFIG) {
+		if (minor >= COMEDI_NUM_BOARD_MINORS) {
+			/* Device config not appropriate on non-board minors. */
+			rc = -ENOTTY;
+			goto done;
+		}
 		rc = do_devconfig_ioctl(dev,
 					(struct comedi_devconfig __user *)arg);
 		if (rc == 0)


