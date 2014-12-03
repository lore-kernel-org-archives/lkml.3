Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaLCLzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:55:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaLCL1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/101] firewire: cdev: prevent kernel stack leaking into ioctl arguments
Date: Wed,  3 Dec 2014 12:26:03 +0100
Message-Id: <9fb5f68e66142ca36cb0958a12b2f1af47a723bc.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/firewire/core-cdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index d7d5c8af92b9..6d4456898007 100644
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
2.1.3

