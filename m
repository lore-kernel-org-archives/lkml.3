Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3GBPmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:42:02 -0400
Received: from cpc6-farn7-2-0-cust119.6-2.cable.virginmedia.com ([81.110.26.120]:42311
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752152Ab3GBPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:41:58 -0400
From: Dean Jenkins <Dean_Jenkins@mentor.com>
To: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/5] SLIP SLIP-Improve robustness to crashing
Date: Tue,  2 Jul 2013 16:31:29 +0100
Message-Id: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using SLIP bound to RFCOMM or PTY/TTY has identified some weaknesses to crashing
under abnormal conditions.

Here is a proposed patchset baselined and built on Linux 3.9.

Note the patches have not been tested on x86 Linux 3.9. However similar patches
have been used on ARM Linux 2.6.34 to avoid kernel crashes in a commercial
project. I believe the same weaknesses still exist in Linux 3.9.

If some or all of the patches look to be useful to the community then I may
attempt to test on x86 but this is not straight forward for me.

I welcome any feedback and whether the fixes are a suitable solution.

Who is the maintainer of SLIP in the kernel ?

The patchset consists of:

0001-Bluetooth-Add-RFCOMM-TTY-write-return-error-codes.patch
0002-SLIP-Handle-error-codes-from-the-TTY-layer.patch
0003-SLIP-Prevent-recursion-stack-overflow-and-scheduler-.patch
0004-SLIP-Add-error-message-for-xleft-non-zero.patch
0005-SLIP-Fix-transmission-segmentation-mechanism.patches

Some background:

0001-Bluetooth-Add-RFCOMM-TTY-write-return-error-codes.patch
This patch is a Bluetooth change to add some error return codes to RFCOMM to
avoid NULL pointer dereference crashes. Note RFCOMM can already generate an
error code that will cause SLIP to malfunction.

0002-SLIP-Handle-error-codes-from-the-TTY-layer.patches
This patch allows SLIP to handle error codes from RFCOMM or other bound TTY layers.

0003-SLIP-Prevent-recursion-stack-overflow-and-scheduler-.patches
This patch prevents SLIP from causing a recursive loop that overflows the stack
and catastrophically crashes the kernel. The scenario is SLIP bound to PTY/TTY.
The underlying trigger is a probably a failure to allocate a TTY buffer in
tty_buffer_alloc() but this is unproven. The crash is sporadic in an ARM
embedded environment where resources are limited.

0004-SLIP-Add-error-message-for-xleft-non-zero.patch
This is an error message patch to identify when a SLIP frame has not been fully
transmitted meaning the frame was truncated.

0005-SLIP-Fix-transmission-segmentation-mechanism.patches
This patch allows multiple attempts to transmit segments of the SLIP frame.
Currently only 1 attempt at writing the whole SLIP frame to PTY/TTY occurs.
This could truncate transmitted SLIP frames. In addition the modification
relies on the TTY write wake-up event to complete the transmission of the
SLIP frame rather than the sl_encaps() call to pty_write(). Probably,
pty_write() should not call tty_wakeup() but safer to modify SLIP rather
than the PTY/TTY layer.

Thanks,
Dean Jenkins
Mentor Graphics
-- 
1.8.1.5

