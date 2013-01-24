Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3AXD34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:29:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3AXD3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 28/74] staging: comedi: prevent auto-unconfig of manually configured devices
Date: Thu, 24 Jan 2013 01:26:40 -0200
Message-Id: <1358998046-613-29-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 7d3135af399e92cf4c9bbc5f86b6c140aab3b88c upstream.

When a low-level comedi driver auto-configures a device, a `struct
comedi_dev_file_info` is allocated (as well as a `struct
comedi_device`) by `comedi_alloc_board_minor()`.  A pointer to the
hardware `struct device` is stored as a cookie in the `struct
comedi_dev_file_info`.  When the low-level comedi driver
auto-unconfigures the device, `comedi_auto_unconfig()` uses the cookie
to find the `struct comedi_dev_file_info` so it can detach the comedi
device from the driver, clean it up and free it.

A problem arises if the user manually unconfigures and reconfigures the
comedi device using the `COMEDI_DEVCONFIG` ioctl so that is no longer
associated with the original hardware device.  The problem is that the
cookie is not cleared, so that a call to `comedi_auto_unconfig()` from
the low-level driver will still find it, detach it, clean it up and free
it.

Stop this problem occurring by always clearing the `hardware_device`
cookie in the `struct comedi_dev_file_info` whenever the
`COMEDI_DEVCONFIG` ioctl call is successful.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d77219a..d231193 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -427,6 +427,9 @@ static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 	if (cmd == COMEDI_DEVCONFIG) {
 		rc = do_devconfig_ioctl(dev,
 					(struct comedi_devconfig __user *)arg);
+		if (rc == 0)
+			/* Evade comedi_auto_unconfig(). */
+			dev_file_info->hardware_device = NULL;
 		goto done;
 	}
 
-- 
1.7.9.5

