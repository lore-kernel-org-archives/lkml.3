Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3B1Oqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab3B1Oq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 017/139] staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
Date: Thu, 28 Feb 2013 14:42:47 +0000
Message-Id: <1362062689-2567-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d231193..2831080 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -425,6 +425,11 @@ static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
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
-- 
1.8.1.2

