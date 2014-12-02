Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaLBTXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:23:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaLBTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 086/121] firewire: cdev: prevent kernel stack leaking into ioctl arguments
Date: Tue,  2 Dec 2014 11:19:25 -0800
Message-Id: <1417548000-1794-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit eaca2d8e75e90a70a63a6695c9f61932609db212 upstream.

Found by the UC-KLEE tool:  A user could supply less input to
firewire-cdev ioctls than write- or write/read-type ioctl handlers
expect.  The handlers used data from uninitialized kernel stack then.

This could partially leak back to the user if the kernel subsequently
generated fw_cdev_event_'s (to be read from the firewire-cdev fd)
which notably would contain the _u64 closure field which many of the
ioctl argument structures contain.

The fact that the handlers would act on random garbage input is a
lesser issue since all handlers must check their input anyway.

The fix simply always null-initializes the entire ioctl argument buffer
regardless of the actual length of expected user input.  That is, a
runtime overhead of memset(..., 40) is added to each firewirew-cdev
ioctl() call.  [Comment from Clemens Ladisch:  This part of the stack is
most likely to be already in the cache.]

Remarks:
  - There was never any leak from kernel stack to the ioctl output
    buffer itself.  IOW, it was not possible to read kernel stack by a
    read-type or write/read-type ioctl alone; the leak could at most
    happen in combination with read()ing subsequent event data.
  - The actual expected minimum user input of each ioctl from
    include/uapi/linux/firewire-cdev.h is, in bytes:
    [0x00] = 32, [0x05] =  4, [0x0a] = 16, [0x0f] = 20, [0x14] = 16,
    [0x01] = 36, [0x06] = 20, [0x0b] =  4, [0x10] = 20, [0x15] = 20,
    [0x02] = 20, [0x07] =  4, [0x0c] =  0, [0x11] =  0, [0x16] =  8,
    [0x03] =  4, [0x08] = 24, [0x0d] = 20, [0x12] = 36, [0x17] = 12,
    [0x04] = 20, [0x09] = 24, [0x0e] =  4, [0x13] = 40, [0x18] =  4.

Reported-by: David Ramos <daramos@stanford.edu>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/firewire/core-cdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index d7d5c8a..6d44568 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1637,8 +1637,7 @@ static int dispatch_ioctl(struct client *client,
 	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -ENOTTY;
 
-	if (_IOC_DIR(cmd) == _IOC_READ)
-		memset(&buffer, 0, _IOC_SIZE(cmd));
+	memset(&buffer, 0, sizeof(buffer));
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
-- 
1.9.1

