Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbaLLGkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:40:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51870 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759202AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Ramos" <daramos@stanford.edu>,
        "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.880044007@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 128/164] firewire: cdev: prevent kernel stack leaking
 into ioctl arguments
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firewire/core-cdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1605,8 +1605,7 @@ static int dispatch_ioctl(struct client
 	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -ENOTTY;
 
-	if (_IOC_DIR(cmd) == _IOC_READ)
-		memset(&buffer, 0, _IOC_SIZE(cmd));
+	memset(&buffer, 0, sizeof(buffer));
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))

